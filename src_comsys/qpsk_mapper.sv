module qpsk_mapper (
    input  logic        clk,
    input  logic        rst_n,          // Active-low reset
    input  logic [3:0]  bit_in,         // 2-bit input symbol
    output logic signed [3:0] i_out,   // I output in Q10 format
    output logic signed [3:0] q_out    // Q output in Q10 format
);

    // QPSK Gray mapping:
    // 00 → (+1, +1)
    // 01 → (−1, +1)
    // 11 → (−1, −1)
    // 10 → (+1, −1)

    localparam signed [15:0] PLUS_ONE  =  4'sd2; // +1.0 in Q10
    localparam signed [15:0] MINUS_ONE = -4'sd2; // -1.0 in Q10

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_out <= 4'sd0;
            q_out <= 4'sd0;
        end else begin
            case (bit_in)
                4'b00: begin
                    i_out <= PLUS_ONE;
                    q_out <= PLUS_ONE;
                end
                4'b01: begin
                    i_out <= MINUS_ONE;
                    q_out <= PLUS_ONE;
                end
                4'b11: begin
                    i_out <= MINUS_ONE;
                    q_out <= MINUS_ONE;
                end
                4'b10: begin
                    i_out <= PLUS_ONE;
                    q_out <= MINUS_ONE;
                end
            endcase
        end
    end

endmodule
