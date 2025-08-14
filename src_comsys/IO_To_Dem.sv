module IO_To_Dem (
    input  logic       clk,
    input  logic       rst_n,
    input  logic [7:0] IO_in,
    output logic [15:0] data_out
);

    
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out[15:8] <= 8'b0;
        else
            data_out[15:8] <= IO_in;
    end
	
	
	
	always_ff @(negedge clk or negedge rst_n) begin
        if (!rst_n)
            data_out[7:0] <= 8'b0;
        else
            data_out[7:0] <= IO_in;
    end
 
endmodule
