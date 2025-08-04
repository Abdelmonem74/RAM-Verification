class my_scoreboard extends uvm_scoreboard;
        `uvm_component_utils(my_scoreboard);

        my_sequence_item my_item; 
        uvm_analysis_imp #(my_sequence_item, my_scoreboard) scrbrd_analysis_imp;

        logic [DATA_WIDTH] ref_model [logic [ADDR_WIDTH]]; // Associative array of type logic[data_width]
        int n_testcases,n_testcases_passed;
        bit [ADDR_WIDTH-1:0] prev_addr;
        
        function new(string name = "my_scoreboard", uvm_component parent = null);
            super.new(name,parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            my_item = my_sequence_item::type_id::create("my_item");
            scrbrd_analysis_imp = new("scrbrd_analysis_imp", this);
            $display("Build phase from my_scoreboard");
        endfunction

        virtual task write (my_sequence_item my_item);
            compare(my_item);
        endtask


        task compare (my_sequence_item my_item);
        
            if (!my_item.rstn) begin
                $display("RESET occured");
            end
            else begin

                if (my_item.valid_out) begin
                        n_testcases++;
                        if (ref_model.exists(prev_addr)) begin
                            if (ref_model[prev_addr] !== my_item.data_out) begin
                                $error("[SCOREBOARD] test FAILED at address %0d: expected = %0d, got = %0d",
                                                                    prev_addr, ref_model[prev_addr], my_item.data_out);
                            end else begin
                                n_testcases_passed++;
                                $display("[SCOREBOARD] test PASSED at address %0d: data = %0d",
                                                                    prev_addr, my_item.data_out);
                            end
                        end
                        else begin
                            if ('0 !== my_item.data_out) begin
                                    $error("[SCOREBOARD] test FAILED at address %0d: expected = %0d, got = %0d",
                                                                        prev_addr,              '0,     my_item.data_out);
                                end else begin
                                    n_testcases_passed++;
                                    $display("[SCOREBOARD] test PASSED at address %0d: data = %0d",
                                                                        prev_addr,     my_item.data_out);
                                end
                            end
                end
                else begin
                    if (~my_item.en) begin
                        $display("IDLE cycle with no reads or writes");
                    end 
                end
                if (~my_item.en) begin // read op
                    prev_addr = my_item.address;
                end else begin // write op
                    ref_model[my_item.address] = my_item.data_in;
                    $display("WRITE OP at address %0d: data = %0d",
                                            my_item.address, my_item.data_in );
                end
            end
            $display("-----------------------------------------------------------------------------------------");
            $display("-----------------------------------------------------------------------------------------");
        
        endtask


    function void report();
        $display("====================================================");
        $display("SCOREBOARD SUMMARY: %0d / %0d testcases passed.", 
                                n_testcases_passed, n_testcases);
        if (n_testcases_passed == n_testcases) begin
            $display("ALL TESTS PASSED!");
        end else begin
            $display("%0d TESTS FAILED!",
            (n_testcases-n_testcases_passed));
        end
        $display("====================================================");
    endfunction
    endclass