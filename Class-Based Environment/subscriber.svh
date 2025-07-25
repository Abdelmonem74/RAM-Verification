class subscriber;
    transaction t_sbscrb;
    mailbox #(transaction) sbscrb_mb;
    

    covergroup op_group;
            d_out : coverpoint t_sbscrb.data_out {
                option.auto_bin_max = 128;
                }
            v_out : coverpoint t_sbscrb.valid_out;
            cross v_out,d_out; 
    endgroup

    function new();
        op_group = new();
    endfunction

    task coverage();
        forever begin
            sbscrb_mb.get(t_sbscrb);
            op_group.sample();
            print();
        end

    endtask 

    task print();
        $display("Transaction :");
        $display("address = %0d", t_sbscrb.address);
        $display("data_in = %0d", t_sbscrb.data_in);
        $display("en      = %0b", t_sbscrb.en);
        $display("rstn    = %0b", t_sbscrb.rstn);
    endtask
endclass