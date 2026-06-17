// env class
class router_env extends uvm_env;

        // factory registration
        `uvm_component_utils(router_env)

        // env object config handle
        router_env_config m_cfg;
        scoreboard sb_h;

        int i;

        // agent top
        source_agt_top s_agt_top_h[];
        desti_agt_top d_agt_top_h[];

        // virtual seqr
        router_virtual_seqr v_seqr_h;

        // extern functions
        extern function new(string name = "router_env", uvm_component parent);
        extern function void  build_phase(uvm_phase phase);
        extern function void connect_phase(uvm_phase phase);
        extern function void end_of_elaboration_phase(uvm_phase phase);

endclass : router_env

// constructor
function router_env::new(string name = "router_env", uvm_component parent);
        super.new(name, parent);
endfunction : new

// build_phase
function void router_env::build_phase(uvm_phase phase);
        super.build_phase(phase);


        // get the env config object
        if(!uvm_config_db#(router_env_config)::get(this,"","router_env_config",m_cfg))
                `uvm_fatal(get_type_name(),"Cannot get the config object");

        // scoreboard
        if(m_cfg.has_scoreboard == 1)
                        sb_h = scoreboard::type_id::create("sb_h",this);

        // source top agent
        if(m_cfg.has_s_agt_top == 1)

                s_agt_top_h = new[m_cfg.no_of_s_agt];
                foreach(s_agt_top_h[i]) begin
                        uvm_config_db#(source_agt_config)::set(this,$sformatf("s_agt_top_h[%0d]*",i),"source_agt_config",m_cfg.s_agt_cfg[i]);

                        s_agt_top_h[i] = source_agt_top::type_id::create($sformatf("s_agt_top_h[%0d]",i), this);
                end

        // destination top agent
        if(m_cfg.has_d_agt_top == 1)

                d_agt_top_h = new[m_cfg.no_of_d_agt];
                foreach(d_agt_top_h[i]) begin
                        uvm_config_db#(desti_agt_config)::set(this,$sformatf("d_agt_top_h[%0d]*",i),"desti_agt_config",m_cfg.d_agt_cfg[i]);
                        d_agt_top_h[i] = desti_agt_top::type_id::create($sformatf("d_agt_top_h[%0d]",i), this);
                end

        // virtual seqr
        if(m_cfg.has_v_seqr == 1)
                v_seqr_h = router_virtual_seqr::type_id::create("v_seqr_h", this);

endfunction : build_phase

// connect phase
function void router_env::connect_phase(uvm_phase phase);
        super.connect_phase(phase);

        // connecting the virtual sequencer
        if(m_cfg.has_v_seqr == 1) begin
                foreach(d_agt_top_h[i]) begin
                        if(m_cfg.has_d_agt_top)
                                v_seqr_h.d_seqr_h[i] = d_agt_top_h[i].d_agt_h.seqr_h;
                end
                foreach(s_agt_top_h[i]) begin
                        if(m_cfg.has_s_agt_top)
                                v_seqr_h.s_seqr_h[i] = s_agt_top_h[i].s_agt_h.seqr_h;
                end
        end

        // connecting the scoreboard
        if(m_cfg.has_scoreboard == 1) begin

                foreach(d_agt_top_h[i])
                        d_agt_top_h[i].d_agt_h.mon_h.monitor_port.connect(sb_h.fifo_desti_tlm[i].analysis_export);

                foreach(s_agt_top_h[i])
                        s_agt_top_h[i].s_agt_h.mon_h.monitor_port.connect(sb_h.fifo_source_tlm[i].analysis_export);
        end

endfunction : connect_phase

// end of elaboaration phase
function void router_env::end_of_elaboration_phase(uvm_phase phase);
        uvm_top.print_topology();
endfunction : end_of_elaboration_phase
