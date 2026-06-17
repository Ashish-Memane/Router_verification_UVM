
// destination xtn
class desti_xtn extends uvm_sequence_item;

        // signals declaration

        // to the dut
         bit read_enb;

        // from the dut
        logic [7:0] data_out;

        logic valid_out;
        logic pkt_valid;

        // signals to capture for scoreboard


        // properties to collect the data from dut
        logic [7:0] header;
        logic [7:2] payload_len;
        logic [1:0] addr;
        byte payload_data[];
        logic [7:0] parity;

        // destination drv pkt count
        static int desti_drv_pkt_count;

        // constraints

        // factory registration of the properties
        `uvm_object_utils_begin(desti_xtn)
                `uvm_field_int(read_enb, UVM_ALL_ON + UVM_NOCOMPARE)
                `uvm_field_int(data_out, UVM_ALL_ON + UVM_NOCOMPARE + UVM_NOPRINT)
                `uvm_field_int(header, UVM_ALL_ON)
                `uvm_field_int(payload_len, UVM_ALL_ON + UVM_NOPRINT + UVM_COMPARE)
                `uvm_field_array_int(payload_data, UVM_ALL_ON)
                `uvm_field_int(addr, UVM_ALL_ON + UVM_NOPRINT)
                `uvm_field_int(parity, UVM_ALL_ON)
        `uvm_object_utils_end

        // extern functions
        extern function new(string name = "desti_xtn");
        extern function void post_randomize();


endclass : desti_xtn

// construction
function desti_xtn::new(string name = "desti_xtn");
        super.new(name);
endfunction : new

// post randomize
function void desti_xtn::post_randomize();

        desti_drv_pkt_count++;

endfunction : post_randomize
