module toptop (
    input  logic        clk,        
    input  logic        rst_n,      

    input  logic        select,     // 0 = receive, 1 = transmit
    
    input [1:0]  guess,   		// for modulation type select or guess

    inout  wire  [3:0]  io_bus,      // external 4-bit bus from FPGA

    // Off-chip 8-bit bidirectional bus (package pins)
    inout  wire  [7:0]  IO 			// IO external
);
	
	

	
	
	
	
	
	
	
	    // internal
    logic [3:0] bus_in;
    logic [3:0]  data_in;
    logic [3:0] bus_out;
    logic       bus_oe; // 1 = drive bus, 0 = Hi-Z

    // drive control
    always_comb begin
        if (select) begin
            bus_oe  = 1'b1; 
            bus_out = data_out;
        end else begin
            bus_oe  = 1'b0;
            bus_out = 4'h0; // don't-care when not driving
        end
    end

    // receive path
    always_comb begin
        if (!select) data_in = bus_in;
        else         data_in = 4'h0; // or hold last value if preferred
    end


    // tri-state at top (OK for sim; ASIC should replace with pad cells)
    assign io_bus = (bus_oe) ? bus_out : 'bz;
    assign bus_in = io_bus;
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	logic [3:0]  data_out;
	
	
	
top t1(
    clk,
    rst_n,

    // Control from FPGA / core
    select,    // 0: TX (mod), 1: RX (demod)
    guess,      // selects which 4 bits appear on data_out

    
	// data from FPGA 4 bits
	
	data_in,
	
    
    data_out,    // 4-bit slice of demo_data

    // Off-chip 8-bit bidirectional bus (package pins)
    IO
);
	
	
	
	
endmodule