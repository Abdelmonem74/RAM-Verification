class my_sequencer extends uvm_sequencer #(my_sequence_item);
        `uvm_component_utils(my_sequencer);

        my_sequence_item my_item;  
        
        uvm_seq_item_pull_imp #(my_sequence_item, my_sequence_item, my_sequencer) sqncr_seq_item_imp;

        function new(string name = "my_sequencer", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            my_item = my_sequence_item::type_id::create("my_item");

            sqncr_seq_item_imp = new("sqncr_seq_item_imp", this);

            $display("Build phase from my_sequencer");
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            $display("run phase of sequencer");
        endtask
    endclass