class desti_mon extends uvm_monitor;

   `uvm_component_utils(desti_mon)

   //-------------------------------------------------------
   // Virtual Interface
   //-------------------------------------------------------

   virtual router_inf.DESTI_MON_MP vif;

   //-------------------------------------------------------
   // Analysis Port
   //-------------------------------------------------------

   uvm_analysis_port #(desti_xtn) monitor_port;

   //-------------------------------------------------------
   // Config Handle
   //-------------------------------------------------------

   desti_agt_config m_cfg;

   int i;

   //-------------------------------------------------------
   // Constructor
   //-------------------------------------------------------

   function new(string name="desti_mon",
                uvm_component parent);

      super.new(name,parent);

      monitor_port = new("monitor_port",this);

   endfunction

   //-------------------------------------------------------
   // Build Phase
   //-------------------------------------------------------

   function void build_phase(uvm_phase phase);

      super.build_phase(phase);

      if(!uvm_config_db #(desti_agt_config)::get(this,
                                                 "",
                                                 "desti_agt_config",
                                                 m_cfg))
      begin
         `uvm_fatal(get_type_name(),
                    "Cannot get desti_agt_config")
      end

   endfunction

   //-------------------------------------------------------
   // Connect Phase
   //-------------------------------------------------------

   function void connect_phase(uvm_phase phase);

      super.connect_phase(phase);

      vif = m_cfg.vif;

   endfunction

   //-------------------------------------------------------
   // Run Phase
   //-------------------------------------------------------

   task run_phase(uvm_phase phase);

      repeat(10)
         collect_data();

   endtask


//-------------------------------------------------------
// Collect Packet
//-------------------------------------------------------

task collect_data();

   desti_xtn xtn_h;

   xtn_h = desti_xtn::type_id::create("xtn_h");

   //----------------------------------------------------
   // WAIT FOR START OF PACKET
   //----------------------------------------------------
   wait (vif.desti_mon_cb.read_enb);


   //----------------------------------------------------
   // CAPTURE HEADER
   //----------------------------------------------------
   xtn_h.header = vif.desti_mon_cb.data_out;

   xtn_h.addr = vif.desti_mon_cb.data_out[1:0];

   xtn_h.payload_len =
            vif.desti_mon_cb.data_out[7:2];

   //----------------------------------------------------
   // ALLOCATE PAYLOAD ARRAY
   //----------------------------------------------------

   xtn_h.payload_data =
            new[xtn_h.payload_len];

      @(vif.desti_mon_cb);

   //----------------------------------------------------
   // CAPTURE PAYLOAD
   //----------------------------------------------------

   foreach(xtn_h.payload_data[i]) begin

   wait (vif.desti_mon_cb.read_enb);

      @(vif.desti_mon_cb);

      xtn_h.payload_data[i] =
                vif.desti_mon_cb.data_out;

   end

   //----------------------------------------------------
   // CAPTURE PARITY
   //----------------------------------------------------

   //@(vif.desti_mon_cb);

   xtn_h.parity =
            vif.desti_mon_cb.data_out;

   //----------------------------------------------------
   // SEND TO SCOREBOARD
   //----------------------------------------------------

   monitor_port.write(xtn_h);

   //----------------------------------------------------
   // PACKET COUNT
   //----------------------------------------------------

   m_cfg.mon_pkt_count++;

   `uvm_info(get_type_name(),
      $sformatf("The destination pkt : %0s",
      xtn_h.sprint()),
      UVM_LOW)

endtask


endclass
