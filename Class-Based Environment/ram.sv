module ram #(
    ADDR_WIDTH = 4,
    DATA_WIDTH = 32
) (
    intf.dut intf1
);
//MEM declaration
logic [DATA_WIDTH-1:0] mem [2**ADDR_WIDTH-1:0];


//MEM initialization
initial begin
    $readmemh("mem_init.txt", mem);
end

always @(posedge intf1.clk or negedge intf1.rstn) begin 
    if (!intf1.rstn) begin
        intf1.data_out  <=  'd0;
        intf1.valid_out <= 1'b0;
    end
    else begin
        if (intf1.en) begin
            mem[intf1.address] <= intf1.data_in;
            intf1.valid_out    <= 1'b0;
        end
        else begin
            intf1.data_out     <= mem[intf1.address];
            intf1.valid_out    <= 1'b1;
        end
    end
end

endmodule