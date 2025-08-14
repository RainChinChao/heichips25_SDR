module top (
    input  logic        clk,
    input  logic        rst_n,

    // Control from FPGA / core
    input  logic        mode_sel,    // 0: TX (mod), 1: RX (demod)
    input  logic [1:0]  in_sel,      // selects which 4 bits appear on data_out

    
	// data from FPGA 4 bits
	input  logic [3:0]  FPGA_data,
	
    // To on-chip logic (to demod section)
    //output logic [7:0]  demo_data,   // TX: 0x00, RX: captured from IO
    output logic [3:0]  data_out,    // 4-bit slice of demo_data

    // Off-chip 8-bit bidirectional bus (package pins)
    inout  wire  [7:0]  IO
);
	
	
	
	logic [7:0]  demo_data;
	//IO Bus part
	
	logic [7:0]   tx_data;
	IO_Bus IO_Bus1(
    mode_sel,    // 0: TX (mod), 1: RX (demod)
    tx_data,     // data from modulation
	demo_data,   // TX: 0x00, RX: captured from IO
    IO);
	
	
	
	
	
	
	
	//modulation part
	
	logic signed [3:0] i_out;
	logic signed [3:0] q_out;
	
	All_mod mod1(
    clk,
    rst_n,          // Active-low reset
    in_sel,          // Modulation guess from AMC
    FPGA_data,
    i_out,    
    q_out     
             
);
	
	always_comb begin
    tx_data[7:4] = i_out;
    tx_data[3:0] = q_out;
	end
	
	
	
	//data to demodulation part
	
	
	logic [15:0] IO_data_out;
	IO_To_Dem IO_To_Dem1(
    clk,
    rst_n,
    demo_data,
    IO_data_out
);
	
	//demodulation part
	
	Demo_Data_full Demo1(
	clk,
	rst_n,
    IO_data_out[15:8],     // Control signal
    IO_data_out[7:0],
    in_sel,
    data_out      // Selected output
);
	
endmodule