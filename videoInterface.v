`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.12.2018 09:28:09
// Design Name: 
// Module Name: videoInterface
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


module videoInterface(
    input clk,
    input vga_v_sync,
    input [9:0] CounterX,
    input [9:0] CounterY,
    input inDisplayArea,
    input [15:0] p_data_in,
    input [11:0] ls_data_in,
    input [11:0] ls_data_in2,
    input ls_data_in3,
    input [7:0] cr_data_in,
    input io_in,
    input io_out,
    input [15:0] io_addr_in,
    input [7:0] io_data_in,
    input [7:0] character_rom_in,
    input [15:0] tilemap0_data_in,
    input [15:0] tilemap1_data_in,
    input scanlines,
    input nreset,
    output reg [7:0] io_data_out,
    output wire [16:0] video_address,   //address to put on external video buffer (ram interface)
    output reg [11:0] v_data,           //video data 12 bit colour out
    output reg [11:0] v_data2,          //foreground tilemap 12 bit colour out
    output reg [7:0] v_data_out,
    input [7:0] v_data_in,
    output reg [7:0] p_address_read,         //address for palette memory
    output reg [7:0] p_address_write,         //address for palette memory
    output reg [15:0] p_data_out,
    output reg p_wren,
    output reg [8:0] ls_address,
    output reg [11:0] ls_data_out,
    output reg [8:0] ls_address2,
    output reg [8:0] ls_address3,
    output reg [11:0] ls_data_out2,
    output reg ls_data_out3,
    output reg ls_wren,
    output reg ls_wren2,
    output reg ls_wren3,
    output reg [5:0] cr_address,
    output reg [7:0] cr_data_out,
    output reg [10:0] character_rom_address,
    output reg cr_wren,
    output reg vid_oe,
    output wire vid_we_out,
    output reg [11:0] tilemap0_address_read,
    output reg [12:0] tilemap0_address_write,
    output reg [11:0] tilemap1_address_read,
    output reg [12:0] tilemap1_address_write,
    output reg tilemap0_we,
    output reg tilemap1_we,
    output reg [7:0] tilemap0_data_out,
    output reg [7:0] tilemap1_data_out,
    output reg foreground_enable,
    //output reg show_scan_lines,
    output reg cpu_wait,
    output reg [15:0] dac_out,
    output reg [15:0] dac_out1,
    output reg [15:0] dac_out2,
    output reg [15:0] dac_out3,
    output reg sample_playing,
    output reg sample_playing1,
    output reg sample_playing2,
    output reg sample_playing3,
    output reg foregroundmask    
    );
    

localparam  TILEGFX_OFFSET = 16384;
localparam  VID2POS = 799;
localparam  VID1POS = 797;
localparam  VID03YPOS=523;

assign vid_we_out=~vid_we;

reg vid_we;
reg [1:0] ByteDelay;	//We only want to increase read address every 2 pixels  
reg [1:0] ByteDelay2;	//We only want to increase read address every 2 pixels
reg [16:0] n_address;	//base address for video memory
reg [16:0] v_address;	//address for reading video memory
reg [16:0] v_temp_addr;	//for holding current video read address when writing to a different address
reg [10:0] ByteCounter;
reg [10:0] ByteCounter2;
reg [10:0] ByteWrapCounter;
reg [10:0] ByteWrapCounter2;
reg [10:0] ByteWrapMax;
reg [10:0] ByteWrapMax2;
reg [9:0] ByteStartCounter;		
reg [9:0] ByteStartCounter2;
//reg [7:0] p_data;			//palette data
reg [8:0]h_scroll_pos; //holds h scroll value 
reg [8:0]h_scroll_pos_latch; //holds h scroll value
reg [8:0]v_scroll_pos; //holds v scroll value
//reg [8:0]v_scroll_pos_latch; //holds v scroll value
reg [8:0]h_scroll_pos2; //holds h scroll value 
reg [8:0]h_scroll_pos2_latch; //holds h scroll value
reg [8:0]v_scroll_pos2; //holds v scroll value
//reg [8:0]v_scroll_pos2_latch; //holds v scroll value
reg ByteRead;
reg ByteRead2;
reg wren;
//reg [0:0]scanlines;
reg [1:0]vid_mode;
reg [2:0]tile_count_h;
reg [2:0]tile_count_v;
reg [2:0]tile_count_h2;
reg [2:0]tile_count_v2;
//reg [11:0] char_address;
reg [12:0] base_char_address;
reg [12:0] base_char_address2;
reg [4:0] tile_row;
reg [4:0] tile_row2;
reg new_char;
reg [7:0]next_char;
reg [15:0]temp_address;
reg [5:0]h_char_counter;  //counter to loop map once we hit 64 horizontal chars
reg [5:0]h_char_counter2;  //counter to loop map once we hit 64 horizontal chars
reg [16:0] latched_address;	//this is the address that will be put on address bus when writing to memory
reg [16:0] gfx_space_address;	//current address to be used when writing individual pixels using port FC
reg [16:0] tile_address;		//address of currently selected tile gfx - 131,072 addressable space (8 x 16,384 banks) 
reg [12:0] map_address;			//address of currently selected map tile - 8,192 (64 x 64 tiles x 2 bytes per tile)
reg [12:0] cursor_address;      //address of cursor location (80 x 60 = 4800) so need 8,192 size register
reg selected_tilemap;           //which tilemap 0 or 1
reg [15:0] sample_write_address;
reg [15:0] sample_read_address [3:0]; 
reg [15:0] sample_length [3:0];
reg [15:0] sample_read_address_active [3:0]; 
reg [15:0] sample_length_active [3:0];
reg [15:0] sample_freq [3:0];
reg [15:0] sample_volume [3:0];
reg sample_loop [3:0];
//reg [1:0] sample_counter;
reg mem_can_write;
reg mem_can_latch;
reg write_latched;
reg read_latched;
reg [1:0] read_delay;
reg [7:0] io_latch;
reg [7:0] pal_read_latch;
reg [7:0] tile0_latch;
reg [7:0] tile1_latch;

reg io_ack;	//control bit - ioreq needs to go high before we acknowledge next ioreq
reg write_wait; //flag to indicate a data write is queued
reg tile_write_wait; //flag to indicate a data write is queued
reg tile_col_write_wait; //flag to indicate a data write is queued
//reg [2:0] tile_read_wait;
reg pal_read_wait;
reg tile_gfx_write_wait; //flag to indicate a data write is queued
reg sample_write_wait;
//reg sample_playing [3:0];
reg [1:0] sample_ptr;
//reg [7:0]write_data; //value to be written to memory


reg [11:0] background_colour;
reg [11:0] foreground_colour;
reg [11:0] bglatch;
reg [11:0] fglatch;
reg [7:0] bgbyte;
reg [7:0] character_latch;
reg [7:0] character;
reg [12:0] vid2_char_address;
//reg [12:0] vid2_col_address;
reg [6:0] cursorx;
reg [5:0] cursory;
reg contention_flag;
reg [11:0] tile0_addr_read_latch;
reg [11:0] tile1_addr_read_latch;

reg [11:0] tilemap0_data_latch;
reg [3:0] tilemap0_pal_latch;
reg [11:0] tilemap1_data_latch;
reg [3:0] tilemap1_pal_latch;

reg [7:0] foregroundmask_index;
//reg [11:0] foregroundmask_colour;
reg foregroundmask_latch;
reg foregroundtest[511:0];

reg [0:5]temp_counter;

reg [8:0]h_read_offset;
reg [8:0]h_read_offset2;


//wire [8:0]h_read_offset=(374+24)-h_scroll_pos[2:0];  //this controls the timing for h scroll
//wire [8:0]h_read_offset2=(373+24)-h_scroll_pos2[2:0];  //this controls the timing for h scroll on background map
//wire [8:0]h_read_offset=(374+24)-h_scroll_pos[2:0];  //this controls the timing for h scroll on foreground map
//assign cpu_wait = cpu_wait_in || cpu_wait_out;



//assign video_io = vid_we ? 8'bZ:v_data_out; //if write enable low then port data on pins else put into tri-state
//assign v_data_in = video_io;

//assign video_address = vid_we ? v_address:latched_address; //either put read address or write address on address lines depending on state
assign video_address = write_latched ? v_address:latched_address; //either put read address or write address on address lines depending on state



initial
begin
	v_address <=0;
	n_address <=0;
	ByteDelay <=0;
	ByteDelay2 <=0;
	v_data <= 0;
	v_data2 <= 0;
	ByteCounter <=0;
	ByteCounter2 <=0;
	ByteWrapCounter <= 0;
	ByteWrapCounter2 <= 0;
	h_scroll_pos <= 0;//120; 
	v_scroll_pos <= 0;//120;
	h_scroll_pos2 <= 0;//120; 
	v_scroll_pos2 <= 0;//120;
	ByteRead <= 0;
    ByteRead2 <= 0;
	p_address_read<=0;
	p_address_write<=0;
	wren<=0;
	ls_wren<=0;
	ls_wren2<=0;
	ls_wren3<=0;
	vid_mode<=2;	//start up in character mode
	new_char<=1;
	bglatch<=0;
		
	io_data_out<=0;
	
	vid_we<=1;	//temp - should be high (1) as init
	
	
	v_data_out<=0;	//debug - should be 0
	write_wait<=0;      //debug - should be 0
	read_delay<=0;
	
	vid_oe<=0;
	io_ack<=0;
	latched_address<=0;
	gfx_space_address<=0;//0;	//current address to be used when writing individual pixels using port FC
	tile_address<=0;		//address of currently selected tile gfx - 32,768 addressable space (reduce by half and use offset?)
	map_address<=0;			//address of currently selected map tile - 4,096 addressable space
	selected_tilemap<=0;   //tilemap 0 initially selected

    cursor_address<=0;
	
	tile_write_wait<=0;
	tile_col_write_wait<=0;
	//tile_read_wait<=0;
	pal_read_wait<=0;
	
	tile_gfx_write_wait<=0;
	sample_write_wait<=0;
	//sample_playing<=0;
	//write_data<=0;
	mem_can_write<=0;
	mem_can_latch<=0;
	write_latched<=1;		//used to latch write address on bus 1 clock before write enable goes low
	read_latched<=1;		
	//cpu_wait_out<=1;			//wait the cpu if trying to write memory when we need to read it
	//cpu_wait_in<=1;
	cpu_wait<=1;
//	show_scan_lines<=0;
    cursorx<=0;
    cursory<=0;
    contention_flag<=0;
    
    //sample_freq<=0;
    //sample_read_address<=0;
    //sample_write_address<=0;
    //sample_length<=0;
    //sample_counter<=0;
    foregroundmask<=0;
    //foregroundmask_colour<=0;
    foregroundmask_index<=0;
    foregroundmask_latch<=0;
    
    sample_volume[0]<=7;
    sample_volume[1]<=7;
    sample_volume[2]<=7;
    sample_volume[3]<=7;
    sample_loop[0]<=0;
    sample_loop[1]<=0;
    sample_loop[2]<=0;
    sample_loop[3]<=0;
    
    
end


wire clkout=clk;


    
    


always @(posedge clk or negedge nreset)
begin
if (!nreset)
begin
	v_address <=0;
	n_address <=0;
	ByteDelay <=0;
	ByteDelay2 <=0;
	v_data <= 0;
	v_data2 <= 0;
	ByteCounter <=0;
	ByteCounter2 <=0;
	ByteWrapCounter <= 0;
	ByteWrapCounter2 <= 0;
	h_scroll_pos <= 0;//120; 
	v_scroll_pos <= 0;//120;
	h_scroll_pos2 <= 0;//120; 
	v_scroll_pos2 <= 0;//120;
	h_scroll_pos_latch<=0;
	h_scroll_pos2_latch<=0;
	ByteRead <= 0;
    ByteRead2 <= 0;
	p_address_read<=0;
	p_address_write<=0;
	wren<=0;
	ls_wren<=0;
	ls_wren2<=0;
	ls_wren3<=0;
	vid_mode<=2;	//start up in character mode
	new_char<=1;
	bglatch<=0;
		
	io_data_out<=0;
	
	vid_we<=1;	//temp - should be high (1) as init
	
	
	v_data_out<=0;	//debug - should be 0
	write_wait<=0;      //debug - should be 0
	read_delay<=0;
	
	vid_oe<=0;
	io_ack<=0;
	latched_address<=0;
	gfx_space_address<=0;//0;	//current address to be used when writing individual pixels using port FC
	tile_address<=0;		//address of currently selected tile gfx - 32,768 addressable space (reduce by half and use offset?)
	map_address<=0;			//address of currently selected map tile - 4,096 addressable space
	selected_tilemap<=0;   //tilemap 0 initially selected

    cursor_address<=0;
	
	tile_write_wait<=0;
	tile_col_write_wait<=0;
	//tile_read_wait<=0;
	pal_read_wait<=0;
	
	tile_gfx_write_wait<=0;
	sample_write_wait<=0;
	sample_playing<=0;
	//write_data<=0;
	mem_can_write<=0;
	mem_can_latch<=0;
	write_latched<=1;		//used to latch write address on bus 1 clock before write enable goes low
	read_latched<=1;
	//cpu_wait_out<=1;			//wait the cpu if trying to write memory when we need to read it
	//cpu_wait_in<=1;
	cpu_wait<=1;
//	show_scan_lines<=0;
    cursorx<=0;
    cursory<=0;
    contention_flag<=0;
    
    sample_playing<=0;
    sample_playing1<=0;
    sample_playing2<=0;
    sample_playing3<=0;
    
    /*sample_freq[0]<=0;
    sample_freq[1]<=0;
    sample_freq[2]<=0;
    sample_freq[3]<=0;
    
    sample_read_address[0]<=0;
    sample_read_address[1]<=0;
    sample_read_address[2]<=0;
    sample_read_address[3]<=0;
    sample_read_address_active[0]<=0;
    sample_read_address_active[1]<=0;
    sample_read_address_active[2]<=0;
    sample_read_address_active[3]<=0;
    sample_write_address[0]<=0;
    sample_write_address[1]<=0;
    sample_write_address[2]<=0;
    sample_write_address[3]<=0;
    sample_length[0]<=0;
    sample_length[1]<=0;
    sample_length[2]<=0;
    sample_length[3]<=0;
    sample_length_active[0]<=0;
    sample_length_active[1]<=0;
    sample_length_active[2]<=0;
    sample_length_active[3]<=0;*/
    //sample_counter<=0;
    foreground_enable<=0;
    foregroundmask<=0;
    //foregroundmask_colour<=0;
    foregroundmask_index<=0;
    foregroundmask_latch<=0;
    
    sample_volume[0]<=7;
    sample_volume[1]<=7;
    sample_volume[2]<=7;
    sample_volume[3]<=7;
    
    sample_loop[0]<=0;
    sample_loop[1]<=0;
    sample_loop[2]<=0;
    sample_loop[3]<=0;
end
else
begin

if ((vid_mode==0) || (vid_mode==3)) 
begin

	if (ByteRead==0)
	begin		
//	    if ((CounterX[9:1]>=h_read_offset[8:0]-16) && (CounterX[9:1]<h_read_offset[8:0]) && (CounterY<480) && (contention_flag)) cpu_wait<=0;
		if ((CounterX[9:1]==h_read_offset[8:0]) && (CounterX[0]==1) && (CounterY<480)) //turn on display at start of new line is y < 480 - actually start reading new byte on last line 523
		begin
//			if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			ByteRead <= 1;
			ByteCounter <= 640+20;//+36;//+(h_scroll_pos[1:0]);
			ByteWrapMax <=640+16-(h_scroll_pos_latch << 1);
			ByteWrapCounter <= 0;
			//if (ByteRead2==0) ByteDelay<=0;
			ByteDelay<=0;
			
//			scanlines <= scanlines +1;
		end
	end
	else
	begin
		if (ByteDelay[0:0]==1'h1)
		begin
			ByteCounter <= ByteCounter -1;
			if (ByteStartCounter) ByteStartCounter = ByteStartCounter -1;
			ByteWrapCounter <= ByteWrapCounter + 1;
			ByteRead <= !(ByteCounter==0); //turn off byte reading after 640 screen pixels (320 actual reads)?
			//cpu_wait <=((ByteCounter==0) && (ByteCounter2==0));
			//cpu_wait <=((ByteCounter==0);
		end
		ByteDelay <= ByteDelay +1;
	
	end
	
	if (ByteRead2==0)
	begin		
//	    if ((CounterX[9:1]>=h_read_offset2[8:0]-20) && (CounterX[9:1]<h_read_offset2[8:0]) && ((CounterY<480) || (CounterY>521)) && (contention_flag)) cpu_wait<=0;
		if ((CounterX[9:1]==h_read_offset2[8:0]) && (CounterX[0]==1) && ((CounterY<480) || (CounterY>(VID03YPOS-2)))) //turn on display at start of new line is y < 480 - actually start reading new byte on last line 523
		begin
//			if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			ByteRead2 <= 1;
			ByteCounter2 <= 640+24;//+36;//+(h_scroll_pos2[1:0]);
			ByteWrapMax2 <=640+20-(h_scroll_pos2_latch << 1);
			ByteWrapCounter2 <= 0;
			//if (ByteRead==0) ByteDelay<=0;
			ByteDelay2<=0;
		end
	end
	else
	begin
		if (ByteDelay2[0:0]==1'h1)
		begin
			ByteCounter2 <= ByteCounter2 -1;
			if (ByteStartCounter2) ByteStartCounter2 = ByteStartCounter2 -1;
			ByteWrapCounter2 <= ByteWrapCounter2 + 1;
			ByteRead2 <= !(ByteCounter2==0); //turn off byte reading after 640 screen pixels (320 actual reads)?
			//cpu_wait <=((ByteCounter==0) && (ByteCounter2==0));
			//cpu_wait <=(ByteCounter2==0);
		end
        ByteDelay2 <= ByteDelay2 +1;	
	end

//	if ((CounterY>480) || (contention_flag==0) || ((ByteRead==0) && (ByteRead2==0)))
//	begin
//	   cpu_wait<=1;
//	end  //make sure we restart cpu if not drawing screen or if no contention
	
	
end

if (vid_mode==1)
begin
	//simpler solution - we start reading 4 clocks before CounterX maxes out
	//CounterX maxes out at 31F or 799 so we will start reading byte data from 31E or 798 (the clock after 797)
	//this is so that we read a go through a 4 clock read cycles to obtain first byte ready to output to display once
	//CounterX wraps to 0 and the Display is turned on  (CounterX updates every 2 clocks)
	if(ByteRead==0)
	begin	
//	    if ((CounterX>=VID1POS-4) && (CounterX<VID1POS) && (CounterY<480) && (contention_flag)) cpu_wait<=0;
		//if ((CounterX==763) && (CounterY<480)) //turn on display at start of new line if y < 480
		if ((CounterX==VID1POS) && (CounterY<480)) //turn on display at start of new line if y < 480
		begin
			ByteRead <= 1;
//			if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			ByteCounter <= 641;//+(h_scroll_pos << 1);
			ByteWrapMax <=640-(h_scroll_pos << 1);
			ByteWrapCounter <= 0;
			ByteDelay<=0;
//			scanlines <= scanlines +1;
		end
	end
	else
	begin
		if (ByteDelay[0:0]==1'h1)
		begin
			ByteCounter <= ByteCounter -1;
			if (ByteStartCounter) ByteStartCounter = ByteStartCounter -1;
			ByteWrapCounter <= ByteWrapCounter + 1;
			ByteRead <= !(ByteCounter==0); //turn off byte reading after 640 screen pixels (320 actual reads)?
			
			//cpu_wait <= (ByteCounter==0);
		end
		ByteDelay <= ByteDelay +1;
	end
	
end

if (vid_mode==2)
begin
	//simpler solution - we have a separate counter that starts reading 4 clocks before CounterX maxes out
	//CounterX maxes out at 2FF or 767 so we will start reading byte data from 2FB or 763
	if(ByteRead==0)
	begin	
		//if ((CounterX==763) && (CounterY<480)) //turn on display at start of new line if y < 480
	//	if ((CounterX>=VID2POS-8) && (CounterX<VID2POS) && (CounterY<480) && (contention_flag)) cpu_wait<=0;
		if ((CounterX==VID2POS) && (CounterY<480)) //turn on display at start of new line if y < 480
		begin
			ByteRead <= 1;
		//	if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			ByteCounter <= 640;//+(h_scroll_pos << 1);
			ByteWrapMax <=640;
			ByteWrapCounter <= 0;
			ByteDelay<=0;
//			scanlines <= scanlines +1;
		end
	end
	else
	begin
		if (ByteDelay[0:0]==1'h1)
		begin
			ByteCounter <= ByteCounter -1;
			if (ByteStartCounter) ByteStartCounter = ByteStartCounter -1;
			ByteWrapCounter <= ByteWrapCounter + 1;
			ByteRead <= !(ByteCounter==0); //turn off byte reading after 640 screen pixels (320 actual reads)?
			
//			if ((ByteCounter>0) && (contention_flag)) cpu_wait<=0; else cpu_wait<=1;
		end
		ByteDelay <= ByteDelay +1;
	end
	
/*	if (vga_v_sync==0)
	begin
	   cpu_wait<=1;
	end*/
	
end


//end

//always @(posedge clk)
//begin

    if (sample_playing)
    begin
        //if (sample_freq[0])
        //begin
            if (sample_length_active [0]==0)
            begin
                if (sample_loop[0])
                begin
                    sample_length_active[0]<=sample_length[0];
                    sample_read_address_active[0]<=sample_read_address[0];
                end
                else
                begin
                    sample_playing<=0;
                end
            end
            else
            begin
                if (CounterX==662)        //update sample in h-blank
                begin
                    v_address<=sample_read_address_active[0]+65536;
                end
                if (CounterX==664)        //update sample in h-blank
                begin
                    //if (sample_volume[0]<7 ) dac_out<=(v_data_in / (7-sample_volume[0])); else dac_out<=v_data_in;
                    //dac_out<=(v_data_in << sample_volume[0]);
                    dac_out<=(v_data_in * sample_volume[0]);
                    if (sample_freq[0] [0])
                    begin
                        sample_length_active[0]<=sample_length_active[0]-1;
                        sample_read_address_active[0]<=sample_read_address_active[0]+1;
                       // if (sample_length==1) sample_playing<=0;
                    end
                    sample_freq[0]<={sample_freq[0] [0],sample_freq[0] [15:1]};
                end
            end
    end
    else
    begin
        dac_out<=8'h0;//80;   //silence DAC
        //dac_out<={0,dac_out[7:1]};   //gradually silence DAC to avoid clicks
    end
    if (sample_playing1)
    begin
        //if (sample_freq[0])
        //begin
            if (sample_length_active [1]==0)
            begin
                if (sample_loop[1])
                begin
                    sample_length_active[1]<=sample_length[1];
                    sample_read_address_active[1]<=sample_read_address[1];
                end
                else
                begin
                    sample_playing1<=0;
                end
            end
            else
            begin
                if (CounterX==665)        //update sample in h-blank
                begin
                    v_address<=sample_read_address_active[1]+65536;
                end
                if (CounterX==667)        //update sample in h-blank
                begin
                    //if (sample_volume[1]<7 ) dac_out1<=(v_data_in / (7-sample_volume[1])); else dac_out1<=v_data_in;
                    //dac_out1<=(v_data_in << sample_volume[1]);
                    dac_out1<=(v_data_in * sample_volume[1]);
                    if (sample_freq[1] [0])
                    begin
                        sample_length_active[1]<=sample_length_active[1]-1;
                        sample_read_address_active[1]<=sample_read_address_active[1]+1;
                       // if (sample_length==1) sample_playing<=0;
                    end
                    sample_freq[1]<={sample_freq[1] [0],sample_freq[1] [15:1]};
                end
            end
    end
    else
    begin
        dac_out1<=8'h0;//80;   //silence DAC
        //dac_out<={0,dac_out[7:1]};   //gradually silence DAC to avoid clicks
    end
    if (sample_playing2)
    begin
        //if (sample_freq[0])
        //begin
            if (sample_length_active [2]==0)
            begin
                if (sample_loop[2])
                begin
                    sample_length_active[2]<=sample_length[2];
                    sample_read_address_active[2]<=sample_read_address[2];
                end
                else
                begin
                    sample_playing2<=0;
                end
            end
            else
            begin
                if (CounterX==668)        //update sample in h-blank
                begin
                    v_address<=sample_read_address_active[2]+65536;
                end
                if (CounterX==670)        //update sample in h-blank
                begin
                    //if (sample_volume[2]<7 ) dac_out2<=(v_data_in / (7-sample_volume[2])); else dac_out2<=v_data_in;
                    //dac_out2<=(v_data_in << sample_volume[2]);
                    dac_out2<=(v_data_in * sample_volume[2]);
                    if (sample_freq[2] [0])
                    begin
                        sample_length_active[2]<=sample_length_active[2]-1;
                        sample_read_address_active[2]<=sample_read_address_active[2]+1;
                       // if (sample_length==1) sample_playing<=0;
                    end
                    sample_freq[2]<={sample_freq[2] [0],sample_freq[2] [15:1]};
                end
            end
    end
    else
    begin
        dac_out2<=8'h0;//80;   //silence DAC
        //dac_out<={0,dac_out[7:1]};   //gradually silence DAC to avoid clicks
    end
    if (sample_playing3)
    begin
        //if (sample_freq[0])
        //begin
            if (sample_length_active [3]==0)
            begin
                if (sample_loop[3])
                begin
                    sample_length_active[3]<=sample_length[3];
                    sample_read_address_active[3]<=sample_read_address[3];
                end
                else
                begin
                    sample_playing3<=0;
                end
            end
            else
            begin
                if (CounterX==671)        //update sample in h-blank
                begin
                    v_address<=sample_read_address_active[3]+65536;
                end
                if (CounterX==673)        //update sample in h-blank
                begin
                    //if (sample_volume[3]<7 ) dac_out3<=(v_data_in / (7-sample_volume[3])); else dac_out3<=v_data_in;
                    //dac_out3<=(v_data_in << sample_volume[3]);
                    dac_out3<=(v_data_in * sample_volume[3]);
                    if (sample_freq[3] [0])
                    begin
                        sample_length_active[3]<=sample_length_active[3]-1;
                        sample_read_address_active[3]<=sample_read_address_active[3]+1;
                       // if (sample_length==1) sample_playing<=0;
                    end
                    sample_freq[3]<={sample_freq[3] [0],sample_freq[3] [15:1]};
                end
            end
    end
    else
    begin
        dac_out3<=8'h0;//80;   //silence DAC
        //dac_out<={0,dac_out[7:1]};   //gradually silence DAC to avoid clicks
    end

	//**** first process any IO Requests
	if (p_wren) p_wren<=0;          //toggle write enable back off after palette write
	if (tilemap0_we) tilemap0_we<=0;
	if (tilemap1_we) tilemap1_we<=0;
	if (io_in==0)	//have we had an IO signal
	begin
		//if (io_ack==0) //have we already acknowledged it?
		if ((io_ack==0) && (contention_flag==0)) //have we already acknowledged it?
		begin
			io_ack<=1;	//acknowledge it
			case (io_addr_in[7:0])
				'hfc:	begin			//write byte to latched address
					//v_data_out<=v_data_out+1;
					//write_data<=io_data_in;
					v_data_out<=io_data_in;
					write_wait<=1;
					contention_flag<=1;
				end
				'hfb:	begin			//increase gfx address by 320
					gfx_space_address<=gfx_space_address+320;
				end
				'hfa:	begin			//increase gfx address by 1
					gfx_space_address<=gfx_space_address+1;
				end
				'hf9:	begin			//increase gfx address by value
					gfx_space_address<=gfx_space_address+io_data_in;
				end
				'hf8:	begin			//set highest bit of gfx address
					gfx_space_address[16]<=io_data_in[0];
				end
				'hf7:	begin			//set mid bit of gfx address
					gfx_space_address[15:8]<=io_data_in[7:0];
				end
				'hf6:	begin			//set low bit of gfx address
					gfx_space_address[7:0]<=io_data_in[7:0];
				end
				'hf5:	begin			//zero gfx address
					gfx_space_address<=0;
				end
				'hec:	begin			//write byte to tile gfx address
					v_data_out<=io_data_in;
					tile_gfx_write_wait<=1;
					contention_flag<=1;
				end
				'heb:	begin			//increase tile gfx address by 64
					if (vid_mode==3) tile_address<=tile_address+32; else tile_address<=tile_address+64;
				end
				'hea:	begin			//increase tile address by 1
					tile_address<=tile_address+1;
				end
				'he9:	begin			//increase gfx address by value
					tile_address<=tile_address+io_data_in;
				end
				'he8:	begin			//set high bit of tile gfx address
					tile_address[16:16]<=io_data_in[0:0];
				end
				'he7:	begin			//set mid byte of tile gfx address
					tile_address[15:8]<=io_data_in[7:0];
				end
				'he6:	begin			//set low byte of tile gfx address
					tile_address[7:0]<=io_data_in[7:0];
				end
				'he5:	begin			//zero tile gfx address
					tile_address<=0;
				end
				'he4:	begin			//set tile bank number
					if (vid_mode==3) tile_address[16:13]<=io_data_in[3:0]; else tile_address[16:14]<=io_data_in[2:0];
				end
				'he3:	begin			//set tile address to tile number
					if (vid_mode==3) tile_address[12:0]<=io_data_in*32; else tile_address[13:0]<=io_data_in*64;
				end
				'hdf:   begin
				    //if (vid_mode==0) selected_tilemap<=io_data_in[0:0]; else selected_tilemap<=0;
				    selected_tilemap<=io_data_in[0:0];
				end
				'hdd:	begin			//write colour byte to tile map address
				    if (vid_mode==2)
				    begin
					   //v_data_out<=io_data_in;
					   //tile_col_write_wait<=1;
    				   //contention_flag<=1;
    				   tilemap1_we<=1;
				       tilemap1_data_out<=io_data_in;
    			    end
				end
				'hdc:	begin			//write byte to tile map address
				    if (vid_mode==2)
				    begin
					   //v_data_out<=io_data_in;
					   //tile_write_wait<=1;
					   //contention_flag<=1;
					   tilemap0_we<=1;
				       tilemap0_data_out<=io_data_in;
				    end
				    else
				    begin
				        if (selected_tilemap)
				        begin
				            tilemap1_we<=1;
				            tilemap1_data_out<=io_data_in;
				        end
				        else
				        begin
				            tilemap0_we<=1;
				            tilemap0_data_out<=io_data_in;
				        end
				    end
			
				end
				'hdb:	begin			//increase tile address by 64 or 80 sepending on screen mode
					if (vid_mode==2)
					begin
					   if (cursory==63)
					   begin
					       tilemap0_address_write<=0;
					       tilemap1_address_write<=0;
					   end
					   else
					   begin
					       tilemap0_address_write<=tilemap0_address_write+80;
					       tilemap1_address_write<=tilemap1_address_write+80;
					   end
					   
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write<=tilemap1_address_write+64*2; else tilemap0_address_write<=tilemap0_address_write+64*2;
					end 
					//if (cursory==59) cursory<=0; else cursory<=cursory+1;
					cursory<=cursory+1;
				end
				'hda:	begin			//increase tile address by 1
					if (vid_mode==2)
					begin
					   tilemap0_address_write<=tilemap0_address_write+1;
					   tilemap1_address_write<=tilemap1_address_write+1;
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write<=tilemap1_address_write+1; else tilemap0_address_write<=tilemap0_address_write+1;
					end
					if (cursorx==79)
					begin
					   cursorx<=0;
					   //if (cursory==59) cursory<=0; else 
					   cursory<=cursory+1;
					end else cursorx<=cursorx+1;
				end
				'hd9:	begin			//increase tile address by value
					if (vid_mode==2)
					begin
					   tilemap0_address_write<=tilemap0_address_write+io_data_in;
					   tilemap1_address_write<=tilemap1_address_write+io_data_in;
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write<=tilemap1_address_write+io_data_in; else tilemap0_address_write<=tilemap0_address_write+io_data_in;
					end
				end
				
				'hd7:	begin			//set mid bit of tile address
					if (vid_mode==2)
					begin
					   tilemap0_address_write[12:8]<=io_data_in[4:0];
					   tilemap1_address_write[12:8]<=io_data_in[4:0];
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write[12:8]<=io_data_in[4:0]; else tilemap0_address_write[12:8]<=io_data_in[4:0];
					end
				end
				'hd6:	begin			//set low bit of tile address
					if (vid_mode==2)
					begin
					   tilemap0_address_write[7:0]<=io_data_in[7:0];
					   tilemap1_address_write[7:0]<=io_data_in[7:0];
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write[7:0]<=io_data_in[7:0]; else tilemap0_address_write[7:0]<=io_data_in[7:0];
					end
				end
				'hd5:	begin			//zero tile address
					if (vid_mode==2)
					begin
					    tilemap0_address_write<=0;
					    tilemap1_address_write<=0;
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write<=0; else tilemap0_address_write<=0;
					end
					cursorx<=0;
					cursory<=0;
				end
				'hd4:	begin			//set tile x element of address
					if (vid_mode==2)
					begin
					   tilemap0_address_write<=(cursory*80) + io_data_in[6:0];
					   tilemap1_address_write<=(cursory*80) + io_data_in[6:0];
					   cursorx<=io_data_in[6:0];
					end else
					begin
					   if (selected_tilemap) tilemap1_address_write[6:0]<={io_data_in[5:0],1'b0}; else tilemap0_address_write[6:0]<={io_data_in[5:0],1'b0};
					   cursorx<=io_data_in[5:0];
					end					
				end
				'hd3:	begin			//set tile y element of address
				    if (vid_mode==2)
					begin
					   tilemap0_address_write<=(80*io_data_in[5:0]) + cursorx;
					   tilemap1_address_write<=(80*io_data_in[5:0]) + cursorx;
					   cursory<=io_data_in[5:0];
					end else
					begin
					   if (selected_tilemap) tilemap1_address_write[12:7]<=io_data_in[5:0]; else tilemap0_address_write[12:7]<=io_data_in[5:0];
					   cursory<=io_data_in[5:0];
					end
				end
				'hd2: begin
				    bgbyte<=io_data_in;
				end
				'hd1:	begin			//decrease tile address by 1
					if (vid_mode==2)
					begin
					    tilemap0_address_write<=tilemap0_address_write-1;
					    tilemap1_address_write<=tilemap1_address_write-1;
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write<=tilemap1_address_write-1; else tilemap0_address_write<=tilemap0_address_write-1;
					end
					if (cursorx==0)
					begin
					   cursorx<=79;
					   //if (cursory==0) cursory<=59; else cursory<=cursory-1;
					   cursory<=cursory-1;
					end else cursorx<=cursorx-1;
				end
				'hd0:	begin			//decrease tile address by 64 or 80 sepending on screen mode
					if (vid_mode==2)
					begin
					   if (cursory==0)
					   begin
					       tilemap0_address_write<=63*80;
					       tilemap1_address_write<=63*80;
					   end
					   else
					   begin
					       tilemap0_address_write<=tilemap0_address_write-80;
					       tilemap1_address_write<=tilemap1_address_write-80;
					   end
					   
					end
					else
					begin
					   if (selected_tilemap) tilemap1_address_write<=tilemap1_address_write-64*2; else tilemap0_address_write<=tilemap0_address_write-64*2;
					end
					//if (cursory==0) cursory<=59; else cursory<=cursory-1;
					cursory<=cursory-1;
				end
				
				'hcf:	begin			//dec x scroll
				   if (vid_mode==1)
				   begin
				       h_scroll_pos<=h_scroll_pos-1;
				       if (h_scroll_pos==320) h_scroll_pos<=0;
				   end
				   else
				   begin
  				      if (selected_tilemap)
				      begin
    					   h_scroll_pos2_latch<=h_scroll_pos2_latch-1;  
				      end
				      else
				      begin
  					      h_scroll_pos_latch<=h_scroll_pos_latch-1;					   
				      end
				  end	
				end
				
				'hce:	begin			//inc x scroll
				   if (vid_mode==1)
				   begin
				       h_scroll_pos<=h_scroll_pos+1;
				       if (h_scroll_pos>319) h_scroll_pos<=319;
				   end
				   else
				   begin
  				      if (selected_tilemap)
				      begin
    					   h_scroll_pos2_latch<=h_scroll_pos2_latch+1;  
				      end
				      else
				      begin
  					      h_scroll_pos_latch<=h_scroll_pos_latch+1;					   
				      end
				  end
				end
				
				'hcd:	begin			//dec y scroll
				   if (vid_mode==1)
				   begin
				       v_scroll_pos<=v_scroll_pos-1;
				       if (v_scroll_pos>239) v_scroll_pos<=239;
				   end
				   else
				   begin
  				      if (selected_tilemap)
				      begin
    					   v_scroll_pos2<=v_scroll_pos2-1;  
    					   //v_scroll_pos2_latch<=v_scroll_pos2_latch-1;
				      end
				      else
				      begin
				          v_scroll_pos<=v_scroll_pos-1;
  					      //v_scroll_pos_latch<=v_scroll_pos_latch-1;					   
				      end
				  end	
				end
				
				'hcc:	begin			//inc y scroll
				   if (vid_mode==1)
				   begin
				       v_scroll_pos<=v_scroll_pos+1;
				       if (v_scroll_pos>239) v_scroll_pos<=239;
				   end
				   else
				   begin
  				      if (selected_tilemap)
				      begin
    					   v_scroll_pos2<=v_scroll_pos2+1;  
    					   //v_scroll_pos2_latch<=v_scroll_pos2_latch+1;
				      end
				      else
				      begin
  					      v_scroll_pos<=v_scroll_pos+1;					   
  					      //v_scroll_pos_latch<=v_scroll_pos_latch+1;
				      end
				  end	
				end
				
				'hcb:	begin			//set high byte (bit) h scroll
					if (selected_tilemap) h_scroll_pos2_latch[8:8]<=io_data_in[0:0]; else h_scroll_pos_latch[8:8]<=io_data_in[0:0];
					if ((vid_mode==1) && (h_scroll_pos_latch>319)) h_scroll_pos_latch<=319;	
				end
				
				'hca:	begin			//set low byte h scroll
					if (selected_tilemap) h_scroll_pos2_latch[7:0]<=io_data_in[7:0]; else h_scroll_pos_latch[7:0]<=io_data_in[7:0];
					if ((vid_mode==1) && (h_scroll_pos_latch>319)) h_scroll_pos_latch<=319;	
				end
				
				'hc9:	begin			//set high byte (bit) v scroll
					if (selected_tilemap) v_scroll_pos2[8:8]<=io_data_in[0:0]; else v_scroll_pos[8:8]<=io_data_in[0:0];
					//if (selected_tilemap) v_scroll_pos2_latch[8:8]<=io_data_in[0:0]; else v_scroll_pos_latch[8:8]<=io_data_in[0:0];
					if ((vid_mode==1) && (v_scroll_pos>239)) v_scroll_pos<=239;	
				end
				
				'hc8:	begin			//set low byte v scroll
				    if (vid_mode==2) v_scroll_pos[8:3]<=io_data_in[5:0];
				    else
				    begin
					   if (selected_tilemap) v_scroll_pos2[7:0]<=io_data_in[7:0]; else v_scroll_pos[7:0]<=io_data_in[7:0];
					   //if (selected_tilemap) v_scroll_pos2_latch[7:0]<=io_data_in[7:0]; else v_scroll_pos_latch[7:0]<=io_data_in[7:0];
					   if ((vid_mode==1) && (v_scroll_pos>239)) v_scroll_pos<=239;
					end	
				end
				
				
				
				'h9f:   begin       //play sample (bits 4 through 7 could be used for looping)
				    if (io_data_in[0])
				    begin
				        sample_playing<=1;
				        sample_read_address_active[0]<=sample_read_address[0];
				        sample_length_active[0]<=sample_length[0];
				        if (io_data_in[4]) sample_loop[0]<=1; else sample_loop[0]<=0;
				    end
				    if (io_data_in[1])
				    begin
				        sample_playing1<=1;
				        sample_read_address_active[1]<=sample_read_address[1];
				        sample_length_active[1]<=sample_length[1];
				        if (io_data_in[5]) sample_loop[1]<=1; else sample_loop[1]<=0;
				    end
				    if (io_data_in[2])
				    begin
				        sample_playing2<=1;
				        sample_read_address_active[2]<=sample_read_address[2];
				        sample_length_active[2]<=sample_length[2];
				        if (io_data_in[6]) sample_loop[2]<=1; else sample_loop[2]<=0;
				    end
				    if (io_data_in[3])
				    begin
				        sample_playing3<=1;
				        sample_read_address_active[3]<=sample_read_address[3];
				        sample_length_active[3]<=sample_length[3];
				        if (io_data_in[7]) sample_loop[3]<=1; else sample_loop[3]<=0;
				    end
				end
				
				'h9e:    begin      //set high byte - sample length
				    sample_length [sample_ptr] [15:8]<=io_data_in;
				end
				
				'h9d:    begin      //set low byte - sample length
				    sample_length [sample_ptr] [7:0]<=io_data_in;
				end
				
				
				
				'h9c:   begin       //write sample data to memory
				    v_data_out<=io_data_in;
					sample_write_wait<=1;
					contention_flag<=1;
				end
				
				'h9b:   begin       //stop sample 
				    if (io_data_in[0])
				    begin
				        sample_playing<=0;				        
				    end
				    if (io_data_in[1])
				    begin
				        sample_playing1<=0;
				    end
				    if (io_data_in[2])
				    begin
				        sample_playing2<=0;
				    end
				    if (io_data_in[3])
				    begin
				        sample_playing3<=0;				        
				    end
				    
				end
				
				'h9a:   begin       //increase sample address
				    sample_write_address<=sample_write_address+1;
				end
				
				'h99:	begin			//set high byte sample write
					sample_write_address[15:8]<=io_data_in[7:0];	
				end
				
				'h98:	begin			//set low byte sample write
					sample_write_address[7:0]<=io_data_in[7:0];	
				end
				
				'h97:	begin			//set high byte sample read
					sample_read_address [sample_ptr] [15:8]<=io_data_in[7:0];	
				end
										
				'h96:	begin			//set low byte sample read
					sample_read_address [sample_ptr] [7:0]<=io_data_in[7:0];	
				end
				
				'h95:   begin
				    sample_write_address<=0;
				end
				
				'h94:   begin           //set sample frequency  0=31500 1=15,750 2=7,875 3=3,937
				    case (io_data_in[1:0])
				        'h0: begin          //uses 16 bit rotating shift register to only update sample when
				            sample_freq [sample_ptr]<=16'b1010101010101010;  //a 1 is in the least significant bit
				         end
				         'h1: begin
				            sample_freq [sample_ptr]<=16'b1000100010001000;
				         end
				         'h2: begin
				            sample_freq [sample_ptr]<=16'b1000000010000000;
				         end
				         'h3: begin
				            sample_freq [sample_ptr]<=16'b1000000000000000;
				         end
				    endcase
				    
				end
				
				'h93:   begin
				    sample_freq [sample_ptr] [15:8]<=io_data_in;
				end
				
				'h92:   begin
				    sample_freq [sample_ptr] [7:0]<=io_data_in;
				end
				
				'h91:   begin
				    //sample_volume [sample_ptr] <={5'b00000,io_data_in[2:0]};
				    sample_volume [sample_ptr] <=io_data_in;
				end
				
				'h90:   begin
				    sample_ptr<=io_data_in[1:0];
				end
				
				'h8f: begin             //latch high byte of palette entry
				    p_data_out[15:8]<=io_data_in;
				end
				'h8e: begin             //latch low byte of palette entry
				    p_data_out[7:0]<=io_data_in;
				end				
				'h8d: begin
				    p_address_write<=io_data_in;  //set palette entry to write to
				end
				'h8c: begin
				    p_wren<=1;  //write entry
				    //if (p_address_write==foregroundmask_index) foregroundmask_colour<=p_data_out;
				end
				'h8b: begin                     //set foreground transparency index
				    //pal_read_wait<=1;
				    //pal_read_latch<=io_data_in;
				    foregroundmask_index<=io_data_in;
				end
				
				
				'h28:	begin			//set video mode
					vid_mode<=io_data_in[1:0];
					if (io_data_in[1:0]==2) foreground_enable<=0;
				end
				
				'h27:	begin			//enable the foreground layer
					if ((vid_mode==0) || (vid_mode==3)) foreground_enable<=io_data_in[0:0]; else foreground_enable<=0; 
				end
			endcase
			
		end
	end //else io_ack<=0;
	

    if (io_out==0)
    begin
        if ((io_ack==0) && (contention_flag==0)); //have we already acknowledged it?
		begin
			io_ack<=1;	//acknowledge it
            case (io_addr_in[7:0])
                 'hdf:  begin
                    io_latch<={7'b0,selected_tilemap};
                    io_data_out<={7'b0,selected_tilemap};
                 end
		         'hdc:	begin              //get tile number at current cursor 			
		             if (selected_tilemap)
		             begin
			             io_data_out<=tile1_latch;
			             io_latch<=tile1_latch;
			         end
			         else
			         begin
			             io_data_out<=tile0_latch;
			             io_latch<=tile0_latch;
			         end
			         
			     end
			     'hd4:   begin
			         io_latch<=cursorx;
			         io_data_out<=cursorx;
			     end
			     'hd3:   begin
			         io_latch<=cursory;
			         io_data_out<=cursory;
			     end
		   endcase
		end
		
		io_data_out[7:0]<=io_latch[7:0];
    end
    else io_data_out<=8'bZ;
    
    if ((io_in) && (io_out)) io_ack<=0;

if (vid_mode==0)                // **** tile mapper mode ****
begin
    if (cpu_wait)
    begin
	   mem_can_write<=1;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=1;
	end
	else
	begin
	   mem_can_write<=0;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=0;
	end
	   
	
	if ((write_wait==0) && (tile_gfx_write_wait==0) && (write_latched==0) && (sample_write_wait==0))
	begin
	  write_latched<=1;
	  contention_flag<=0;
	  vid_we<=1;
	end
	
	if ((ByteRead==0) && (ByteRead2==0))   //Manage Video Ram Contention prior to screen drawing
	begin
	   if ((CounterX>=780-8) && (CounterY<480) && (contention_flag)) cpu_wait<=0; else cpu_wait<=1;	
	end
	
	


	if (ByteRead==0)
	begin	
			if ((CounterX==780-8) && (CounterY<480)) //We need to pre-load first character byte
			begin
				tilemap0_address_read<=base_char_address[11:0];
				tile0_addr_read_latch<=base_char_address[11:0];
			end
			
			if ((CounterX==780-6) && (CounterY<480)) //We need to pre-load first character byte
			begin								
				if (scanlines) v_address<={tilemap0_data_in[10:0],tile_count_v,3'b000};
				tilemap0_data_latch<=tilemap0_data_in[11:0];
//				tilemap0_pal_latch<=tilemap0_data_in[15:12];
			end
			if (CounterX==780-5)// && (CounterY<480)) 
			begin
			     tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];			             
			end
			if (CounterX>=780-3) //&& (CounterY<480)) 
			begin
			     if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
			end
			if (scanlines) ls_address<=0; else ls_address<=1;
			v_data<=0;  //clear v_data to zero outside of display
			tile_count_h<=1;			
			if ((CounterX<780-8) || ((CounterY>=480) && (CounterY<=521)))
			begin
			   //v_data <= 0;  //clear v_data to zero outside of display
			   tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];
	           if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	        end
			
			if ((CounterX==780-9) && (scanlines))
			begin
		      h_scroll_pos<=h_scroll_pos_latch;
		      h_read_offset<=(372+24)-h_scroll_pos_latch[2:0];  //this controls the timing for h scroll
		      h_char_counter<=(h_scroll_pos_latch[8:3]);		      
		      base_char_address[11:0]<=((v_scroll_pos[8:3]+tile_row)<<6)+h_scroll_pos_latch[8:3];     		      
		    end
	end
	
	if (ByteRead2==0)
	begin
			if ((CounterX==780-4) && ((CounterY<480) || (CounterY>521))) //We need to pre-load first character byte
			begin
				tilemap1_address_read<=base_char_address2[11:0];
				tile1_addr_read_latch<=base_char_address2[11:0];
			end
			
			if ((CounterX==780-2) && ((CounterY<480) || (CounterY>521))) //We need to pre-load first character byte
			begin
				if (scanlines==0) v_address<={tilemap1_data_in[10:0],tile_count_v2,3'b000};
				tilemap1_data_latch<=tilemap1_data_in[11:0];
			end
			if (CounterX==780-1) 
			begin
			     tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];			             
			     //p_address_read[7:0]<={tilemap0_data_in[15:12],v_data_in[7:4]};
			end
			
			if (CounterX>=780) 
			begin
			     if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			end
			ls_address2<=0;
			if (scanlines) ls_address3<=0; else ls_address3<=1;
			v_data2 <= 0;  //clear v_data to zero outside of display
			tile_count_h2<=1;			
			if ((CounterX<780-4) || ((CounterY>=480) && (CounterY<=521)))
			begin
			   tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
	        end
			
			if ((CounterX==780-9) && (scanlines))
			begin
		      h_scroll_pos2<=h_scroll_pos2_latch;
		      h_read_offset2<=(371+24)-h_scroll_pos2_latch[2:0];  //this controls the timing for h scroll
		      h_char_counter2<=(h_scroll_pos2_latch[8:3]);		      
		      base_char_address2[11:0]<=((v_scroll_pos2[8:3]+tile_row2)<<6)+h_scroll_pos2_latch[8:3];     		      
		    end
	end
	
    if (vga_v_sync==0)
	begin
		ls_address <= 0;
		ls_address2 <= 0;
		tile_count_h<=0;
		tile_count_h2<=0;

		tile_count_v<=v_scroll_pos[2:0];
		tile_count_v2<=v_scroll_pos2[2:0];
		
		tile_row<=0;
		tile_row2<=0;
		
		base_char_address[11:0]<={v_scroll_pos[8:3],h_scroll_pos_latch[8:3]};
		base_char_address2[11:0]<={v_scroll_pos2[8:3],h_scroll_pos2_latch[8:3]};
	end
	
		if (scanlines==1)
		begin
			if (ByteRead)
			begin
			    if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			    if (ByteDelay==0)
			    begin			        			        
			        ls_wren<=0;
			        if (tile_count_h==0)
					begin
                        if (h_char_counter==63)
                        begin
                            tile0_addr_read_latch<=tile0_addr_read_latch-63;
                            tilemap0_address_read<=tile0_addr_read_latch-63;
                            h_char_counter<=0;
                        end
                        else
                        begin
                            tile0_addr_read_latch<=tile0_addr_read_latch+1;
                            tilemap0_address_read<=tile0_addr_read_latch+1;
                            h_char_counter<=h_char_counter+1;
                        end                         
					end
					else tilemap0_address_read<=tilemap0_address_write[12:1];
					
					
			    end  
			    
			    if( ByteDelay==1)
			    begin
			        ls_address<=ls_address+1;			    
			        p_address_read[7:0]<=v_data_in[7:0];
			    end
			    
			    if (ByteDelay==2)
			    begin
			    end
			    
			    if (ByteDelay==3)
			    begin
			        v_data[11:0]<=p_data_in[11:0];	//copy latched byte video out
			        ls_data_out[11:0]<=p_data_in[11:0];	//copy latched byte video out
			        ls_wren<=1;
			        
			        tile_count_h<=tile_count_h+1;
			        if (tile_count_h==0)
			        begin
			            tilemap0_data_latch<=tilemap0_data_in[11:0];
				        v_address<={tilemap0_data_in[10:0],tile_count_v,3'b000};
				        				        
				    end
				    else
				    begin
				        v_address<={tilemap0_data_latch[10:0],tile_count_v,tile_count_h};
				        if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
				    end
					
					if (ByteWrapCounter==639+20)
					begin
						tile_count_v<=tile_count_v+1;
						if (tile_count_v==7) tile_row<=tile_row+1;
					end
			    end	
			end
			
			
			if (ByteRead2)
			begin		   
			    if (ByteDelay2==0)
			    begin
			       tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			    end  
			    
			    if( ByteDelay2==1)
			    begin
			        ls_address2<=ls_address2+1;
			        ls_address3<=ls_address3+1;
			        tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			    end
			    
			    if (ByteDelay2==2)
			    begin	               
			       tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			    end
			    
			    if (ByteDelay2==3)
			    begin
					v_data2[11:0]<=ls_data_in2[11:0];//0;//fglatch;	
					foregroundmask<=ls_data_in3;
		            tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	            if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			    end
			end
		end
		if (scanlines==0)
		begin
			if (ByteRead) 
			begin	
			    if (ByteDelay==0)
			    begin
			        tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
			    end 
			    if (ByteDelay==1)
			    begin
			        ls_address<=ls_address+1;
			        tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
			       
			    end
				if (ByteDelay==2) //On clock 2/4 read the palette entry into the video_data byte (fed to the rgb module)
				begin
				    tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
				end
				if (ByteDelay==3) //On clock 3/4 update addresses 
				begin
				    v_data[11:0]<=ls_data_in[11:0];//0;//fglatch;				    
				    tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
				end
				
			end
			if (ByteRead2) 
			begin
			   if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			    if (ByteDelay2==0)
			    begin
			        ls_wren2<=0;
			        ls_wren3<=0;
			        fglatch<=ls_data_in2[11:0];
			        foregroundmask_latch<=ls_data_in3;

			        if (tile_count_h2==0)
					begin
                        if (h_char_counter2==63)
                        begin
                          //  tilemap0_address_read<=tilemap0_address_read-63;
                            tile1_addr_read_latch<=tile1_addr_read_latch-63;
                            tilemap1_address_read<=tile1_addr_read_latch-63;
                            h_char_counter2<=0;
                        end
                        else
                        begin
                          //  tilemap1_address_read<=tilemap1_address_read+1;
                            tile1_addr_read_latch<=tile1_addr_read_latch+1;
                            tilemap1_address_read<=tile1_addr_read_latch+1;
                            h_char_counter2<=h_char_counter2+1;
                        end                         
					end
					else tilemap1_address_read<=tilemap1_address_write[12:1];
			        
			    end 
			    if (ByteDelay2==1)
			    begin
			        ls_address2<=ls_address2+1;
			        p_address_read[7:0]<=v_data_in[7:0];
			    end
				if (ByteDelay2==2) //On clock 2/4 read the palette entry into the video_data byte (fed to the rgb module)
				begin
			        ls_wren3<=1;
				end
				if (ByteDelay2==3) //On clock 3/4 update addresses 
				begin
			        if (p_address_read[7:0]==foregroundmask_index[7:0])   
			        begin
			             ls_data_out3<=1;
			        end
			        else
			        begin
			             ls_data_out3<=0;
			        end
			        ls_address3<=ls_address3+1;			        
			        ls_data_out2[11:0]<=p_data_in[11:0];	//copy latched byte video out
			        ls_wren2<=1;
			        ls_wren3<=0;
			        v_data2[11:0]<=fglatch;
			        foregroundmask<=foregroundmask_latch;
			        
			        tile_count_h2<=tile_count_h2+1;
			        if (tile_count_h2==0)
			        begin
			            tilemap1_data_latch<=tilemap1_data_in[11:0];
				        v_address<={tilemap1_data_in[10:0],tile_count_v2,3'b000};
				    end
				    else
				    begin
				        v_address<={tilemap1_data_latch[10:0],tile_count_v2,tile_count_h2};
				        //tilemap0_address_read<=tilemap0_address_write[12:1];
				        if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
				    end
					
					if (ByteWrapCounter2==639+20)
					begin
						tile_count_v2<=tile_count_v2+1;
						//if (tile_count_v2==7) base_char_address2[11:0]<=base_char_address2[11:0]+64;
						if (tile_count_v2==7) tile_row2<=tile_row2+1;
					end

				end
			end
		end

	if ((mem_can_latch) && (write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=gfx_space_address;
		vid_we<=0;
		write_wait<=0;
	end 
	
	if ((mem_can_latch) && (tile_gfx_write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=tile_address;//+TILEGFX_OFFSET;
		vid_we<=0;
		tile_gfx_write_wait<=0;
	end

	if ((mem_can_latch) && (sample_write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=sample_write_address+65536;
		vid_we<=0;
		sample_write_wait<=0;
	end
	
end


if (vid_mode==1)
begin

    if (cpu_wait)
    begin
	   mem_can_write<=1;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=1;
	end
	else
	begin
	   mem_can_write<=0;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=0;
	end
	   
	
	//if ((write_wait==0) && (tile_write_wait==0) && (tile_gfx_write_wait==0) && (write_latched==0) && (tile_read_wait==0))
	if ((write_wait==0) && (tile_write_wait==0) && (tile_col_write_wait==0) && (tile_gfx_write_wait==0) && (write_latched==0) && (sample_write_wait==0))
	//if ((write_wait==0) && (tile_write_wait==0) && (tile_col_write_wait==0) && (tile_gfx_write_wait==0) && (write_latched==0) && (tile_read_wait==0))
	begin
	  // if (read_delay==0) write_latched<=1; else read_delay<=read_delay+1;
	  write_latched<=1;
	  contention_flag<=0;
	end
	
	
	

		
	if (vga_v_sync==0)
		begin

		    h_scroll_pos<=h_scroll_pos_latch;
			ls_address <= 0;
			n_address <= 0;
			v_address <= n_address+h_scroll_pos+(v_scroll_pos * 320);
			//if (scanlines) ls_address<=1; else ls_address<=0;
			//latched_address<=41;
		//	v_data_out<=write_data;
			//if ((CounterX>0) && (CounterX<50))  //temp scroll code for testing, can be removed in final build
			//	begin
				//	vid_we<=0;
	//				if (CounterX==1)
	//				begin
	//					h_scroll_pos <= h_scroll_pos +1;
	//					if (h_scroll_pos==320) h_scroll_pos <= 0;
	//					v_scroll_pos <= v_scroll_pos +1;
	//					if (v_scroll_pos==240) v_scroll_pos <= 0;
	//				end
		//		end
		//	else vid_we<=1;
		end
	else	
		if (ByteRead)
			begin
				//vid_we<=1;
				if(ByteDelay==0) //on clock 1/4 get data byte from memory
					begin
						if (scanlines==1) //only read new data from memory if on odd scanline (1st scanline is odd)
							begin
//								mem_can_write<=0;	//flag that we cannot write to memory on this clock
//								mem_can_latch<=0;
//								cpu_wait<=0;
								//if (v_data_in==224) p_address[7:0]<=v_data_in[7:0]; else p_address[7:0]<=255;	//read byte into palette address
								//if (v_data_in==224) ls_data_out[7:0]<=v_data_in[7:0]; else ls_data_out[7:0]<=255;//v_data_in[7:0]; //also store in temp internal memory (to copy to even scanline)
								p_address_read[7:0]<=v_data_in[7:0];	//read byte into palette address
								ls_data_out[7:0]<=v_data_in[7:0];//v_data_in[7:0]; //also store in temp internal memory (to copy to even scanline)
								ls_wren<=1;								//set internal memory write register
							//	v_temp_addr<=v_address;				//back up current video read address
							//	v_address<=1;
							end
						else
						    begin
								if (ls_address>1) p_address_read[7:0]<=ls_data_in[7:0]; //if even scanline read the data byte from internal temp memory
							end								
					end  //end clock 1/4
					//else
					//begin
					//	if (write_wait)
					//	begin
					//		vid_we<=0;
					//		write_wait<=0;
					//	end else vid_we<=1;
					//end
				if (ByteDelay==1) //On clock 2/4 read the palette entry into the video_data byte (fed to the rgb module)
					begin
					
					  ls_wren<=0; //turn off the internal memory write reg (as it is written to on clock 1)
					  v_data[11:0]<=p_data_in[11:0]; //take the 12 lsb from palette into the v_data reg (we only have 12 bit colour)
																//we waste a nibble for each colour but maybe we can use that in future, eg inverse flag
																
					//	if ((scanlines==1) && (write_wait)) //do we need to write any data to memory
					//	begin
							//v_address<=1;//latched_address;
							//v_data_out<=224;//write_data;
							//vid_we<=0;	//write data to mem
					//	end
					end
				if (ByteDelay==2) //clock 3/4, we increase all the relevant addresses
					begin
					    //ls_wren<=0;
						//if (scanlines) ls_wren<=1;
						ls_address<=ls_address+1; 
						if (scanlines==1) //for odd scanlines
						begin
							if (ByteWrapCounter<640) n_address <= n_address +1; //increase base mem pointer until we wrap after 640 clocks, 320 pixels
							if (ByteWrapCounter[10:1]==ByteWrapMax[10:1]) v_address <= v_address-320; else	v_address <= v_address +1;  //wrap virtual address after 320 pixel for wrap around scrolling
							//if (ByteWrapCounter[10:1]==ByteWrapMax[10:1]) v_temp_addr <= v_temp_addr-320; else	v_temp_addr <= v_temp_addr +1;  //wrap virtual address after 320 pixel for wrap around scrolling
							
							//v_data_out<=v_data_out+3;
							//if (temp_counter==0) vid_we<=0;
							//vid_we<=0
							
						end
						else
						begin
	//						mem_can_latch<=0;
	//						cpu_wait<=0;
						end
					end
				if (ByteDelay==3)
				begin
				    //ls_wren<=0;
				    //ls_address<=ls_address+1;
					if (scanlines==0)
					begin
				//		vid_we<=1;	//turn off write to mem
				//		v_address<=v_temp_addr;
				//	end
//						mem_can_write<=0;
//						mem_can_latch<=0;
//						cpu_wait<=0;
					end
				end
			end
		else
			begin            //ByteRead==0
				v_data <= 0;  //clear v_data to zero outside of display
				//p_address_read[7:0]<=0;
				if (CounterX==VID1POS-4)
        	    begin
	               //if (scanlines) ls_address<=1; else ls_address<=0; //as we read 1 byte ahead we need to offset temp memory address when writing the data
	               ls_address<=0; //as we read 1 byte ahead we need to offset temp memory address when writing the data
	            end
	            if (CounterX==VID1POS-3)
	            begin
	               if (scanlines==0) p_address_read[7:0]<=ls_data_in[7:0]; else p_address_read[7:0]<=0;
	            end
	            if (CounterX==VID1POS-2)
	            begin
	               if (scanlines==0) ls_address<=1; //as we read 1 byte ahead we need to offset temp memory address when writing the data
	            end

				
				v_address<=n_address+h_scroll_pos+(v_scroll_pos * 320);  //reset virtual address as offset of base address
				if (CounterX==VID1POS-5) h_scroll_pos<=h_scroll_pos_latch;
			end
					

	
	
	
	if ((mem_can_write) && ((write_wait) || (tile_write_wait) || (tile_gfx_write_wait) || (sample_write_wait)) && (write_latched==0))
	//if ((mem_can_write) && ((write_wait) || (tile_write_wait) || (tile_gfx_write_wait) ) && (write_latched==0))
	begin
		vid_we<=0;
		write_wait<=0;
		tile_write_wait<=0;
		tile_gfx_write_wait<=0;
		sample_write_wait<=0;
		//read_delay<=1;
	end else vid_we<=1;
	
	
	
	if ((mem_can_latch) && (write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=gfx_space_address;
		//read_delay<=3;
	end 
	
	
	
	if ((mem_can_latch) && (sample_write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=sample_write_address+65536;
		//read_delay<=3;
	end
	
	
	
end


//******************  VIDEO MODE 2 *************************
if (vid_mode==2)
begin
    if (cpu_wait)//(contention_flag==0)
    begin
	   mem_can_write<=1;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=1;
	end
	else
	begin
	   mem_can_write<=0;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=0;
	end
	   
	
	if ((write_wait==0) && (tile_write_wait==0) && (tile_col_write_wait==0) && (tile_gfx_write_wait==0) && (write_latched==0) && (sample_write_wait==0))
	begin
	  write_latched<=1;
	  contention_flag<=0;
	  vid_we<=1;
	end
	
	
	/*if ((ByteRead==0) && (ByteRead2==0))   //Manage Video Ram Contention prior to screen drawing
	begin
	   if ((CounterX>=VID2POS-5) && (CounterY<480) && (contention_flag)) cpu_wait<=0; else cpu_wait<=1;
	end*/


	if (ByteRead==0)
	begin
	   if ((CounterX<VID2POS-8) || (CounterY>=480))
	   begin
	       tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];          //this allows us to read the current 'write' address when
	       tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];      //there is no screen drawing so that we can service a getchar IO req
	       if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	       if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
	       
	   end
	
	    if ((CounterX==VID2POS-5) && (CounterY<480)) //We need to pre-load first character byte	
		begin
			tilemap0_address_read[11:0]<=base_char_address[12:1];
			tilemap1_address_read[11:0]<=base_char_address[12:1];
			p_address_read<=bgbyte;
		end
		if ((CounterX==VID2POS-3) && (CounterY<480)) //We need to pre-load first character byte
		begin
			if (base_char_address[0]) character_rom_address<={tilemap0_data_in[15:8],tile_count_v}; else character_rom_address<={tilemap0_data_in[7:0],tile_count_v};  //read byte from char rom pointed to by video_address + display row (0 to 7) of character
			                                                  //char rom is 11 bits (8 bits for character + 3 bits for display row)
			bglatch<=p_data_in[11:0];
			background_colour<=p_data_in[11:0];
		end
		if ((CounterX==VID2POS-2) && (CounterY<480)) //We need to pre-load first character byte
		begin
			if (base_char_address[0]) p_address_read<=tilemap1_data_in[15:8]; else p_address_read<=tilemap1_data_in[7:0];
			character<=character_rom_in;
		end
		if ((CounterX==VID2POS-1) && (CounterY<480)) //We need to pre-load first character byte
		begin
			foreground_colour<=p_data_in[11:0];
			fglatch<=p_data_in[11:0];
			
			vid2_char_address<=base_char_address+1;
		    tile_count_h<=0;
		end
	end
	
    if (CounterY==521)//(vga_v_sync==0)
	begin
		tile_count_h<=0;
		tile_count_v<=0;
		base_char_address<=v_scroll_pos[8:3]*80;
		vid2_char_address<=v_scroll_pos[8:3]*80;
		h_char_counter<=0;
	end
		
	if (ByteRead)
	begin	
		if(ByteDelay[0:0]==1'b0) //on clock 1/4 get data byte from memory
			begin
	           v_data<=character[7]?foreground_colour:background_colour;
	           character<={character[6:0],1'b0};
			   if (tile_count_h==7)
			   begin
				  foreground_colour<=fglatch;
				  background_colour<=bglatch;
				  character<=character_latch;
				  if (vid2_char_address==5119) vid2_char_address<=0; else vid2_char_address<=vid2_char_address+1;
			   end
	       	end
					
			if (ByteDelay[0:0]==1'b1) //On clock 2/4 read the palette entry into the video_data byte (fed to the rgb module)
		 	begin
				case (tile_count_h)
			        0: begin
					   tilemap0_address_read[11:0]<=vid2_char_address[12:1];
					   tilemap1_address_read[11:0]<=vid2_char_address[12:1];
					   p_address_read<=bgbyte;
				    end
				    2: begin
				        if (vid2_char_address[0]) character_rom_address<={tilemap0_data_in[15:8],tile_count_v}; else character_rom_address<={tilemap0_data_in[7:0],tile_count_v};
				        //tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];          //this allows us to read the current 'write' address when
	                    //tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];      //there is no screen drawing so that we can service a getchar IO req
				    end
					3: begin
					   bglatch<=p_data_in[11:0];
					   //if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	                   //if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
				    end
				    4: begin
				        character_latch<=character_rom_in;
				        if (vid2_char_address[0]) p_address_read<=tilemap1_data_in[15:8]; else p_address_read<=tilemap1_data_in[7:0];
				        //if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	                    //if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
	                    tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];          //this allows us to read the current 'write' address when
	                    tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];      //there is no screen drawing so that we can service a getchar IO req
				     end
					5: begin
					   if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	                   if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
					end
					6: begin
					   fglatch<=p_data_in[11:0];
					   if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	                   if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
					end
					7: begin
					   if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	                   if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
					end
				endcase
				
				tile_count_h<=tile_count_h+1;

				if (ByteWrapCounter==639)
			    begin
		          tile_count_v<=tile_count_v+1;
			      if (tile_count_v==7)
			      begin
			         if (base_char_address==5040) base_char_address<=0; else base_char_address<=base_char_address+80;// else tile_count_v<=tile_count_v+1;
			      end    
			     end						
			end
		end
	
	if ((mem_can_latch) && (write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=gfx_space_address;
		vid_we<=0;
		write_wait<=0;
	end 
	
	if ((mem_can_latch) && (tile_gfx_write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=tile_address+TILEGFX_OFFSET;
		vid_we<=0;
		tile_gfx_write_wait<=0;
	end
	
	if ((mem_can_latch) && (sample_write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=sample_write_address+65536;
	end
end


//******************  VIDEO MODE 3 *************************
if (vid_mode==3)                // **** 4 bit tile mapper mode ****
begin
    if (cpu_wait)
    begin
	   mem_can_write<=1;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=1;
	end
	else
	begin
	   mem_can_write<=0;	//assume we can write to memory unless we set flag otherwise
	   mem_can_latch<=0;
	end
	   
	
	if ((write_wait==0) && (tile_gfx_write_wait==0) && (write_latched==0) && (sample_write_wait==0))
	begin
	  write_latched<=1;
	  contention_flag<=0;
	  vid_we<=1;
	end
	
	if ((ByteRead==0) && (ByteRead2==0))   //Manage Video Ram Contention prior to screen drawing
	begin
	   if ((CounterX>=780-8) && (CounterY<480) && (contention_flag)) cpu_wait<=0; else cpu_wait<=1;	
	end
	
	


	if (ByteRead==0)
	begin	
			if ((CounterX==780-8) && (CounterY<480)) //We need to pre-load first character byte
			begin
				tilemap0_address_read<=base_char_address[11:0];
				tile0_addr_read_latch<=base_char_address[11:0];
			end
			
			if ((CounterX==780-6) && (CounterY<480)) //We need to pre-load first character byte
			begin								
				if (scanlines) v_address<={tilemap0_data_in[11:0],tile_count_v,2'b00};
				tilemap0_data_latch<=tilemap0_data_in[11:0];
				tilemap0_pal_latch<=tilemap0_data_in[15:12];
			end
			if (CounterX==780-5)// && (CounterY<480)) 
			begin
			     tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];			             
			     //p_address_read[7:0]<={tilemap0_data_in[15:12],v_data_in[7:4]};
			end
			/*if ((CounterX==780-4) && (CounterY<480))
			begin
			     p_address_read<={tilemap0_pal_latch,v_data_in[3:0]};
			end
			if ((CounterX==780-2) && (CounterY<480))
			begin
			     v_data<=p_data_in;
			end*/
			if (CounterX>=780-3) //&& (CounterY<480)) 
			begin
			     if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
			end
			if (scanlines) ls_address<=0; else ls_address<=1;
			v_data<=0;  //clear v_data to zero outside of display
			tile_count_h<=1;			
			if ((CounterX<780-8) || ((CounterY>=480) && (CounterY<=(VID03YPOS-2))))
			begin
			   //v_data <= 0;  //clear v_data to zero outside of display
			   tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];
	           if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
	        end
			
			if ((CounterX==780-9) && (scanlines))
			begin
		      h_scroll_pos<=h_scroll_pos_latch;
		      //v_scroll_pos<=v_scroll_pos_latch;
		      h_read_offset<=(374+24)-h_scroll_pos_latch[2:0];  //this controls the timing for h scroll
		      h_char_counter<=(h_scroll_pos_latch[8:3]);		      
		      base_char_address[11:0]<=((v_scroll_pos[8:3]+tile_row)<<6)+h_scroll_pos_latch[8:3];     		      
		    end
	end
	
	if (ByteRead2==0)
	begin
			if ((CounterX==780-4) && ((CounterY<480) || (CounterY>(VID03YPOS-2)))) //We need to pre-load first character byte
			begin
				tilemap1_address_read<=base_char_address2[11:0];
				tile1_addr_read_latch<=base_char_address2[11:0];
			end
			
			if ((CounterX==780-2) && ((CounterY<480) || (CounterY>(VID03YPOS-2)))) //We need to pre-load first character byte
			begin
				//v_address<={tilemap0_data_in[10:0],tile_count_v,3'b000};				
				if (scanlines==0) v_address<={tilemap1_data_in[11:0],tile_count_v2,2'b00};
				tilemap1_data_latch<=tilemap1_data_in[11:0];
				tilemap1_pal_latch<=tilemap1_data_in[15:12];
			end
			if (CounterX==780-1) 
			begin
			     tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];			             
			     //p_address_read[7:0]<={tilemap0_data_in[15:12],v_data_in[7:4]};
			end
			/*if ((CounterX==780-4) && ((CounterY<480) || (CounterY>521))) //We need to pre-load first character byte
			begin
			     p_address_read<={tilemap1_pal_latch,v_data_in[3:0]};			             			     
			end*/
			
			if (CounterX>=780) 
			begin
			     if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			end
			//if (scanlines) ls_address2<=0; else 
			ls_address2<=0;
			if (scanlines) ls_address3<=0; else ls_address3<=1;
			v_data2 <= 0;  //clear v_data to zero outside of display
			tile_count_h2<=1;			
			if ((CounterX<780-4) || ((CounterY>=480) && (CounterY<=(VID03YPOS-2))))
			begin
			   tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
	        end
			
			if ((CounterX==780-9) && (scanlines))
			begin
		      h_scroll_pos2<=h_scroll_pos2_latch;
		      //v_scroll_pos2<=v_scroll_pos2_latch;
		      h_read_offset2<=(373+24)-h_scroll_pos2_latch[2:0];  //this controls the timing for h scroll
		      h_char_counter2<=(h_scroll_pos2_latch[8:3]);		      
		      base_char_address2[11:0]<=((v_scroll_pos2[8:3]+tile_row2)<<6)+h_scroll_pos2_latch[8:3];     		      
		    end
	end
		
    if (vga_v_sync==0)
	begin
		ls_address <= 0;
		ls_address2 <= 0;
		tile_count_h<=0;
		tile_count_h2<=0;

		//tile_count_v<=v_scroll_pos_latch[2:0];
		tile_count_v<=v_scroll_pos[2:0];
		//tile_count_v2<=v_scroll_pos2_latch[2:0];
		tile_count_v2<=v_scroll_pos2[2:0];
		
		tile_row<=0;
		tile_row2<=0;
		
		base_char_address[11:0]<={v_scroll_pos[8:3],h_scroll_pos_latch[8:3]};
		base_char_address2[11:0]<={v_scroll_pos2[8:3],h_scroll_pos2_latch[8:3]};
	end
	
		if (scanlines==1)
		begin
			if (ByteRead)
			begin
			    if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			    if (ByteDelay==0)
			    begin			        			        
			        ls_wren<=0;
			        if (tile_count_h==0)
					begin
                        if (h_char_counter==63)
                        begin
                            tile0_addr_read_latch<=tile0_addr_read_latch-63;
                            tilemap0_address_read<=tile0_addr_read_latch-63;
                            h_char_counter<=0;
                        end
                        else
                        begin
                            tile0_addr_read_latch<=tile0_addr_read_latch+1;
                            tilemap0_address_read<=tile0_addr_read_latch+1;
                            h_char_counter<=h_char_counter+1;
                        end                         
					end
					else tilemap0_address_read<=tilemap0_address_write[12:1];
					
					
			    end  
			    
			    if( ByteDelay==1)
			    begin
			        ls_address<=ls_address+1;			    
			        if (tile_count_h[0]==0) p_address_read<={tilemap0_pal_latch,v_data_in[3:0]}; else p_address_read<={tilemap0_pal_latch,v_data_in[7:4]};
			    end
			    
			    if (ByteDelay==2)
			    begin
			    end
			    
			    if (ByteDelay==3)
			    begin
			        v_data[11:0]<=p_data_in[11:0];	//copy latched byte video out
			        ls_data_out[11:0]<=p_data_in[11:0];	//copy latched byte video out
			        ls_wren<=1;
			        
			        tile_count_h<=tile_count_h+1;
			        if (tile_count_h==0)
			        begin
			            tilemap0_data_latch<=tilemap0_data_in[11:0];
				        tilemap0_pal_latch<=tilemap0_data_in[15:12];
				        v_address<={tilemap0_data_in[11:0],tile_count_v,2'b00};
				        				        
				    end
				    else
				    begin
				        v_address<={tilemap0_data_latch,tile_count_v,tile_count_h[2:1]};
				        //tilemap0_address_read<=tilemap0_address_write[12:1];
				        if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
				    end
					
					if (ByteWrapCounter==639+20)
					begin
						tile_count_v<=tile_count_v+1;
						if (tile_count_v==7) tile_row<=tile_row+1;
					end
			    end	
			end
			
			
			if (ByteRead2)
			begin		   
			    if (ByteDelay2==0)
			    begin
			       tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			    end  
			    
			    if( ByteDelay2==1)
			    begin
			        ls_address2<=ls_address2+1;
			        ls_address3<=ls_address3+1;
			        tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			    end
			    
			    if (ByteDelay2==2)
			    begin	               
			       tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	           if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
			    end
			    
			    if (ByteDelay2==3)
			    begin
					v_data2[11:0]<=ls_data_in2[11:0];//0;//fglatch;	
					foregroundmask<=ls_data_in3;
		            tilemap1_address_read[11:0]<=tilemap1_address_write[12:1];
    	            if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];			
			    end
			end
		end
		if (scanlines==0)
		begin
			if (ByteRead) 
			begin	
			    if (ByteDelay==0)
			    begin
			        tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
			    end 
			    if (ByteDelay==1)
			    begin
			        ls_address<=ls_address+1;
			        tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
			       
			    end
				if (ByteDelay==2) //On clock 2/4 read the palette entry into the video_data byte (fed to the rgb module)
				begin
				    tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
				end
				if (ByteDelay==3) //On clock 3/4 update addresses 
				begin
				    v_data[11:0]<=ls_data_in[11:0];//0;//fglatch;				    
				    tilemap0_address_read[11:0]<=tilemap0_address_write[12:1];	               
    	            if (tilemap0_address_write[0]) tile0_latch<=tilemap0_data_in[15:8]; else tile0_latch<=tilemap0_data_in[7:0];
				end
				
			end
			if (ByteRead2) 
			begin
			   if (contention_flag) cpu_wait<=0; else cpu_wait<=1;
			    if (ByteDelay2==0)
			    begin
			        ls_wren2<=0;
			        ls_wren3<=0;
			        fglatch<=ls_data_in2[11:0];
			        foregroundmask_latch<=ls_data_in3;
			        
			        if (tile_count_h2==0)
					begin
                        if (h_char_counter2==63)
                        begin
                            tile1_addr_read_latch<=tile1_addr_read_latch-63;
                            tilemap1_address_read<=tile1_addr_read_latch-63;
                            h_char_counter2<=0;
                        end
                        else
                        begin
                            tile1_addr_read_latch<=tile1_addr_read_latch+1;
                            tilemap1_address_read<=tile1_addr_read_latch+1;
                            h_char_counter2<=h_char_counter2+1;
                        end                         
					end
					else tilemap1_address_read<=tilemap1_address_write[12:1];
			        
			    end 
			    if (ByteDelay2==1)
			    begin
			        ls_address2<=ls_address2+1;
			        if (tile_count_h2[0]==0)
			        begin
			             p_address_read<={tilemap1_pal_latch,v_data_in[3:0]};
			        end
			        else
			        begin
			             p_address_read<={tilemap1_pal_latch,v_data_in[7:4]};			             
			        end
			    end
				if (ByteDelay2==2) //On clock 2/4 read the palette entry into the video_data byte (fed to the rgb module)
				begin
				    ls_wren3<=1;
				end
				if (ByteDelay2==3) //On clock 3/4 update addresses 
				begin
				    //cpu_wait<=1;
			        //ls_data_out2[12:0]<={foregroundmask_latch,p_data_in[11:0]};	//copy latched byte video out
			        //if (tile_count_h2[0]==0)
			        //begin
			           if (p_address_read[3:0]==foregroundmask_index[3:0])   //only check 4 LSBs in 4 bit indexed mode
			           begin
			               ls_data_out3<=1;	//copy latched byte video out
			           end
			           else
			           begin
			               ls_data_out3<=0;	//copy latched byte video out
			           end
			        /*end
			        else
			        begin
			           if (p_address_read[7:4]==foregroundmask_index[3:0])   //only check 4 LSBs in 4 bit indexed mode
			           begin
			               ls_data_out3<=1;	//copy latched byte video out
			           end
			           else
			           begin
			               ls_data_out3<=0;	//copy latched byte video out
			           end
			        end*/
			        ls_address3<=ls_address3+1;
			        ls_data_out2[11:0]<=p_data_in[11:0];
			        ls_wren2<=1;
			        ls_wren3<=0;
			        v_data2[11:0]<=fglatch;
			        foregroundmask<=foregroundmask_latch;
			        
			        tile_count_h2<=tile_count_h2+1;
			        if (tile_count_h2==0)
			        begin
			            tilemap1_data_latch<=tilemap1_data_in[11:0];
				        tilemap1_pal_latch<=tilemap1_data_in[15:12];
				        v_address<={tilemap1_data_in[11:0],tile_count_v2,2'b00};
				        //p_address_read[7:4]<=tilemap0_data_in[15:12];
				        				        
				    end
				    else
				    begin
				        v_address<={tilemap1_data_latch,tile_count_v2,tile_count_h2[2:1]};
				        //tilemap0_address_read<=tilemap0_address_write[12:1];
				        if (tilemap1_address_write[0]) tile1_latch<=tilemap1_data_in[15:8]; else tile1_latch<=tilemap1_data_in[7:0];
				    end
					
					if (ByteWrapCounter2==639+20)
					begin
						tile_count_v2<=tile_count_v2+1;
						//if (tile_count_v2==7) base_char_address2[11:0]<=base_char_address2[11:0]+64;
						if (tile_count_v2==7) tile_row2<=tile_row2+1;
					end

				end
			end
		end

	if ((mem_can_latch) && (write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=gfx_space_address;
		vid_we<=0;
		write_wait<=0;
	end 
	
	if ((mem_can_latch) && (tile_gfx_write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=tile_address;//+TILEGFX_OFFSET;
		vid_we<=0;
		tile_gfx_write_wait<=0;
	end

	if ((mem_can_latch) && (sample_write_wait) && (write_latched))
	begin
		write_latched<=0;
		latched_address<=sample_write_address+65536;
		vid_we<=0;
		sample_write_wait<=0;
	end
	
end
end



end
    
endmodule
