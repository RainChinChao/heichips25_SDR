// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

`default_nettype none

module heichips25_template_Mod (
    input  wire [7:0] ui_in,    // Dedicated inputs
    output wire [7:0] uo_out,   // Dedicated outputs
    input  wire [7:0] uio_in,   // IOs: Input path
    output wire [7:0] uio_out,  // IOs: Output path
    output wire [7:0] uio_oe,   // IOs: Enable path (active high: 0=input, 1=output)
    input  wire       ena,      // always 1 when the design is powered, so you can ignore it
    input  wire       clk,      // clock
    input  wire       rst_n     // reset_n - low to reset
);

    // List all unused inputs to prevent warnings
    wire _unused = &{ena, ui_in[1:0],uio_in[7:0]};



	logic [1:0] in_sel;
	assign in_sel = ui_in[7:6];
	
	logic [3:0]FPGA_data;
	assign FPGA_data = ui_in[5:2];
	


//modulation part
	
	logic [3:0] i_out;
	logic [3:0] q_out;
	
	assign uo_out[3:0] = i_out;
	assign uo_out[7:4] = q_out;
	assign uio_out[3:0] = i_out;
	assign uio_out[7:4] = q_out;
	
	All_mod mod1(
    clk,
    rst_n,          // Active-low reset
    in_sel,          // Modulation guess from AMC
    FPGA_data,
    i_out,    
    q_out     
             
);
	

	
	
	
	
assign uio_oe  = '1;





endmodule
