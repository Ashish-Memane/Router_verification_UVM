// env config class
class router_env_config extends uvm_object;

        // factory registration
        `uvm_object_utils(router_env_config)

        //properties
        int has_scoreboard;
        int has_d_agt_top;
        int has_s_agt_top;
        int has_v_seqr;

        // no of source and destination agents
        int no_of_d_agt;
        int no_of_s_agt;

        source_agt_config s_agt_cfg[];
        desti_agt_config d_agt_cfg[];

        // constructor
        function new(string name = "env_config");
                super.new(name);
        endfunction : new

endclass : router_env_config

