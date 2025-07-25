
class driver;
mailbox #(transaction) drv_mb;
transaction t_driver;
virtual intf class_vif;
    function new(virtual intf.tb class_vif);
    this.class_vif = class_vif;
    endfunction

    task drive ();
    forever begin
        
        @(posedge class_vif.clk);
        drv_mb.get(t_driver);

        class_vif.data_in   <= t_driver.data_in;
        class_vif.en        <= t_driver.en;
        class_vif.address   <= t_driver.address;
        class_vif.rstn      <= t_driver.rstn;
    end
        
    endtask 

endclass 