
class monitor;
transaction t_monitor;
mailbox #(transaction) mntr_mb1,mntr_mb2;
virtual intf class_vif;
    function new(virtual intf.tb class_vif);
    this.class_vif = class_vif;
    t_monitor = new();
    endfunction

    task mon();
    
    forever begin
    
        @(posedge class_vif.clk);
        #(0.1*clk_period);
        t_monitor.data_out  <= class_vif.data_out;
        t_monitor.valid_out <= class_vif.valid_out;
        t_monitor.data_in   <= class_vif.data_in;
        t_monitor.en        <= class_vif.en;
        t_monitor.address   <= class_vif.address;
        t_monitor.rstn      <= class_vif.rstn;
        
        if(class_vif.rstn) begin
            mntr_mb1.put(t_monitor);
            mntr_mb2.put(t_monitor);
        end
    end
    endtask 
endclass