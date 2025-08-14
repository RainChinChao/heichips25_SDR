module qam16_mapper (
    input  logic        clk,
    input  logic        rst_n,          // Active-low reset
    input  logic [3:0]  bit_in,         // 4-bit input symbol
    output logic signed [3:0] i_out,   // I output in Q10
    output logic signed [3:0] q_out    // Q output in Q10
);

    // Q10 format levels
    localparam signed [3:0] LEVEL_3   =  4'sd6;  // +3.0
    localparam signed [3:0] LEVEL_1   =  4'sd2;  // +1.0
    localparam signed [3:0] LEVEL_N1  = -4'sd2;  // –1.0
    localparam signed [3:0] LEVEL_N3  = -4'sd6;  // –3.0

    logic signed [4:0] i_level, q_level;

    // Combinational I/Q mapping from Gray-coded bits
    always_comb begin
        // I component mapping from bit_in[3:2]
        case (bit_in[3:2])
            2'b00: i_level = LEVEL_N3;
            2'b01: i_level = LEVEL_N1;
            2'b11: i_level = LEVEL_1;
            2'b10: i_level = LEVEL_3;
            default: i_level = 8'sd0;
        endcase

        // Q component mapping from bit_in[1:0]
        case (bit_in[1:0])
            2'b00: q_level = LEVEL_N3;
            2'b01: q_level = LEVEL_N1;
            2'b11: q_level = LEVEL_1;
            2'b10: q_level = LEVEL_3;
            default: q_level = 8'sd0;
        endcase
    end

    // Registered output for timing control
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_out <= 4'sd0;
            q_out <= 4'sd0;
        end else begin
            i_out <= i_level;
            q_out <= q_level;
        end
    end

endmodule
