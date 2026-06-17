class desti_drv extends uvm_driver #(desti_xtn);

    // factory registration
    `uvm_component_utils(desti_drv)

    // virtual interface
    virtual router_inf.DESTI_DRV_MP vif;

    // config handle
    desti_agt_config m_cfg;

    //========================================================
    // Constructor
    //========================================================

    function new(string name = "desti_drv",
                 uvm_component parent);
        super.new(name, parent);
    endfunction

    //========================================================
    // Build Phase
    //========================================================

    function void build_phase(uvm_phase phase);

        super.build_phase(phase);

        if(!uvm_config_db #(desti_agt_config)::get(
                this,
                "",
                "desti_agt_config",
                m_cfg))
        begin
            `uvm_fatal(get_type_name(),
                       "Cannot get desti_agt_config")
        end

    endfunction

    //========================================================
    // Connect Phase
    //========================================================

    function void connect_phase(uvm_phase phase);

        super.connect_phase(phase);

        vif = m_cfg.vif;

    endfunction

    //========================================================
    // Run Phase
    //========================================================
task run_phase(uvm_phase phase);

    forever begin

        //-----------------------------------------
        // WAIT UNTIL VALID OUT ASSERTS
        //-----------------------------------------

        @(vif.desti_drv_cb);

        wait(vif.desti_drv_cb.valid_out)

        //-----------------------------------------
        // ASSERT READ ENABLE
        //-----------------------------------------

        vif.desti_drv_cb.read_enb <= 1'b1;


        //-----------------------------------------
        // KEEP READING UNTIL valid_out DROPS
        //-----------------------------------------

//         do begin
//          @(vif.desti_drv_cb);
//         end
//          while(vif.desti_drv_cb.valid_out);
//
        //-----------------------------------------
        // DEASSERT READ ENABLE
        //-----------------------------------------

        @(vif.desti_drv_cb);
        wait(!vif.desti_drv_cb.valid_out);
        vif.desti_drv_cb.read_enb <= 1'b0;


    end

endtask

    //========================================================
    // Report Phase
    //========================================================

    function void report_phase(uvm_phase phase);

        `uvm_info(get_type_name(),
                  "Destination Driver Report",
                  UVM_LOW)

    endfunction

endclass
