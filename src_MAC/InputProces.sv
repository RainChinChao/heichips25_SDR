module Input_pro (
    input  logic clk,
    input  logic rst_n,  // Active-low synchronous reset
    input  logic signed [3:0] in_data,  // Q5.10 fixed-point input
    //output logic        valid,          // Output valid flag
    output logic [5:0]  out_data        // Rounded unsigned output (0 to 8)
);

    // Internal wires/regs
    logic signed [15:0] data_plus_4;
    logic signed [15:0] adjusted;
    logic signed [15:0] rounded;
    logic        in_range;

    // Step 1: Range Check
    always_comb begin
        if (in_data >= -4'sd6 && in_data < 16'sd6)
            in_range = 1'b1;
        else
            in_range = 1'b0;
    end

    // Step 2: Add 4.0 → +4096 in Q5.10
    assign data_plus_4 = in_data + 16'sd8;

    // Step 3: Round by adding 0.5 (512 in Q5.10) and then take integer part
    assign rounded = data_plus_4 + 16'sd1;  // +0.5 for rounding

    // Step 4: On clock, latch result if in range
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            out_data <= 4'd0;
            //valid    <= 1'b0;
        end else begin
            if (in_range) begin
                out_data <= rounded[6:1];  // Take integer part
                //valid    <= 1'b1;
            end else begin
                out_data <= 4'd0;
                //valid    <= 1'b0;
            end
        end
    end

endmodule
