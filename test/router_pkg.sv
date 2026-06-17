// router pkg
package router_pkg;


        int no_of_transactions = 5;

        // importing the uvm pkg
        import uvm_pkg::*;
        `include "uvm_macros.svh"

        // file inclusion
        `include "source_agt_config.sv"
        `include "desti_agt_config.sv"
        `include "router_env_config.sv"

        `include "source_xtn.sv"
        `include "desti_xtn.sv"

        `include "source_seqs.sv"
        `include "desti_seqs.sv"

        `include "source_seqr.sv"
        `include "desti_seqr.sv"

        `include "source_drv.sv"
        `include "desti_drv.sv"

        `include "source_mon.sv"
        `include "desti_mon.sv"

        `include "scoreboard.sv"

        `include "source_agt.sv"
        `include "source_agt_top.sv"

        `include "desti_agt.sv"
        `include "desti_agt_top.sv"

        `include "router_virtual_seqr.sv"
        `include "router_virtual_seqs.sv"
        `include "router_env.sv"

        `include "router_vtest_lib.sv"

endpackage : router_pkg
