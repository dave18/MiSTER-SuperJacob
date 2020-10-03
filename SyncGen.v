module SyncGen(
    input clk,
    output vga_h_sync,
    output vga_v_sync,
    output reg v_sync_int,
    output reg h_sync_int,
	 output reg h_blank,
	 output reg v_blank,
    output reg inDisplayArea,
    output reg [9:0] CounterX,
    output reg [9:0] CounterY,
    output wire outclk,
    output reg scanlines
    );
    
//////////////////////////////////////////////////


/*
// 720 x 576 @ 27mhz pix clock
localparam HorizSize = 10'd864;
localparam HorizPix = 10'd720;
localparam HBlankS = HorizPix+20;
localparam HBlankE = HorizPix+51;
localparam VertSize = 10'd625;
localparam VertPix = 10'd576;
localparam VBlankS = VertPix+1;
localparam VBlankE = VertPix+3;
*/

// 720 x 576 @ 28mhz pix clock - black borders on left and right due to increased pixel clock
/*localparam HorizSize = 10'd896;
localparam HorizPix = 10'd720;
localparam HBlankS = HorizPix+34;
localparam HBlankE = HorizPix+65;
localparam VertSize = 10'd625;
localparam VertPix = 10'd576;
localparam VBlankS = VertPix+1;
localparam VBlankE = VertPix+3;*/

// 720 x 576 @ 28mhz pix clock - black borders on left and right due to increased pixel clock - 50.08hz
/*localparam HorizSize = 10'd896;
localparam HorizPix = 10'd720;
localparam HBlankS = HorizPix+34;
localparam HBlankE = HorizPix+65;
localparam VertSize = 10'd624;
localparam VertPix = 10'd576;
localparam VBlankS = VertPix+1;
localparam VBlankE = VertPix+3;*/
    
 // 720 x 288 @ 14mhz pix clock - black borders on left and right due to increased pixel clock - 50.08hz
/*localparam HorizSize = 10'd896;
localparam HorizPix = 10'd720;
localparam HBlankS = HorizPix+34+28;
localparam HBlankE = HorizPix+65+28;
localparam VertSize = 10'd312;
localparam VertPix = 10'd288;
localparam VBlankS = VertPix+13;
localparam VBlankE = VertPix+15;*/

// 640 x 480 @ 25.175mhz pix clock - 60hz
localparam HorizSize = 10'd800;
localparam HorizPix = 10'd640;
localparam HBlankS = HorizPix+16;
localparam HBlankE = HBlankS+96;
localparam VertSize = 10'd524;
localparam VertPix = 10'd480;
localparam VBlankS = VertPix+10'd10;
localparam VBlankE = VBlankS+10'd2;

    
wire CounterXmaxed = (CounterX==HorizSize-1);

initial
begin
	CounterX <= 0;
	CounterY <= 0;
	scanlines<=0;	
end

always @(posedge clk)
if(CounterXmaxed)
	CounterX <= 0;
else
    begin
	   CounterX <= CounterX + 1;
	   if (CounterX==HBlankE) scanlines<=scanlines+1;
		//if (CounterX==751) scanlines<=scanlines+1;
	end

always @(posedge clk)
if(CounterXmaxed)
begin
    CounterY <= CounterY + 1;
    if (CounterY==VertSize-1) CounterY<=0;//523) CounterY<=0;      ;524=60hz  627=50hz  ;should change to 524 but will need to adjust other timings
	 //if (CounterY==523) CounterY<=0;//523) CounterY<=0;      ;524=60hz  627=50hz  ;should change to 524 but will need to adjust other timings
end

reg	vga_HS, vga_VS;
always @(posedge clk)
begin
	//vga_HS <= (CounterX[9:4]==6'h29); // change this value to move the display horizontally - default 2D - 27 works on some
	//vga_HS <= (CounterX[9:4]==6'h2b); // change this value to move the display horizontally - default 2D - 27 works on some
	//vga_HS <= (CounterX[9:2]==8'hA3); // change this value to move the display horizontally - default A4 (656)
	vga_HS <= ((CounterX>=HBlankS) && (CounterX<HBlankE)); // change this value to move the display horizontally - default A4 (656)
	vga_VS <= ((CounterY>=VBlankS) && (CounterY<VBlankE)); // change this value to move the display vertically
	
	h_sync_int <= ~(((CounterX>=HBlankS) && (CounterX<HBlankS+15)) && (CounterY[0]==0)); 
	v_sync_int <= ~(((CounterX>=HBlankS) && (CounterX<HBlankS+15) && (CounterY==VBlankS+1))); 
	/*
	vga_HS <= ((CounterX>=655-1) && (CounterX<751-1)); // change this value to move the display horizontally - default A4 (656)
	vga_VS <= ((CounterY>=490+1) && (CounterY<492+1)); // change this value to move the display vertically	
	
	h_sync_int <= ~(((CounterX>=655-1) && (CounterX<655+16)) && (CounterY[0]==0)); 
	v_sync_int <= ~(((CounterX>=655-1) && (CounterX<655+16) && (CounterY==490+2))); 
*/
	
end

//reg inDisplayArea;
always @(posedge clk)
begin

if(inDisplayArea==0)
	//inDisplayArea <= ((CounterXmaxed) && ((CounterY<VertPix-1) || (CounterY==VertSize-1))); //turn on display at start of new line is y < 480
	inDisplayArea <= (CounterXmaxed) && (CounterY<VertPix); //turn on display at start of new line is y < 480
else
	inDisplayArea <= !(CounterX==HorizPix-1); //turn off display when x pos = 639 (ie end of line) ? will turn off on next clock so effectively at 640
	//inDisplayArea <= (CounterX<32);
	
	v_blank<=(CounterY>=VertPix);
	h_blank<=(CounterX>=HorizPix);
end	

/*always @(posedge clk)
if(inDisplayArea==0)
	inDisplayArea <= (CounterXmaxed) && (CounterY<480); //turn on display at start of new line is y < 480
else
	inDisplayArea <= !(CounterX==639); //turn off display when x pos = 639 (ie end of line) ? will turn off on next clock so effectively at 640
*/
	
assign vga_h_sync = ~vga_HS;
assign vga_v_sync = ~vga_VS;

    

    
endmodule