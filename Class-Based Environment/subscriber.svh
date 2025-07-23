class subscriber;
    transaction t_sbscrb;
    mailbox #(transaction) sbscrb_mb;
    task print();
        forever begin
            sbscrb_mb.get(t_sbscrb);
            $display("Transaction :");
            $display("  address = %0d", t_sbscrb.address);
            $display("  data_in = %0d", t_sbscrb.data_in);
            $display("  en      = %0b", t_sbscrb.en);
            $display("  rstn    = %0b", t_sbscrb.rstn);
        end
    endtask
endclass