// destination sequencer class
class desti_seqr extends uvm_sequencer #(desti_xtn);

        // factory registration
        `uvm_component_utils(desti_seqr)

        //constructor
        function new(string name = "desti_seqr", uvm_component parent);
                super.new(name,parent);
        endfunction

endclass : desti_seqr
