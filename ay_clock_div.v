`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 17.07.2020 17:40:37
// Design Name: 
// Module Name: ay_clock_div
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


module ay_clock_div(
    input clk,
    output reg ay_sig
    );
    
    reg  [4:0] counter;
    
    
    
    initial
    begin
        counter<=0;
    end
    
    always @(posedge clk)
    begin
        counter<=counter+1'd1;
        ay_sig<=!counter;
    end
    
endmodule
