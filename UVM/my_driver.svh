class my_driver extends uvm_driver #(my_sequence_item);
        `uvm_component_utils(my_driver);

        my_sequence_item my_item; 
        virtual intf config_virtual;  

        uvm_seq_item_pull_port #(my_sequence_item, my_sequence_item) drv_seq_item_port;

        function new(string name = "my_driver", uvm_component parent = null);
            super.new(name,parent);
        endfunction
        
        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            my_item = my_sequence_item::type_id::create("my_item");

            if (!uvm_config_db #(virtual intf)::get(this,"","my_vif",config_virtual)) begin
                `uvm_fatal(get_full_name(), "Error!");
            end

            drv_seq_item_port = new("drv_seq_item_port", this);

            $display("Build phase from my_driver");
        endfunction

        task run_phase(uvm_phase phase);
            super.run_phase(phase);
            forever begin
                $display("run phase of driver");
                drv_seq_item_port.get_next_item(my_item);
                $display("get next item of driver");
                @(negedge config_virtual.clk);

                config_virtual.rstn    <= my_item.rstn;
                config_virtual.en      <= my_item.en;
                config_virtual.address <= my_item.address;
                config_virtual.data_in <= my_item.data_in;

                //drv_seq_item_port.put_response(my_item);
                drv_seq_item_port.item_done();
                $display("item done of driver");
            end
            
        endtask
    endclass