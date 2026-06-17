// source agent top
class source_agt_top extends uvm_env;

        // factory registration
        `uvm_component_utils(source_agt_top)

        //config object handle
        source_agt s_agt_h;

        // extern functions
        extern function new(string name = "source_agt_top", uvm_component parent);
        extern function void build_phase(uvm_phase phase);

endclass : source_agt_top

// constructor
function source_agt_top::new(string name = "source_agt_top", uvm_component parent);
        super.new(name,parent);
endfunction : new

// build phase
function void source_agt_top::build_phase(uvm_phase phase);
        super.build_phase(phase);

        s_agt_h = source_agt::type_id::create("s_agt_h", this);

endfunction : build_phase
