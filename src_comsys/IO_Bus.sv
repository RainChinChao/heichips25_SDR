// io_iface_onefile.sv
module IO_Bus (
    //input  logic        clk,
    //input  logic        rst_n,

    // Control from FPGA / core
    input  logic        mode_sel,    // 0: TX (mod), 1: RX (demod)
    //input  logic [1:0]  in_sel,      // selects which 4 bits appear on data_out

    // TX path (core -> off-chip when mode_sel=0)
    input  logic [7:0]  tx_data,     // data from modulation

    // To on-chip logic (to demod section)
    output logic [7:0]  demo_data,   // TX: 0x00, RX: captured from IO
    //output logic [3:0]  data_out,    // 4-bit slice of demo_data

    // Off-chip 8-bit bidirectional bus (package pins)
    inout  wire  [7:0]  IO
);



    logic [7:0] ext_in;    // sampled from IO (off-chip -> core)
    logic [7:0] ext_out;   // driven to IO (core -> off-chip)
    logic       ext_oe;    // output-enable: 1=drive IO, 0=Hi-Z

    always_comb begin
        if (mode_sel == 1'b0) begin
            // Modulation / transmit mode
            ext_oe    = 1'b1;
            ext_out   = tx_data;
            demo_data = 8'h00;        // abandon demod path in TX mode
        end else begin
            // Demodulation / receive mode
            ext_oe    = 1'b0;
            ext_out   = 8'h00;        // don't-care while not driving
            demo_data = ext_in;       // use off-chip bus as demod input
        end
    end
	
	
	
	
	
	
	
	
	
	
	

	
	
	


    // Top-level tri-state (OK for sim). For ASIC, replace with real PAD cells.
    assign IO     = (ext_oe) ? ext_out : 'bz;
    assign ext_in = IO;



endmodule
