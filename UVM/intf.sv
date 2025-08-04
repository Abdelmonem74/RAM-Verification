import config_pack::*;
interface intf ();
    logic [DATA_WIDTH-1:0]   data_out;
    logic                    valid_out;
    logic [DATA_WIDTH-1:0]   data_in;
    logic                    en;
    logic [ADDR_WIDTH-1:0]   address;
    bit                      clk;
    bit                      rstn;

    modport dut (
    input data_in,en,address,clk,rstn,
    output data_out,valid_out
    );
    modport tb (
    output data_in,en,address,
    input data_out,valid_out,clk,rstn
    );

endinterface 