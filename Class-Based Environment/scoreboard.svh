
class scoreboard;
mailbox #(transaction) scr_brd_mb;
transaction t_scr_brd;
    logic [DATA_WIDTH] ref_model [logic [ADDR_WIDTH]]; // Associative array of type logic[data_width]
    int n_testcases,n_testcases_passed;
    bit [ADDR_WIDTH-1:0] prev_addr;
    task check ();
        forever begin
            scr_brd_mb.get(t_scr_brd);

            if (t_scr_brd.valid_out) begin
                    n_testcases++;
                    if (ref_model.exists(prev_addr)) begin
                        if (ref_model[prev_addr] !== t_scr_brd.data_out) begin
                            $error("[SCOREBOARD] test FAILED at address %0d: expected = %0d, got = %0d",
                                                                prev_addr, ref_model[prev_addr], t_scr_brd.data_out);
                        end else begin
                            n_testcases_passed++;
                            $display("[SCOREBOARD] test PASSED at address %0d: data = %0d",
                                                                prev_addr, t_scr_brd.data_out);
                        end
                    end
                    else begin
                        if ('0 !== t_scr_brd.data_out) begin
                                $error("[SCOREBOARD] test FAILED at address %0d: expected = %0d, got = %0d",
                                                                    prev_addr,              '0,     t_scr_brd.data_out);
                            end else begin
                                n_testcases_passed++;
                                $display("[SCOREBOARD] test PASSED at address %0d: data = %0d",
                                                                    prev_addr,     t_scr_brd.data_out);
                            end
                        end
            end
            else begin
                if (~t_scr_brd.en) begin
                    $display("IDLE cycle with no checks or writes");
                end 
            end
                
            if (~t_scr_brd.en) begin // read op
                prev_addr = t_scr_brd.address;
            end else begin // write op
                ref_model[t_scr_brd.address] = t_scr_brd.data_in;
                $display("WRITE OP at address %0d: data = %0d",
                                        t_scr_brd.address, t_scr_brd.data_in );
            end
            $display("-----------------------------------------------------------------------------------------");
        end
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