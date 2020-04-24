`timescale 1 ns / 100 ps

module tb ();

//Inputs to DUT are reg type
	reg CLOCK;
/*	reg WE;
	reg [7:0] OFFSET;
	reg RESET_N;

//Output from DUT is wire type
	wire [8:0] RD_DATA;

//Instantiate the DUT
	PLL_RAM Test1 (
		.RESET_N(RESET_N),
		.OFFSET(OFFSET),
		.WE(WE),
		.CLOCK(CLOCK),
		.RD_DATA(RD_DATA)
	);*/
	
	sys_top test1 (
		.FPGA_CLK1_50(CLOCK),
		.FPGA_CLK2_50(CLOCK),
		.FPGA_CLK3_50(CLOCK)
	);

//Create a 50MHz clock
always
	#10 CLOCK = ~CLOCK;

//Initial Block
initial
begin
	$display($time, " << Starting Simulation >> ");
	CLOCK = 1'b0;
/*	RESET_N = 1'b1;
	WE = 1'b1;
	OFFSET = 8'b00000000;
	
	#5 RESET_N = 1'b0;
	OFFSET = 8'b10000000;
	
	@(posedge CLOCK); 
	#1000 RESET_N = 1'b1;
	#5 RESET_N = 1'b0;
	@(posedge CLOCK);
	OFFSET = 8'b00011100;*/

	#3000;
	$display($time, "<< Simulation Complete >>");
	$stop;
end

endmodule
