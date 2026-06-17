class router_virtual_seqs extends uvm_sequence #(uvm_sequence_item);

        // factory registration
        `uvm_object_utils(router_virtual_seqs)

        // virtual seqs
        source_seqr s_seqr_h[];
        desti_seqr d_seqr_h[];

        // virtual sequecner handle
        router_virtual_seqr v_seqr_h;

        int i;

        // env config object
        router_env_config m_tb_cfg;

        // extern methods
        extern function new(string name = "router_virtual_seqs");
        extern task body();

endclass : router_virtual_seqs

// constructor
function router_virtual_seqs::new(string name = "router_virtual_seqs");
        super.new(name);
endfunction : new


// task body
task router_virtual_seqs::body();
        super.body();
        // get the env config object
        if(!uvm_config_db#(router_env_config)::get(null,"","router_env_config",m_tb_cfg))
                `uvm_fatal(get_type_name(),"Cannot get the config object")

        // initializing the seqr objects with no of agents
        s_seqr_h = new[m_tb_cfg.no_of_s_agt];
        d_seqr_h = new[m_tb_cfg.no_of_d_agt];

        // assigning the v_seqr_h to m_sequencer
        if(!$cast(v_seqr_h,m_sequencer))  begin
                `uvm_error(get_type_name(),"Cannot cast the object to base class object");
        end

        // connecting the local seqrs to vitrual seqr
        foreach(s_seqr_h[i])
                s_seqr_h[i] = v_seqr_h.s_seqr_h[i];

        foreach(d_seqr_h[i])
                d_seqr_h[i] = v_seqr_h.d_seqr_h[i];


endtask : body
//===============================================================================================================

class router_v_seqs_1 extends router_virtual_seqs;

        // factory registration
        `uvm_object_utils(router_v_seqs_1)

        // seq handle declaraion
        source_seqs_1 s_xtns_h;
        desti_seqs_1 d_xtns_h;

        // extern methods
        extern function new(string name = "router_v_seqs_1");
        extern task body();

endclass : router_v_seqs_1

// constructor
function router_v_seqs_1::new(string name = "router_v_seqs_1");
        super.new(name);
endfunction : new

// body
task router_v_seqs_1::body();
        super.body();

        s_xtns_h = source_seqs_1::type_id::create("s_xtns_h");
        d_xtns_h = desti_seqs_1::type_id::create("d_xtns_h");

        fork
                if(m_tb_cfg.has_s_agt_top) begin
                        foreach (s_seqr_h[i]) begin
                                s_xtns_h.start(s_seqr_h[i]);
                        end
                end

                if(m_tb_cfg.has_d_agt_top) begin
                        foreach (d_seqr_h[i]) begin
                                d_xtns_h.start(d_seqr_h[i]);
                        end
                end
        join

endtask : body

//===================================================================================================================

