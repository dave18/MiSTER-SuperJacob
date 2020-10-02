`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11.01.2019 08:27:02
// Design Name: 
// Module Name: sprite_gen
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


module sprite_gen(
    input clk,
    input nReset,
    input [9:0] CounterX,
    input [9:0] CounterY,
    input [127:0] spr_data_in,
    input [15:0] spr_pal_in,
    input [15:0] spr_pal_in2,
    input [7:0] line_store_data_in,
    input [7:0] line_store_data_in2,
    input [7:0] line_store_data_in_2,
    input [7:0] line_store_data_in2_2,
    input [7:0] line_store2_data_in,
    input [7:0] line_store2_data_in2,
    input [15:0] io_address_in,
    input [7:0] io_data_in,
    input io_in,
    input [63:0] sprite_attr_data_in,
    //input show_scan_lines,
    output reg [15:0] spr_pal_out,
    output reg [7:0] spr_pal_address_read,
    output reg [7:0] spr_pal_address_write,
    output reg [15:0] spr_pal_out2,
    output reg [7:0] spr_pal_address_read2,
    output reg [7:0] spr_pal_address_write2,
    output reg spr_pal_we,
    output reg spr_pal_we2,
    output reg [8:0] line_store_read,
    output reg [8:0] line_store_write,
    output reg [8:0] line_store_read2,
    output reg [8:0] line_store_write2,
    output reg line_store_we,
    output reg line_store_we2,
    output reg [7:0] line_store_data_out,
    output reg [7:0] line_store_data_out2,
    output reg [8:0] line_store2_read,
    output reg [8:0] line_store2_write,
    output reg [8:0] line_store2_read2,
    output reg [8:0] line_store2_write2,
    output reg line_store2_we,
    output reg line_store2_we2,
    output reg [7:0] line_store2_data_out,
    output reg [7:0] line_store2_data_out2,
    output reg [8:0] line_store_read_2,
    output reg [8:0] line_store_write_2,
    output reg [8:0] line_store_read2_2,
    output reg [8:0] line_store_write2_2,
    output reg line_store_we_2,
    output reg line_store_we2_2,
    output reg [7:0] line_store_data_out_2,
    output reg [7:0] line_store_data_out2_2,
    output reg [7:0] spr_data_out,
    output reg spr_active,
    output reg spr_active2,
    output reg [11:0] spr_vid_out,
    output reg [11:0] spr_vid_out2,
    output reg spr_we,
    output reg [9:0] spr_address_read,
    output reg [13:0] spr_address_write,
    output reg [7:0] sprite_attr_data_out,
    output reg spr_attr_we,
    output reg [6:0] sprite_attr_addr_read,
    output reg [9:0] sprite_attr_addr_write
    );
  
    /*reg [8:0] spritex;
    reg [8:0] spritey;
    reg flipx;
    reg flipy;
    reg [6:0] pattern;
    reg visible;
    reg priority;        //if 1 then sprite is shown in front of foreground layer
    reg [3:0] paloffset;
    reg spritemode;
    
    reg [8:0] spritex_2;
    reg [8:0] spritey_2;
    reg flipx_2;
    reg flipy_2;
    reg [6:0] pattern_2;
    reg visible_2;
    reg priority_2;        //if 1 then sprite is shown in front of foreground layer
    reg [3:0] paloffset_2;
    reg spritemode_2;*/
    
    //reg [63:0] sprite_attr_data;
    //reg [63:0] sprite_attr_data_2;
    
    
//    reg [8:0] spritex [127:0];
//    reg [8:0] spritey [127:0];
//    reg flipx [127:0];
//    reg flipy [127:0];
//    reg [6:0] pattern [127:0];
//    reg visible [127:0];
 //   reg priority [127:0];        //if 1 then sprite is shown in front of foreground layer
//    reg [3:0] paloffset [127:0];
//    reg spritemode [127:0];      //0=8 bit sprites   1=4 bit sprites
//    reg chainx [63:0];
//    reg chainy [63:0];
    reg spriteon;
    reg spriteon_2;
    reg [5:0] spriteptr;
    reg [6:0] spriteptr_2;
    reg [6:0] currsprite;
    reg [9:0] sprite_attr_addr_base;
    reg spriteprocessing;
    
    reg [127:0] spritetemp;
    reg [127:0] spritetemp_2;
    reg linetemp;
    reg linetemp_2;
    reg [3:0] offsettemp;
    reg [3:0] offsettemp_2;
    reg spritemodetemp;
    reg spritemodetemp_2;
//    reg [8:0] spritextemp;
//    reg [8:0] spriteytemp;
//    reg [6:0] patterntemp;
//    reg [3:0] paloffsettemp;
 //   reg spritemodetemp2;
//    reg visibletemp;
//    reg prioritytemp;
//    reg flipxtemp;
//    reg flipytemp;
    
    reg [2:0] ByteDelay;
    reg [4:0] spritestage;
    reg [7:0] sprite_write_address;
    reg [7:0] spritexoffset;
    reg [7:0] spriteyoffset;
    reg ByteRead;
    reg SpriteRead;
    reg scanlines;
    reg io_ack;
    reg [7:0] maskbyte;
	 
//	 reg [10:0] ByteCounter;
    
    reg [8:0] clip_l;
    reg [8:0] clip_r;
    reg [7:0] clip_t;
    reg [7:0] clip_b;
    
//    integer i;
    
    //reg [8:0] sprite_write_address;
    //reg [8:0] clear_write_address;
    //reg [0:319] mask;
    
    
   // reg [8:0] spritecol;        //column from sprite line to be output to screen
    
    //integer x;
    //integer y;
    
    //reg [7:0] spriteline [0:319];


    /*wire [8:0] spritex=sprite_attr_data[56:48];
    wire [8:0] spritey=sprite_attr_data[40:32];
    wire spritemode=sprite_attr_data[31];
    wire [6:0] pattern=sprite_attr_data[30:24];
    wire flipy=sprite_attr_data[23];
    wire flipx=sprite_attr_data[22];
    wire [3:0] paloffset=sprite_attr_data[19:16];    
    wire priority=sprite_attr_data[9];
    wire visible=sprite_attr_data[8];*/       
        
    /*wire priority=sprite_attr_data[49];
    wire visible=sprite_attr_data[48];
    wire flipy=sprite_attr_data[47];
    wire flipx=sprite_attr_data[46];
    wire [3:0] paloffset=sprite_attr_data[43:40];
    wire spritemode=sprite_attr_data[39];
    wire [6:0] pattern=sprite_attr_data[38:32];
    wire [8:0] spritey=sprite_attr_data[24:16];
    wire [8:0] spritex=sprite_attr_data[8:0];*/
    
    reg priority;
    reg visible;
    reg flipy;
    reg flipx;
    reg [3:0] paloffset;
    reg spritemode;
    reg [6:0] pattern;
    reg [8:0] spritey;
    reg [8:0] spritex; 
    
    /*wire [8:0] spritex_2=sprite_attr_data_2[56:48];
    wire [8:0] spritey_2=sprite_attr_data_2[40:32];
    wire spritemode_2=sprite_attr_data_2[31];
    wire [6:0] pattern_2=sprite_attr_data_2[30:24];
    wire flipy_2=sprite_attr_data_2[23];
    wire flipx_2=sprite_attr_data_2[22];
    wire [3:0] paloffset_2=sprite_attr_data_2[19:16];    
    wire priority_2=sprite_attr_data_2[9];
    wire visible_2=sprite_attr_data_2[8];*/
    
    reg priority_2;
    reg visible_2;
    reg flipy_2;
    reg flipx_2;
    reg [3:0] paloffset_2;
    reg spritemode_2;
    reg [6:0] pattern_2;
    reg [8:0] spritey_2;
    reg [8:0] spritex_2;
    
    /*wire priority_2=sprite_attr_data_2[49];
    wire visible_2=sprite_attr_data_2[48];
    wire flipy_2=sprite_attr_data_2[47];
    wire flipx_2=sprite_attr_data_2[46];
    wire [3:0] paloffset_2=sprite_attr_data_2[43:40];
    wire spritemode_2=sprite_attr_data_2[39];
    wire [6:0] pattern_2=sprite_attr_data_2[38:32];
    wire [8:0] spritey_2=sprite_attr_data_2[24:16];
    wire [8:0] spritex_2=sprite_attr_data_2[8:0];*/
    
    

//Wires to create 2 4 bit depth 16 pixel lines from a single 128 bit read
    wire [7:0] masktemp=(spritemodetemp)?{offsettemp[3:0],maskbyte[3:0]}:maskbyte;
    wire [7:0] masktemp_2=(spritemodetemp_2)?{offsettemp_2[3:0],maskbyte[3:0]}:maskbyte;
  
    wire [7:0] nib01=(linetemp)?{offsettemp[3:0],spritetemp[127:124]}:{offsettemp[3:0],spritetemp[63:60]}; 
    wire [7:0] nib00=(linetemp)?{offsettemp[3:0],spritetemp[123:120]}:{offsettemp[3:0],spritetemp[59:56]};
    wire [7:0] nib03=(linetemp)?{offsettemp[3:0],spritetemp[119:116]}:{offsettemp[3:0],spritetemp[55:52]};
    wire [7:0] nib02=(linetemp)?{offsettemp[3:0],spritetemp[115:112]}:{offsettemp[3:0],spritetemp[51:48]};
    wire [7:0] nib05=(linetemp)?{offsettemp[3:0],spritetemp[111:108]}:{offsettemp[3:0],spritetemp[47:44]}; 
    wire [7:0] nib04=(linetemp)?{offsettemp[3:0],spritetemp[107:104]}:{offsettemp[3:0],spritetemp[43:40]};
    wire [7:0] nib07=(linetemp)?{offsettemp[3:0],spritetemp[103:100]}:{offsettemp[3:0],spritetemp[39:36]};
    wire [7:0] nib06=(linetemp)?{offsettemp[3:0],spritetemp[99:96]}:{offsettemp[3:0],spritetemp[35:32]};
    wire [7:0] nib09=(linetemp)?{offsettemp[3:0],spritetemp[95:92]}:{offsettemp[3:0],spritetemp[31:28]}; 
    wire [7:0] nib08=(linetemp)?{offsettemp[3:0],spritetemp[91:88]}:{offsettemp[3:0],spritetemp[27:24]};
    wire [7:0] nib11=(linetemp)?{offsettemp[3:0],spritetemp[87:84]}:{offsettemp[3:0],spritetemp[23:20]};
    wire [7:0] nib10=(linetemp)?{offsettemp[3:0],spritetemp[83:80]}:{offsettemp[3:0],spritetemp[19:16]};
    wire [7:0] nib13=(linetemp)?{offsettemp[3:0],spritetemp[79:76]}:{offsettemp[3:0],spritetemp[15:12]}; 
    wire [7:0] nib12=(linetemp)?{offsettemp[3:0],spritetemp[75:72]}:{offsettemp[3:0],spritetemp[11:8]};
    wire [7:0] nib15=(linetemp)?{offsettemp[3:0],spritetemp[71:68]}:{offsettemp[3:0],spritetemp[7:4]};
    wire [7:0] nib14=(linetemp)?{offsettemp[3:0],spritetemp[67:64]}:{offsettemp[3:0],spritetemp[3:0]};
       
    
    //Wires to create 8 bit depth 16 pixel line from a single 128 bit read
    wire [7:0] p00=(spritemodetemp)?nib00:spritetemp[127:120]; 
    wire [7:0] p01=(spritemodetemp)?nib01:spritetemp[119:112];
    wire [7:0] p02=(spritemodetemp)?nib02:spritetemp[111:104];
    wire [7:0] p03=(spritemodetemp)?nib03:spritetemp[103:96];
    wire [7:0] p04=(spritemodetemp)?nib04:spritetemp[95:88];
    wire [7:0] p05=(spritemodetemp)?nib05:spritetemp[87:80];
    wire [7:0] p06=(spritemodetemp)?nib06:spritetemp[79:72];
    wire [7:0] p07=(spritemodetemp)?nib07:spritetemp[71:64];
    wire [7:0] p08=(spritemodetemp)?nib08:spritetemp[63:56];
    wire [7:0] p09=(spritemodetemp)?nib09:spritetemp[55:48];
    wire [7:0] p10=(spritemodetemp)?nib10:spritetemp[47:40];
    wire [7:0] p11=(spritemodetemp)?nib11:spritetemp[39:32];
    wire [7:0] p12=(spritemodetemp)?nib12:spritetemp[31:24];
    wire [7:0] p13=(spritemodetemp)?nib13:spritetemp[23:16];
    wire [7:0] p14=(spritemodetemp)?nib14:spritetemp[15:8];
    wire [7:0] p15=(spritemodetemp)?nib15:spritetemp[7:0];
    
    
    wire [7:0] nib01_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[127:124]}:{offsettemp_2[3:0],spritetemp_2[63:60]}; 
    wire [7:0] nib00_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[123:120]}:{offsettemp_2[3:0],spritetemp_2[59:56]};
    wire [7:0] nib03_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[119:116]}:{offsettemp_2[3:0],spritetemp_2[55:52]};
    wire [7:0] nib02_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[115:112]}:{offsettemp_2[3:0],spritetemp_2[51:48]};
    wire [7:0] nib05_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[111:108]}:{offsettemp_2[3:0],spritetemp_2[47:44]}; 
    wire [7:0] nib04_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[107:104]}:{offsettemp_2[3:0],spritetemp_2[43:40]};
    wire [7:0] nib07_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[103:100]}:{offsettemp_2[3:0],spritetemp_2[39:36]};
    wire [7:0] nib06_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[99:96]}:{offsettemp_2[3:0],spritetemp_2[35:32]};
    wire [7:0] nib09_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[95:92]}:{offsettemp_2[3:0],spritetemp_2[31:28]}; 
    wire [7:0] nib08_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[91:88]}:{offsettemp_2[3:0],spritetemp_2[27:24]};
    wire [7:0] nib11_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[87:84]}:{offsettemp_2[3:0],spritetemp_2[23:20]};
    wire [7:0] nib10_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[83:80]}:{offsettemp_2[3:0],spritetemp_2[19:16]};
    wire [7:0] nib13_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[79:76]}:{offsettemp_2[3:0],spritetemp_2[15:12]}; 
    wire [7:0] nib12_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[75:72]}:{offsettemp_2[3:0],spritetemp_2[11:8]};
    wire [7:0] nib15_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[71:68]}:{offsettemp_2[3:0],spritetemp_2[7:4]};
    wire [7:0] nib14_2=(linetemp_2)?{offsettemp_2[3:0],spritetemp_2[67:64]}:{offsettemp_2[3:0],spritetemp_2[3:0]};
       
    
    //Wires to create 8 bit depth 16 pixel line from a single 128 bit read
    wire [7:0] p00_2=(spritemodetemp_2)?nib00_2:spritetemp_2[127:120]; 
    wire [7:0] p01_2=(spritemodetemp_2)?nib01_2:spritetemp_2[119:112];
    wire [7:0] p02_2=(spritemodetemp_2)?nib02_2:spritetemp_2[111:104];
    wire [7:0] p03_2=(spritemodetemp_2)?nib03_2:spritetemp_2[103:96];
    wire [7:0] p04_2=(spritemodetemp_2)?nib04_2:spritetemp_2[95:88];
    wire [7:0] p05_2=(spritemodetemp_2)?nib05_2:spritetemp_2[87:80];
    wire [7:0] p06_2=(spritemodetemp_2)?nib06_2:spritetemp_2[79:72];
    wire [7:0] p07_2=(spritemodetemp_2)?nib07_2:spritetemp_2[71:64];
    wire [7:0] p08_2=(spritemodetemp_2)?nib08_2:spritetemp_2[63:56];
    wire [7:0] p09_2=(spritemodetemp_2)?nib09_2:spritetemp_2[55:48];
    wire [7:0] p10_2=(spritemodetemp_2)?nib10_2:spritetemp_2[47:40];
    wire [7:0] p11_2=(spritemodetemp_2)?nib11_2:spritetemp_2[39:32];
    wire [7:0] p12_2=(spritemodetemp_2)?nib12_2:spritetemp_2[31:24];
    wire [7:0] p13_2=(spritemodetemp_2)?nib13_2:spritetemp_2[23:16];
    wire [7:0] p14_2=(spritemodetemp_2)?nib14_2:spritetemp_2[15:8];
    wire [7:0] p15_2=(spritemodetemp_2)?nib15_2:spritetemp_2[7:0];
    
    
    
    
    
    
    
    //localparam  maskbyte = 'he3;
    
    reg [8:0] line_counter;
    
    initial
    begin
        spr_we<=0;
        spr_pal_we<=0;
        spr_pal_we2<=0;
        spr_attr_we<=0;
        maskbyte<='he3;
        spritexoffset<=0;
        spriteyoffset<=0;
        clip_l<=9'd0;
        clip_r<=9'd320;
        clip_t<=8'd0;
        clip_b<=8'd240;

//        scanlines<=1;
    end
    
    //assign line_counter=CounterY<522?CounterY[9:1]+1:261-CounterY[9:1];
    always @(posedge clk or negedge nReset)
    begin
    if (!nReset)
    begin
        spr_we<=0;
        spr_pal_we<=0;
        spr_pal_we2<=0;
        spr_attr_we<=0;
        maskbyte<='he3;
        //for (i=0;i<128;i=i+1) visible[i]<=0;
        spritexoffset<=0;
        spriteyoffset<=0;
        clip_l<=9'd0;
        clip_r<=9'd320;
        clip_t<=8'd0;
        clip_b<=8'd240;
	  end
    else begin
        if (spr_pal_we) spr_pal_we<=0;          //toggle write enable back off after palette write
        if (spr_pal_we2) spr_pal_we2<=0;          //toggle write enable back off after palette write
        if (spr_attr_we) spr_attr_we<=0;          //toggle write enable back off after palette write
        if ((io_in==1) && (spr_we)) spr_we<=0;
        //if ((io_ack==0) && (spr_we)) spr_we<=0;
        if (io_in==0)	//have we had an IO signal
	    begin
	       if (io_ack==0) //have we already acknowledged it?
		   begin
			io_ack<=1;	//acknowledge it
	       case (io_address_in[7:0])
	           'haf:   begin
	                spr_address_write<=sprite_write_address+(currsprite*256);
	                spr_data_out<=io_data_in;
	                spr_we<=1;
	                sprite_write_address<=sprite_write_address+1;
	            end
	           'hae:   begin
	                spr_address_write<=sprite_write_address+(currsprite*256);
	                spr_data_out<=io_data_in;
	                spr_we<=1;     
	            end
	            'hac:   begin
	               maskbyte<=io_data_in;
	            end
	            'hab:   begin
	                spritexoffset[7:0]<=io_data_in;
	            end
	            'haa:   begin
	                spriteyoffset[7:0]<=io_data_in;	                
	            end
	            'ha9:   begin
	                //spritex[currsprite] [8:8]<=io_data_in[0:0];
	                sprite_attr_addr_write<=sprite_attr_addr_base+1;
	                sprite_attr_data_out<=io_data_in & 1;
	                spr_attr_we<=1;
	//                spritextemp<={io_data_in[0:0],spritex[currsprite] [7:0]};
	               /* for (y=0;y<=1;y=y+1)
					   for (x=0;x<=1;x=x+1)
					   begin
					       if (flipx[currsprite]==0) spritex[currsprite+y*chainx[currsprite]+x]={io_data_in[8],spritex[currsprite] [7:0]}+x*16; else spritex[currsprite+y*chainx[currsprite]+x]={io_data_in[8],spritex[currsprite] [7:0]}+((chainx[currsprite]-x)*16);
					   end*/
	            end
	           'ha8:   begin
	                //spritex[currsprite] [7:0]<=io_data_in;
	                sprite_attr_addr_write<=sprite_attr_addr_base;
	                sprite_attr_data_out<=io_data_in;
	                spr_attr_we<=1;
	//                spritextemp<={spritex[currsprite] [8],io_data_in[7:0]};
	                /* //1 x 1 sprite
					if ((chainx[currsprite]==0) && (chainy[currsprite]==0))
					begin
					   spritex[currsprite] [7:0]<=io_data_in;
					end
					//2 x 1 sprite
					if ((chainx[currsprite]) && (chainy[currsprite]==0))
					begin
					   if (flipx[currsprite]==0)
					   begin
					       spritex[currsprite] [7:0]<=io_data_in;
					       spritex[currsprite+1] [7:0]<={spritex[currsprite] [8],io_data_in}+16;
					   end
					   else
					   begin
					       spritex[currsprite+1] [7:0]<=io_data_in;
					       spritex[currsprite] [7:0]<={spritex[currsprite] [8],io_data_in}+16;
					   end
					end
					//1 x 2 sprite
					if ((chainx[currsprite]==0) && (chainy[currsprite]))
					begin
					   spritex[currsprite] [7:0]<=io_data_in;
					   spritex[currsprite+1] [7:0]<=io_data_in;					   
					end
					//2 x 2 sprite
					if ((chainx[currsprite]) && (chainy[currsprite]))
					begin
					   if (flipx[currsprite]==0)
					   begin
					       spritex[currsprite] [7:0]<=io_data_in;
					       spritex[currsprite+1] [7:0]<={spritex[currsprite] [8],io_data_in}+16;
					       spritex[currsprite+2] [7:0]<=io_data_in;
					       spritex[currsprite+3] [7:0]<={spritex[currsprite] [8],io_data_in}+16;
					   end
					   else
					   begin
					       spritex[currsprite+1] [7:0]<=io_data_in;
					       spritex[currsprite] [7:0]<={spritex[currsprite] [8],io_data_in}+16;
					       spritex[currsprite+3] [7:0]<=io_data_in;
					       spritex[currsprite+2] [7:0]<={spritex[currsprite] [8],io_data_in}+16;
					   end
					end*/
					
	                /*for (y=0;y<=1;y=y+1)
					   for (x=0;x<=1;x=x+1)
					   begin
					       if (flipx[currsprite]==0) spritex[currsprite+y*chainx[currsprite]+x]={spritex[currsprite] [8],io_data_in[7:0]}+x*16; else spritex[currsprite+y*chainx[currsprite]+x]={spritex[currsprite] [8],io_data_in[7:0]}+((chainx[currsprite]-x)*16);
					   end*/
	            end
	            'ha7:   begin
	                //spritey[currsprite] [8:8]<=io_data_in[0:0];
	                sprite_attr_addr_write<=sprite_attr_addr_base+3;
	                sprite_attr_data_out<=io_data_in & 1;
	                spr_attr_we<=1;
//	                spriteytemp<={io_data_in[0:0],spritey[currsprite] [7:0]};
	                /*for (y=0;y<=1;y=y+1)
					   for (x=0;x<=1;x=x+1)
					   begin
					       if (flipy[currsprite]==0) spritey[currsprite+y*chainx[currsprite]+x]={io_data_in[8],spritey[currsprite] [7:0]}+y*16; else spritex[currsprite+y*chainx[currsprite]+x]={io_data_in[8],spritey[currsprite] [7:0]}+((chainy[currsprite]-y)*16);
					   end*/
	            end
	           'ha6:   begin
	                //spritey[currsprite] [7:0]<=io_data_in;
	                sprite_attr_addr_write<=sprite_attr_addr_base+2;
	                sprite_attr_data_out<=io_data_in;
	                spr_attr_we<=1;
//	                spriteytemp<={spritey[currsprite] [8],io_data_in[7:0]};
	                /*for (y=0;y<=1;y=y+1)
					   for (x=0;x<=1;x=x+1)
					   begin
					       if (flipy[currsprite]==0) spritey[currsprite+y*chainx[currsprite]+x]={spritey[currsprite] [8],io_data_in[7:0]}+y*16; else spritex[currsprite+y*chainx[currsprite]+x]={spritey[currsprite] [8],io_data_in[7:0]}+((chainy[currsprite]-y)*16);
					   end*/
	            end
	           
	           
	            'ha5:	begin			//set current pattern and mode
	                //pattern[currsprite]<=io_data_in[6:0];
	//                patterntemp<=io_data_in[6:0];
					//spritemode[currsprite]<=io_data_in[7];
					sprite_attr_addr_write<=sprite_attr_addr_base+4;
	                sprite_attr_data_out<=io_data_in;
	                spr_attr_we<=1;
	//				spritemodetemp2<=io_data_in[7];
	                /* //1 x 1 sprite
					if ((chainx[currsprite]==0) && (chainy[currsprite]==0))
					begin
					   pattern[currsprite]<=io_data_in[6:0];
					   spritemode[currsprite]<=io_data_in[7];
					end
					// 2 x 1 sprite
					if ((chainx[currsprite]) && (chainy[currsprite]==0))
					begin
					   spritemode[currsprite]<=io_data_in[7];
					   spritemode[currsprite+1]<=io_data_in[7];					   
					   if (flipx[currsprite]==0)
					   begin
					       pattern[currsprite]<=io_data_in[6:0];
					       pattern[currsprite+1]<=io_data_in[6:0]+1;					       					   
					   end
					   else
					   begin
					       pattern[currsprite+1]<=io_data_in[6:0];
					       pattern[currsprite]<=io_data_in[6:0]+1;					       					   
					   end					  
					end
					// 1 x 2 sprite
					if ((chainx[currsprite]==0) && (chainy[currsprite]))
					begin
					   spritemode[currsprite]<=io_data_in[7];
					   spritemode[currsprite+1]<=io_data_in[7];					   
					   if (flipy[currsprite]==0)
					   begin
					       pattern[currsprite]<=io_data_in[6:0];
					       pattern[currsprite+1]<=io_data_in[6:0]+1;					       					   
					   end
					   else
					   begin
					       pattern[currsprite+1]<=io_data_in[6:0];
					       pattern[currsprite]<=io_data_in[6:0]+1;					       					   
					   end					  
					end
					// 2 x 2 sprite
					if ((chainx[currsprite]) && (chainy[currsprite]))
					begin
					   spritemode[currsprite]<=io_data_in[7];
					   spritemode[currsprite+1]<=io_data_in[7];
					   spritemode[currsprite+2]<=io_data_in[7];
					   spritemode[currsprite+3]<=io_data_in[7];
					   if ((flipx[currsprite]==0) && (flipy[currsprite]==0))
					   begin
					       pattern[currsprite]<=io_data_in[6:0];
					       pattern[currsprite+1]<=io_data_in[6:0]+1;
					       pattern[currsprite+2]<=io_data_in[6:0]+2;
					       pattern[currsprite+3]<=io_data_in[6:0]+3;					   
					   end
					   if ((flipx[currsprite]) && (flipy[currsprite]==0))
					   begin
					       pattern[currsprite+1]<=io_data_in[6:0];
					       pattern[currsprite]<=io_data_in[6:0]+1;
					       pattern[currsprite+3]<=io_data_in[6:0]+2;
					       pattern[currsprite+2]<=io_data_in[6:0]+3;					   
					   end
					   if ((flipx[currsprite]==0) && (flipy[currsprite]))
					   begin
					       pattern[currsprite+2]<=io_data_in[6:0];
					       pattern[currsprite+3]<=io_data_in[6:0]+1;
					       pattern[currsprite]<=io_data_in[6:0]+2;
					       pattern[currsprite+1]<=io_data_in[6:0]+3;					   
					   end
					   if ((flipx[currsprite]) && (flipy[currsprite]))
					   begin
					       pattern[currsprite+3]<=io_data_in[6:0];
					       pattern[currsprite+2]<=io_data_in[6:0]+1;
					       pattern[currsprite+1]<=io_data_in[6:0]+2;
					       pattern[currsprite]<=io_data_in[6:0]+3;					   
					   end
					end
					*/
					/*case (chainx[currsprite])
					   1: pattern[currsprite+1]<=io_data_in[6:0]+1;
					   2: pattern[currsprite+2]<=io_data_in[6:0]+2;
					   3: pattern[currsprite+3]<=io_data_in[6:0]+3;
					   4: pattern[currsprite+4]<=io_data_in[6:0]+4;
					   5: pattern[currsprite+5]<=io_data_in[6:0]+5;
					   6: pattern[currsprite+6]<=io_data_in[6:0]+6;
					   7: pattern[currsprite+7]<=io_data_in[6:0]+7;
					   8: pattern[currsprite+8]<=io_data_in[6:0]+8;
					   9: pattern[currsprite+9]<=io_data_in[6:0]+9;
					   10: pattern[currsprite+10]<=io_data_in[6:0]+10;
					   11: pattern[currsprite+11]<=io_data_in[6:0]+11;
					   12: pattern[currsprite+12]<=io_data_in[6:0]+12;
					   13: pattern[currsprite+13]<=io_data_in[6:0]+13;
					   14: pattern[currsprite+14]<=io_data_in[6:0]+14;
					   15: pattern[currsprite+15]<=io_data_in[6:0]+15;
					endcase
					
					
					
					case (chainx[currsprite])
					   1: pattern[currsprite+chainx[currsprite]*1]<=io_data_in[6:0]+1;
					endcase*/
					
					/*for (y=0;y<=1;y=y+1)
					   for (x=0;x<=1;x=x+1)
					   begin
					       if ((flipx[currsprite]==0) && (flipy[currsprite]==0)) pattern[currsprite+y*chainx[currsprite]+x]=io_data_in[6:0]+y*chainx[currsprite]+x;
					       if ((flipx[currsprite]) && (flipy[currsprite]==0)) pattern[currsprite+y*chainx[currsprite]+chainx[currsprite]-x]=io_data_in[6:0]+y*chainx[currsprite]+x;
					       if ((flipx[currsprite]==0) && (flipy[currsprite])) pattern[currsprite+(chainy[currsprite]-y)*chainx[currsprite]+x]=io_data_in[6:0]+y*chainx[currsprite]+x;
					       if ((flipx[currsprite]) && (flipy[currsprite])) pattern[currsprite+(chainy[currsprite]-y)*chainx[currsprite]+chainx[currsprite]-x]=io_data_in[6:0]+y*chainx[currsprite]+x;
					       spritemode[currsprite+y*chainx[currsprite]+x]=io_data_in[7];
					   end*/
					
				end
	            'ha4:	begin			//set current palette offset + flip regs
					//paloffset[currsprite] [3:0]<=io_data_in[3:0];
		//			paloffsettemp [3:0]<=io_data_in[3:0];
					//flipx[currsprite]<=io_data_in[6:6];
					//flipy[currsprite]<=io_data_in[7:7];
					sprite_attr_addr_write<=sprite_attr_addr_base+5;
	                sprite_attr_data_out<=io_data_in;
	                spr_attr_we<=1;
//					flipxtemp<=io_data_in[6:6];
	//				flipytemp<=io_data_in[7:7];
					/*for (y=0;y<=1;y=y+1)
					   for (x=0;x<=1;x=x+1)
					   begin					       
					       paloffset[currsprite+y*chainx[currsprite]+x]=io_data_in[3:0];
					       flipx[currsprite+y*chainx[currsprite]+x]=io_data_in[6:6];
					       flipy[currsprite+y*chainx[currsprite]+x]=io_data_in[7:7];
					   end*/
				end
	           'ha3:	begin			//sprite linking control
                    sprite_attr_addr_write<=sprite_attr_addr_base+7;
	                sprite_attr_data_out<=io_data_in;
	                spr_attr_we<=1;
	           end
    	       'ha2:	begin			//set current sprite x flip
					//flipx[currsprite]<=(io_data_in!=0);
				end
	           'ha1:	begin			//set current sprite visible
					//visible[currsprite]<=io_data_in[0:0];
					//priority[currsprite]<=io_data_in[1:1];
					sprite_attr_addr_write<=sprite_attr_addr_base+6;
	                sprite_attr_data_out<=io_data_in;
	                spr_attr_we<=1;
//					visibletemp<=io_data_in[0:0];
//					prioritytemp<=io_data_in[1:1];
					/*for (y=0;y<=1;y=y+1)
					   for (x=0;x<=1;x=x+1)
					   begin					       
					       visible[currsprite+y*chainx[currsprite]+x]=io_data_in[0:0];
					       priority[currsprite+y*chainx[currsprite]+x]=io_data_in[1:1];
					   end*/
				end
				'ha0:	begin			//set current sprite to be written to
					currsprite<=io_data_in[6:0];
					sprite_write_address<=0;
					sprite_attr_addr_base<=io_data_in[6:0]*8;
				end
				'h87: begin             //latch high byte of palette entry
				    spr_pal_out[15:8]<=io_data_in;
				    spr_pal_out2[15:8]<=io_data_in;
				end
				'h86: begin             //latch low byte of palette entry
				    spr_pal_out[7:0]<=io_data_in;
				    spr_pal_out2[7:0]<=io_data_in;
				end				
				'h85: begin
				    spr_pal_address_write<=io_data_in;  //set palette entry to write to
				    spr_pal_address_write2<=io_data_in;  //set palette entry to write to
				end
				'h84: begin
				    spr_pal_we<=io_data_in[0];  //write entry
				    spr_pal_we2<=io_data_in[1];  //write entry
				end
				'h6f: begin
				    clip_l[8:1]<=io_data_in[7:0];
				end
				'h6e: begin
				    clip_r[8:1]<=io_data_in[7:0];
				end
				'h6d: begin
				    clip_t<=io_data_in;
				end
				'h6c: begin
				    clip_b<=io_data_in;
				end
		  endcase
		  end
	    end
	    else io_ack<=0;
    //end
    
    
        
    //always @(posedge clk)
    //begin    
    if ((CounterY<480) || (CounterY>521)) //start of new row
    begin
        if (CounterX==640)
        begin
            if (scanlines==1) sprite_attr_addr_read<=0;      //preload address with first sprite attribute address to read
        end
        if (CounterX==642)                //start sprite processing for next line as soon as previous line has finished drawing
        begin
            
            line_store_read<=0;
            line_store_write<=0;
            line_store_we<=0;
               
            line_store_read_2<=0;
            line_store_write_2<=0;
            line_store_we_2<=0;
                
            line_store_read2<=0;
            line_store_write2<=0;
            line_store_we2<=0;
                
            line_store_read2_2<=0;
            line_store_write2_2<=0;
            line_store_we2_2<=0;
            if (scanlines==1)
            begin
                spritestage<=0;
                //spritecol<=0;
                spriteptr<=1;//63;                
                spriteptr_2<=64;//127;
                spriteprocessing<=1;
                spriteon<=0;
                spriteon_2<=0;
                    
                //sprite_attr_data<=sprite_attr_data_in;
                spritex<=sprite_attr_data_in[8:0];//_in[8:0];                            
                spritey<=sprite_attr_data_in[24:16];//_in[24:16];
                spritemode<=sprite_attr_data_in[39];                                    
                pattern<=sprite_attr_data_in[38:32];                                            
                flipy<=sprite_attr_data_in[47];
                flipx<=sprite_attr_data_in[46];
                paloffset<=sprite_attr_data_in[43:40];                                                    
                priority<=sprite_attr_data_in[49];
                visible<=sprite_attr_data_in[48];
                // linkage<=0;  //no linking for first sprite!
                
                //if (CounterY<480) SpriteRead<=1;
                line_counter<=CounterY<522?CounterY[9:1]+1+spriteyoffset:261-CounterY[9:1]+spriteyoffset;
             end
        end
    end
        
        if (CounterX==796)
        begin
            //scanlines<=scanlines+1;
            if (((CounterY<480) || (CounterY>521)) && (ByteRead==0)) //start of new row
            begin
                ByteDelay<=0;
                ByteRead<=1;
  //              ByteCounter<=0;
                //clear_write_address<=0;
                scanlines<=~scanlines;//+1;
                line_store2_read<=0;
                line_store2_write<=0;
                
                line_store2_read2<=0;
                line_store2_write2<=0;
           
                
                
                
            end
        end
        
        
        if  (ByteRead==1)   //we are just displaying previous line
        begin
            if(CounterX==640)
            begin
           
                //SpriteRead<=0; //Turn off Byte Reading after line has ended
                ByteRead<=0;
                //spriteptr<=1;
                //spriteprocessing<=0;
            end
            
        if ((CounterX==792) && (spriteprocessing) && (scanlines==0))      //turm off sprite processing if out of cycles
        begin           
            spriteprocessing<=0;
        end
            
            //if ((scanlines==0) && (spriteprocessing))
            if (spriteprocessing)
            begin
                
            
                //if ((spritestage==0) && (CounterY<480))
                if (spritestage==0)
                begin
                    //sprite_attr_data<=sprite_attr_data_in;
                    sprite_attr_addr_read<=spriteptr_2;
                    line_store_write<=spritex-spritexoffset;
                    line_store_write2<=spritex-spritexoffset;                    
                    offsettemp<=paloffset;                    
                    spritemodetemp<=spritemode;
                    
                    //if (spritey[spriteptr] [0]) linetemp<=(line_counter-spritey[spriteptr]) & 1; else linetemp<=(line_counter-spritey[spriteptr]) & 1;
                    linetemp<=(line_counter-spritey) & 1;
                    
                    //if ((line_counter>=0) && (line_counter<16)) //should sprite show on this line? 50, 50+16
                    if ((line_counter>=spritey) && (line_counter<spritey+16) && (line_counter>=clip_t) && (line_counter<=clip_b)) //should sprite show on this line? 50, 50+16
                    begin
                        if (visible) spriteon<=1; else spriteon<=0;
                        //if (flipy[spriteptr]) spr_address_read<=15-((CounterY[9:1])-spritey[spriteptr])+(pattern[spriteptr]*16); else spr_address_read<=(CounterY[9:1])-spritey[spriteptr]+(pattern[spriteptr]*16);
                        if (spritemode)
                        begin
                            if (flipy) spr_address_read<=15-((line_counter-spritey)>>1)+(pattern [6:0]*8); else spr_address_read<=((line_counter -spritey)>>1)+(pattern [6:0]*8);
                        end
                        else
                        begin
                            if (flipy) spr_address_read<=15-((line_counter)-spritey)+(pattern [5:0]*16); else spr_address_read<=(line_counter)-spritey+(pattern [5:0]*16);
                        end
                        //spr_address_read<=line_counter;//-50);
                        //sprite_write_address<=spritex[spriteptr];
                        
                    end
                    else
                    begin
                        spriteon<=0;        
                    end             
                    
                    spritestage<=spritestage+1;   
                end
                
                
                //******************** SPRITE ENGINE NUMBER 1 ************************//
            
            
                
                   case (spritestage)
                    /*0:  begin           //don't think this will ever exist??? 
                        //spritetemp<=spr_data_in;
                        //line_store_write<=spritex[spriteptr];
                        spritestage<=spritestage+1;
                    end*/
                    
                    ////******* 01 *******////
                    1:  begin                    
                        spritestage<=spritestage+1;
                    end
                    
                    ////******* 02 *******////
                    2:  begin                    
                        spritestage<=spritestage+1;
                    end
                    
                    ////******* 03 *******////
                    3:  begin
                            case (sprite_attr_data_in[57:56])
                                2'b00:begin
                                    spritex_2<=sprite_attr_data_in[8:0];                            
                                end
                                /*8'b??????01:begin
                                    spritex<=spritex;                                
                                end*/
                                2'b10:begin                                    
                                    if (flipx_2) spritex_2<=spritex_2-16; else spritex_2<=spritex_2+16;
                                end
                                2'b11:begin
                                    if (flipx_2) spritex_2<=spritex_2+16; else spritex_2<=spritex_2-16;
                                end
                             endcase
                             case (sprite_attr_data_in[59:58])
                                2'b00:begin
                                    spritey_2<=sprite_attr_data_in[24:16];
                                end
                                /*8'b????01??:begin
                                    spritey<=spritey;
                                end*/
                                2'b10:begin
                                    if (flipy_2) spritey_2<=spritey_2-16; else spritey_2<=spritey_2+16;
                                end
                                2'b11:begin
                                    if (flipy_2) spritey_2<=spritey_2+16; else spritey_2<=spritey_2-16;
                                end
                             endcase
                             case (sprite_attr_data_in[61:60])
                                2'b00:begin
                                    spritemode_2<=sprite_attr_data_in[39];                                    
                                    pattern_2<=sprite_attr_data_in[38:32];                            
                                end
                                /*8'b??01????:begin
                                    spritemode<=spritemodetemp2;
                                    pattern<=patterntemp;                                    
                                end*/
                                2'b10:begin
                                 //   spritemode<=spritemodetemp2;
                                    pattern_2<=pattern_2+1;                                 
                                 end
                                2'b11:begin
                                    //spritemode<=spritemodetemp2;
                                    pattern_2<=pattern_2-1;                                
                                end
                             endcase
                             case (sprite_attr_data_in[62])
                                1'b0:begin
                                    flipy_2<=sprite_attr_data_in[47];
                                    flipx_2<=sprite_attr_data_in[46];
                                    paloffset_2<=sprite_attr_data_in[43:40];                                    
                                end                             
                                /*8'b?1??????:begin
                                    flipy<=flipy;
                                    flipx<=flipx;
                                    paloffset<=paloffset;                                
                                end*/
                             endcase
                             case (sprite_attr_data_in[63])
                                1'b0:begin
                                    priority_2<=sprite_attr_data_in[49];
                                    visible_2<=sprite_attr_data_in[48];
                                end                                
                                /*8'b1???????:begin
                                    priority<=priority;
                                    visible<=visible;
                                end*/                        
                             endcase
                        /*spritex_2<=sprite_attr_data_in[8:0];//_in[8:0];                            
                        spritey_2<=sprite_attr_data_in[24:16];//_in[24:16];
                        spritemode_2<=sprite_attr_data_in[39];                                    
                        pattern_2<=sprite_attr_data_in[38:32];                                            
                        flipy_2<=sprite_attr_data_in[47];
                        flipx_2<=sprite_attr_data_in[46];
                        paloffset_2<=sprite_attr_data_in[43:40];                                                    
                        priority_2<=sprite_attr_data_in[49];
                        visible_2<=sprite_attr_data_in[48];*/
                         
                        //spritex_2<=0;//_in[8:0];                            
                        //spritey_2<=0;//_in[24:16];
                        /*spritemode_2<=0;                                    
                        pattern_2<=0;                                            
                        flipy_2<=0;
                        flipx_2<=0;
                        paloffset_2<=0;                                                    
                        priority_2<=0;
                        visible_2<=0;*/
                        
                        //sprite_attr_data_2<=sprite_attr_data_in;
                        //sprite_attr_data_2<=64'h0040004080000300;
                        spritestage<=spritestage+1;                        
                    end
                    
                    ////******* 04 *******////
                    4:  begin
                    //if (spriteon==1)
                    //begin
                        //spritetemp<=spr_data_in;                                          
                        spritetemp<=spr_data_in;      
                    //end
                    line_store_write_2<=spritex_2-spritexoffset;
                    line_store_write2_2<=spritex_2-spritexoffset;
                    offsettemp_2<=paloffset_2;
                    spritemodetemp_2<=spritemode_2;
                    linetemp_2<=(line_counter-spritey_2) & 1;
                    if ((line_counter>=spritey_2) && (line_counter<spritey_2+16) && (line_counter>=clip_t) && (line_counter<=clip_b)) //should sprite show on this line? 50, 50+16
                    begin
                       if (visible_2) spriteon_2<=1; else spriteon_2<=0;
                       //spriteon_2<=1;
                       //if (flipy[spriteptr]) spr_address_read<=15-((CounterY[9:1])-spritey[spriteptr])+(pattern[spriteptr]*16); else spr_address_read<=(CounterY[9:1])-spritey[spriteptr]+(pattern[spriteptr]*16);
                       if (spritemode_2)
                       begin
                           if (flipy_2) spr_address_read<=15-((line_counter-spritey_2)>>1)+(pattern_2 [6:0]*8); else spr_address_read<=((line_counter -spritey_2)>>1)+(pattern_2 [6:0]*8);
                       end
                       else
                       begin
                           if (flipy_2) spr_address_read<=15-((line_counter)-spritey_2)+(pattern_2 [5:0]*16); else spr_address_read<=(line_counter)-spritey_2+(pattern_2 [5:0]*16);
                       end
                       //spr_address_read<=line_counter;//-50);
                       //sprite_write_address<=spritex[spriteptr];
                        
                    end
                    else
                    begin
                        spriteon_2<=0;
                        //spr_address_read<=((line_counter -spritey[spriteptr_2])>>1)+(pattern[spriteptr_2] [6:0]*8);
                    end
                    //spriteon_2<=1;
                    
                    spritestage<=spritestage+1;
                    end  
                                  
                    ////******* 05 *******////    
                    5:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p00!=masktemp)
                                begin
                                    line_store_data_out<=p00;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p15!=masktemp)
                                begin
                                    line_store_data_out<=p15;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p00!=masktemp)
                                begin
                                    line_store_data_out2<=p00;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p15!=masktemp)
                                begin
                                    line_store_data_out2<=p15;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    
                    spritestage<=spritestage+1;
                    
                    end
                    
                    ////******* 06 *******////
                    6:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p01!=masktemp)
                                begin
                                    line_store_data_out<=p01;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p14!=masktemp)
                                begin
                                    line_store_data_out<=p14;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p01!=masktemp)
                                begin
                                    line_store_data_out2<=p01;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p14!=masktemp)
                                begin
                                    line_store_data_out2<=p14;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    spritestage<=spritestage+1;
                    sprite_attr_addr_read<=spriteptr;
                    end
                    
                    ////******* 07 *******////
                    7:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p02!=masktemp)
                                begin
                                    line_store_data_out<=p02;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p13!=masktemp)
                                begin
                                    line_store_data_out<=p13;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p02!=masktemp)
                                begin
                                    line_store_data_out2<=p02;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p13!=masktemp)
                                begin
                                    line_store_data_out2<=p13;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    //if (spriteon_2==1)
                    //begin
                        spritetemp_2<=spr_data_in;                        
                    //end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 08 *******////
                    8:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p03!=masktemp)
                                begin
                                    line_store_data_out<=p03;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p12!=masktemp)
                                begin
                                    line_store_data_out<=p12;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p03!=masktemp)
                                begin
                                    line_store_data_out2<=p03;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p12!=masktemp)
                                begin
                                    line_store_data_out2<=p12;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                         if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p00_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p00_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p15_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p15_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p00_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p00_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p15_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p15_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 09 *******////
                    9:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p04!=masktemp)
                                begin
                                    line_store_data_out<=p04;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p11!=masktemp)
                                begin
                                    line_store_data_out<=p11;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p04!=masktemp)
                                begin
                                    line_store_data_out2<=p04;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p11!=masktemp)
                                begin
                                    line_store_data_out2<=p11;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                    if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p01_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p01_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p14_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p14_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p01_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p01_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p14_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p14_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 10 *******////
                    10:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p05!=masktemp)
                                begin
                                    line_store_data_out<=p05;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p10!=masktemp)
                                begin
                                    line_store_data_out<=p10;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p05!=masktemp)
                                begin
                                    line_store_data_out2<=p05;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p10!=masktemp)
                                begin
                                    line_store_data_out2<=p10;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p02_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p02_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p13_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p13_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p02_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p02_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p13_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p13_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 11 *******////
                    11:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p06!=masktemp)
                                begin
                                    line_store_data_out<=p06;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p09!=masktemp)
                                begin
                                    line_store_data_out<=p09;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p06!=masktemp)
                                begin
                                    line_store_data_out2<=p06;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p09!=masktemp)
                                begin
                                    line_store_data_out2<=p09;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                         if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p03_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p03_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p12_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p12_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p03_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p03_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p12_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p12_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 12 *******////
                    12:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p07!=masktemp)
                                begin
                                    line_store_data_out<=p07;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p08!=masktemp)
                                begin
                                    line_store_data_out<=p08;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p07!=masktemp)
                                begin
                                    line_store_data_out2<=p07;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p08!=masktemp)
                                begin
                                    line_store_data_out2<=p08;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p04_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p04_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p11_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p11_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p04_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p04_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p11_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p11_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 13 *******////
                    13:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p08!=masktemp)
                                begin
                                    line_store_data_out<=p08;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p07!=masktemp)
                                begin
                                    line_store_data_out<=p07;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p08!=masktemp)
                                begin
                                    line_store_data_out2<=p08;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p07!=masktemp)
                                begin
                                    line_store_data_out2<=p07;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p05_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p05_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p10_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p10_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p05_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p05_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p10_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p10_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 14 *******////
                    14:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p09!=masktemp)
                                begin
                                    line_store_data_out<=p09;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p06!=masktemp)
                                begin
                                    line_store_data_out<=p06;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p09!=masktemp)
                                begin
                                    line_store_data_out2<=p09;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p06!=masktemp)
                                begin
                                    line_store_data_out2<=p06;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p06_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p06_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p09_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p09_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p06_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p06_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p09_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p09_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                    spritestage<=spritestage+1;
                    end
                    
                   ////******* 15 *******//// 
                   15:   begin
                   if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p10!=masktemp)
                                begin
                                    line_store_data_out<=p10;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p05!=masktemp)
                                begin
                                    line_store_data_out<=p05;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p10!=masktemp)
                                begin
                                    line_store_data_out2<=p10;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p05!=masktemp)
                                begin
                                    line_store_data_out2<=p05;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                    if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p07_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p07_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p08_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p08_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p07_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p07_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p08_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p08_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 16 *******////
                    16:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p11!=masktemp)
                                begin
                                    line_store_data_out<=p11;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p04!=masktemp)
                                begin
                                    line_store_data_out<=p04;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p11!=masktemp)
                                begin
                                    line_store_data_out2<=p11;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p04!=masktemp)
                                begin
                                    line_store_data_out2<=p04;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p08_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p08_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p07_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p07_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p08_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p08_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p07_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p07_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 17 *******////
                    17:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p12!=masktemp)
                                begin
                                    line_store_data_out<=p12;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p03!=masktemp)
                                begin
                                    line_store_data_out<=p03;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p12!=masktemp)
                                begin
                                    line_store_data_out2<=p12;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p03!=masktemp)
                                begin
                                    line_store_data_out2<=p03;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p09_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p09_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p06_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p06_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p09_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p09_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p06_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p06_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 18 *******////
                    18:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p13!=masktemp)
                                begin
                                    line_store_data_out<=p13;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p02!=masktemp)
                                begin
                                    line_store_data_out<=p02;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p13!=masktemp)
                                begin
                                    line_store_data_out2<=p13;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p02!=masktemp)
                                begin
                                    line_store_data_out2<=p02;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p10_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p10_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p05_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p05_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p10_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p10_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p05_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p05_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 19 *******////
                    19:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p14!=masktemp)
                                begin
                                    line_store_data_out<=p14;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p01!=masktemp)
                                begin
                                    line_store_data_out<=p01;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p14!=masktemp)
                                begin
                                    line_store_data_out2<=p14;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p01!=masktemp)
                                begin
                                    line_store_data_out2<=p01;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p11_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p11_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p04_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p04_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p11_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p11_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p04_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p04_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 20 *******////
                    20:   begin
                    if (spriteon==1)
                    begin
                         if (priority)
                         begin
                            if (flipx)
                            begin
                                if (p15!=masktemp)
                                begin
                                    line_store_data_out<=p15;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                            else
                            begin
                                if (p00!=masktemp)
                                begin
                                    line_store_data_out<=p00;
                                    line_store_we<=1;    
                                end
                                else line_store_we<=0;
                            end
                         end
                         else line_store_we<=0;
                         
                         if (priority==0)
                         begin
                            if (flipx)
                            begin
                                if (p15!=masktemp)
                                begin
                                    line_store_data_out2<=p15;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                            else
                            begin
                                if (p00!=masktemp)
                                begin
                                    line_store_data_out2<=p00;
                                    line_store_we2<=1;    
                                end
                                else line_store_we2<=0;
                            end
                         end 
                         else line_store_we2<=0;
                         line_store_write<=line_store_write+1;
                         line_store_write2<=line_store_write2+1;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p12_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p12_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p03_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p03_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p12_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p12_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p03_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p03_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 21 *******////
                    21: begin
                    if (spriteon==1)
                    begin
                            //if (spriteptr==0) spriteprocessing<=0; else spriteptr<=spriteptr-1;
                            //spriteptr<=spriteptr-1;
                            //if (spriteptr==63) spriteprocessing<=0;                            
                            line_store_we<=0;
                            line_store_we2<=0;
                            //spriteprocessing<=0;
                    end
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p13_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p13_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p02_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p02_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p13_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p13_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p02_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p02_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end
                    spritestage<=spritestage+1;
                    end
                    
                    ////******* 22 *******////
                    22: begin
                        
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p14_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p14_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p01_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p01_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p14_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p14_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p01_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p01_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;        
                    end
                    spritestage<=spritestage+1;
                    //spritestage<=0;
                    spriteon<=0; 
                    end
                    
                    ////******* 23 *******////
                    23: begin
                    if (spriteon_2==1)
                    begin
                        if (priority_2)
                         begin
                            if (flipx_2)
                            begin
                                if (p15_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p15_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                            else
                            begin
                                if (p00_2!=masktemp_2)
                                begin
                                    line_store_data_out_2<=p00_2;
                                    line_store_we_2<=1;    
                                end
                                else line_store_we_2<=0;
                            end
                         end
                         else line_store_we_2<=0;
                         
                         if (priority_2==0)
                         begin
                            if (flipx_2)
                            begin
                                if (p15_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p15_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                            else
                            begin
                                if (p00_2!=masktemp_2)
                                begin
                                    line_store_data_out2_2<=p00_2;
                                    line_store_we2_2<=1;    
                                end
                                else line_store_we2_2<=0;
                            end
                         end 
                         else line_store_we2_2<=0;
                         line_store_write_2<=line_store_write_2+1;
                         line_store_write2_2<=line_store_write2_2+1;
                    end

                        //spritestage<=0;
                    spritestage<=spritestage+1;
                        //spriteon<=0; 
                    end
                    
                    ////******* 24 *******////
                    24: begin
                        //spritestage<=0;
                    if (spriteon_2==1)
                    begin
                            //if (spriteptr==0) spriteprocessing<=0; else spriteptr<=spriteptr-1;
                            //spriteptr_2<=spriteptr_2-1;
                            //spriteptr<=spriteptr-1;
                            //if (spriteptr==63) spriteprocessing<=0;                            
                            line_store_we_2<=0;
                            line_store_we2_2<=0;
                            //spriteprocessing<=0;
                    end
                    
                    spritestage<=spritestage+1;
                        //spriteon<=0; 
                    end
                    
                    ////******* 25 *******////
                    25: begin
                    //    spritestage<=0;                        
                        spriteon_2<=0; 
                    end
   
                    default:   begin
                            line_store_we<=0;
                            line_store_we2<=0;
                            line_store_we_2<=0;
                            line_store_we2_2<=0;
                    end
                    endcase
                
                
                if ((spriteon==0) && (spriteon_2==0))
                begin
                    if (spritestage>8)
                    begin
                        if (spriteptr_2==127) spriteprocessing<=0; else
                        begin
                             //sprite_attr_addr_read<=spriteptr;
                             spriteptr<=spriteptr+1;                       
                             spriteptr_2<=spriteptr_2+1;
                             spritestage<=0;
                             
                             case (sprite_attr_data_in[57:56])
                                2'b00:begin
                                    spritex<=sprite_attr_data_in[8:0];                            
                                end
                                /*8'b??????01:begin
                                    spritex<=spritex;                                
                                end*/
                                2'b10:begin
                                    if (flipx) spritex<=spritex-16; else spritex<=spritex+16;                            
                                end
                                2'b11:begin
                                    if (flipx) spritex<=spritex+16; else spritex<=spritex-16;                            
                                end
                             endcase
                             case (sprite_attr_data_in[59:58])
                                2'b00:begin
                                    spritey<=sprite_attr_data_in[24:16];
                                end
                                /*8'b????01??:begin
                                    spritey<=spritey;
                                end*/
                                2'b10:begin
                                    if (flipy) spritey<=spritey-16; else spritey<=spritey+16;
                                end
                                2'b11:begin
                                    if (flipy) spritey<=spritey+16; else spritey<=spritey-16;
                                end
                             endcase
                             case (sprite_attr_data_in[61:60])
                                2'b00:begin
                                    spritemode<=sprite_attr_data_in[39];                                    
                                    pattern<=sprite_attr_data_in[38:32];                            
                                end
                                /*8'b??01????:begin
                                    spritemode<=spritemodetemp2;
                                    pattern<=patterntemp;                                    
                                end*/
                                2'b10:begin
                                 //   spritemode<=spritemodetemp2;
                                    pattern<=pattern+1;                                 
                                 end
                                2'b11:begin
                                    //spritemode<=spritemodetemp2;
                                    pattern<=pattern-1;                                
                                end
                             endcase
                             case (sprite_attr_data_in[62])
                                1'b0:begin
                                    flipy<=sprite_attr_data_in[47];
                                    flipx<=sprite_attr_data_in[46];
                                    paloffset<=sprite_attr_data_in[43:40];                                    
                                end                             
                                /*8'b?1??????:begin
                                    flipy<=flipy;
                                    flipx<=flipx;
                                    paloffset<=paloffset;                                
                                end*/
                             endcase
                             case (sprite_attr_data_in[63])
                                1'b0:begin
                                    priority<=sprite_attr_data_in[49];
                                    visible<=sprite_attr_data_in[48];
                                end                                
                                /*8'b1???????:begin
                                    priority<=priority;
                                    visible<=visible;
                                end*/                        
                             endcase
                             /*spritex<=sprite_attr_data_in[8:0];//_in[8:0];                            
                             spritey<=sprite_attr_data_in[24:16];//_in[24:16];
                             spritemode<=sprite_attr_data_in[39];                                    
                             pattern<=sprite_attr_data_in[38:32];                                            
                             flipy<=sprite_attr_data_in[47];
                             flipx<=sprite_attr_data_in[46];
                             paloffset<=sprite_attr_data_in[43:40];                                                    
                             priority<=sprite_attr_data_in[49];
                             visible<=sprite_attr_data_in[48];*/
                        end
                        
                    end
                end
                
            
            
              //  spr_active<=0;
                //spritestage<=spritestage+1;
            end
       
       
            //if (ByteRead==1)
            //begin
    
    
                //if (ByteDelay==0)
                //begin
                    
                //end
                if (ByteDelay==0)
                begin
                    if (scanlines==1)
                    begin
                        if (line_store_data_in_2==maskbyte)
                        begin
                            spr_pal_address_read<=line_store_data_in;
                            line_store2_data_out<=line_store_data_in;
                        end
                        else
                        begin
                            
                            spr_pal_address_read<=line_store_data_in_2;
                            line_store2_data_out<=line_store_data_in_2;
                        end
                        line_store2_we<=1;
                        
                        if (line_store_data_in2_2==maskbyte)
                        begin
                            spr_pal_address_read2<=line_store_data_in2;
                            line_store2_data_out2<=line_store_data_in2;
                        end
                        else
                        begin
                            
                            spr_pal_address_read2<=line_store_data_in2_2;
                            line_store2_data_out2<=line_store_data_in2_2;
                        end
                        line_store2_we2<=1;
                        //if (line_store_data_in==maskbyte) spr_active<=0; else spr_active<=1;                  //apply masking
                        
                    end
                    else
                    begin
                        //if (show_scan_lines) spr_pal_address_read<=0; else 
                        spr_pal_address_read<=line_store2_data_in;
                        
                        spr_pal_address_read2<=line_store2_data_in2;
                        //if (line_store2_data_in==maskbyte) spr_active<=0; else spr_active<=1;
                    end
                    
                    //if (spr_pal_address_read==maskbyte) spr_active<=0; else spr_active<=1;
                    
                end
                
                if (ByteDelay==2)
                begin
                    line_store2_we<=0;    
                    line_store2_we2<=0;
                    if (scanlines==1)
                    begin
                        line_store_read<=line_store_read+1;
                        line_store_read2<=line_store_read2+1;
                        line_store_read_2<=line_store_read_2+1;
                        line_store_read2_2<=line_store_read2_2+1;
                    end
                    
                end
                if (ByteDelay==4)
                begin
                    
                    line_store2_read<=line_store2_read+1;
                    line_store2_write<=line_store2_write+1;
                    line_store2_read2<=line_store2_read2+1;
                    line_store2_write2<=line_store2_write2+1;
                    //line_store_read<=spritecol;
                    if (scanlines==1)
                    begin
                        line_store_data_out<=maskbyte;
                        line_store_we<=1;
                        line_store_data_out2<=maskbyte;
                        line_store_we2<=1;
                        line_store_data_out_2<=maskbyte;
                        line_store_we_2<=1;
                        line_store_data_out2_2<=maskbyte;
                        line_store_we2_2<=1;
                    end
                    //if (spr_pal_address_read==maskbyte) spr_active<=0; else spr_active<=1;
                end
                if (ByteDelay==6)
                begin
	//					  ByteCounter<=ByteCounter+1;
                    spr_vid_out<=spr_pal_in[11:0];   //get indexed colour from palette
                    spr_vid_out2<=spr_pal_in2[11:0];   //get indexed colour from palette
                    //if (spr_pal_address_read==maskbyte) spr_active<=0; else spr_active<=1;
                    //if (spr_pal_address_read2==maskbyte) spr_active2<=0; else spr_active2<=1;
						  //if ((spr_pal_address_read==maskbyte) || (ByteCounter<clip_l) || (ByteCounter>clip_r)) spr_active<=0; else spr_active<=1;
                    //if ((spr_pal_address_read2==maskbyte) || (ByteCounter<clip_l) || (ByteCounter>clip_r)) spr_active2<=0; else spr_active2<=1;
						  if ((spr_pal_address_read==maskbyte) || (CounterX[9:1]<clip_l) || (CounterX[9:1]>clip_r)) spr_active<=0; else spr_active<=1;
                    if ((spr_pal_address_read2==maskbyte) || (CounterX[9:1]<clip_l) || (CounterX[9:1]>clip_r)) spr_active2<=0; else spr_active2<=1;
                    //if (spr_pal_address_read==maskbyte) spr_active<=0; else spr_active<=1;
                    if (scanlines==1)
                    begin
                        line_store_we<=0;
                        line_store_write<=line_store_write+1;
                        line_store_we2<=0;
                        line_store_write2<=line_store_write2+1;
                        line_store_we_2<=0;
                        line_store_write_2<=line_store_write_2+1;
                        line_store_we2_2<=0;
                        line_store_write2_2<=line_store_write2_2+1;
                    end
                end
                 ByteDelay<=ByteDelay+1;
            end
             
            //ByteDelay<=ByteDelay+1;
      //  end
        //if ((CounterY==481) && (CounterX==1)) spritex<=spritex+1;
    end
    
    end
    endmodule
