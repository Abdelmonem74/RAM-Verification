class my_subscriber extends uvm_subscriber #(my_sequence_item);
        `uvm_component_utils(my_subscriber);

        my_sequence_item my_item; 
        uvm_analysis_imp #(my_sequence_item, my_subscriber) sbscrb_analysis_imp;


        covergroup op_group;
            d_out : coverpoint my_item.data_out {
                option.auto_bin_max = 128;
                }
            v_out : coverpoint my_item.valid_out;
            cross v_out,d_out; 
        endgroup


        function new(string name = "my_subscriber", uvm_component parent = null);
            super.new(name,parent);
            op_group = new();
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            my_item = my_sequence_item::type_id::create("my_item");
            
            $display("Build phase from my_subscriber");

            sbscrb_analysis_imp = new("sbscrb_analysis_imp", this);
        endfunction

        function void write (my_sequence_item t);
            my_item = t;
            coverage(my_item);
        endfunction

        


        function void coverage(my_sequence_item my_item);                
                op_group.sample();
                print(my_item);
        endfunction 

        function void print(my_sequence_item my_item);
            $display("Transaction :");
            $display("address = %0d", my_item.address);
            $display("data_in = %0d", my_item.data_in);
            $display("en      = %0b", my_item.en);
            $display("rstn    = %0b", my_item.rstn);
        endfunction
    endclass