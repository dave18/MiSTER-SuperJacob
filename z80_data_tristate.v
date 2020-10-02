`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.12.2018 18:21:04
// Design Name: 
// Module Name: z80_data_tristate
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


module z80_data_tristate(
    input clk,
    input mreq,
    input rd,
    input wr,
    input ioreq,
    input m1,
    input [7:0] data_from_memory,
    input [7:0] cpu_data_in,
    output reg [7:0] cpu_data_out,
    output reg [7:0] data_to_memory,
    input [7:0] data_from_io,
    output reg [7:0] data_to_io,
    output reg io_low
    );

    //reg [7:0] cpu_data_in;
    //assign cpu_data_in=((!wr) && (!mreq) && (rd))?data_from_memory:8'bZ;
    //wire cpu_mem=((!wr) && (!mreq) && (rd))?data_from_memory:8'bZ;
    //wire cpu_io=((!wr) && (!ioreq) && (rd))?data_from_io:8'bZ;
    //assign cpu_data_in=(!mreq)?cpu_mem:cpu_io;

    initial
    begin
        io_low<=1;
    end

	always //@ (posedge clk)
	   begin 
			if (!mreq)
			begin
			     if ((!wr) && (rd))
			     begin
			         //cpu_data_in<=data_out_from_device;
			         data_to_memory<=cpu_data_in;
			         cpu_data_out<=8'bZ;
			         data_to_io<=8'bZ;
			     end 
			     if ((wr) && (!rd))
			     begin
			         cpu_data_out<=data_from_memory;
			         data_to_memory<=8'bZ;
			         data_to_io<=8'bZ;
			     end
			     if ((wr) && (rd))
			     begin
			         data_to_memory<=8'bZ;
			         data_to_io<=8'bZ;
			         cpu_data_out<=8'bZ;
			     end
			     io_low<=1;
			end
			if ((!ioreq) && (m1))
			begin
			     if ((!wr) && (rd))
			     begin
			         data_to_io<=cpu_data_in;
			         cpu_data_out<=8'bZ;
			         data_to_memory<=8'bZ;
			         io_low<=0;
			     end
			     if ((wr) && (!rd))
			     begin
			         cpu_data_out<=data_from_io;
			         data_to_memory<=8'bZ;
			         data_to_io<=8'bZ;
			         io_low<=0;
			     end
			     if ((wr) && (rd))
			     begin
			         data_to_memory<=8'bZ;
			         data_to_io<=8'bZ;
			         cpu_data_out<=8'bZ;
			     end
			     
			end
			if ((!ioreq) && (!m1))           //int ackknowledge
			begin
			     data_to_memory<=8'bZ;
			     data_to_io<=8'bZ;
			     cpu_data_out<=data_from_io;
			     io_low<=1;
			end
			if ((ioreq) && (mreq)) 
			begin
			     data_to_memory<=8'bZ;
			     data_to_io<=8'bZ;
			     cpu_data_out<=8'bZ;
			     io_low<=1;
			end
			     
	   end
	   
endmodule
