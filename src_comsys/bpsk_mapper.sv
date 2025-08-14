module bpsk_mapper (
    input  logic        clk,
    input  logic        rst_n,          // Active-low reset
    input  logic        [3:0]bit_in,         // 1-bit input symbol
    output logic signed [3:0] i_out,   // I output in Q10
    output logic signed [3:0] q_out    // Q output (zero for BPSK)
);

    // Q10 format: 1.0 = 1024
    localparam signed [15:0] PLUS_ONE_Q10  =  4'sd2;
    localparam signed [15:0] MINUS_ONE_Q10 = -8'sd2;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_out <= 4'sd0;
            q_out <= 4'sd0;
        end else begin
            i_out <= (bit_in == 4'b0000) ? PLUS_ONE_Q10 : MINUS_ONE_Q10;
            q_out <= 4'sd0;  // BPSK has no Q component
        end
    end

endmodule

