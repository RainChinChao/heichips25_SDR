module Demo_Data_full (
	input logic clk,
	input logic rst_n,
    input  logic [4:0] I,     // Control signal
    input  logic [4:0] Q,
    input logic [1:0]sel,
    output logic [3:0]   bit_out      // Selected output
);


logic [4:0] out0I;
logic [4:0] out1I;
logic [4:0] out2I;
logic [4:0] out3I;
logic [4:0] out0Q;
logic [4:0] out1Q;
logic [4:0] out2Q;
logic [4:0] out3Q;

demux_1to4 demuxI(
    I,
    sel,
    out0I,
    out1I,
    out2I,
    out3I
);


demux_1to4 demuxQ(
    Q,
    sel,
    out0Q,
    out1Q,
    out2Q,
    out3Q
);


    // Internal demod outputs
    logic        bpsk_bit;
    logic [1:0]  qpsk_bits;
    logic [2:0]  psk8_bits;
    logic [3:0]  qam16_bits;

    // BPSK Demodulator
    bpsk_demod bpsk_de1 (
        .clk(clk),
        .rst_n(rst_n),
        .i_in(out0I),
        .q_in(out0Q),
        .bit_out(bpsk_bit)
    );

    // QPSK Demodulator
    qpsk_demod qpsk_de1 (
        .clk(clk),
        .rst_n(rst_n),
        .i_in(out1I),
        .q_in(out1Q),
        .bit_out(qpsk_bits)
    );

    // 8-PSK Demodulator
    psk8_demodulator epsk_de1 (
        .clk(clk),
        .rst_n(rst_n),
        .i_in(out2I),
        .q_in(out2Q),
        .bit_out(psk8_bits)
    );

    // 16-QAM Demodulator
    qam16_demodulator qam16_de1 (
        .clk(clk),
        .rst_n(rst_n),
        .i_in(out3I),
        .q_in(out3Q),
        .bit_out(qam16_bits)
    );

    // Output selector based on AMC guess
    always_comb begin
        case (sel)
            2'b00: bit_out = {3'b000, bpsk_bit};       // 000X
            2'b01: bit_out = {2'b00, qpsk_bits};       // 00XX
            2'b10: bit_out = {1'b0, psk8_bits};        // 0XXX
            2'b11: bit_out = qam16_bits;               // XXXX
            default: bit_out = {3'b000, bpsk_bit};     // Safe fallback
        endcase
    end






endmodule


