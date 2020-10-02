`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.12.2018 17:17:11
// Design Name: 
// Module Name: rom_interface
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

//`define INTERNAL_CPU_RAM

module rom_interface(
    input clk,
    input nReset,
    input [18:0] dma_addr,          //DMA addressing for direct access
    input dma_assert,                //DMA overrides all other addressing
    input [15:0] input_addr,
    //input [7:0] ram_data,
    input [7:0] rom_data,
    input we,
	 input rd,    
    input mem_req,
    input m1,
    input [15:0] io_address_in,
    input [5:0] io_data_in,
    input io_req,
    input nmi_in,
	 
	 
	 
    output reg [18:0] ram_output_addr,
    output reg [13:0] rom_output_addr,
`ifdef INTERNAL_CPU_RAM 
	 input [7:0] data_in,
    output wire [7:0] data_out,
	 output wire [7:0] data_write,
	 output wire we_out,
	 output wire rd_out,    
`else
	input [7:0] cpu_data_in,
	input [7:0] data_from_io,
//	output wire [7:0] data_to_memory,
	output reg [7:0] data_to_io,
	output reg [7:0] cpu_data_out,
	output reg io_low,	
//`ifdef INTERNAL_CPU_RAM 
    output reg we_out,
	 output reg rd_out,    
	 output reg [7:0] data_write,
`endif
/*`else
    output reg we_out,
	 output reg rd_out,    
	 output reg [7:0] data_write,
`endif*/
	 input [7:0] ram_data,
    //inout wire [7:0] sram_data
	 input ram_ready,
	 output reg ram_wait
	 
    );
    
 
 //reg [7:0] data_out;
 //wire [7:0] data_route;
 
 reg romsel;
 reg [5:0] bank0;
 reg [5:0] bank1;
 reg [5:0] bank2;
 reg [5:0] bank3;
 reg [5:0] bank4;
 reg [5:0] bank5;
 reg [5:0] bank6;
 reg [5:0] bank7;
 

 
 reg io_ack;
 
 //reg we_out;
 //assign we_out=((!we) && (!mem_req))?1:0;		
 //assign rd_out=((!rd) && (!mem_req))?1:0;	
 
 
   
 
`ifdef INTERNAL_CPU_RAM 
	   assign data_out=((input_addr<16384) && (romsel))?rom_data:ram_data;
		//assign data_write=data_in;
		assign we_out=~we & ~mem_req;
		assign rd_out=~rd & ~mem_req;
		
`endif
/*`else
		wire data_out=((input_addr<16384) && (romsel))?rom_data:ram_data;
	   //assign data_write=data_in;
		assign we_out=~we & ~mem_req;
		assign rd_out=~rd & ~mem_req;
		
		assign data_write=(~mem_req & ~we & rd)?cpu_data_in:8'bz;
		assign cpu_data_out=(~mem_req & we & ~rd)?data_out:(~io_req & m1 & we & ~rd)?data_from_io:(~io_req & ~m1)?data_from_io:8'bz;
		assign data_to_io=(~io_req & m1 & ~we & rd)?cpu_data_in:8'bz;
		
		assign io_low=(~io_req & m1)?0:1;
		
		
		//assign data_write=8'h9d;//we_out?data_in:8'bZ;		
		//wire [7:0] ram_data=data_write;	//remove if separate input and output RAM ports (eg block RAM) as it will be an input port in module ref above
`endif*/
 

 //assign data_out=input_addr<16384?rom_data:ram_data;
 
	initial 
	   begin
		   rom_output_addr<=0;
			ram_output_addr<=0;
			romsel<=1;           //start with rom banked in
			bank0<=0;
			bank1<=1;
			bank2<=2;
			bank3<=3;
			bank4<=4;
			bank5<=5;
			bank6<=6;
			bank7<=7;
	//		we_out<=0;
	       io_ack<=0;
			 ram_wait<=0;
	  end
	  
    always @(posedge clk or negedge nReset)
    begin
    if (!nReset)
    	   begin
		   rom_output_addr<=0;
			ram_output_addr<=0;
			romsel<=1;           //start with rom banked in
			bank0<=0;
			bank1<=1;
			bank2<=2;
			bank3<=3;
			bank4<=4;
			bank5<=5;
			bank6<=6;
			bank7<=7;
	//		we_out<=0;
	       io_ack<=0;
			 ram_wait<=0;
	  end
	  else
	  begin
	  
		  //if (((rd_out) || (we_out)) && (!ram_ready)) ram_wait<=1; else ram_wait<=0;	//pause CPU if SDRAM not ready
		  ram_wait<=ram_ready;
/*`ifndef INTERNAL_CPU_RAM  
		 we_out<=~we & ~mem_req;
		 rd_out<=~rd & ~mem_req;
		 data_write<=data_in;
		 //data_write<=(~we & ~mem_req)?data_in:8'bZ;		
		  //ram_wait<=0;	//pause CPU if SDRAM not ready
`endif	  */
        if (io_req==0)	//have we had an IO signal
	    begin
	       if (io_ack==0) //have we already acknowledged it?
		   begin
			io_ack<=1;	//acknowledge it
	       case (io_address_in[7:0])
	           'h78:   begin
	               romsel<=io_data_in!=0;
	           end
	           'h77:   begin
	               bank7<=io_data_in;
	           end
	           'h76:   begin
	               bank6<=io_data_in;
	           end
	           'h75:   begin
	               bank5<=io_data_in;
	           end
	           'h74:   begin
	               bank4<=io_data_in;
	           end
	           'h73:   begin
	               bank3<=io_data_in;
	           end
	           'h72:   begin
	               bank2<=io_data_in;
	           end
	           'h71:   begin
	               bank1<=io_data_in;
	           end
	           'h70:   begin
	               bank0<=io_data_in;
	           end
		  endcase
		  end
	    end
	    else io_ack<=0;
    end
end	  
	//always @ (posedge clk)
always_comb begin
      if ((nmi_in==0) && (m1==0)) romsel=1;
       
	  // if (dma_assert)
	 //  begin 
	        casez (input_addr)
	        16'b000?????????????: begin       //0 to 8191
			     //if (romsel) rom_output_addr<=input_addr[13:0]; else 
			     //ram_output_addr<=(bank0 << 13)+input_addr;
			     ram_output_addr={bank0,input_addr[12:0]};
			     rom_output_addr=input_addr[13:0];
			end
			16'b001?????????????: begin       //8192 to 16383
			     //if (romsel) rom_output_addr<=input_addr[13:0]; else 
			     //ram_output_addr<=(bank1 << 13)+(input_addr-8192);
			     ram_output_addr={bank1,input_addr[12:0]};
			     rom_output_addr=input_addr[13:0];
			end
			16'b010?????????????: begin       //16384 to 24575
			     //ram_output_addr<=(bank2 << 13)+(input_addr-16384);
			     ram_output_addr={bank2,input_addr[12:0]};
			end
			16'b011?????????????: begin       //24576 to 32767
			     //ram_output_addr<=(bank3 << 13)+(input_addr-24576);
			     ram_output_addr={bank3,input_addr[12:0]};
			end
			16'b100?????????????: begin       //32768 to 40959
			     //ram_output_addr<=(bank4 << 13)+(input_addr-32768);
			     ram_output_addr={bank4,input_addr[12:0]};
			end
			16'b101?????????????: begin       //40960 to 49151
			     //ram_output_addr<=(bank5 << 13)+(input_addr-40960);
			     ram_output_addr={bank5,input_addr[12:0]};
			end
			16'b110?????????????: begin       //49152 to 57343
			     //ram_output_addr<=(bank6 << 13)+(input_addr-49152);
			     ram_output_addr={bank6,input_addr[12:0]};
			end
			16'b111?????????????: begin       //57344 to 65535
			     //ram_output_addr<=(bank7 << 13)+(input_addr-57344);
			     ram_output_addr={bank7,input_addr[12:0]};
			end
			
			endcase
	//	end
	//	else ram_output_addr=dma_addr;	
		
		
		we_out=~we & ~mem_req;
		rd_out=~rd & ~mem_req;
		
		
		if (!mem_req)
			begin
			     if ((!we) && (rd))
			     begin
			         //cpu_data_in<=data_out_from_device;
			         data_write=cpu_data_in;
			         cpu_data_out=8'bZ;
			         data_to_io=8'bZ;
			     end 
			     if ((we) && (!rd))
			     begin
						if ((input_addr<16384) && (romsel)) cpu_data_out=rom_data; else cpu_data_out=ram_data;
			         //cpu_data_out<=data_from_memory;
			         data_write=8'bZ;
			         data_to_io=8'bZ;
			     end
			     if ((we) && (rd))
			     begin
			         data_write=8'bZ;
			         data_to_io=8'bZ;
			         cpu_data_out=8'bZ;
			     end
			     io_low=1;
			end
			if ((!io_req) && (m1))
			begin
			     if ((!we) && (rd))
			     begin
			         data_to_io=cpu_data_in;
			         cpu_data_out=8'bZ;
			         data_write=8'bZ;
			         io_low=0;
			     end
			     if ((we) && (!rd))
			     begin
			         cpu_data_out=data_from_io;
			         data_write=8'bZ;
			         data_to_io=8'bZ;
			         io_low=0;
			     end
			     if ((we) && (rd))
			     begin
			         data_write=8'bZ;
			         data_to_io=8'bZ;
			         cpu_data_out=8'bZ;
			     end
			     
			end
			if ((!io_req) && (!m1))           //int ackknowledge
			begin
			     data_write=8'bZ;
			     data_to_io=8'bZ;
			     cpu_data_out=data_from_io;
			     io_low=1;
			end
			if ((io_req) && (mem_req)) 
			begin
			     data_write=8'bZ;
			     data_to_io=8'bZ;
			     cpu_data_out=8'bZ;
			     io_low=1;
			end
	end
//end
	   
endmodule
