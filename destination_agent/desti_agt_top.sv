// destination agent top class
class desti_agt_top extends uvm_env;

        // factory regitration
        `uvm_component_utils(desti_agt_top)

        desti_agt d_agt_h;

        // extern function
        extern function new(string name = "desti_agt_top", uvm_component parent);
        extern function void build_phase(uvm_phase phase);
//      extern function void connect_phae(uvm_phase phase);

endclass : desti_agt_top

// constructor
function desti_agt_top::new(string name = "desti_agt_top", uvm_component parent);
        super.new(name,parent);
endfunction : new

// build phase
function void desti_agt_top::build_phase(uvm_phase phase);
        super.build_phase(phase);

        d_agt_h = desti_agt::type_id::create("d_agt_h", this);

endfunction : build_phase
