// sequencer class
class source_seqr extends uvm_sequencer #(source_xtn);

        // factory registration
        `uvm_component_utils(source_seqr)

        // constructor
        function new(string name = "source_seqr", uvm_component parent);
                super.new(name,parent);
        endfunction

endclass : source_seqr
