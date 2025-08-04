class my_agent extends uvm_agent;
        `uvm_component_utils(my_agent);

        my_driver    my_drv;
        my_sequencer my_sqncr;
        my_monitor   my_mntr;
        virtual intf config_virtual;
        uvm_analysis_port #(my_sequence_item) agent_analysis_port;

        function new(string name = "my_agent", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            my_drv   = my_driver::type_id::create("my_drv", this);
            my_sqncr = my_sequencer::type_id::create("my_sqncr", this);
            my_mntr  = my_monitor::type_id::create("my_mntr", this);

            if (!uvm_config_db #(virtual intf)::get(this,"","my_vif",config_virtual)) begin
                `uvm_fatal(get_full_name(), "Error!");
            end

            uvm_config_db #(virtual intf)::set(this, "my_drv",  "my_vif", config_virtual);
            uvm_config_db #(virtual intf)::set(this, "my_mntr", "my_vif", config_virtual);

            agent_analysis_port = new("agent_analysis_port", this);

            $display("Build phase from my_agent");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            my_mntr.mntr_analysis_port.connect(agent_analysis_port);
            my_drv.drv_seq_item_port.connect(my_sqncr.sqncr_seq_item_imp);
        endfunction
    endclass