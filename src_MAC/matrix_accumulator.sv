module matrix_accumulator#(
	parameter MA_SIZE = 4,
    parameter RANGE_X_MIN = 0,                  // inclusive
    parameter RANGE_X_MAX = 3,    // inclusive
    parameter RANGE_Y_MIN = 0,
    parameter RANGE_Y_MAX = 3
)

(
    input  logic clk,
    input  logic rst_n,
    //input  logic enable,                        // when high, triggers the update
    input  logic [5:0] x_index,
    input  logic [5:0] y_index,
    output logic [8:0] [MA_SIZE*MA_SIZE-1:0]matrix // 8-bit counters
);

    // Internal signals
    logic in_range;
    logic [5:0] x_local;
    logic [5:0] y_local;

    // Check if x and y are in valid range
    always_comb begin
        in_range = (x_index >= RANGE_X_MIN && x_index <= RANGE_X_MAX) &&
                   (y_index >= RANGE_Y_MIN && y_index <= RANGE_Y_MAX);
        x_local  = x_index - RANGE_X_MIN;
        y_local  = y_index - RANGE_Y_MIN;
    end

    // Update matrix on clock
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            // Reset matrix
            integer i, j;
            for (i = 0; i < MA_SIZE; i = i + 1)
                for (j = 0; j < MA_SIZE; j = j + 1)
                    matrix[i*MA_SIZE+j] <= '0;
        end else begin
            if (in_range) begin
                matrix[x_local*MA_SIZE+y_local] <= matrix[x_local*MA_SIZE+y_local] + 1;
            end
        end
    end

endmodule
