module qpsk_demod (
    input  logic         clk,
    input  logic         rst_n,       // Active-low reset
    input  logic signed [4:0] i_in,  // I input in Q10 format
    input  logic signed [4:0] q_in,  // Q input in Q10 format
    output logic [1:0]   bit_out      // Demodulated 2-bit symbol
);

    // Gray-coded QPSK demodulation using I/Q sign bits:
    // 00: I≥0, Q≥0 → symbol 00
    // 10: I<0,  Q≥0 → symbol 01
    // 11: I<0,  Q<0  → symbol 11
    // 01: I≥0, Q<0  → symbol 10

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_out <= 2'b00;
        else begin
            case ({i_in[7], q_in[7]})  // use sign bits only
                2'b00: bit_out <= 2'b00;
                2'b10: bit_out <= 2'b01;
                2'b11: bit_out <= 2'b11;
                2'b01: bit_out <= 2'b10;
            endcase
        end
    end

endmodule
