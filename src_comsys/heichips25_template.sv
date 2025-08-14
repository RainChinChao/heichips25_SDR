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
	wire _unused = &{ena, ui_in[0]};

    // Modulation Part
    wire [1:0] in_sel;
    assign in_sel = ui_in[7:6];  // Select modulation settings

    wire [3:0] FPGA_data;
    assign FPGA_data = ui_in[5:2];  // Data input for modulation

    wire signed [3:0] i_out;
    wire signed [3:0] q_out;

    assign uo_out[3:0] = i_out;   // Assign I (in-phase) output to lower 4 bits
    assign uo_out[7:4] = q_out;   // Assign Q (quadrature) output to upper 4 bits






    // Modulation module instantiation
    All_mod mod1(
        .clk(clk),
        .rst_n(rst_n),          // Active-low reset
        .select(in_sel),        // Modulation guess from AMC
        .bit_in(FPGA_data),
        .i_out(i_out),    
        .q_out(q_out)          
    );











    // Demodulation Part
    wire [4:0] II_out;
    wire [4:0] QQ_out;
    wire [3:0] data_out;

    assign II_out = uio_in[3:0];  // Control signal for demodulation
    assign QQ_out[4:1] = uio_in[7:4];  // Upper bits from input
    assign QQ_out[0] = ui_in[1];  // Lower bit from input for demodulation

    // Demodulation module instantiation
    Demo_Data_full Demo1(
        .clk(clk),
        .rst_n(rst_n),
        .I(II_out),     // Control signal
        .Q(QQ_out),
        .sel(in_sel),
        .bit_out(data_out)  // Selected output
    );

    assign uio_out[3:0] = data_out;  // Output data from demodulation
assign uio_out[7:4] = '0;



assign uio_oe  = '1;




endmodule
