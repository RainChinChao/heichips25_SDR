// SPDX-FileCopyrightText: © 2025 XXX Authors
// SPDX-License-Identifier: Apache-2.0

// Adapted from the Tiny Tapeout template

`default_nettype none

module heichips25_template (
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
    wire _unused = &{ena, uio_in[3:0]};


	
	
	logic [1:0] in_sel;
	assign in_sel = ui_in[7:6];
	logic [4:0]II_out;
	logic [4:0]QQ_out;
	logic [3:0]data_out;
	assign II_out = ui_in[5:1];
	
	assign QQ_out[4:1] = uio_in[7:4];
	assign QQ_out[0] =ui_in[0];
	//demodulation part
	
	Demo_Data_full Demo1(
	clk,
	rst_n,
    II_out,     // Control signal
    QQ_out,
    in_sel,
    data_out      // Selected output
);




	assign uo_out[7:4]='1;
	assign uo_out[3:0]=data_out;
	
	assign uio_out[7:4]='1;
	assign uio_out[3:0]=data_out;

assign uio_oe  = '0;



endmodule
