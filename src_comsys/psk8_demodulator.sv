module psk8_demodulator (
    input  logic         clk,
    input  logic         rst_n,       // Active-low reset
    input  logic signed [4:0] i_in,  // I input (Q10)
    input  logic signed [4:0] q_in,  // Q input (Q10)
    output logic [2:0]   bit_out      // Demodulated 3-bit output
);

    // Precomputed threshold: 0.7071 * 1024 ≈ 724
    localparam signed [4:0] THRESH = 5'sd1;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            bit_out <= 3'b000;
        end else begin
            // Region 0: 0°     (I +THRESH, Q (−THRESH, +THRESH))
            if (i_in >= THRESH && q_in > -THRESH && q_in < THRESH)
                bit_out <= 3'b000;

            // Region 1: 45°    (I +THRESH, Q +THRESH)
            else if (i_in >= THRESH && q_in >= THRESH)
                bit_out <= 3'b001;

            // Region 2: 90°    (Q +THRESH, I  (−THRESH, +THRESH))
            else if (q_in >= THRESH && i_in > -THRESH && i_in < THRESH)
                bit_out <= 3'b011;

            // Region 3: 135°   (I −THRESH, Q  +THRESH)
            else if (i_in <= -THRESH && q_in >= THRESH)
                bit_out <= 3'b010;

            // Region 4: 180°   (I  −THRESH, Q  (−THRESH, +THRESH))
            else if (i_in <= -THRESH && q_in > -THRESH && q_in < THRESH)
                bit_out <= 3'b110;

            // Region 5: 225°   (I  −THRESH, Q  −THRESH)
            else if (i_in <= -THRESH && q_in <= -THRESH)
                bit_out <= 3'b111;

            // Region 6: 270°   (Q  −THRESH, I (−THRESH, +THRESH))
            else if (q_in <= -THRESH && i_in > -THRESH && i_in < THRESH)
                bit_out <= 3'b101;

            // Region 7: 315°   (I  +THRESH, Q  −THRESH)
            else if (i_in >= THRESH && q_in <= -THRESH)
                bit_out <= 3'b100;

            // Fallback (center or noisy symbol)
            else
                bit_out <= 3'b000;
        end
    end

endmodule
