module top;


        // importing the pkgs
        import router_pkg::*;

        import uvm_pkg::*;

        // clock generation
        bit clock;

        // interface instantiation
        router_inf inf(clock);

        router_inf inf0(clock);
        router_inf inf1(clock);
        router_inf inf2(clock);

        // DUT instantiation
        router_top dut( .clock(clock),
                        .resetn(inf.resetn),
                        .read_enb_0(inf0.read_enb),
                        .read_enb_1(inf1.read_enb),
                        .read_enb_2(inf2.read_enb),
                        .data_in(inf.data_in),
                        .pkt_valid(inf.pkt_valid),
                        .data_out_0(inf0.data_out),
                        .data_out_1(inf1.data_out),
                        .data_out_2(inf2.data_out),
                        .valid_out_0(inf0.valid_out),
                        .valid_out_1(inf1.valid_out),
                        .valid_out_2(inf2.valid_out),
                        .error(inf.error),
                        .busy(inf.busy));



        initial begin
                clock = 0;
                forever #5 clock = ~clock;
        end

        // setting the virtual interface
        initial begin

                `ifdef VCS
                $fsdbDumpvars(0, top);
                `endif


                uvm_config_db#(virtual router_inf)::set(null,"*","vif0",inf);

                uvm_config_db#(virtual router_inf)::set(null,"*","vif_0",inf0);
                uvm_config_db#(virtual router_inf)::set(null,"*","vif_1",inf1);
                uvm_config_db#(virtual router_inf)::set(null,"*","vif_2",inf2);


                // run test

                run_test();
        end

endmodule : top
