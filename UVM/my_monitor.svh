class my_monitor extends uvm_monitor;
        `uvm_component_utils(my_monitor);

        my_sequence_item my_item;
        virtual intf config_virtual;
        uvm_analysis_port #(my_sequence_item) mntr_analysis_port;

        function new(string name = "my_monitor", uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            my_item = my_sequence_item::type_id::create("my_item");

            if (!uvm_config_db #(virtual intf)::get(this,"","my_vif",config_virtual)) begin
                `uvm_fatal(get_full_name(), "Error!");
            end

            mntr_analysis_port = new("mntr_analysis_port", this);

            $display("Build phase from my_monitor");
        endfunction

        task run_phase (uvm_phase phase);
            $display("run phase of monitor");
            super.run_phase(phase);
            
            forever begin
                
                @(posedge config_virtual.clk);
                my_item.rstn      = config_virtual.rstn;
                my_item.en        = config_virtual.en;
                my_item.address   = config_virtual.address;
                my_item.data_in   = config_virtual.data_in;
                my_item.data_out  = config_virtual.data_out;
                my_item.valid_out = config_virtual.valid_out;

                mntr_analysis_port.write(my_item);
            end
    
        endtask

    endclass