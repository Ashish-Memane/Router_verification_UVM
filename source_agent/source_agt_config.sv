// source agent config
class source_agt_config extends uvm_object;

        // factory registration
        `uvm_object_utils(source_agt_config)

        // virtual interface
        virtual router_inf vif;

//      virtual source_interface s_vif;

        // passive active enum
        uvm_active_passive_enum is_active = UVM_ACTIVE;

        int drv_pkt_count = 0;
        int mon_pkt_count = 0;

        // construction
        function new(string name = "source_agt_config");
                super.new(name);
        endfunction

endclass : source_agt_config
