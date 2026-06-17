// source agent class
class source_agt extends uvm_agent;

        // factory registration
        `uvm_component_utils(source_agt)

        // component handles
        source_mon mon_h;
        source_drv drv_h;
        source_seqr seqr_h;

        // agetn top config object
        source_agt_config m_cfg;

        // extern function
        extern function new(string name = "source_agt", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);

endclass : source_agt

// constructor
function source_agt::new(string name = "source_agt", uvm_component parent = null);
        super.new(name,parent);
endfunction

// build phase
function void source_agt::build_phase(uvm_phase phase);
        super.build_phase(phase);

        // get the config object
        if(!uvm_config_db#(source_agt_config)::get(this,"","source_agt_config",m_cfg))
                `uvm_fatal(get_type_name(),"Cannot get the config object");

        mon_h = source_mon::type_id::create("mon_h", this);

        if(m_cfg.is_active == UVM_ACTIVE) begin
                drv_h = source_drv::type_id::create("drv_h", this);
                seqr_h = source_seqr::type_id::create("seqr_h", this);
        end

endfunction : build_phase

// connect phase
function void source_agt::connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        if(m_cfg.is_active == UVM_ACTIVE) begin
                drv_h.seq_item_port.connect(seqr_h.seq_item_export);
        end

endfunction : connect_phase
