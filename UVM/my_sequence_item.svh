class my_sequence_item extends uvm_sequence_item; 
        `uvm_object_utils(my_sequence_item);

                logic [DATA_WIDTH-1:0]   data_out;
                logic                    valid_out;
        rand    logic [DATA_WIDTH-1:0]   data_in;
        rand    logic                    en;
        rand    logic [ADDR_WIDTH-1:0]   address;
        rand    logic                    rstn;

        constraint low_freq_rst {
                rstn dist { 1 := 9, 0 := 1 };
        }

        function new(string name = "my_sequence_item");
            super.new(name);
        endfunction
    endclass 