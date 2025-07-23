import config_pack::*;
class transaction;
            logic [DATA_WIDTH-1:0]   data_out;
            logic                    valid_out;
    rand    logic [DATA_WIDTH-1:0]   data_in;
    rand    logic                    en;
    rand    logic [ADDR_WIDTH-1:0]   address;
            logic                    rstn;

endclass 
