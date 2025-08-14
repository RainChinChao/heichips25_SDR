module MAC4x4 (
    input  logic         clk,
    input  logic         rst_n,
    input  logic [9:0][15:0]   A ,      // 4x4 matrix A, flattened
    input  logic [9:0][15:0]   B ,      // 4x4 matrix B, flattened
    output logic [23:0]  total_sum      // Registered output
);

    // Stage 0: Input Multiplication (registered)
    logic [19:0][15:0] products_ff ;  // Registered products

    genvar i;
    generate
        for (i = 0; i < 16; i++) begin : mult_stage
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    products_ff[i] <= 16'd0;
                else
                    products_ff[i] <= A[i] * B[i];
            end
        end
    endgenerate

    // Stage 1: First layer of adder tree (registered)
    logic [20:0][7:0] sum_lvl1_ff ;
    generate
        for (i = 0; i < 8; i++) begin : add_lvl1
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    sum_lvl1_ff[i] <= 17'd0;
                else
                    sum_lvl1_ff[i] <= products_ff[2*i] + products_ff[2*i+1];
            end
        end
    endgenerate

    // Stage 2: Second layer of adder tree (registered)
    logic [21:0][3:0] sum_lvl2_ff ;
    generate
        for (i = 0; i < 4; i++) begin : add_lvl2
            always_ff @(posedge clk or negedge rst_n) begin
                if (!rst_n)
                    sum_lvl2_ff[i] <= 18'd0;
                else
                    sum_lvl2_ff[i] <= sum_lvl1_ff[2*i] + sum_lvl1_ff[2*i+1];
            end
        end
    endgenerate

    // Stage 3: Third layer (registered)
    logic [22:0][1:0] sum_lvl3_ff;
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            sum_lvl3_ff[0] <= 19'd0;
            sum_lvl3_ff[1] <= 19'd0;
        end else begin
            sum_lvl3_ff[0] <= sum_lvl2_ff[0] + sum_lvl2_ff[1];
            sum_lvl3_ff[1] <= sum_lvl2_ff[2] + sum_lvl2_ff[3];
        end
    end

    // Stage 4: Final sum (registered output)
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            total_sum <= 32'd0;
        else
            total_sum <= sum_lvl3_ff[0] + sum_lvl3_ff[1];
    end

endmodule
