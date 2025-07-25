class sequencer;
transaction t;
mailbox #(transaction)  seq_mb;

    function new();
        t = new();
    endfunction

    task create_transaction(
        input logic [DATA_WIDTH-1:0]  d_in,
        input logic                   enable,
        input logic [ADDR_WIDTH-1:0]  addr,
        input bit                     rstn);

        seq_mb.put(t);
        //$display("put reset = %0b, din = %0d, at time = %0t",t.rstn,t.data_in,$time);
        t.data_in  = d_in;
        t.en       = enable;
        t.address  = addr;
        t.rstn     = rstn;
        

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

    test_vector directed_tests[] = '{ //dynamic array of struct
    '{32'h0000_0000, 1'b0, 0, 0 },
    '{32'h0000_0000, 1'b0, 0, 1 },
    '{32'hAAAA_BBBB, 1'b1, 5, 1 },
    '{32'h0000_0000, 1'b0, 5, 1 },
    '{32'hCCC0_CCC0, 1'b1, 7, 1 },
    '{32'h0000_0000, 1'b0, 7, 1 },
    '{32'hFFFF_FFFF, 1'b1, 15,1 },
    '{32'h0000_0000, 1'b0, 15,1 },
    '{32'hABCD_0000, 1'b1, 6, 1 },
    '{32'hABCD_0000, 1'b0, 6, 1 },
    '{32'h0000_ABCD, 1'b1, 11, 1 },
    '{32'h0000_ABCD, 1'b0, 11, 1 },
    '{32'h00AB_CD00, 1'b1, 13, 1 },
    '{32'h00AB_CD00, 1'b0, 13, 1 },
    '{32'h00CD_AB00, 1'b1, 2, 1 },
    '{32'h00CD_AB00, 1'b0, 2, 1 }
};

task transactions();
        int n_rand_tests = 1000;
        
        foreach (directed_tests[i]) begin
            create_transaction (directed_tests[i].d_in, directed_tests[i].en, directed_tests[i].addr, directed_tests[i].rstn);            
        end

        
        for (int i = 0; i < n_rand_tests; i++) begin
            seq_mb.put(t);
            void'(t.randomize());
        end
    endtask
endclass