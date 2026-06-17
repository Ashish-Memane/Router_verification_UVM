// test class
class router_base_test extends uvm_test;

        // factory registration
        `uvm_component_utils(router_base_test)

        // property declarion
        router_env env_h;                               // env
        router_env_config m_tb_cfg;                     // env config object

        // config objects
        source_agt_config source_m_cfg[];
        desti_agt_config desti_m_cfg[];

        // config properties
        int no_of_d_agt = 3;
        int no_of_s_agt = 1;
        int has_scoreboard = 1;
        int has_d_agt_top = 1;
        int has_s_agt_top = 1;
        int has_v_seqr = 1;

        //methods
        extern function new(string name = "router_base_test", uvm_component parent = null);
        extern function void build_phase(uvm_phase phase);

endclass : router_base_test

// constructor
function router_base_test::new(string name = "router_base_test", uvm_component parent = null);
        super.new(name, parent);
endfunction : new

// build_phase
function void router_base_test::build_phase(uvm_phase phase);

        // creating the config class object
        m_tb_cfg = router_env_config::type_id::create("m_tb_cfg");

        // assigning values to the properties in env_config object
        m_tb_cfg.has_scoreboard = has_scoreboard;
        m_tb_cfg.no_of_d_agt = no_of_d_agt;
        m_tb_cfg.no_of_s_agt = no_of_s_agt;
        m_tb_cfg.has_v_seqr = has_v_seqr;
        m_tb_cfg.has_d_agt_top = has_d_agt_top;
        m_tb_cfg.has_s_agt_top = has_s_agt_top;


        if(has_s_agt_top)
                begin
                        source_m_cfg = new[no_of_s_agt];
                        m_tb_cfg.s_agt_cfg = new[no_of_s_agt];

                        foreach(source_m_cfg[i])
                                begin
                                        // Creating the source m cfg object
                                        source_m_cfg[i] = source_agt_config::type_id::create($sformatf("source_m_cfg[%0d]",i));

                                        // getting the virtual interface and setting to the vif of object config
                                        if(!uvm_config_db#(virtual router_inf)::get(this,"",$sformatf("vif%0d",i),source_m_cfg[i].vif))
                                                `uvm_fatal(get_type_name(),"Cannot get the config object")

                                        m_tb_cfg.s_agt_cfg[i] = source_m_cfg[i];
                                end
                end

        if(has_d_agt_top)
                begin
                        desti_m_cfg = new[no_of_d_agt];
                        m_tb_cfg.d_agt_cfg = new[no_of_d_agt];

                        foreach(desti_m_cfg[i])
                                begin
                                        // creating the desti m cfg object
                                        desti_m_cfg[i] = desti_agt_config::type_id::create($sformatf("desti_m_cfg[%0d]",i));

                                        // getting virtual interface
                                        if(!uvm_config_db#(virtual router_inf)::get(this,"",$sformatf("vif_%0d",i),desti_m_cfg[i].vif))
                                                `uvm_fatal(get_type_name(),"Cannot get the config object");

                                        m_tb_cfg.d_agt_cfg[i] = desti_m_cfg[i];

                                end
                end

        // set the env config object
        uvm_config_db #(router_env_config)::set(null,"*","router_env_config",m_tb_cfg);

        super.build_phase(phase);

        // create the env
        env_h = router_env::type_id::create("env_h", this);

endfunction : build_phase

//=================================================================================================================

// test_1

class router_test_1 extends router_base_test;

        // factory registration
        `uvm_component_utils(router_test_1)

        // seq_1 handle
        router_v_seqs_1 seq_h;

        // extern method
        extern function new(string name = "router_test_1", uvm_component parent = null);
        extern function void build_phase( uvm_phase phase);
        extern task run_phase(uvm_phase);

endclass : router_test_1

// constructor
function router_test_1::new(string name = "router_test_1", uvm_component parent = null);
        super.new(name,parent);
endfunction : new

// build_phase
function void router_test_1::build_phase(uvm_phase phase);
        super.build_phase(phase);
endfunction : build_phase

// run_phase
task router_test_1::run_phase(uvm_phase phase);

        phase.raise_objection(this);

                seq_h = router_v_seqs_1::type_id::create("seq_h");              // creating the object of the seq
                seq_h.start(env_h.v_seqr_h);                                    // starting the sequence on the virtual seqr in the env
#100;
        phase.drop_objection(this);

endtask : run_phase
