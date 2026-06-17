// destination agent class
class desti_agt extends uvm_agent;

        // factory registration
        `uvm_component_utils(desti_agt)

        // component declaration
        desti_mon mon_h;
        desti_drv drv_h;
        desti_seqr seqr_h;

        // config object
        desti_agt_config m_cfg;

        // extern functions
        extern function new(string name = "desti_agt", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);


endclass : desti_agt

// constructor
function desti_agt::new(string name = "desti_agt", uvm_component parent);
        super.new(name,parent);
endfunction

// build phase
function void desti_agt::build_phase(uvm_phase phase);
        super.build_phase(phase);

        // get the config object
        if(!uvm_config_db#(desti_agt_config)::get(this,"","desti_agt_config",m_cfg))
                `uvm_fatal(get_type_name(),"Cannot get the config object");

        mon_h = desti_mon::type_id::create("mon_h", this);

        if(m_cfg.is_active == UVM_ACTIVE) begin
                drv_h = desti_drv::type_id::create("drv_h", this);
                seqr_h = desti_seqr::type_id::create("seqr_h", this);
        end

endfunction : build_phase

// connect phase
function void desti_agt::connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(m_cfg.is_active == UVM_ACTIVE) begin
                drv_h.seq_item_port.connect(seqr_h.seq_item_export);
        end

endfunction : connect_phase
