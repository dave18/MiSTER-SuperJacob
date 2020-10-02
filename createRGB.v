`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2018 00:47:59
// Design Name: 
// Module Name: createRGB
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


module createRGB(
    input clk,
    input vga_v_sync,
    input vga_h_sync,
    input [9:0] CounterX,
    input [9:0] CounterY,
    input inDisplayArea,
    input [11:0] v_data,        //main video data 12 bit colour
    input [11:0] v_data2,       //foreground tilemap 12 bit color
    input [11:0] spr_data,      //hardware sprites 12 bit color
    input [11:0] spr_data2,      //hardware sprites 12 bit color
    input foreground_enable,
    input spr_active,
    input spr_active2,
    input io_in,
	 input io_out,
    input [7:0] io_data_in,
    input [15:0] io_address_in,
    input foregroundmask,
    input cpuwait,
	 output reg [7:0] io_data_out,
    output reg vga_R,
    output reg vga_G,
    output reg vga_B,
    output reg vga_R1,
    output reg vga_G1,
    output reg vga_B1,
    output reg vga_R2,
    output reg vga_G2,
    output reg vga_B2,
    output reg vga_R3,
    output reg vga_G3,
    output reg vga_B3,
    output wire vga_v_sync2,
    output wire vga_h_sync2,
	 output reg spr_int  //interrupt for sprite collisions
    );
    
    
assign vga_h_sync2=vga_h_sync;
assign vga_v_sync2=vga_v_sync;
reg io_ack;
//reg show_scan_lines;
//reg background_enable;
//reg screen_enable;
reg [7:0] screen_reg;
reg [7:0] io_latch;
//reg screenActive;
reg [7:0] coll_x_lo;
reg [7:0] coll_x_hi;
reg [7:0] coll_y;

//wire screenActive=inDisplayArea;
wire screenActive=(screen_reg[7])?inDisplayArea:0;
/////////////////////////////////////////////////////////////////

initial
begin
    io_ack<=0;
    //show_scan_lines<=0;
    //background_enable<=1;
    //screen_enable<=1;
    screen_reg<=8'b10000010;
	 spr_int<=1;
end

//wire screenActive;
//wire [9:0] CounterX;
//wire [8:0] CounterY;

//hvsync_generator syncgen(.vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), 
//  .screenActive(screenActive), .CounterX(CounterX), .CounterY(CounterY));

/////////////////////////////////////////////////////////////////

//wire [7:0] v_data;
//vid_ram_inf vidsync(.v_data(v_data));


/////////////////////////////////////////////////////////////////


//reg [17:0] Counter1;
/*
wire R = CounterY[3] | (CounterX==256);
wire G = (CounterX[5] ^ CounterX[6]) | (CounterX==256);
wire B = CounterX[4] | (CounterX==256);

wire R1 = CounterY[2] | (CounterX==256);
wire G1 = (CounterX[4] ^ CounterX[5]) | (CounterX==256);
wire B1 = CounterX[3] | (CounterX==256);

wire R2 = CounterY[1] | (CounterX==256);
wire G2 = (CounterX[3] ^ CounterX[4]) | (CounterX==256);
wire B2 = CounterX[2] | (CounterX==256);

wire R3 = CounterY[0] | (CounterX==256);
wire G3 = (CounterX[2] ^ CounterX[3]) | (CounterX==256);
wire B3 = CounterX[1] | (CounterX==256);
*/

/*
wire R = Counter1[6];
wire G = Counter1[7];
wire B = Counter1[8];

wire R1 = Counter1[9];
wire G1 = Counter1[10];
wire B1 = Counter1[11];

wire R2 = Counter1[12];
wire G2 = Counter1[13];
wire B2 = Counter1[14];

wire R3 = Counter1[15];
wire G3 = Counter1[16];
wire B3 = Counter1[17];
*/

wire R = v_data[8];
wire G = v_data[4];
wire B = v_data[0];

wire R1 = v_data[9];
wire G1 = v_data[5];
wire B1 = v_data[1];

wire R2 = v_data[10];
wire G2 = v_data[6];
wire B2 = v_data[2];

wire R3 = v_data[11];
wire G3 = v_data[7];
wire B3 = v_data[3];

/*
wire R = (background_enable)?v_data[8]:0;
wire G = (background_enable)?v_data[4]:0;
wire B = (background_enable)?v_data[0]:0;

wire R1 = (background_enable)?v_data[9]:0;
wire G1 = (background_enable)?v_data[5]:0;
wire B1 = (background_enable)?v_data[1]:0;

wire R2 = (background_enable)?v_data[10]:0;
wire G2 = (background_enable)?v_data[6]:0;
wire B2 = (background_enable)?v_data[2]:0;

wire R3 = (background_enable)?v_data[11]:0;
wire G3 = (background_enable)?v_data[7]:0;
wire B3 = (background_enable)?v_data[3]:0;
*/
wire R_2 = v_data2[8];
wire G_2 = v_data2[4];
wire B_2 = v_data2[0];

wire R1_2 = v_data2[9];
wire G1_2 = v_data2[5];
wire B1_2 = v_data2[1];

wire R2_2 = v_data2[10];
wire G2_2 = v_data2[6];
wire B2_2 = v_data2[2];

wire R3_2 = v_data2[11];
wire G3_2 = v_data2[7];
wire B3_2 = v_data2[3];

//wire R = 0;//CounterY[3] | (CounterX==256);
//wire G = 0;//(CounterX[5] ^ CounterX[6]) | (CounterX==256);
//wire B = 0;//CounterX[4] | (CounterX==256);

/*wire R = 1;
wire G = 1;
wire B = 1;

wire R1 = 0;
wire G1 = 0;
wire B1 = 0;

wire R2 = 0;
wire G2 = 0;
wire B2 = 0;

wire R3 = 0;
wire G3 = 0;
wire B3 = 0;
  */
//wire R = q[7] & q[6] & q[5];
//wire G = q[4] & q[3] & q[2];
//wire B = q[1] & q[0];

wire SR = spr_data[8];
wire SG = spr_data[4];
wire SB = spr_data[0];

wire SR1 = spr_data[9];
wire SG1 = spr_data[5];
wire SB1 = spr_data[1];

wire SR2 = spr_data[10];
wire SG2 = spr_data[6];
wire SB2 = spr_data[2];

wire SR3 = spr_data[11];
wire SG3 = spr_data[7];
wire SB3 = spr_data[3];  

wire SR_2 = spr_data2[8];
wire SG_2 = spr_data2[4];
wire SB_2 = spr_data2[0];

wire SR1_2 = spr_data2[9];
wire SG1_2 = spr_data2[5];
wire SB1_2 = spr_data2[1];

wire SR2_2 = spr_data2[10];
wire SG2_2 = spr_data2[6];
wire SB2_2 = spr_data2[2];

wire SR3_2 = spr_data2[11];
wire SG3_2 = spr_data2[7];
wire SB3_2 = spr_data2[3];
  
//reg vga_R, vga_G, vga_B;
//reg vga_R1, vga_G1, vga_B1;
//reg vga_R2, vga_G2, vga_B2;
//reg vga_R3, vga_G3, vga_B3;

always @(posedge clk)
begin
	 if (!vga_v_sync) spr_int<=1;            //reset sprite collision flag in vblank
	 
    if (io_in==0)	//have we had an IO signal
	 begin
	   if (io_ack==0) //have we already acknowledged it?
	   begin
            io_ack<=1;	//acknowledge it
	        case (io_address_in[7:0])
					'h21:	begin			//reset interrupt and flags
	               spr_int<=1;
	               coll_x_hi<=coll_x_hi & 8'b00000001;
	               //coll_x_hi<=8'd0;
	               //coll_x_lo<=8'd0;
	               //coll_y<=8'd0;
	            end
                'h20:	begin			//set show scanlines flag
					//show_scan_lines<=io_data_in[0:0];
				//	screen_enable<=io_data_in[7:7];
				//	background_enable<=io_data_in[1:1];
				    screen_reg<=io_data_in;
				end
			endcase
		end
	 end
	 
	if (io_out==0)
    begin
        if (io_ack==0) //have we already acknowledged it?
		begin
			io_ack<=1;	//acknowledge it
            case (io_address_in[7:0])
					 'h23:  begin
                    io_latch<=coll_x_hi;
                    io_data_out<=coll_x_hi;
                 end
                 'h22:  begin
                    io_latch<=coll_x_lo;
                    io_data_out<=coll_x_lo;
                 end
                'h21:  begin
                    io_latch<=coll_y;
                    io_data_out<=coll_y;
                 end
                 'h20:  begin
                    io_latch<=screen_reg;
                    io_data_out<=screen_reg;
                 end		        
		   endcase
		end
		
		io_data_out[7:0]<=io_latch[7:0];
    end
    else io_data_out<=8'bZ;
    
    if ((io_in) && (io_out)) io_ack<=0;
	 
//end


//always @(posedge clk)
//begin
    //screenActive<=(screen_enable)?0:inDisplayArea;
    if (screen_reg[0])
    begin
        if (CounterY[0:0])
        begin
           if ((foregroundmask) || (foreground_enable==0))  
    	   begin
    	       if (spr_active)
    	       begin
    	           vga_R <= SR & screenActive;
    	           vga_G <= SG & screenActive;
    	           vga_B <= SB & screenActive;
    	           vga_R1 <= SR1 & screenActive;
    	           vga_G1 <= SG1 & screenActive;
    	           vga_B1 <= SB1 & screenActive;
    	           vga_R2 <= SR2 & screenActive;
    	           vga_G2 <= SG2 & screenActive;
    	           vga_B2 <= SB2 & screenActive;
    	           vga_R3 <= SR3 & screenActive;
    	           vga_G3 <= SG3 & screenActive;
    	           vga_B3 <= SB3 & screenActive;
					  
					  if (spr_int)
	               begin
	                   spr_int<=0;        //if spr is active and foreground active then collision occurs
	                   coll_x_lo<=CounterX[7:0];
    	               coll_x_hi<={7'b0100000,CounterX[8]};
    	               coll_y<=CounterY[7:0];
	               end
    	       end
    	       else
    	       begin
	               if (spr_active2) vga_R <= SR_2 & screenActive; else vga_R <= R & screenActive;
	               if (spr_active2) vga_G <= SG_2 & screenActive; else vga_G <= G & screenActive;
	               if (spr_active2) vga_B <= SB_2 & screenActive; else vga_B <= B & screenActive;
	               if (spr_active2) vga_R1 <= SR1_2 & screenActive; else vga_R1 <= R1 & screenActive;
	               if (spr_active2) vga_G1 <= SG1_2 & screenActive; else vga_G1 <= G1 & screenActive;
	               if (spr_active2) vga_B1 <= SB1_2 & screenActive; else vga_B1 <= B1 & screenActive;
	               if (spr_active2) vga_R2 <= SR2_2 & screenActive; else vga_R2 <= R2 & screenActive;
	               if (spr_active2) vga_G2 <= SG2_2 & screenActive; else vga_G2 <= G2 & screenActive;
	               if (spr_active2) vga_B2 <= SB2_2 & screenActive; else vga_B2 <= B2 & screenActive;
	               if (spr_active2) vga_R3 <= SR3_2 & screenActive; else vga_R3 <= R3 & screenActive;
	               if (spr_active2) vga_G3 <= SG3_2 & screenActive; else vga_G3 <= G3 & screenActive;
	               if (spr_active2) vga_B3 <= SB3_2 & screenActive; else vga_B3 <= B3 & screenActive;
						
						if (spr_active2 & spr_int)
	               begin
	                   spr_int<=0;        //if spr is active and foreground active then collision occurs
	                   coll_x_lo<=CounterX[7:0];
    	               coll_x_hi<={7'b0010000,CounterX[8]};
    	               coll_y<=CounterY[7:0];
	               end
	           end	       
	       end
	       else
	       begin
	           if (spr_active) vga_R <= SR & screenActive; else vga_R <= R_2 & screenActive;
	           if (spr_active) vga_G <= SG & screenActive; else vga_G <= G_2 & screenActive;
	           if (spr_active) vga_B <= SB & screenActive; else vga_B <= B_2 & screenActive;
	           if (spr_active) vga_R1 <= SR1 & screenActive; else vga_R1 <= R1_2 & screenActive;
    	       if (spr_active) vga_G1 <= SG1 & screenActive; else vga_G1 <= G1_2 & screenActive;
    	       if (spr_active) vga_B1 <= SB1 & screenActive; else vga_B1 <= B1_2 & screenActive;
    	       if (spr_active) vga_R2 <= SR2 & screenActive; else vga_R2 <= R2_2 & screenActive;
	           if (spr_active) vga_G2 <= SG2 & screenActive; else vga_G2 <= G2_2 & screenActive;
	           if (spr_active) vga_B2 <= SB2 & screenActive; else vga_B2 <= B2_2 & screenActive;
	           if (spr_active) vga_R3 <= SR3 & screenActive; else vga_R3 <= R3_2 & screenActive;
	           if (spr_active) vga_G3 <= SG3 & screenActive; else vga_G3 <= G3_2 & screenActive;
	           if (spr_active) vga_B3 <= SB3 & screenActive; else vga_B3 <= B3_2 & screenActive;
				  
				  if (spr_active & spr_int)
	           begin
	               spr_int<=0;        //if spr is active and foreground active then collision occurs
	               coll_x_lo<=CounterX[7:0];
	               coll_x_hi<={7'b1000000,CounterX[8]};
	               coll_y<=CounterY[7:0];
	            end
	        end
	    end
	    else
	    begin
	       if ((foregroundmask) || (foreground_enable==0))  
    	   begin
    	       if (spr_active)
    	       begin
//    	           if (cpuwait)
//    	           begin
    	           vga_R <= SR2 & screenActive;
    	           vga_G <= SG2 & screenActive;
    	           vga_B <= SB2 & screenActive;
    	           vga_R1 <= SR3 & screenActive;
    	           vga_G1 <= SG3 & screenActive;
    	           vga_B1 <= SB3 & screenActive;
    	           vga_R2 <= 0;
    	           vga_G2 <= 0;
    	           vga_B2 <= 0;
    	           vga_R3 <= 0;
    	           vga_G3 <= 0;
    	           vga_B3 <= 0;
  /*  	           end
	           else
	           begin
	           vga_R=1;
	           vga_G=1;
	           vga_B=1;
	           vga_R1=1;
	           vga_G1=1;
	           vga_B1=1;
	           vga_R2=1;
	           vga_G2=1;
	           vga_B2=1;
	           vga_R3=1;
	           vga_G3=1;
	           vga_B3=1;
	           end*/
    	       end
    	       else
    	       begin
//    	           if (cpuwait)
//    	           begin
	               if (spr_active2) vga_R <= SR2_2 & screenActive; else vga_R <= R2 & screenActive;
	               if (spr_active2) vga_G <= SG2_2 & screenActive; else vga_G <= G2 & screenActive;
	               if (spr_active2) vga_B <= SB2_2 & screenActive; else vga_B <= B2 & screenActive;
	               if (spr_active2) vga_R1 <= SR3_2 & screenActive; else vga_R1 <= R3 & screenActive;
	               if (spr_active2) vga_G1 <= SG3_2 & screenActive; else vga_G1 <= G3 & screenActive;
	               if (spr_active2) vga_B1 <= SB3_2 & screenActive; else vga_B1 <= B3 & screenActive;
	               vga_R2 <= 0;
	               vga_G2 <= 0;
	               vga_B2 <= 0;
	               vga_R3 <= 0;
	               vga_G3 <= 0;
	               vga_B3 <= 0;
/*	               end
	           else
	           begin
	           vga_R=1;
	           vga_G=1;
	           vga_B=1;
	           vga_R1=1;
	           vga_G1=1;
	           vga_B1=1;
	           vga_R2=1;
	           vga_G2=1;
	           vga_B2=1;
	           vga_R3=1;
	           vga_G3=1;
	           vga_B3=1;
	           end*/
	           end	       
	       end
	       else
	       begin
	           //if (cpuwait)
    	      //     begin
	           if (spr_active) vga_R <= SR2 & screenActive; else vga_R <= R2_2 & screenActive;
	           if (spr_active) vga_G <= SG2 & screenActive; else vga_G <= G2_2 & screenActive;
	           if (spr_active) vga_B <= SB2 & screenActive; else vga_B <= B2_2 & screenActive;
	           if (spr_active) vga_R1 <= SR3 & screenActive; else vga_R1 <= R3_2 & screenActive;
    	       if (spr_active) vga_G1 <= SG3 & screenActive; else vga_G1 <= G3_2 & screenActive;
    	       if (spr_active) vga_B1 <= SB3 & screenActive; else vga_B1 <= B3_2 & screenActive;
    	       vga_R2 <= 0;
	           vga_G2 <= 0;
	           vga_B2 <= 0;
	           vga_R3 <= 0;
	           vga_G3 <= 0;
	           vga_B3 <= 0;
	           /*end
	           else
	           begin
	           vga_R=1;
	           vga_G=1;
	           vga_B=1;
	           vga_R1=1;
	           vga_G1=1;
	           vga_B1=1;
	           vga_R2=1;
	           vga_G2=1;
	           vga_B2=1;
	           vga_R3=1;
	           vga_G3=1;
	           vga_B3=1;
	           end*/
	        end
        end
	end
	else
	begin
    	if ((foregroundmask) || (foreground_enable==0))  
    	begin
    	   if (spr_active)
    	   begin
    	       vga_R <= SR & screenActive;
    	       vga_G <= SG & screenActive;
    	       vga_B <= SB & screenActive;
    	       vga_R1 <= SR1 & screenActive;
    	       vga_G1 <= SG1 & screenActive;
    	       vga_B1 <= SB1 & screenActive;
    	       vga_R2 <= SR2 & screenActive;
    	       vga_G2 <= SG2 & screenActive;
    	       vga_B2 <= SB2 & screenActive;
    	       vga_R3 <= SR3 & screenActive;
    	       vga_G3 <= SG3 & screenActive;
    	       vga_B3 <= SB3 & screenActive;
    	   end
    	   else
    	   begin
	           if (spr_active2) vga_R <= SR_2 & screenActive; else vga_R <= R & screenActive;
	           if (spr_active2) vga_G <= SG_2 & screenActive; else vga_G <= G & screenActive;
	           if (spr_active2) vga_B <= SB_2 & screenActive; else vga_B <= B & screenActive;
	           if (spr_active2) vga_R1 <= SR1_2 & screenActive; else vga_R1 <= R1 & screenActive;
	           if (spr_active2) vga_G1 <= SG1_2 & screenActive; else vga_G1 <= G1 & screenActive;
	           if (spr_active2) vga_B1 <= SB1_2 & screenActive; else vga_B1 <= B1 & screenActive;
	           if (spr_active2) vga_R2 <= SR2_2 & screenActive; else vga_R2 <= R2 & screenActive;
	           if (spr_active2) vga_G2 <= SG2_2 & screenActive; else vga_G2 <= G2 & screenActive;
	           if (spr_active2) vga_B2 <= SB2_2 & screenActive; else vga_B2 <= B2 & screenActive;
	           if (spr_active2) vga_R3 <= SR3_2 & screenActive; else vga_R3 <= R3 & screenActive;
	           if (spr_active2) vga_G3 <= SG3_2 & screenActive; else vga_G3 <= G3 & screenActive;
	           if (spr_active2) vga_B3 <= SB3_2 & screenActive; else vga_B3 <= B3 & screenActive;
	       end	       
	   end
	   else
	   begin
	       if (spr_active) vga_R <= SR & screenActive; else vga_R <= R_2 & screenActive;
	       if (spr_active) vga_G <= SG & screenActive; else vga_G <= G_2 & screenActive;
	       if (spr_active) vga_B <= SB & screenActive; else vga_B <= B_2 & screenActive;
	       if (spr_active) vga_R1 <= SR1 & screenActive; else vga_R1 <= R1_2 & screenActive;
    	   if (spr_active) vga_G1 <= SG1 & screenActive; else vga_G1 <= G1_2 & screenActive;
    	   if (spr_active) vga_B1 <= SB1 & screenActive; else vga_B1 <= B1_2 & screenActive;
    	   if (spr_active) vga_R2 <= SR2 & screenActive; else vga_R2 <= R2_2 & screenActive;
	       if (spr_active) vga_G2 <= SG2 & screenActive; else vga_G2 <= G2_2 & screenActive;
	       if (spr_active) vga_B2 <= SB2 & screenActive; else vga_B2 <= B2_2 & screenActive;
	       if (spr_active) vga_R3 <= SR3 & screenActive; else vga_R3 <= R3_2 & screenActive;
	       if (spr_active) vga_G3 <= SG3 & screenActive; else vga_G3 <= G3_2 & screenActive;
	       if (spr_active) vga_B3 <= SB3 & screenActive; else vga_B3 <= B3_2 & screenActive;
	   end
	end
	
	

	//address <= ByteCounter;
	//Counter1 <= Counter1 + (1 & screenActive);
	//if ((CounterX==0) && (CounterY==0)) Counter1<=0;
end

    
endmodule
