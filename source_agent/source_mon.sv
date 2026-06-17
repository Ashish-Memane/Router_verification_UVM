// class monitor
class source_mon extends uvm_monitor;

        // factory registration
        `uvm_component_utils(source_mon)

        // virtual interface
        virtual router_inf.SOURCE_MON_MP vif;

        int i;

        // source agt config
        source_agt_config m_cfg;

        // analysis tlm port
        uvm_analysis_port #(source_xtn) monitor_port;

        // extern functions
        extern function new(string name = "source_mon", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern task run_phase(uvm_phase phase);
        extern task collect_data();
        extern function void report_phase(uvm_phase phase);

endclass : source_mon

// constructor
function source_mon::new(string name = "source_mon", uvm_component parent);
        super.new(name, parent);
        monitor_port = new("monitor_port",this);
endfunction : new

// build phase
function void source_mon::build_phase(uvm_phase phase);
        super.build_phase(phase);

        if(!uvm_config_db#(source_agt_config)::get(this,"","source_agt_config",m_cfg))
                `uvm_fatal(get_type_name(),"Cannot get the config object");

endfunction : build_phase

// connect phase
function void source_mon::connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        vif = m_cfg.vif;
endfunction : connect_phase

// run phase
task source_mon::run_phase(uvm_phase phase);
        super.run_phase(phase);
        repeat(10) begin
                collect_data();
        end
endtask : run_phase

task source_mon::collect_data();

    //-----------------------------------------
    // transaction object
    //-----------------------------------------

    source_xtn xtn_h;

    xtn_h = source_xtn::type_id::create("xtn_h");

    //-----------------------------------------
    // WAIT FOR HEADER
    //-----------------------------------------

    @(vif.source_mon_cb);
    wait(vif.source_mon_cb.pkt_valid && !vif.source_mon_cb.busy);

    //-----------------------------------------
    // CAPTURE HEADER
    //-----------------------------------------

    xtn_h.header = vif.source_mon_cb.data_in;

    xtn_h.addr = vif.source_mon_cb.data_in[1:0];

    xtn_h.payload_len = vif.source_mon_cb.data_in[7:2];

    xtn_h.payload_data = new[xtn_h.payload_len];

   // @(vif.source_mon_cb);

    //-----------------------------------------
    // CAPTURE PAYLOAD
    //-----------------------------------------

    foreach(xtn_h.payload_data[i]) begin

        @(vif.source_mon_cb);

        wait(vif.source_mon_cb.pkt_valid && !vif.source_mon_cb.busy);

        xtn_h.payload_data[i] =
            vif.source_mon_cb.data_in;

    end

    //-----------------------------------------
    // CAPTURE PARITY
    //-----------------------------------------

    @(vif.source_mon_cb);

    while(vif.source_mon_cb.busy)
        @(vif.source_mon_cb);

    xtn_h.parity = vif.source_mon_cb.data_in;

    //-----------------------------------------
    // PRINT
    //-----------------------------------------

    `uvm_info(get_type_name(),$sformatf("The monitor source pkt : \n%s", xtn_h.sprint()), UVM_LOW)

    //-----------------------------------------
    // SEND TO SCOREBOARD
    //-----------------------------------------

    monitor_port.write(xtn_h);

    //-----------------------------------------
    // PACKET COUNT
    //-----------------------------------------

    m_cfg.mon_pkt_count++;

    @(vif.source_mon_cb);
    @(vif.source_mon_cb);

endtask

// report phase
function void source_mon::report_phase(uvm_phase phase);

        `uvm_info(get_type_name(), $sformatf("Source Monitor packet count : %0d", m_cfg.mon_pkt_count), UVM_LOW)

endfunction : report_phase
