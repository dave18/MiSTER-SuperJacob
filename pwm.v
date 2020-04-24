`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 19.01.2019 15:56:37
// Design Name: 
// Module Name: pwm
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

module pwm(
    input clk,
    input [15:0] pwm_in,
    input [15:0] dac_in,
    input [15:0] dac_in1,
    input [15:0] dac_in2,
    input [15:0] dac_in3,
    input sample_playing,
    input sample_playing1,
    input sample_playing2,
    input sample_playing3,
    output reg pwm_out,
	 output wire [15:0] mixed
    );
    

  wire [2:0] samples_playing=sample_playing3+sample_playing2+sample_playing1+sample_playing;    
  
  wire [18:0] mixer=(dac_in+dac_in1+dac_in2+dac_in3)/samples_playing;
  assign mixed=mixer[15:0]+pwm_in;//pwm_in;//mixer[17:2];
/*    reg [16:0] pwm_accumulator;
    
     always @(posedge clk)
     begin
        if (samples_playing)
        begin
            pwm_accumulator <= pwm_accumulator[15:0] + pwm_in+(((dac_in+dac_in1+dac_in2+dac_in3)/samples_playing) <<6);
        end 
        else pwm_accumulator <= pwm_accumulator[15:0] + pwm_in+14'h2000; 
     end
    


    assign pwm_out = pwm_accumulator[16];// & pwm_accumulator_dac[16] & pwm_accumulator_dac1[8] & pwm_accumulator_dac2[8] & pwm_accumulator_dac3[8];
*/    
    
wire [17:0] Sadder;
wire [17:0] Dadder_i;
reg  [17:0] Dadder;
reg  [17:0] Slatch;

//tb uuttb();

assign Dadder_i =(samples_playing)?((Slatch[17] << 17) | (Slatch[17] << 16) | (pwm_in+((dac_in+dac_in1+dac_in2+dac_in3)/samples_playing) )):((Slatch[17] << 17) | (Slatch[17] << 16) | (pwm_in+14'h2000));
assign Sadder = Dadder + Slatch;

initial begin
	Slatch <= 18'h2000;
	pwm_out <= 1'b0;
end

always@(posedge clk) begin// or posedge rst) begin
	//if(rst) begin
//		Dadder <= 0;
	//end
	//else
	//begin
		Dadder <= Dadder_i;
	//end
end

always@(posedge clk) begin// or posedge rst) begin
	//if(rst) begin
	//	Slatch <= 10'h200;
	//	dac_out <= 1'b0;
	//end
	//else
	//begin

        Slatch <= Sadder;
		pwm_out <= Slatch[17];
	//end
end    
    
endmodule
