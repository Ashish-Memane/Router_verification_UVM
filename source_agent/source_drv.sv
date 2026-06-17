class source_drv extends uvm_driver #(source_xtn);

    // factory registration
    `uvm_component_utils(source_drv)

    // virtual interface
    virtual router_inf.SOURCE_DRV_MP vif;

    // config handle
    source_agt_config m_cfg;

    // extern methods
    extern function new(string name = "source_drv",
                        uvm_component parent);

    extern function void build_phase(uvm_phase phase);

    extern function void connect_phase(uvm_phase phase);

    extern task run_phase(uvm_phase phase);

    extern task send_to_dut(source_xtn xtn_h);

    extern task reset_dut();

    extern function void report_phase(uvm_phase phase);

endclass : source_drv


// constructor
function source_drv::new(string name = "source_drv",
                         uvm_component parent);

    super.new(name, parent);

endfunction : new


// build phase
function void source_drv::build_phase(uvm_phase phase);

    super.build_phase(phase);

    if(!uvm_config_db #(source_agt_config)::get(this,
                                                "",
                                                "source_agt_config",
                                                m_cfg))
    begin
        `uvm_fatal(get_type_name(),
                   "Cannot get source_agt_config")
    end

endfunction : build_phase


// connect phase
function void source_drv::connect_phase(uvm_phase phase);

    super.connect_phase(phase);

    vif = m_cfg.vif;

endfunction : connect_phase


// run phase
task source_drv::run_phase(uvm_phase phase);

    reset_dut();

    repeat(10) begin

        seq_item_port.get_next_item(req);

        send_to_dut(req);

        seq_item_port.item_done();

    end

endtask : run_phase


task source_drv::send_to_dut(source_xtn xtn_h);


    `uvm_info(get_type_name(),
              $sformatf("The drv XTN pkt : \n%s",
              xtn_h.sprint()),
              UVM_LOW)

    //-----------------------------------------
    // HEADER
    //-----------------------------------------

    @(vif.source_drv_cb);

    while(vif.source_drv_cb.busy)
        @(vif.source_drv_cb);

    vif.source_drv_cb.pkt_valid <= 1'b1;
    vif.source_drv_cb.data_in   <= xtn_h.header;


    @(vif.source_drv_cb);
    //-----------------------------------------
    // PAYLOAD
    //-----------------------------------------

    foreach(xtn_h.payload_data[i]) begin

//        @(vif.source_drv_cb);

        while(vif.source_drv_cb.busy)
            @(vif.source_drv_cb);

        vif.source_drv_cb.data_in <= xtn_h.payload_data[i];
            @(vif.source_drv_cb);

    end

    //-----------------------------------------
    // PARITY
    //-----------------------------------------

   // @(vif.source_drv_cb);

    while(vif.source_drv_cb.busy)
        @(vif.source_drv_cb);

    vif.source_drv_cb.pkt_valid <= 1'b0;
    vif.source_drv_cb.data_in   <= xtn_h.parity;

    //-----------------------------------------
    // IDLE CYCLE
    //-----------------------------------------

    @(vif.source_drv_cb);

    vif.source_drv_cb.data_in   <= 8'h00;
    vif.source_drv_cb.pkt_valid <= 1'b0;

    //-----------------------------------------
    // ERROR CHECK
    //-----------------------------------------


    //-----------------------------------------
    // PACKET COUNT
    //-----------------------------------------

    m_cfg.drv_pkt_count++;

    @(vif.source_drv_cb);
    @(vif.source_drv_cb);
endtask


task source_drv::reset_dut();

        @(vif.source_drv_cb);

        vif.source_drv_cb.resetn <= 1'b0;

        @(vif.source_drv_cb);

        vif.source_drv_cb.resetn <= 1'b1;


endtask : reset_dut


// report phase
function void source_drv::report_phase(uvm_phase phase);

    `uvm_info(get_type_name(),
              $sformatf("Driver packet count : %0d",
              m_cfg.drv_pkt_count),
              UVM_LOW)

endfunction : report_phase
