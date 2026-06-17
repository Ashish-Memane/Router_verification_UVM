// virtual sequencer class
class router_virtual_seqr extends uvm_sequencer #(uvm_sequence_item);

        // factory registration
        `uvm_component_utils(router_virtual_seqr)

        // virtual sequencer
        source_seqr s_seqr_h[];
        desti_seqr d_seqr_h[];

        // env config object
        router_env_config m_cfg;

        // extern method
        extern function new(string name = "router_virtual_seqr", uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass : router_virtual_seqr

// constructor
function router_virtual_seqr::new(string name = "router_virtual_seqr", uvm_component parent);
        super.new(name,parent);
endfunction


// build phase
function void router_virtual_seqr::build_phase(uvm_phase phase);
        super.build_phase(phase);

        // getting the env config
        if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
                `uvm_fatal(get_type_name(),"Cannot get the object");

        // initializing the seqrs
        s_seqr_h = new[m_cfg.no_of_s_agt];
        d_seqr_h = new[m_cfg.no_of_d_agt];

endfunction : build_phase
