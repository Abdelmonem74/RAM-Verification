class env;
    virtual intf class_vif;
    
    scoreboard scr_brd;
    sequencer seq;
    driver drv;
    monitor mntr;
    subscriber sbscrb;
////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////  constructor   //////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
    function new(virtual intf.tb class_vif);
        scr_brd   = new();
        seq  = new();
        drv  = new(class_vif);
        mntr = new(class_vif);
        sbscrb = new();
        this.class_vif = class_vif;


        seq.seq_mb = new(1);
        drv.drv_mb = seq.seq_mb;

        mntr.mntr_mb1 = new(1);
        mntr.mntr_mb2 = new(1);
        scr_brd.scr_brd_mb = mntr.mntr_mb1;
        sbscrb.sbscrb_mb = mntr.mntr_mb2;
    endfunction


////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////  classes calling task   ////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////

    task run ();
           
        fork
        begin
            seq.transactions(); 
        end
        begin
            drv.drive();
        end
        
        begin
            mntr.mon();
        end
        begin
            sbscrb.print();
        end
        begin
            scr_brd.check();
        end
        join_any
        
    endtask


    task end_sim();
        scr_brd.report();
        $finish;
    endtask
endclass 