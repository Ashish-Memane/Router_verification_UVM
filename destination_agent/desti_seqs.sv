// destination seqs class
class desti_seqs extends uvm_sequence #(desti_xtn);

        // factory registration
        `uvm_object_utils(desti_seqs)

        // constructor
        function new(string name = "desti_seqs");
                super.new(name);
        endfunction : new

endclass : desti_seqs


// desti_seqs_1
class desti_seqs_1 extends desti_seqs;

        // factory registration
        `uvm_object_utils(desti_seqs_1)

        // constructor
        function new(string name = "desti_seqs_1");
                super.new(name);
        endfunction : new

        // task body
        task body();
                repeat (no_of_transactions)
                        begin
                                req = desti_xtn::type_id::create("desti_xtn");
                                start_item(req);
                                assert(req.randomize());
                        //      `uvm_info(get_type_name,$sformatf("Desti_seqs_1 :\n %s",req.sprint()),UVM_LOW)
                                finish_item(req);
                        end

        endtask : body

endclass : desti_seqs_1
