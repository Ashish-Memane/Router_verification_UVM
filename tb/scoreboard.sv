// class scoreboard
class scoreboard extends uvm_scoreboard;

        // factory registration
        `uvm_component_utils(scoreboard)

        // tlm analysis fifo
        uvm_tlm_analysis_fifo #(source_xtn) fifo_source_tlm[];
        uvm_tlm_analysis_fifo #(desti_xtn) fifo_desti_tlm[];

        int i;

        // env config object
        router_env_config m_cfg;

        // source monitor object
        source_xtn s_xtn_h[];
        source_xtn s_xtn_cal_h;

        // desti monitor object
        desti_xtn d_xtn_h[];
        desti_xtn d_xtn_cal_h;

        // pkt count
        static int d_pkt_count = 0;
        static int s_pkt_count = 0;

        // extern functions
        extern function new(string name = "scoreboard", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern function bit compare_the_pkts(source_xtn s_xtn, desti_xtn d_xtn);
        extern function void report_phase(uvm_phase phase);

endclass : scoreboard

// constructor
function scoreboard::new(string name = "scoreboard", uvm_component parent);
        super.new(name, parent);
endfunction : new

// build phase
function void scoreboard::build_phase(uvm_phase phase);
        super.build_phase(phase);

        // getting the env config object
        if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
                `uvm_fatal(get_type_name()," Cannot get the config object")

        // initializing the tlm ports
        fifo_source_tlm = new[m_cfg.no_of_s_agt];
        fifo_desti_tlm = new[m_cfg.no_of_d_agt];

        // initializing the source and desti xtn objects
        s_xtn_h = new[m_cfg.no_of_s_agt];
        d_xtn_h = new[m_cfg.no_of_d_agt];


        // creating the tlm analysis ports
        foreach(fifo_source_tlm[i])
                fifo_source_tlm[i] = new($sformatf("fifo_source_tlm[%0d]",i),this);

        foreach(fifo_desti_tlm[i])
                fifo_desti_tlm[i] = new($sformatf("fifo_desti_tlm[%0d]",i),this);

endfunction : build_phase

// run phase
task scoreboard::run_phase(uvm_phase phase);
        super.run_phase(phase);

        s_xtn_cal_h = source_xtn::type_id::create("s_xtn_cal_h");
        d_xtn_cal_h = desti_xtn::type_id::create("d_xtn_cal_h");

        fork
                // try getting the source object
                for(i = 0; i < m_cfg.no_of_s_agt; i++)
                        if(fifo_source_tlm[i].try_get(s_xtn_h[i])) begin

                                s_xtn_cal_h.copy(s_xtn_h[i]);
                                s_pkt_count++;
                                break;
                        end

                // try getting the desti object
                for(i = 0; i < m_cfg.no_of_d_agt; i++)
                        if(fifo_desti_tlm[i].try_get(d_xtn_h[i])) begin

                                d_xtn_cal_h.copy(d_xtn_h[i]);
                                d_pkt_count++;
                                break;
                        end


        join

        #1;

        // pkts compare
        if (s_xtn_cal_h == null || d_xtn_cal_h == null) begin
                `uvm_warning(get_type_name(),"Skipping : compare pkts are null")

        end else if(!compare_the_pkts(s_xtn_cal_h, d_xtn_cal_h)) begin

                `uvm_info(get_type_name(),$sformatf("Compare failed : pkt count = %0d",d_pkt_count),UVM_LOW)

                `uvm_info(get_type_name(),$sformatf("Source Monitor Packet : \n %s || Destination Monitor Packet : \n %s", s_xtn_cal_h.sprint(), d_xtn_cal_h.sprint()), UVM_LOW)

        end else begin

                `uvm_info(get_type_name(),$sformatf("Compare Successful : pkt count = %0d",d_pkt_count),UVM_LOW)

                `uvm_info(get_type_name(),$sformatf("Source Monitor Packet : \n %s || Destination Monitor Packet : \n %s", s_xtn_cal_h.sprint(), d_xtn_cal_h.sprint()), UVM_LOW)
        end

endtask : run_phase


// compare the pkts
function bit scoreboard::compare_the_pkts(source_xtn s_xtn, desti_xtn d_xtn);

        // comparing the packets
        return  (s_xtn.header == d_xtn.header) &&
                (s_xtn.payload_data == d_xtn.payload_data) &&
                (s_xtn.parity == d_xtn.parity);
        //      (s_xtn.busy == d_xtn.busy) &&
        //      (s_xtn.error == d_xtn.error);
        // returns 1 if compare successful and 0 if not

endfunction : compare_the_pkts

// report phase
function void scoreboard::report_phase(uvm_phase phase);

        `uvm_info(get_type_name(), $sformatf("Source Monitor pkt count : %0d || Desti Monitor pkt count : %0d ", s_pkt_count, d_pkt_count),UVM_LOW)

endfunction : report_phase
