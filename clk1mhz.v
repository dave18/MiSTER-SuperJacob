`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2019 17:51:01
// Design Name: 
// Module Name: clk1mhz
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


module clk1mhz(
    input clkin,
    output clkout
    );
    
    reg [2:0] counter;
    
    assign clkout=counter[2];
    
    initial
    begin
        counter<=0;
    end
    
    always @(posedge clkin)
    begin
        counter<=counter+1;
    end
endmodule
