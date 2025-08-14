module All_mod (
    input  logic         clk,
    input  logic         rst_n,          // Active-low reset
    input  logic [1:0]   select,          // Modulation guess from AMC
    input logic [3:0]   bit_in,
    output  logic signed [3:0] i_out,    
    output  logic signed [3:0] q_out     
             
);


logic signed[7:0] i_out_bpsk;
logic signed[7:0] q_out_bpsk;
logic signed[7:0] i_out_qpsk;
logic signed[7:0] q_out_qpsk;
logic signed[7:0] i_out_8psk;
logic signed[7:0] q_out_8psk;
logic signed[7:0] i_out_qam16;
logic signed[7:0] q_out_qam16;

bpsk_mapper bpsk_mod(
    clk,
    rst_n,          // Active-low reset
    bit_in,         // 1-bit input symbol
    i_out_bpsk,   // I output in Q10
    q_out_bpsk    // Q output (zero for BPSK)
);

 qpsk_mapper qpsk_mod(
    clk,
    rst_n,          // Active-low reset
    bit_in,         // 2-bit input symbol
    i_out_qpsk,   // I output in Q10 format
    q_out_qpsk   // Q output in Q10 format
);






psk8_mapper psk8_mod(
    clk,
    rst_n,
    bit_in,              // 3-bit input symbol
    i_out_8psk,       // I output in Q10
    q_out_8psk       // Q output in Q10

);


qam16_mapper qam16_mod(
    clk,
    rst_n,
    bit_in,               // 4-bit input symbol
    i_out_qam16,        // 16-bit I output in Q10
    q_out_qam16       // 16-bit Q output in Q10
    
);




always_comb begin
    case (select)
        2'b00: i_out = i_out_bpsk;

        2'b01: i_out = i_out_qpsk;
            
        2'b10:  i_out = i_out_8psk;
            
        2'b11:   i_out = i_out_qam16;
           
        default:  i_out = i_out_bpsk;
            
    endcase
end


always_comb begin
    case (select)
        2'b00:q_out = q_out_bpsk;
        
        2'b01:  q_out = q_out_qpsk;
        
        2'b10: q_out = q_out_8psk;
        
        2'b11:  q_out = q_out_qam16;
        
        default: q_out = q_out_bpsk;
        
    endcase
end


endmodule