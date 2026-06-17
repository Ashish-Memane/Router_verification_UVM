// destination agent config
class desti_agt_config extends uvm_object;

        // factory registration
        `uvm_object_utils(desti_agt_config)

        // virtual interface
        virtual router_inf vif;

//      virtual desti_interface d_vif;

        // active passive enum
        uvm_active_passive_enum is_active = UVM_ACTIVE;

        // mon_pkt count
        int mon_pkt_count = 0;

        // constructor
        function new(string name = "desti_agt_config");
                super.new(name);
        endfunction

endclass : desti_agt_config
