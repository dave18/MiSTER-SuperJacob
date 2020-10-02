`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.10.2019 17:01:16
// Design Name: 
// Module Name: SpriteDMA
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


module SpriteDMA(
    input wire clk,
    input wire [7:0] normal_spr_data_in,
    input wire [13:0] normal_spr_addr_in,
    input wire normal_spr_we,
    input wire [7:0] attr_spr_data_in,
    input wire [9:0] attr_spr_addr_in,
    input wire attr_spr_we,
    input wire [7:0] cpudata,
    input wire [7:0] io_data_in,
    input wire [15:0] io_addr_in,
	 input wire ram_ready,
    output wire [7:0] sprdata,
    output reg [20:0] cpuaddr,
    output wire [13:0] spraddr,
    output wire spr_we,
    output wire [7:0] sprdata_attr,
    output wire [9:0] spraddr_attr,
    output wire spr_we_attr,
    output reg DMAassert,            //this asserts the DMA address on the RAM
	 output reg DMA_read,
    output reg Z80_clk_ctrl,        //this halt the Z80 while DMA transfer takes place
    input wire ioreq
    );
    
    reg [3:0] state;               //0=idle, 1=halting cpu, 2=transferring data
    //reg [3:0] attr_state;               //0=idle, 1=halting cpu, 2=transferring data
    reg io_ack; 
    reg spr_we_latch;
    reg spr_we_attr_latch;
    
    reg [20:0] cpu_addr_latch;
    reg [13:0] spr_addr_latch;
    reg [13:0] spr_addr_attr_latch;
    reg [14:0] length_latch;
    reg [2:0] timer;            //controls how long certain states are active for
    reg [7:0] cpu_data_latch;
    reg flipflop;
    reg dma_type;
    reg special_mode;  //if set assumes source data is in 8x8 tiles and auto formats!  Good for arcade conversions
    reg [1:0] special_counter_x;
    reg [3:0] special_counter_y;
    reg special_dir;
    
    assign spraddr=((state<2) || (dma_type))?normal_spr_addr_in:spr_addr_latch;
    assign sprdata=((state<2) || (dma_type))?normal_spr_data_in:cpu_data_latch;
    assign spr_we=((state<2) || (dma_type))?normal_spr_we:spr_we_latch;
    
    /*assign spraddr=state<2?normal_spr_addr_in:spr_addr_latch;
    assign sprdata=state<2?normal_spr_data_in:cpu_data_latch;
    assign spr_we=state<2?normal_spr_we:spr_we_latch;*/
    
    assign spraddr_attr=((state<2) || (dma_type==0))?attr_spr_addr_in:spr_addr_attr_latch;
    assign sprdata_attr=((state<2) || (dma_type==0))?attr_spr_data_in:cpu_data_latch;
    assign spr_we_attr=((state<2) || (dma_type==0))?attr_spr_we:spr_we_attr_latch;
    
    /*assign spraddr_attr=attr_spr_addr_in;
    assign sprdata_attr=attr_spr_data_in;
    assign spr_we_attr=attr_spr_we;*/
    
    //assign spraddr=normal_spr_addr_in;
    //assign sprdata=normal_spr_data_in;
    //assign spr_we=normal_spr_we;
	 localparam DELAY_VALUE=1;//1;
    
initial
begin
    DMAassert<=1;
	 DMA_read<=1;
    Z80_clk_ctrl<=1;
    state<=0;
    //attr_state<=0;
    io_ack<=0;
    spr_we_latch<=0;
    spr_we_attr_latch<=0;
    dma_type<=0;            //0=sprite gfx, 1=sprite attr
    special_mode<=0;
end

always @(posedge clk)
begin
    if (ioreq==0)	//have we had an IO signal
	begin
	   if ((io_ack==0) && (state==0)) //have we already acknowledged it?
	   begin
	       io_ack<=1;	//acknowledge it
	       case (io_addr_in[7:0])
	           'h4a:   begin                                   //DMA length low byte + start
	               length_latch[7:0]<=io_data_in[7:0];     
	               //if (dma_type) length_latch[13:10]<=4'b0000;
	               dma_type<=0; 
	               state<=1;                                   //start process
	               Z80_clk_ctrl<=0;                            //by halting the cpu               
	               timer<=4;                                   //for a least 4 master clks before proceeding
	               special_mode<=1;
	               special_counter_x<=0;
	               special_counter_y<=0;
	               special_dir<=1;
	           end
	           'h49:   begin                                   //Spr attr DMA address to 4 bit pattern number
	               spr_addr_latch<=io_data_in[6:0]*128;     
						spr_addr_attr_latch<=io_data_in[6:0]*8;
	           end
	           'h48:   begin                                   //Spr attr DMA address high 2 bits
	               spr_addr_attr_latch[9:8]<=io_data_in[1:0];     
	           end
	           'h47:   begin                                   //Spr attr DMA address low byte
	               spr_addr_attr_latch[7:0]<=io_data_in[7:0];     
	           end
	           'h46:   begin                                   //DMA length high 6 bits
	               length_latch[14:8]<={1'b0,io_data_in[5:0]};
	               dma_type<=io_data_in[7];     
	           end
	           'h45:   begin                                   //DMA length low byte + start
	               length_latch[7:0]<=io_data_in[7:0];     
	               //if (dma_type) length_latch[13:10]<=4'b0000; 
	               if (dma_type) length_latch[13:11]<=3'b000;
	               state<=1;                                   //start process
	               Z80_clk_ctrl<=0;                            //by halting the cpu               
	               timer<=4;                                   //for a least 4 master clks before proceeding
	               special_mode<=0;
	           end
	           'h44:   begin                                   //Spr DMA address high 6 bits
	               spr_addr_latch[13:8]<=io_data_in[5:0];     
	           end
	           'h43:   begin                                   //Spr DMA address low byte
	               spr_addr_latch[7:0]<=io_data_in[7:0];     
	           end
	           'h42:   begin                                   //CPU DMA address high 5 bits
	               cpu_addr_latch[20:16]<=io_data_in[4:0];     
	           end
	           'h41:   begin                                   //CPU DMA address mid byte
	               cpu_addr_latch[15:8]<=io_data_in[7:0];     
	           end
	           'h40:   begin                                   //CPU DMA address low byte
	               cpu_addr_latch[7:0]<=io_data_in[7:0];     
	           end
	       endcase
	   end
    end
    else io_ack<=0;
    
    case (state)
        1: begin              //halting cpu - so we just wait until timer = 0
            timer<=timer-1;
            if (timer==0)
            begin
                state<=2;  //change state to transferring
                DMAassert<=0;      //assert DMA addresses onto bus
                flipflop<=0;
                cpuaddr<=cpu_addr_latch;
                length_latch<=length_latch+1;       //need to add 1 to copy the whole 16k (ie 0 length=1 byte, 3fff = 16384 bytes)
					 DMA_read<=0;
              //  spr_we_latch<=1;
              timer<=1;
            end
        end
        2: begin
			   if (ram_ready)
				begin					
					cpu_data_latch<=cpudata;
					state<=3;
					timer<=DELAY_VALUE;
				end
        end
        3: begin                    //now we transfer the data - 1st clock of 4 retrieve data from cpu
                                    //3rd clock of 4 write it to the sprite ram
            if (timer>0) timer<=timer-1;
            if (timer==0)
            begin
            if (flipflop==0)
            begin
					 if (ram_ready)			//Additional MiSTER check to ensure SDRAM is ready before DMA read
					 begin						
						cpu_data_latch<=cpudata;
						DMA_read<=1;
						if (dma_type) spr_we_attr_latch<=1; else spr_we_latch<=1;
						if (special_mode)
						begin
							if (special_counter_x==3)
							begin
									if (special_counter_y==15)
									begin
										cpuaddr<=cpuaddr+1;
									end                                                   
									else
									begin     
										if (special_dir) cpuaddr<=cpuaddr+'h1d; else cpuaddr<=cpuaddr-'h1f;                                                        
									end
									special_counter_y<=special_counter_y+1;
									special_dir<=~special_dir;                   
							end
							else
							begin
									cpuaddr<=cpuaddr+1;                        
							end
							special_counter_x<=special_counter_x+1;
						end
						else cpuaddr<=cpuaddr+1;
						
						flipflop<=~flipflop;
						timer<=DELAY_VALUE;
					end
				end
            else
            begin
					 DMA_read<=0;
                if (dma_type)
                begin
                    spr_addr_attr_latch<=spr_addr_attr_latch+1;
                    spr_we_attr_latch<=0;
                end
                else
                begin
                    spr_addr_latch<=spr_addr_latch+1;
                    spr_we_latch<=0;
                end
                 
                length_latch<=length_latch-1;
					 flipflop<=~flipflop;
					 timer<=DELAY_VALUE;
            end
            
            
            end
            
            
            //if (length_latch<2)
            //if (length_latch==13'h3fff)
            if (length_latch==0)
            begin
					 DMA_read<=1;
                state<=4;
                timer<=7;
                if (dma_type) spr_we_attr_latch<=0; else spr_we_latch<=0;
            end    
        end
        4: begin              //halting cpu - so we just wait until timer = 0
            if (timer>0) timer<=timer-1;
           DMAassert<=1;      //remove DMA address assert from bus
			  
           if (timer==0)
           begin
              Z80_clk_ctrl<=1;
              state<=0;
           end
        end
        /*default: begin        //State 0 - remove assertion from bus and wait four clks before resuming cpu (maybe 4 is overly safe)           
           DMAassert<=1;      //assert DMA addresses onto bus        
           Z80_clk_ctrl<=1;           
        end*/
    endcase
end    
endmodule
