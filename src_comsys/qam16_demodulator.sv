module qam16_demodulator (
    input  logic         clk,
    input  logic         rst_n,         // Active-low reset
    input  logic signed [4:0] i_in,    // I input (Q10)
    input  logic signed [4:0] q_in,    // Q input (Q10)
    output logic [3:0]   bit_out        // 4-bit demodulated output
);

    // Thresholds in Q10 (scaled by 1024): midpoints between symbol levels
    localparam signed [4:0] THR_M2 = -8'sd3; // midpoint between -3 and -1
    localparam signed [4:0] THR_0  =  8'sd0;    // midpoint between -1 and +1
    localparam signed [4:0] THR_P2 =  8'sd3; // midpoint between +1 and +3

    // Gray-coded decoding function: maps Q10 input to 2-bit code
    function automatic [1:0] gray_decode (
        input signed [4:0] val
    );
        begin
            if (val < THR_M2)
                gray_decode = 2'b00;  // represents -3
            else if (val < THR_0)
                gray_decode = 2'b01;  // represents -1
            else if (val < THR_P2)
                gray_decode = 2'b11;  // represents +1
            else
                gray_decode = 2'b10;  // represents +3
        end
    endfunction

    // Sequential demodulation logic
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            bit_out <= 4'b0000;
        else
            bit_out <= { gray_decode(i_in), gray_decode(q_in) }; // MSB=I, LSB=Q
    end

endmodule
