class my_test extends uvm_test;
        `uvm_component_utils(my_test);

        my_env my_env1;
        my_sequence seq;
        virtual intf config_virtual;

        function new(string name = "my_test", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);

            my_env1 = my_env::type_id::create("my_env1", this);
            seq = my_sequence::type_id::create("seq");

            if (!uvm_config_db #(virtual intf)::get(this,"","my_vif",config_virtual)) begin
                `uvm_fatal(get_full_name(), "Error!");
            end

            uvm_config_db #(virtual intf)::set(this,"my_env1","my_vif",config_virtual);

            $display("Build phase from my_test");

        endfunction

        task run_phase(uvm_phase phase);
            
            phase.raise_objection(this);

            seq.start(my_env1.my_agnt.my_sqncr); 
            $display("start task of seq run"); 
        
            phase.drop_objection(this);
        endtask
    endclass
