`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 16.02.2019 19:29:41
// Design Name: 
// Module Name: z80_clk_ctrl
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module z80_clk_ctrl(
    input wire clk,
	 input wire clk2,
    input wire clk_ctrl,
    input wire clk_ctrl_DMA,
	 input wire sdram_ready,
	 input wire ram_wait,
    output reg outclk
    );
    
   // reg [1:0] speed;
	reg oldclk;
    
    //assign outclk=(clk_ctrl & clk_ctrl_DMA & sdram_ready)?clk:0;
	 //assign outclk=(clk_ctrl & clk_ctrl_DMA & ~ram_wait)?clk2:0;
    //assign outclk=(clk_ctrl & clk_ctrl_DMA)?speed[1]:0;
    
    always @(posedge clk)
    begin
      //  speed<=speed+1;
		if (clk_ctrl & clk_ctrl_DMA & ~ram_wait)
		begin
			outclk<=clk2;
			oldclk<=clk2;
		end
		else
		begin
			outclk<=oldclk;
		end
    end
	 /*always @(negedge clk)
    begin
        outclk<=(clk_ctrl & clk_ctrl_DMA & sdram_ready)?clk:1;
    end*/
	 
endmodule
