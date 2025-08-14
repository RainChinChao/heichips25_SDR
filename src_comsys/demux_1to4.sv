module demux_1to4 (
    input  logic [4:0] in_data,
    input  logic [1:0]       sel,
    output logic [4:0] out0,
    output logic [4:0] out1,
    output logic [4:0] out2,
    output logic [4:0] out3
);

    always_comb begin
        // Default all outputs to zero
        out0 = '0;
        out1 = '0;
        out2 = '0;
        out3 = '0;

        // Route input to selected path
        case (sel)
            2'b00: out0 = in_data;
            2'b01: out1 = in_data;
            2'b10: out2 = in_data;
            2'b11: out3 = in_data;
            default: ; // No change needed; all are already zero
        endcase
    end

endmodule
