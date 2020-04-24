`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 14.11.2019 19:02:16
// Design Name: 
// Module Name: keyboard_matrix
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


module keyboard_matrix(
    input wire clk,
    input wire nReset,
    input wire ps2_sig_in,
    input wire e_in,
    input wire f_in,
    input wire [7:0] ps2_code,
    input wire io_req,
    input wire [15:0] io_addr,
    output reg [7:0] io_data_out
    );
    
    reg [7:0] key_status [7:0];
    reg key_ack;
    reg io_ack;
    reg [7:0] latch;
    
    initial
    begin
        key_status [0] <=0;
        key_status [1] <=0;
        key_status [2] <=0;
        key_status [3] <=0;
        key_status [4] <=0;
        key_status [5] <=0;
        key_status [6] <=0;
        key_status [7] <=0;
        key_ack<=0;
        io_ack<=0;
    end 
    
    always @(posedge clk or negedge nReset)
    begin
    if (!nReset)
    begin
        key_status [0] <=0;
        key_status [1] <=0;
        key_status [2] <=0;
        key_status [3] <=0;
        key_status [4] <=0;
        key_status [5] <=0;
        key_status [6] <=0;
        key_status [7] <=0;
        key_ack<=0;
        io_ack<=0;
    end
    else
    begin
    
        if (io_req)
        begin
            if (io_ack==0) //have we already acknowledged it?
		  begin
    			io_ack<=1;	//acknowledge it
                case (io_addr[7:0])		         
	       	    'h17:   begin
			         io_data_out<=key_status[7];
			     end
			     'h16:   begin
			         io_data_out<=key_status[6];
			     end
			     'h15:   begin
			         io_data_out<=key_status[5];
			     end
			     'h14:   begin
			         io_data_out<=key_status[4];
			     end
			     'h13:   begin
			         io_data_out<=key_status[3];
			     end
			     'h12:   begin
			         io_data_out<=key_status[2];
			     end
			     'h11:   begin
			         io_data_out<=key_status[1];
			     end
			     'h10:   begin
			         io_data_out<=key_status[0];
			     end
        	   endcase
        	//   io_data_out<=latch;
		  end
        end
        else
        begin
            io_data_out<=8'bZ;
            io_ack<=0;
        end
    
    
        if (ps2_sig_in)
        begin
            if (key_ack==0)
            begin
                key_ack<=1;
                if (f_in)       //break code
                begin
             //       latch<=ps2_code;
                    //key_status[0]<=0;
                    if (e_in)
                    begin
                        case (ps2_code)
                            'h11: begin
                                key_status[3]<=key_status[3] & 'hfd;
                                //key_status[3]<={key_status[3] [7:2],1'b0,key_status[3] [0]};     //RALT
                            end
                            'h75: begin
                                key_status[5]<=key_status[5] & 'hfd;
                                //key_status[5]<={key_status[5] [7:2],1'b0,key_status[5] [0]};     //UP
                            end
                            'h14: begin
                                key_status[7]<=key_status[7] & 'hef;
                                //key_status[7]<={key_status[7] [7:5],1'b0,key_status[7] [3:0]};     //RCTRL
                            end
                            'h6b: begin
                                key_status[7]<=key_status[7] & 'hfb;
                                //key_status[7]<={key_status[7] [7:3],1'b0,key_status[7] [1:0]};     //LEFT
                            end
                            'h72: begin
                                key_status[7]<=key_status[7] & 'hfd;
                                //key_status[7]<={key_status[7] [7:2],1'b0,key_status[7] [0]};     //DOWN
                            end                            
                            'h74: begin
                                //key_status[7]<=key_status[7] & 'hfe;
                                key_status[7]<={key_status[7] [7:1],1'b0};     //RIGHT
                            end       
                        endcase
                    end
                    else
                    begin
                        case (ps2_code)
                            //*******  Keys Esc, `, 1 ,2, 3, 4, 5, 6
                            'h76: begin
                                key_status[0]<=key_status[0] & 'h7f;
                                //key_status[0]<={1'b0,key_status[0] [6:0]};     //esc
                            end
                            'h0e: begin
                                key_status[0]<=key_status[0] & 'hbf;
                                //key_status[0]<={key_status[0] [7],1'b0,key_status[0] [5:0]};     //`
                            end
                            'h16: begin
                                key_status[0]<=key_status[0] & 'hdf;
                                //key_status[0]<={key_status[0] [7:6],1'b0,key_status[0] [4:0]};     //1
                            end
                            'h1e: begin
                                key_status[0]<=key_status[0] & 'hef;
                                //key_status[0]<={key_status[0] [7:5],1'b0,key_status[0] [3:0]};     //2
                            end
                            'h26: begin
                                key_status[0]<=key_status[0] & 'hf7;
                                //key_status[0]<={key_status[0] [7:4],1'b0,key_status[0] [2:0]};     //3
                            end
                            'h25: begin
                                key_status[0]<=key_status[0] & 'hfb;
                                //key_status[0]<={key_status[0] [7:3],1'b0,key_status[0] [1:0]};     //4
                            end
                            'h2e: begin
                                key_status[0]<=key_status[0] & 'hfd;
                                //key_status[0]<={key_status[0] [7:2],1'b0,key_status[0] [0]};     //5
                            end
                            'h36: begin
                                key_status[0]<=key_status[0] & 'hfe;
                                //key_status[0]<={key_status[0] [7:1],1'b0};     //6
                            end
                            //*******  Keys 7, 8, 9 ,0, -, +, Backspace, F1
                            'h3d: begin
                                key_status[1]<=key_status[1] & 'h7f;
                                //key_status[1]<={1'b0,key_status[1] [6:0]};     //7
                            end
                            'h3e: begin
                                key_status[1]<=key_status[1] & 'hbf;
                                //key_status[1]<={key_status[1] [7],1'b0,key_status[1] [5:0]};     //8
                            end
                            'h46: begin
                                key_status[1]<=key_status[1] & 'hdf;
                                //key_status[1]<={key_status[1] [7:6],1'b0,key_status[1] [4:0]};     //9
                            end
                            'h45: begin
                                key_status[1]<=key_status[1] & 'hef;
                                //key_status[1]<={key_status[1] [7:5],1'b0,key_status[1] [3:0]};     //0
                            end
                            'h4e: begin
                                key_status[1]<=key_status[1] & 'hf7;
                                //key_status[1]<={key_status[1] [7:4],1'b0,key_status[1] [2:0]};     //-
                            end
                            'h55: begin
                                key_status[1]<=key_status[1] & 'hfb;
                                //key_status[1]<={key_status[1] [7:3],1'b0,key_status[1] [1:0]};     //+
                            end
                            'h66: begin
                                key_status[1]<=key_status[1] & 'hfd;
                                //key_status[1]<={key_status[1] [7:2],1'b0,key_status[1] [0]};     //F1
                            end
                            'h05: begin
                                key_status[1]<=key_status[1] & 'hfe;
                                //key_status[1]<={key_status[1] [7:1],1'b0};     //esc
                            end
                            //*******  Keys TAB, Q, W ,E, R, T, Y, U
                            'h0d: begin
                                key_status[2]<=key_status[2] & 'h7f;
                                //key_status[2]<={1'b0,key_status[2] [6:0]};     //TAB
                            end
                            'h15: begin
                                key_status[2]<=key_status[2] & 'hbf;
                                //key_status[2]<={key_status[2] [7],1'b0,key_status[2] [5:0]};     //Q
                            end
                            'h1d: begin
                                key_status[2]<=key_status[2] & 'hdf;
                                //key_status[2]<={key_status[2] [7:6],1'b0,key_status[2] [4:0]};     //W
                            end
                            'h24: begin
                                key_status[2]<=key_status[2] & 'hef;
                                //key_status[2]<={key_status[2] [7:5],1'b0,key_status[2] [3:0]};     //E
                            end
                            'h2d: begin
                                key_status[2]<=key_status[2] & 'hf7;
                                //key_status[2]<={key_status[2] [7:4],1'b0,key_status[2] [2:0]};     //R
                            end
                            'h2c: begin
                                key_status[2]<=key_status[2] & 'hfb;
                                //key_status[2]<={key_status[2] [7:3],1'b0,key_status[2] [1:0]};     //T
                            end
                            'h35: begin
                                key_status[2]<=key_status[2] & 'hfd;
                                //key_status[2]<={key_status[2] [7:2],1'b0,key_status[2] [0]};     //Y
                            end
                            'h3c: begin
                                key_status[2]<=key_status[2] & 'hfe;
                                //key_status[2]<={key_status[2] [7:1],1'b0};     //
                            end
                            //*******  Keys I, O, P ,[, ], LALT, RALT, ENTER
                            'h43: begin
                                key_status[3]<=key_status[3] & 'h7f;
                                //key_status[3]<={1'b0,key_status[3] [6:0]};     //I
                            end
                            'h44: begin
                                key_status[3]<=key_status[3] & 'hbf;
                                //key_status[3]<={key_status[3] [7],1'b0,key_status[3] [5:0]};     //O
                            end
                            'h4d: begin
                                key_status[3]<=key_status[3] & 'hdf;
                                //key_status[3]<={key_status[3] [7:6],1'b0,key_status[3] [4:0]};     //P
                            end
                            'h54: begin
                                key_status[3]<=key_status[3] & 'hef;
                                //key_status[3]<={key_status[3] [7:5],1'b0,key_status[3] [3:0]};     //[
                            end
                            'h5b: begin
                                key_status[3]<=key_status[3] & 'hf7;
                                //key_status[3]<={key_status[3] [7:4],1'b0,key_status[3] [2:0]};     //]
                            end
                            'h11: begin
                                key_status[3]<=key_status[3] & 'hfb;
                                //key_status[3]<={key_status[3] [7:3],1'b0,key_status[3] [1:0]};     //LALT
                            end                            
                            'h5a: begin
                                key_status[3]<=key_status[3] & 'hfe;
                                //key_status[3]<={key_status[3] [7:1],1'b0};     //ENTER
                            end
                            //*******  Keys LSFT, A, S ,D, F, G, H, J
                            'h12: begin
                                key_status[4]<=key_status[4] & 'h7f;
                                //key_status[4]<={1'b0,key_status[4] [6:0]};     //LSFT
                            end
                            'h1c: begin
                                key_status[4]<=key_status[4] & 'hbf;
                                //key_status[4]<={key_status[4] [7],1'b0,key_status[4] [5:0]};     //A
                            end
                            'h1b: begin
                                key_status[4]<=key_status[4] & 'hdf;
                                //key_status[4]<={key_status[4] [7:6],1'b0,key_status[4] [4:0]};     //S
                            end
                            'h23: begin
                                key_status[4]<=key_status[4] & 'hef;
                                //key_status[4]<={key_status[4] [7:5],1'b0,key_status[4] [3:0]};     //D
                            end
                            'h2b: begin
                                key_status[4]<=key_status[4] & 'hf7;
                                //key_status[4]<={key_status[4] [7:4],1'b0,key_status[4] [2:0]};     //F
                            end
                            'h34: begin
                                key_status[4]<=key_status[4] & 'hfb;
                                //key_status[4]<={key_status[4] [7:3],1'b0,key_status[4] [1:0]};     //G
                            end
                            'h33: begin
                                key_status[4]<=key_status[4] & 'hfd;
                                //key_status[4]<={key_status[4] [7:2],1'b0,key_status[4] [0]};     //H
                            end
                            'h3b: begin
                                key_status[4]<=key_status[4] & 'hfe;
                                //key_status[4]<={key_status[4] [7:1],1'b0};     //J
                            end
                            //*******  Keys K, L, ; ,', #, F2, UP, RSFT
                            'h42: begin
                                key_status[5]<=key_status[5] & 'h7f;
                                //key_status[5]<={1'b0,key_status[5] [6:0]};     //K
                            end
                            'h4b: begin
                                key_status[5]<=key_status[5] & 'hbf;
                                //key_status[5]<={key_status[5] [7],1'b0,key_status[5] [5:0]};     //L
                            end
                            'h4c: begin
                                key_status[5]<=key_status[5] & 'hdf;
                                //key_status[5]<={key_status[5] [7:6],1'b0,key_status[5] [4:0]};     //;
                            end
                            'h52: begin
                                key_status[5]<=key_status[5] & 'hef;
                                //key_status[5]<={key_status[5] [7:5],1'b0,key_status[5] [3:0]};     //'
                            end
                            'h5d: begin
                                key_status[5]<=key_status[5] & 'hf7;
                                //key_status[5]<={key_status[5] [7:4],1'b0,key_status[5] [2:0]};     //#
                            end
                            'h06: begin
                                key_status[5]<=key_status[5] & 'hfb;
                                //key_status[5]<={key_status[5] [7:3],1'b0,key_status[5] [1:0]};     //F2
                            end                            
                            'h59: begin
                                key_status[5]<=key_status[5] & 'hfe;
                                //key_status[5]<={key_status[5] [7:1],1'b0};     //RSFT
                            end
                            //*******  Keys LCTRL, Z, X ,C, V, B, N, M
                            'h14: begin
                                key_status[6]<=key_status[6] & 'h7f;
                                //key_status[6]<={1'b0,key_status[6] [6:0]};     //LCTRL
                            end
                            'h1a: begin
                                key_status[6]<=key_status[6] & 'hbf;
                                //key_status[6]<={key_status[6] [7],1'b0,key_status[6] [5:0]};     //Z
                            end
                            'h22: begin
                                key_status[6]<=key_status[6] & 'hdf;
                                //key_status[6]<={key_status[6] [7:6],1'b0,key_status[6] [4:0]};     //X
                            end
                            'h21: begin
                                key_status[6]<=key_status[6] & 'hef;
                                //key_status[6]<={key_status[6] [7:5],1'b0,key_status[6] [3:0]};     //C
                            end
                            'h2a: begin
                                key_status[6]<=key_status[6] & 'hf7;
                                //key_status[6]<={key_status[6] [7:4],1'b0,key_status[6] [2:0]};     //V
                            end
                            'h32: begin
                                key_status[6]<=key_status[6] & 'hfb;
                                //key_status[6]<={key_status[6] [7:3],1'b0,key_status[6] [1:0]};     //B
                            end
                            'h31: begin
                                key_status[6]<=key_status[6] & 'hfd;
                                //key_status[6]<={key_status[6] [7:2],1'b0,key_status[6] [0]};     //N
                            end
                            'h3a: begin
                                key_status[6]<=key_status[6] & 'hfe;
                                //key_status[6]<={key_status[6] [7:1],1'b0};     //M
                            end
                            //*******  Keys ,, ., / ,RCTRL, lEFT, DOWN, RIGHT, F3
                            'h41: begin
                                key_status[7]<=key_status[7] & 'h7f;
                                //key_status[7]<={1'b0,key_status[7] [6:0]};     // ,
                            end
                            'h49: begin
                                key_status[7]<=key_status[7] & 'hbf;
                                //key_status[7]<={key_status[7] [7],1'b0,key_status[7] [5:0]};     // .
                            end
                            'h4a: begin
                                key_status[7]<=key_status[7] & 'hdf;
                                //key_status[7]<={key_status[7] [7:6],1'b0,key_status[7] [4:0]};     // /
                            end
                            'h29: begin
                                key_status[7]<=key_status[7] & 'hf7;
                                //key_status[7]<={key_status[7] [7:4],1'b0,key_status[7] [2:0]};     //SPC
                            end                            
                        endcase
                    end
                end
                else
                begin           //normal (non-break) code
                    if (e_in)
                    begin
                        case (ps2_code)
                            'h11: begin
                                key_status[3]<=key_status[3] | 'h02;     //RALT                                                         
                            end
                            'h75: begin
                                key_status[5]<=key_status[5] | 'h02;     //UP                                                          
                            end
                            'h14: begin
                                key_status[7]<=key_status[7] | 'h10;     //RCTRL                                                           
                            end
                            'h6b: begin
                                key_status[7]<=key_status[7] | 'h04;     //LEFT                                                 
                            end
                            'h72: begin
                                key_status[7]<=key_status[7] | 'h02;     //DOWN                                                           
                            end                            
                            'h74: begin
                                key_status[7]<=key_status[7] | 'h01;     //RIGHT                                                   
                            end      
                        endcase
                    end
                    else
                    begin
                        case (ps2_code)
                            'h76: begin
                                key_status[0]<=key_status[0] | 'h80;     //esc                                
                            end 
                            'h0e: begin
                                key_status[0]<=key_status[0] | 'h40;     //`                                
                            end
                            'h16: begin
                                key_status[0]<=key_status[0] | 'h20;     //1                                
                            end
                            'h1e: begin
                                key_status[0]<=key_status[0] | 'h10;     //2                                                           
                            end
                            'h26: begin
                                key_status[0]<=key_status[0] | 'h08;     //3                                                           
                            end
                            'h25: begin
                                key_status[0]<=key_status[0] | 'h04;     //4                                                    
                            end
                            'h2e: begin
                                key_status[0]<=key_status[0] | 'h02;     //5                                                           
                            end
                            'h36: begin
                                key_status[0]<=key_status[0] | 'h01;     //6                                                   
                            end
                            'h3d: begin
                                key_status[1]<=key_status[1] | 'h80;     //7                                
                            end 
                            'h3e: begin
                                key_status[1]<=key_status[1] | 'h40;     //8                                
                            end
                            'h46: begin
                                key_status[1]<=key_status[1] | 'h20;     //9                                
                            end
                            'h45: begin
                                key_status[1]<=key_status[1] | 'h10;     //0                                                           
                            end
                            'h4e: begin
                                key_status[1]<=key_status[1] | 'h08;     //-                                                           
                            end
                            'h55: begin
                                key_status[1]<=key_status[1] | 'h04;     //=                                                    
                            end
                            'h66: begin
                                key_status[1]<=key_status[1] | 'h02;     //Backspace                                                           
                            end
                            'h05: begin
                                key_status[1]<=key_status[1] | 'h01;     //F1                                           
                            end
                            'h0d: begin
                                key_status[2]<=key_status[2] | 'h80;     //TAB                                
                            end 
                            'h15: begin
                                key_status[2]<=key_status[2] | 'h40;     //Q                              
                            end
                            'h1d: begin
                                key_status[2]<=key_status[2] | 'h20;     //W                                
                            end
                            'h24: begin
                                key_status[2]<=key_status[2] | 'h10;     //E                                                           
                            end
                            'h2d: begin
                                key_status[2]<=key_status[2] | 'h08;     //R                                                           
                            end
                            'h2c: begin
                                key_status[2]<=key_status[2] | 'h04;     //T                                                    
                            end
                            'h35: begin
                                key_status[2]<=key_status[2] | 'h02;     //Y                                                           
                            end
                            'h3c: begin
                                key_status[2]<=key_status[2] | 'h01;     //U                                                   
                            end
                            'h43: begin
                                key_status[3]<=key_status[3] | 'h80;     //I                                
                            end 
                            'h44: begin
                                key_status[3]<=key_status[3] | 'h40;     //O                              
                            end
                            'h4d: begin
                                key_status[3]<=key_status[3] | 'h20;     //P                                
                            end
                            'h54: begin
                                key_status[3]<=key_status[3] | 'h10;     //[                                                           
                            end
                            'h5b: begin
                                key_status[3]<=key_status[3] | 'h08;     //]                                                           
                            end
                            'h11: begin
                                key_status[3]<=key_status[3] | 'h04;     //LALT                                                    
                            end                            
                            'h5a: begin
                                key_status[3]<=key_status[3] | 'h01;     //ENTER                                                
                            end
                            'h12: begin
                                key_status[4]<=key_status[4] | 'h80;     //LSFT                                
                            end 
                            'h1c: begin
                                key_status[4]<=key_status[4] | 'h40;     //A                              
                            end
                            'h1b: begin
                                key_status[4]<=key_status[4] | 'h20;     //S                                
                            end
                            'h23: begin
                                key_status[4]<=key_status[4] | 'h10;     //D                                                           
                            end
                            'h2b: begin
                                key_status[4]<=key_status[4] | 'h08;     //F                                                           
                            end
                            'h34: begin
                                key_status[4]<=key_status[4] | 'h04;     //G                                                    
                            end
                            'h33: begin
                                key_status[4]<=key_status[4] | 'h02;     //H                                                           
                            end
                            'h3b: begin
                                key_status[4]<=key_status[4] | 'h01;     //J                                                   
                            end
                            'h42: begin
                                key_status[5]<=key_status[5] | 'h80;     //K                                
                            end 
                            'h4b: begin
                                key_status[5]<=key_status[5] | 'h40;     //L                              
                            end
                            'h4c: begin
                                key_status[5]<=key_status[5] | 'h20;     //;                                
                            end
                            'h52: begin
                                key_status[5]<=key_status[5] | 'h10;     //'                                                           
                            end
                            'h5d: begin
                                key_status[5]<=key_status[5] | 'h08;     //#                                                           
                            end
                            'h06: begin
                                key_status[5]<=key_status[5] | 'h04;     //F2                                                    
                            end
                            'h59: begin
                                key_status[5]<=key_status[5] | 'h01;     //RSFT                                                  
                            end
                            'h14: begin
                                key_status[6]<=key_status[6] | 'h80;     //LCRTL                                
                            end 
                            'h1a: begin
                                key_status[6]<=key_status[6] | 'h40;     //Z                              
                            end
                            'h22: begin
                                key_status[6]<=key_status[6] | 'h20;     //X                                
                            end
                            'h21: begin
                                key_status[6]<=key_status[6] | 'h10;     //C                                                           
                            end
                            'h2a: begin
                                key_status[6]<=key_status[6] | 'h08;     //V                                                           
                            end
                            'h32: begin
                                key_status[6]<=key_status[6] | 'h04;     //B                                                    
                            end
                            'h31: begin
                                key_status[6]<=key_status[6] | 'h02;     //N                                                           
                            end
                            'h3a: begin
                                key_status[6]<=key_status[6] | 'h01;     //M                                                   
                            end
                            'h41: begin
                                key_status[7]<=key_status[7] | 'h80;     //,                                
                            end 
                            'h49: begin
                                key_status[7]<=key_status[7] | 'h40;     //.                              
                            end
                            'h4a: begin
                                key_status[7]<=key_status[7] | 'h20;     ///                                
                            end
                            'h29: begin
                                key_status[7]<=key_status[7] | 'h08;     //SPC                                                       
                            end
                            
                        endcase
                    end
                end
                //else latch<=0;
               // latch<=ps2_code;
            end
        end
        else key_ack<=0;
    end
    end
endmodule
