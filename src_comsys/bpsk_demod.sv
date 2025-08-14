module bpsk_demod (
    input  logic         clk,
    input  logic         rst_n,       // active-low reset
    input  logic signed [4:0] i_in,  // I input (Q10 fixed-point)
    input  logic signed [4:0] q_in,  // Q input (unused)
    output logic         bit_out      // Output bit: 0 or 1
);

    // BPSK decision: bit = 0 if I >= 0, else 1
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_out <= 1'b0;
        else
            bit_out <= (i_in >= 5'sd0) ? 1'b0 : 1'b1;
    end

endmodule
