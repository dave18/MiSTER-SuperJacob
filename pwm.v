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
	 input [15:0] ts_in_l,    
    input [15:0] opl_in,
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
    
	 
localparam SASIZE=19;
    
wire [SASIZE-1:0] Sadder;
wire [SASIZE-1:0] Dadder_i;
reg  [SASIZE-1:0] Dadder;
reg  [SASIZE-1:0] Slatch;

wire [2:0] samples_playing=sample_playing3+sample_playing2+sample_playing1+sample_playing;    
  
wire [18:0] mixer=(dac_in+dac_in1+dac_in2+dac_in3)/samples_playing;
  
reg [16:0] unsigned_opl;
reg [16:0] unsigned_ay;
 
wire [17:0] dac_sum = dac_in+dac_in1+dac_in2+dac_in3;

wire [18:0] no_clip_mix=dac_in+dac_in1+dac_in2+dac_in3+pwm_in+unsigned_ay[15:0]+unsigned_opl[15:0];
assign mixed=no_clip_mix[17:2];
//assign mixed=mixer[15:0]+pwm_in+unsigned_ay+unsigned_opl;//pwm_in;//mixer[17:2];
//assign mixed=dac_in+dac_in1+dac_in2+dac_in3+pwm_in+unsigned_ay[15:0]+unsigned_opl[15:0];//pwm_in;//mixer[17:2];
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
  

//tb uuttb();

assign Dadder_i =(samples_playing)?((Slatch[SASIZE-1] << SASIZE-1) | (Slatch[SASIZE-1] << SASIZE-2)) + unsigned_ay+(pwm_in<<1)+unsigned_opl+dac_sum[17:2]:((Slatch[SASIZE-1] << SASIZE-1) | (Slatch[SASIZE-1] << SASIZE-2)) + unsigned_ay+(pwm_in<<1)+unsigned_opl+16'h8000;
assign Sadder = Dadder + Slatch;

initial begin
	Slatch <= 19'h0;
	pwm_out <= 1'b0;
end

always
begin
    unsigned_opl<=((opl_in*2)+16'h8000);
    unsigned_ay<=(ts_in_l+16'h8000);
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
		pwm_out <= Slatch[SASIZE-1];
	//end
end    
    
endmodule
