module psk8_mapper (
    input  logic        clk,
    input  logic        rst_n,        // Active-low reset
    input  logic [3:0]  bit_in,       // 3-bit input symbol
    output logic signed [3:0] i_out, // I output in Q10
    output logic signed [3:0] q_out  // Q output in Q10
);

    // Q10 format constants (scaled by 1024)
    localparam signed [3:0] ONE              =  4'sd2;  // +1.0
    localparam signed [3:0] ZERO             =  4'sd0;     //  0.0
    localparam signed [3:0] HALF_SQRT2       =  4'sd1;   // +0.707
    localparam signed [3:0] NEG_ONE          = -4'sd2;  // -1.0
    localparam signed [3:0] NEG_HALF_SQRT2   = -4'sd1;   // -0.7071

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i_out <= 4'sd0;
            q_out <= 4'sd0;
        end else begin
            case (bit_in)
                4'b000: begin i_out <= ONE;             q_out <= ZERO;             end // 0°
                4'b001: begin i_out <= HALF_SQRT2;      q_out <= HALF_SQRT2;       end // 45°
                4'b011: begin i_out <= ZERO;            q_out <= ONE;              end // 90°
                4'b010: begin i_out <= NEG_HALF_SQRT2;  q_out <= HALF_SQRT2;       end // 135°
                4'b110: begin i_out <= NEG_ONE;         q_out <= ZERO;             end // 180°
                4'b111: begin i_out <= NEG_HALF_SQRT2;  q_out <= NEG_HALF_SQRT2;   end // 225°
                4'b101: begin i_out <= ZERO;            q_out <= NEG_ONE;          end // 270°
                4'b100: begin i_out <= HALF_SQRT2;      q_out <= NEG_HALF_SQRT2;   end // 315°
                default: begin
                    i_out <= 4'sd0;
                    q_out <= 4'sd0;
                end
            endcase
        end
    end

endmodule
