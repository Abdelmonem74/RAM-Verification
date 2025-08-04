class my_sequence extends uvm_sequence;
    `uvm_object_utils(my_sequence);

    function new(string name = "my_sequence");
        super.new(name);
    endfunction

    my_sequence_item my_seq_item;

    task pre_body();
        my_seq_item = my_sequence_item::type_id::create("my_seq_item");
        $display("pre_body task of sequence run"); 
    endtask 

    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////  struct for direct tests   ////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////
    typedef struct {
        logic [DATA_WIDTH-1:0]  d_in;
        logic                   en;
        logic [ADDR_WIDTH-1:0]  addr;
        bit                     rstn;
    } test_vector;

    test_vector directed_tests[] = '{
        '{32'hFFFF_FFFF, 1'b1, 20, 0 },
        '{32'h0000_0000, 1'b0, 0, 1 },
        '{32'hAAAA_BBBB, 1'b1, 5, 1 },
        '{32'h0000_0000, 1'b0, 5, 1 },
        '{32'hCCC0_CCC0, 1'b1, 7, 1 },
        '{32'h0000_0000, 1'b0, 7, 1 }
    };

    task body();
        int n_rand_tests = 1000;
        $display("body of sequence");

        foreach (directed_tests[i]) begin
            start_item(my_seq_item);
            $display("start item of sequence item %0d directed", i);
            my_seq_item.data_in = directed_tests[i].d_in;
            my_seq_item.en      = directed_tests[i].en;
            my_seq_item.address = directed_tests[i].addr;
            my_seq_item.rstn    = directed_tests[i].rstn;
            finish_item(my_seq_item);
            $display("finish item of sequence item %0d directed", i);

            // Traceability logging
            `uvm_info("TRACE", $sformatf("DIRECTED: idx=%0d rstn=%0b en=%0b addr=0x%0h data=0x%0h",
                                         i,
                                         directed_tests[i].rstn,
                                         directed_tests[i].en,
                                         directed_tests[i].addr,
                                         directed_tests[i].d_in),
                      UVM_LOW)
        end

        for (int i = 0; i < n_rand_tests; i++) begin
            start_item(my_seq_item);
            $display("start item of sequence item random");
            void'(my_seq_item.randomize());
            finish_item(my_seq_item);
            $display("finish item of sequence item random");

            // Traceability logging
            `uvm_info("TRACE", $sformatf("RANDOM: idx=%0d rstn=%0b en=%0b addr=0x%0h data=0x%0h",
                                         i,
                                         my_seq_item.rstn,
                                         my_seq_item.en,
                                         my_seq_item.address,
                                         my_seq_item.data_in),
                      UVM_LOW)
        end
    endtask
endclass
