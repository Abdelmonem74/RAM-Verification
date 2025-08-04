class my_env extends uvm_env;
        `uvm_component_utils(my_env);

        my_agent      my_agnt;
        my_scoreboard my_scrbrd;
        my_subscriber my_sbscrb;
        virtual intf  config_virtual;

        function new(string name = "my_env", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            my_agnt   = my_agent::type_id::create("my_agnt", this);
            my_scrbrd = my_scoreboard::type_id::create("my_scrbrd", this);
            my_sbscrb = my_subscriber::type_id::create("my_sbscrb", this);

            if (!uvm_config_db #(virtual intf)::get(this,"","my_vif",config_virtual)) begin
                `uvm_fatal(get_full_name(), "Error!");
            end

            uvm_config_db #(virtual intf)::set(this,"my_agnt","my_vif",config_virtual);

            $display("Build phase from my_env");
        endfunction

        function void connect_phase(uvm_phase phase);
            super.connect_phase(phase);
            my_agnt.agent_analysis_port.connect(my_scrbrd.scrbrd_analysis_imp);
            my_agnt.agent_analysis_port.connect(my_sbscrb.sbscrb_analysis_imp);
        endfunction
endclass