// class source xtn
class source_xtn extends uvm_sequence_item;


        // property declaration

        rand logic [1:0] addr;
        rand logic [5:0] payload_len;

        // header
        logic [7:0] header;

        // dynamic array for payload data
        rand byte payload_data[];

        // parity
        rand bit good_parity;
        rand logic [7:0] bad_parity;

        logic [7:0] parity;

//-----------------------------------------
        rand bit pkt_valid;
        bit resetn;
        logic valid_out;

        bit error;
        bit busy;

        // source driver pkt count
        static int source_drv_pkt_count;

        // factory registration
        `uvm_object_utils_begin(source_xtn)
                `uvm_field_int(payload_len, UVM_ALL_ON + UVM_NOPRINT + UVM_NOCOMPARE)
                `uvm_field_int(addr, UVM_ALL_ON + UVM_NOPRINT + UVM_NOCOMPARE)
                `uvm_field_int(header, UVM_ALL_ON)
                `uvm_field_array_int(payload_data, UVM_ALL_ON)
                `uvm_field_int(parity, UVM_ALL_ON)
                `uvm_field_int(pkt_valid, UVM_ALL_ON + UVM_NOCOMPARE)
                `uvm_field_int(error, UVM_ALL_ON)
                `uvm_field_int(busy, UVM_ALL_ON)
        `uvm_object_utils_end

        // constraints
        constraint c_payload_len {
                payload_len == 30;}

        constraint c_addr {
                addr inside {[0:2]};}

//      constraint c_pkt_valid {
//              pkt_valid dist {0:=1, 1:=99};}

        constraint c_parity {
                good_parity == 1;}


        // extern methods
        extern function new(string name = "source_xtn");
        extern function void post_randomize();

endclass: source_xtn

// constructor
function source_xtn::new(string name = "source_xtn");
        super.new(name);
endfunction : new

// post randomize
function void source_xtn::post_randomize();

        fork
        // build header
        header = {payload_len, addr};

        payload_data = new[payload_len];

        // allocate the payload array
        foreach (payload_data[i]) begin
                if(!std::randomize(payload_data[i])) begin
                        `uvm_error(get_type_name(),"Failed to randomize the payload data")
                end

        end

        join

        if(good_parity) begin

                parity = header;

           foreach(payload_data[i]) begin
                parity ^= payload_data[i];
                end

        end
        else begin
                parity = bad_parity;
        end


        // pkt count
        source_drv_pkt_count++;

endfunction : post_randomize

