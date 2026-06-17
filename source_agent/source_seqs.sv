// source seq class
class source_seqs extends uvm_sequence #(source_xtn);

        // factory registration
        `uvm_object_utils(source_seqs)

        // extern methods
        extern function new(string name = "source_seqs");

endclass : source_seqs

// constructor
function source_seqs::new(string name = "source_seqs");
        super.new(name);
endfunction : new

//============================================================================

class source_seqs_1 extends source_seqs;

        // factory registration
        `uvm_object_utils(source_seqs_1)

        // extern methods
        extern function new(string name = "source_seqs_1");
        extern task body();

endclass : source_seqs_1

// constructor
function source_seqs_1::new(string name = "source_seqs_1");
        super.new(name);
endfunction : new

// task body
task source_seqs_1::body();
        repeat (no_of_transactions) begin
                req = source_xtn::type_id::create("req");
                start_item(req);
                assert(req.randomize());
        //      `uvm_info(get_type_name(),$sformatf("printing from seq :\n %s",req.sprint()),UVM_LOW)
                finish_item(req);
        end
endtask : body

//============================================================================
