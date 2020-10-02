`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 31.12.2018 12:32:47
// Design Name: 
// Module Name: io_interface
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

/*    PORT Allocation

Outputs

Hex NAME            Description
FF  INT_DATA_BUS    Value that will be presented to the data bus upon interrupt
FE  INT_EN_FLAG     Interrupt enable flags  [OPL Timers,Internal Timers,KEYBOARD,GOPIOB,GPIOA,HSYNC,RASTERLINE,VSYNC]
FD  AY_REGISTER     Reserved for AY
FC  VID_WRITE       Writes byte to current video address
FB  VID_INC_ROW     Increases video address by 1 row (320 bytes)  (value written is irrelevant)
FA  VID_INC         Increase video address by 1 byte  (value written is irrelevant)
F9  VID_ADD_VAL     Increase video address by value written to port
F8  VID_ADDR_HI     Set MSB of video address
F7  VID_ADDR_MD     Set bits 15 through 8 of video address
F6  VID_ADDR_LO     Set bits 7 through 0 of video address
F5  VID_ZERO        Zero video address
F4  TMR_STATUS      IRQ xxxxx TMR2 TMR1
F3  **** Not used ****
F2  **** Not used ****
F1  RASTER_HI       Writes high 2 bits of raster line interrupt
F0  RASTER_LO       Writes low byte of raster line interrupt

EF  **** Not used ****
EE  **** Not used ****
ED  **** Not used ****
EC  TILE_WRITE      Writes byte to current tile graphics address
EB  TILE_INC_TILE   Increases tile graphics address by 1 tile (64 bytes)  (value written is irrelevant)
EA  TILE_INC        Increases tile graphics address by 1   (value written is irrelevant)
E9  TILE_ADD_VAL    Increases tile graphics address by value written to port
E8  TILE_ADDR_HI    Set MSB of tile graphics address
E7  TILE_ADDR_MD    Set bits 15 through 8 of tile graphics address
E6  TILE_ADDR_LO    Set bits 7 through 0 of tile graphics address
E5  TILE_ZERO       Zero tile graphics address
E4  TILE_BANK       Set bits 16 through 14 of tile graphics address to select one of eight 16k tile banks
E3  TILE_NUM        Sets bits 13 through 6 to to select one of 256 tiles within a bank (bits 5 through 0 are zeroed upon write)
E2  **** Not used ****
E1  **** Not used ****
E0  **** Not used ****

DF  TILEMAP_SEL     Select tilemap to be affected by future IO reqs (any value other than 1 is treated as 0)
DE  **** Not used ****
DD  TILEMAP_COLOUR In video mode 2, sets the foreground colour of the tile
DC  TILEMAP_WRITE   Write byte to tilemap address.  In video mode 0 even addresses are tile number, odd addresses are tile attributes.  In Video mode 2 this is always tile (char) number
DB  TILEMAP_INC_ROW Increases tilemap address by 1 row (64 bytes in video mode 0 or 80 bytes in video mode 2)  (value written is irrelevant)
DA  TILEMAP_INC     Increases tilemap address by 1   (value written is irrelevant)
D9  TILEMAP_ADD_VAL Increases tile graphics address by value written to port
D8  **** Not used ****
D7  TILEMAP_ADDR_HI Set bits 12 through 8 of tile graphics address
D6  TILEMAP_ADDR_LO Set bits 7 through 0 of tile graphics address
D5  TILEMAP_ZERO    Zero tile graphics address
D4  TILEMAP_X_VAL   Set column position in tilemap.  In video mode 0 6 bit value, in video mode 2 7 bit value.  Values greater than cloumns will wrap
D3  TILEMAP_Y_VAL   Set row position in tilemap.  6 bit value.  Values greater than visible are accepted but will wrap if past avaiable memory
D2  TILEMAP_BG      Set Background colour for video mode 2
D1  TILEMAP_DEC     Decreases tilemap address by 1   (value written is irrelevant)
D0  TILEMAP_DEC_ROW Decreases tilemap address by 1 row (64 bytes in video mode 0 or 80 bytes in video mode 2)  (value written is irrelevant)

CF  SCROLL_DEC_X    Decreases X scroll value by 1 - affect video modes 0 & 1
CE  SCROLL_INC_X    Increases X scroll value by 1 - affect video modes 0 & 1
CD  SCROLL_DEC_Y    Decreases Y scroll value by 1 - affect video modes 0 & 1
CC  SCROLL_INC_Y    Increases Y scroll value by 1 - affect video modes 0 & 1
CB  SCROLL_X_HI     Sets MSB of X scroll value - affect video modes 0 & 1
CA  SCROLL_X_LO     Sets low byte of X scroll value - affect video modes 0 & 1
C9  SCROLL_Y_HI     Sets MSB of X scroll value - affect video modes 0 & 1
C8  SCROLL_Y_LO     Sets low byte of X scroll value - affect video modes 0 & 1
C7  **** Not used ****
C6  **** Not used ****
C5  **** Not used ****
C4  LED_1
C3  LED_0
C2  LED_RED
C1  LED_GREEN
C0  LED_BLUE

AF  SPRITE_WRITE_INC    Write byte to sprite memory and increase pointer (not sure this works!)
AE  SPRITE_WRITE    Write byte to sprite memory and increase
AD  **** not used ****
AC  SPRITE_MASK     Set the colour index value for the sprite transparency mask
AB  SPRITE_X_OFF    Set te sprite X offset position (where sprite position 0 is compared with physical screen)
AA  SPRITE_Y_OFF    Set te sprite X offset position (where sprite position 0 is compared with physical screen)
A9  SPRITE_X_HI     High bit of sprite X position    
A8  SPRITE_X_LO     Low byte of sprite X position
A7  SPRITE_Y_HI     High bit of sprite Y position    
A6  SPRITE_Y_LO     Low byte of sprite Y position
A5  SPRITE_PAT     Set sprite attributes - bit 7 = mode, 6 through 0 = pattern.  Mode 0 = 8 bit colour, pattern (out of 64) in bits 5 though 0
                                            Mode 1 = 4 bits colour, pattern = bits 6 through 0, lower 4 bits of pattern added to 4 high bits off palette offset
A4  SPRITE_ATTR      bit 7 = y flip, 6 = x flip, Sprite palette offset for 4 bit mode [bits 0 through 3 only]
A3  SPRITE_CHAIN    Set Sprite Chain [7:4] = Y chain. [3:0] = X chain
A2  **** Not Used ****
A1  SPRITE_VISIBLE  Set sprite either hidden or visible
A0  SPRITE_SELECT   Selects which sprite all other sprite operations affect

9F  SAMPLE_PLAY     Play sample (bit 0 to 3 select which sample plays, bits 4 to 7 is whether samples loop or not)
9E  SAMPLE_LEN_HI   Sample length high byte
9D  SAMPLE_LEN_LO   Sample length loq byte
9C  SAMPLE_WRITE    Write a byte to memory (sample memory is shared with top half video gfx ram)
9B  SAMPLE_STOP     Stop Sample (bits 0 to 3 select which samples to stop)
9A  SAMPLE_INC      Increase sample address
99  SAMPLE_ADDR_HI  Set bits 15 through 8 of sample write address
98  SAMPLE_ADDR_LO  Set bits 7 through 0 of sample write address
97  SAMPLE_READ_HI  Set bits 15 through 8 of sample read (play) address
96  SAMPLE_READ_LO  Set bits 7 through 0 of sample read (play) address
95  SAMPLE_ZERO     Zero sample write address
94  SAMPLE_FREQ     Set sample freq 0=33k, 1=15k 2=7k 3=3k
93  SAMPLE_CUST_HI  Set high byte of custom frequency pattern
92  SAMPLE_CUST_LO  Set high byte of custom frequency pattern
91  SAMPLE_VOLUME   Set sample playback volume (0 to 255)
90  SAMPLE_SELECT   Select sample (0 to 3) that other operations affect

8F  PAL_VAL_HI      Latch high 4 bits of palette value 
8E  PAL_VAL_LO      Latch low byte of palette value
8D  PAL_ENTRY       Latch palette index to write to
8C  PAL_WRITE       Write 12 bit latched value to latched palette index
8B  FOREGROUND_MASK Set the transparency index for the foreground layer in video mode 0
8A  **** Not used ****
89  **** Not used ****
88  **** Not used ****
87  SPR_PAL_HI      Latch high 4 bits of sprite palette value
86  SPR_PAL_LO      Latchlow byte of sprite palette value
85  SPR_PAL_ENTRY       Latch palette index to write to
84  SPR_WRITE       Write 12 bit latched value to latched palette index (bits 0 affect background sprites, bit 1 foreground sprites)
83  **** Not used ****
82  **** Not used ****
81  **** Not used ****
80  **** Not used ****

7F  TMR1_HI         Timer 1 High Byte       
7E  TMR1_LO         Timer 1 Low Byte and Start
7D  TMR2_HI         Timer 2 High Byte
7C  TMR2_LO         Timer 2 Low Byte and Start
7B  TMR_CTRL        Timer Control - bit 7 - reset irq, bit 1 = timer 2 restarts on 0, bit 0 timer 1 restarts on 0

78  ROM_OVERLAY     Rom select. 0 = RAM paged into 16k bank at address 0, any other value is ROM paged in
77  RAM_BANK_7      Selects one of the 64 8k RAM bank paged into address $E000
76  RAM_BANK_6      Selects one of the 64 8k RAM bank paged into address $C000
75  RAM_BANK_5      Selects one of the 64 8k RAM bank paged into address $A000
74  RAM_BANK_4      Selects one of the 64 8k RAM bank paged into address $8000
73  RAM_BANK_3      Selects one of the 64 8k RAM bank paged into address $6000
72  RAM_BANK_2      Selects one of the 64 8k RAM bank paged into address $4000
71  RAM_BANK_1      Selects one of the 64 8k RAM bank paged into address $2000
70  RAM_BANK_0      Selects one of the 64 8k RAM bank paged into address $0000

6F  SPRITE_CLIP_L   Sprite Left Clip Value
6E  SPRITE_CLIP_R   Sprite Right Clip Value
6D  SPRITE_CLIP_T   Sprite Top Clip Value
6C  SPRITE_CLIP_B   Sprite Bottom Clip Value

53 AY_DATA_WRITE     Select AY Register
52 AY_REG_WRITE    Write to AY Register
51 OPL_DATA_WRITE    Select OPL Register
50 OPL_REG_WRITE   Write to OPL Register


49  DMA_SPR_NO4     DMA Sprite gfx memory address  set to 4 bit sprite number
48  DMA_ATTR_HI     DMA Sprite attr memory address high 2 bits
47  DMA_ATTR_LO     DMA Sprite attr memory address low byte
46  DMA_LEN_HI      DMA Length high 6 bits - bit 8 control sprite gfx (0) or sprite attr (1) operation
45  DMA_LEN_LO      DMA Length low byte - a write here also starts the DMA operation
44  DMA_SPR_HI      DMA Sprite gfx memory address high 6 bits
43  DMA_SPR_LO      DMA Sprite gfx memory address low byte
42  DMA_CPU_HI      DMA CPU memory address high 3 bits
41  DMA_CPU_MD     DMA CPU memory address mid byte
40  DMA_CPU_LO      DMA CPU memory address low byte

3B  I2C_ADDR        Address of I2C (bits [3 though 1] select 8 possible addresses, bit 0 is R/W
3A  I2C_REG         Register to read from/write to
39  I2C_DATA        Data to be written during write operations
38  I2C_SEND        Send the Address/Register/Data package to the I2C interface

33  SDCARD_SS       SD Card chip select
32  SDCARD_SPD      Sets the SD Card speed - 0 = Low Speed, any other value = high speed
31  SDCARD_BYTE     Send a byte to SD Card - Byte is sent immediately
30  SDCARD_CMD      Send a byte to the SD Command Register (CMD will be sent to SD Card once 8th byte is written)



28  VIDEO_MODE      Sets the video mode
27  FOREGROUND_EN   Enables the foreground layer in video mode 0    

21  CLEAR_SPR_COL   Clear sprite collision flags and Interrupt
20  SCREEN_CTRL     Screen Control  Bit 7 - screen enable, Bit 1 - Background enable, Bit 0 - Show scanlines (Foreground enable is reg 27)



1c  **** Not used ****          (read only)
1B  **** Not used ****          (read only)
1A  **** Not used ****          (read only)
19  **** Not used ****          (read only)
18  SID_FILTER_V    filter mode and main volume control [mute voice 3/high pass/band pass/low pass/main volume [3 through 0]]
17  SID_FILTER_R    filter resonance and routing   resonance [7 though 4], [external input/voice 3/voice 2/voice 1]
16  SID_CUTOFF_HI   filter cutoff frequency high byte
15  SID_CUTOFF_LO   filter cutoff frequency low byte {bits 2 through 0]
14  SID_SUSREL3     Voice 3 Sustain level [7 through 4]  Release duration [3 through 0]
13  SID_ATKDEC3     Voice 3 Attack duration [7 through 4]  Decay duration [3 through 0]  
12  SID_CTRL3       control register voice 3    [noise/pulse/sawtooth/triangle/test/ring mod with voice 2/sync with voice 2/gate]
11  SID_DUTY3_HI    pulse wave duty cycle voice 3 high bits [3 through 0]
10  SID_DUTY3_LO    pulse wave duty cycle voice 3 low byte
0F  SID_FRQ3_HI     frequency voice 3 high byte
0E  SID_FRQ3_LO     frequency voice 3 low byte
0D  SID_SUSREL2     Voice 2 Sustain level [7 through 4]  Release duration [3 through 0]
0C  SID_ATKDEC2     Voice 2 Attack duration [7 through 4]  Decay duration [3 through 0]  
0B  SID_CTRL2       control register voice 2    [noise/pulse/sawtooth/triangle/test/ring mod with voice 1/sync with voice 1/gate]
0A  SID_DUTY2_HI    pulse wave duty cycle voice 2 high bits [3 through 0]
09  SID_DUTY2_LO    pulse wave duty cycle voice 2 low byte
08  SID_FRQ2_HI     frequency voice 2 high byte
07  SID_FRQ2_LO     frequency voice 2 low byte
06  SID_SUSREL1     Voice 1 Sustain level [7 through 4]  Release duration [3 through 0]
05  SID_ATKDEC1     Voice 1 Attack duration [7 through 4]  Decay duration [3 through 0]  
04  SID_CTRL1       control register voice 1    [noise/pulse/sawtooth/triangle/test/ring mod with voice 3/sync with voice 3/gate]
03  SID_DUTY1_HI    pulse wave duty cycle voice 1 high bits [3 through 0]
02  SID_DUTY1_LO    pulse wave duty cycle voice 1 low byte
01  SID_FRQ1_HI     frequency voice 1 high byte
00  SID_FRQ1_LO     frequency voice 1 low byte

*********************************************

Inputs
Hex NAME            Description
FF  INT_STATUS      Interrupt status        [BUTTON,X,KEYBOARD,GOPIOB,GPIOA,HSYNC,RASTERLINE,VSYNC]
FE  INT_EN_FLAG     Interrupt enable flags  [BUTTON,X,KEYBOARD,GOPIOB,GPIOA,HSYNC,RASTERLINE,VSYNC]

F1  RASTER_HI       Reads high 2 bits of raster line number
F0  RASTER_LO       Reads low byte of raster line number


DC  TILEMAP_READ       Reads the tile number at the current cursor positon (ie current screen memeory address)

D4  TILEMAP_READ_X     Get the current cursor column
D3  TILEMAP_READ_Y     Get the current cursor row

7B  TMR_STATUS      Timer Control - bit 1 = Timer B Flag, bit 0 Timer A Flag
7A  GPIO_STATUS     GPIO Control  - bit 1 = GPIO B Flag, bit 0 GPIO A Flag

39  I2C_READ        Read the data send from the I2C interface
38  I2C_STATUS      Read the status byte from the I2C interface


32  SDCARD_WAITING  Read Data Waiting status of SD Card
31  SDCARD_READY    Read ready status of SD card
30  SDCARD_DATA     Read the last byte returned from the SD Card

23  SPR_COL_X_HI    Sprite collision X pos high & flags (bit 7=foreground sprite/foreground collision) (bit 6=foreground sprite/background collision)  (bit 5=background sprite/background collision)
22  SPR_COL_X_LO    Sprite collision X pos low
21  SPR_COL_Y       Sprite collision Y pos
20  SCREEN_REG      Read screen control register

17  KEY_MATRIX_7    Read Keyboard byte 7 -  ,   .   / RCTL SPC  LT  DN  RT 
16  KEY_MATRIX_6    Read Keyboard byte 6 - LCTL Z   X   C   V   B   N   M
15  KEY_MATRIX_5    Read Keyboard byte 5 -  K   L   ;   '   #   F2  UP  RSFT
14  KEY_MATRIX_4    Read Keyboard byte 4 - LSFT A   S   D   F   G   H   J
13  KEY_MATRIX_3    Read Keyboard byte 3 -  I   O   P   [   ]  LALT RALT RET
12  KEY_MATRIX_2    Read Keyboard byte 2 - TAB  Q   W   E   R   T   Y   U
11  KEY_MATRIX_1    Read Keyboard byte 1 -  7   8   9   0   -   =  BSP  F1
10  KEY_MATRIX_0    Read Keyboard byte 0 - ESC  `   1   2   3   4   5   6

01  KEY_DATA        Reads the most recent ASCII value PS2 keyboard state

*/

module io_interface(
    input nReset,
    input [6:0] keyboard_in,
    input vsync_int_in,
    input hsync_int_in,
    input GPIOA_int_in,
    input GPIOB_int_in,
    input keyb_int_in,
	 input opl_int_in,
    input ay_int_in,
	 input spr_int_in,
//    input button_int_in,
    input io_m_in,
    input io_wait_in,
    input [7:0] io_data_in_from_cpu,
    input [7:0] io_data_in_from_ram,
	 input [7:0] io_data_in_from_rgb,
	 input [7:0] io_data_in_from_ay,
    input [7:0] io_data_in_from_opl,
    input [7:0] io_data_in_from_sid,
    input [7:0] io_data_in_from_matrix,
    input [31:0] io_data_in_from_sdcard,
    input [9:0] CounterY,
    //input [15:0] adc_data_in,
	 input [7:0] adc_1_in,
	 input [7:0] adc_2_in,
    input sysclk,
    input io_req,
    input io_wr,
    input io_rd,
    input [15:0] io_address_in,    
    input [31:0] io_data_in_from_i2c,
    input [31:0] sd_debug,
    input sd_ack,
	 input [7:0] joy0,
	 input [7:0] joy1,
	 input [1:0] mem_option,
  //  input adc_enable,
    input adc_ready, 
    output wire led0_b,
    output wire led0_g,
    output wire led0_r,
    output reg led1,
    output reg led2,
    output reg [6:0] adc_address_out,
    output reg [7:0] io_data_to_cpu,
    output reg z80_int,
    output wire io_wait_out,
    output reg io_to_ram,
    output reg io_from_ram,
    output reg io_to_sprite,
    output reg io_to_rgb,
	 output reg io_from_rgb,
    output reg io_to_sid,
    output reg io_to_sdcard,
    //output reg io_to_banking,
	 output reg io_to_ay,
    output reg io_to_opl,
    output reg io_sdcard_we,
    output reg io_from_matrix,     
    output reg sdcard_speed,
    output reg sdcard_ss,
    output reg io_to_DMA,
    output wire [15:0] io_address_out,
    output reg [7:0] io_data_to_sprite,
    output reg [7:0] io_data_to_ram,
    output reg [7:0] io_data_to_rgb,
    output reg [7:0] io_data_to_sid,
	 output reg  io_reg_to_ay,
    output reg  io_reg_to_opl,
    output reg [7:0] io_data_to_ay,
    output reg [7:0] io_data_to_opl,
    //output reg [5:0] io_data_to_banking,
    output reg [31:0] io_data_to_sdcard,
    output reg [1:0] io_addr_to_sdcard,
    output reg io_cyc_to_sdcard,
    output reg [31:0] io_data_to_i2c,
    output reg [7:0] potx_latch,
    output reg [7:0] poty_latch,
    output reg i2c_write_ctrl,
    output reg [7:0] io_data_to_DMA,
    output reg i2c_data_ack,
	 output reg romsel,
	 output reg [7:0] bank0,
	 output reg [7:0] bank1,
	 output reg [7:0] bank2,
	 output reg [7:0] bank3,
	 output reg [7:0] bank4,
	 output reg [7:0] bank5,
	 output reg [7:0] bank6,
	 output reg [7:0] bank7

	 //output reg [7:0] MCP23017_data_out,
	 //output reg [7:0] MCP23017_status
    );
    
wire [8:0]raster_line=CounterY[9:1]+1;
//reg [8:0] z80_int_timer;  //timer for how long to keep interrupt low

wire timer2_int_in=opl_int_in & ay_int_in;
wire GPIO_int_in=GPIOA_int_in & GPIOB_int_in;

reg [10:0] timer_speed_control;  //controls how quickly the timers count down

//reg [15:0] io_address_in;
//reg [7:0] io_data_in;
		 
//reg [15:0] io_address_out;

//reg int_ctrl;
reg vsync_ctrl;
reg hsync_ctrl;
reg keyb_ctrl;
reg tmr1_ctrl;
reg tmr2_ctrl;
reg spr_ctrl;
reg gpio_ctrl;
//reg button_ctrl;
reg [31:0] i2c_ctrl;
reg i2c_write_req;
reg [7:0]int_status;
reg [7:0]int_status_latch;
reg [7:0]int_mask;
reg [8:0]raster_int;
reg [7:0]int_data_bus;
reg [7:0] data_r;
reg [7:0] data_g;
reg [7:0] data_b;
reg [8:0] pot_selectff;
reg [31:0] sd_data_out_latch;
reg [31:0] sd_data_in_latch;
reg [15:0] timer1_latch;
reg [15:0] timer2_latch;
reg [15:0] timer1;
reg [15:0] timer2;
reg timer1_active;
reg timer2_active;
reg timer1_loop;
reg timer2_loop;
reg timer1_int;
reg sd_ctrl;

reg [7:0] MCP23017_data_out;
reg [7:0] MCP23017_status;
reg [7:0] MCP23017_addr;
reg [7:0] MCP23017_reg;
reg [7:0] MCP23017_data;
reg MCP23017_mode;

reg [7:0] timer_status;

reg [1:0] gpio_reg;

//OPL Timers,Internal Timers,KEYBOARD,GOPIOB,GPIOA,HSYNC,RASTERLINE,VSYNC]
reg snd_irq_flag;
reg tmr_irq_flag;
reg kbd_irq_flag;
reg spr_irq_flag;
reg ioa_irq_flag;
reg hsc_irq_flag;
reg ras_irq_flag;
reg vsc_irq_flag;
reg [2:0] clear_flags_next_cycle;

assign io_address_out =  io_address_in; 
//assign io_data_out = ((!io_wr) && (!io_req)) ? io_data_in:8'bZ; //if not writing tri-state

assign io_wait_out=io_wait_in;


     ///////////////////////////////////////////////////////////////////
    //LED PWM
    //////////////////////////////////////////////////////////////////  
           
    integer pwm_end = 4070;      
    wire [11:0] shifted_data_r;
    wire [11:0] shifted_data_g;
    wire [11:0] shifted_data_b;
    //filter out tiny noisy part of signal to achieve zero at ground
    assign shifted_data_r = (data_r * 16) & 12'hff0;
    assign shifted_data_g = (data_g * 16) & 12'hff0;
    assign shifted_data_b = (data_b * 16) & 12'hff0;
    
    integer pwm_count = 0;
    //reg pwm_out = 0;
   

    //ledrgb is active low
    assign led0_r = !(pwm_count < shifted_data_r ? 1'b1 : 1'b0);
    assign led0_g = !(pwm_count < shifted_data_g ? 1'b1 : 1'b0);
    assign led0_b = !(pwm_count < shifted_data_b ? 1'b1 : 1'b0);
	 
	 wire [7:0]bank_data=(mem_option==2'h0)?{2'b00,io_data_in_from_cpu[5:0]}:(mem_option==2'h1)?{1'b0,io_data_in_from_cpu[6:0]}:io_data_in_from_cpu;
    


		 
	initial 
	   begin	   
	       io_to_ram<=1;
		   io_to_sprite<=1;
		   io_to_rgb<=1;
		   io_to_sid<=0;
		   io_to_sdcard<=0;
		   //io_to_banking<=1;
		   io_from_ram<=1;
		   io_from_rgb<=1;
		   io_from_matrix<=0;
		   io_to_DMA<=1;
		   io_to_ay<=1;
		   io_to_opl<=1;
		   io_sdcard_we<=0;
		   z80_int<=1;		//keep high unless issuing interrupt
		   io_data_to_ram<=8'bZ;	//start in hi impedence
		   io_data_to_sprite<=8'bZ;
		   io_data_to_rgb<=8'bZ;
		   io_data_to_sid<=8'bZ;
		   io_data_to_sdcard<=32'bZ;
		   //io_data_to_banking<=6'bz;
		   io_data_to_DMA<=8'bz;
		   io_data_to_ay<=8'bz;
		   io_data_to_opl<=8'bz;
		   io_reg_to_ay<=0;
		   io_reg_to_opl<=0;
		   //int_ctrl<=0;
		   vsync_ctrl<=0;      //make sure we only issue a single interrupt for each vert blank
		   hsync_ctrl<=0;      //make sure we only issue a single interrupt for each horiz blank
		   keyb_ctrl<=0;
		   tmr1_ctrl<=0;
		   tmr2_ctrl<=0;
			spr_ctrl<=0;
//		   z80_int_timer<=0;
		   sdcard_speed<=0;
		   i2c_write_req<=0;
		   int_data_bus<=0;
		   data_r<=0;
		   data_g<=0;
		   data_b<=0;
		   led1<=0;
		   led2<=0;
		   sdcard_ss<=0;
		   timer1_latch<=0;
           timer2_latch<=0;
           timer1<=0;
           timer2<=0;
           timer1_active<=0;
           timer2_active<=0;
           timer1_loop<=0;
           timer2_loop<=0;
           timer1_int<=0;          
           i2c_data_ack<=0;
           snd_irq_flag<=0;
           tmr_irq_flag<=0;
           kbd_irq_flag<=0;
           spr_irq_flag<=0;
           ioa_irq_flag<=0;
            hsc_irq_flag<=0;
           ras_irq_flag<=0;
           vsc_irq_flag<=0;
           clear_flags_next_cycle<=0;
           int_mask<=8'h00;
			  MCP23017_mode<=0;
			  			romsel<=1;           //start with rom banked in
			bank0<=0;
			bank1<=1;
			bank2<=2;
			bank3<=3;
			bank4<=4;
			bank5<=5;
			bank6<=6;
			bank7<=7;

	  end
	  
	always @ (posedge sysclk or negedge nReset)
    begin               //+1
    if (!nReset)
    begin               //+2
        io_to_ram<=1;
		io_to_sprite<=1;
		io_to_rgb<=1;
		io_to_sid<=0;
		io_to_sdcard<=0;
		//io_to_banking<=1;
		io_from_ram<=1;
		io_from_rgb<=1;
		io_from_matrix<=0;
		io_to_DMA<=1;
		io_to_ay<=1;
		io_to_opl<=1;
		io_sdcard_we<=0;
		z80_int<=1;		//keep high unless issuing interrupt
		io_data_to_ram<=8'bZ;	//start in hi impedence
		io_data_to_sprite<=8'bZ;
		io_data_to_rgb<=8'bZ;
		io_data_to_sid<=8'bZ;
		io_data_to_sdcard<=32'bZ;
		//io_data_to_banking<=6'bz;
		io_data_to_DMA<=8'bz;
		io_data_to_ay<=8'bz;
		io_reg_to_ay<=0;
		io_data_to_opl<=8'bz;
		io_reg_to_opl<=0;
		//int_ctrl<=0;
		vsync_ctrl<=0;      //make sure we only issue a single interrupt for each vert blank
		hsync_ctrl<=0;      //make sure we only issue a single interrupt for each horiz blank
		keyb_ctrl<=0;
		tmr1_ctrl<=0;
		tmr2_ctrl<=0;
		spr_ctrl<=0;
//		z80_int_timer<=0;
		sdcard_speed<=0;
		i2c_write_req<=0;
		int_data_bus<=0;
		data_r<=0;
		data_g<=0;
		data_b<=0;
		led1<=0;
		led2<=0;
		sdcard_ss<=0;
		timer1_latch<=0;
        timer2_latch<=0;
        timer1<=0;
        timer2<=0;
        timer1_active<=0;
        timer2_active<=0;
        timer1_loop<=0;
        timer2_loop<=0;
        timer1_int<=0;        
        i2c_data_ack<=0;
        snd_irq_flag<=0;
        tmr_irq_flag<=0;
        kbd_irq_flag<=0;
        spr_irq_flag<=0;
        ioa_irq_flag<=0;
        hsc_irq_flag<=0;
        ras_irq_flag<=0;
        vsc_irq_flag<=0;
        clear_flags_next_cycle<=0;
        int_mask<=8'h00;
		  MCP23017_mode<=0;
		  			romsel<=1;           //start with rom banked in
			bank0<=0;
			bank1<=1;
			bank2<=2;
			bank3<=3;
			bank4<=4;
			bank5<=5;
			bank6<=6;
			bank7<=7;

    end     //-2
    else 
	begin   //+2
	   if (clear_flags_next_cycle>1) clear_flags_next_cycle<=clear_flags_next_cycle-1;
	   if (clear_flags_next_cycle==1)
	   begin
	       snd_irq_flag<=snd_irq_flag & int_status_latch[7];   //reset flag if set on last read of interrupt
           tmr_irq_flag<=tmr_irq_flag & int_status_latch[6];   //reset flag if set on last read of interrupt
           kbd_irq_flag<=kbd_irq_flag & int_status_latch[5];   //reset flag if set on last read of interrupt
           spr_irq_flag<=spr_irq_flag & int_status_latch[4];   //reset flag if set on last read of interrupt
           ioa_irq_flag<=ioa_irq_flag & int_status_latch[3];   //reset flag if set on last read of interrupt
           hsc_irq_flag<=hsc_irq_flag & int_status_latch[2];   //reset flag if set on last read of interrupt
           ras_irq_flag<=ras_irq_flag & int_status_latch[1];   //reset flag if set on last read of interrupt
           vsc_irq_flag<=vsc_irq_flag & int_status_latch[0];   //reset flag if set on last read of interrupt
           clear_flags_next_cycle<=0;
       end
	
	   if (io_data_in_from_i2c[28]) i2c_data_ack<=1; 
	   timer_speed_control<=timer_speed_control+1;
	   if (timer_speed_control==0)
	   begin
	       if (timer1_active)
	       begin
	           timer1<=timer1-1;
	           if (timer1==0)
	           begin
	               timer_status<=timer_status | 8'b10000001;
	               timer1_int<=1;
	               if (timer1_loop) timer1<=timer1_latch; else timer1_active<=0;
	           end
	       end
	       if (timer2_active)
	       begin
	           timer2<=timer2-1;
	           if (timer2==0)
	           begin
	               timer_status<=timer_status | 8'b10000010;
	               timer1_int<=1;
	               if (timer2_loop) timer2<=timer2_latch; else timer2_active<=0;
	           end
	       end
	   end
	   /*case (pot_selectff)
	       0:begin
	           poty_latch<=adc_data_in[15:8];
	           adc_address_out <= 8'h14;
	       end
	       256:begin
	           potx_latch<=adc_data_in[15:8];
	           adc_address_out <= 8'h1c;
	       end
	   endcase	   
	   pot_selectff<=pot_selectff+1;
	   */
		potx_latch<=adc_1_in;
		poty_latch<=adc_2_in;
			//if ((io_req==0) && (io_wr==0)) io_to_ram<=0; else io_to_ram<=1;
			//i2c_write_ctrl<=0;
			
			
			if ((io_req==0) && (io_m_in))  //io request
			begin    //+3
				if ((io_wr==0) && (io_rd))
				begin   //+4
				    casez (io_address_in[7:0])
				    
				    
				       8'hff: begin     //Set value to be loaded onto data bus during interrupt
				          int_data_bus<=io_data_in_from_cpu;
				       end
				    
				       8'hfe: begin     //Interrupt enable flags
				          int_mask<=io_data_in_from_cpu;
				       end
				       
				       8'hfd: begin           //for compatibility for spectrum we will use 16 bit decoding here
					      //if (io_address_in[15:8]==8'hff) io_reg_to_ay<=io_data_in_from_cpu[3:0];  //AY REG SELECT
				          //if (io_address_in[15:8]==8'hbf)
				          //begin
				            io_reg_to_ay<=~io_address_in[14];
				            io_data_to_ay<=io_data_in_from_cpu;     //AY DATA WRITE
				            io_to_ay<=0;     //ay wr active low
				         // end
				       end
				       
				       'hf1:begin					       
					       raster_int[8:8]<=io_data_in_from_cpu[0:0];
					   end
					
					   'hf0:begin
					       raster_int[7:0]<=io_data_in_from_cpu;
					   end
					   
					   
					   'hc5:begin
					       if (io_data_in_from_cpu==0) adc_address_out <= 8'h14; else adc_address_out <= 8'h1c;            
					   end
					   
					   							   
					   
					   'hc4:begin
					       led2<=io_data_in_from_cpu!=0;
					   end
					   
					   'hc3:begin
					       led1<=io_data_in_from_cpu!=0;
					   end
					   
					   'hc2:begin
					       data_r<=io_data_in_from_cpu;
					   end
					   
					   'hc1:begin
					       data_g<=io_data_in_from_cpu;
					   end
					   
					   'hc0:begin
					       data_b<=io_data_in_from_cpu;
					   end    
				    
				       8'b1010????: begin  //sprite register range (a0 to af)
				          io_data_to_sprite<=io_data_in_from_cpu;
				          /*io_data_to_banking<=6'bZ;
				          io_data_to_cpu<=8'bZ;
				          io_data_to_rgb<=8'bZ;
				          io_data_to_sid<=8'bZ;
				          io_data_to_sdcard<=8'bZ;
				          io_to_sid<=0;
				          io_to_ram<=1;
				          io_to_rgb<=1;*/
					      io_to_sprite<=0;
					      /*io_from_ram<=1;
					      io_from_matrix<=0;
					      io_to_sdcard<=0;
					      io_to_banking<=1;*/
				       end
				       
				       8'b10000???: begin  //sprite palette register range (80 to 87)
				          io_data_to_sprite<=io_data_in_from_cpu;
				          /*io_data_to_banking<=6'bZ;
				          io_data_to_cpu<=8'bZ;
				          io_data_to_rgb<=8'bZ;
				          io_data_to_sid<=8'bZ;
				          io_data_to_sdcard<=8'bZ;
				          io_to_sid<=0;
				          io_to_ram<=1;
				          io_to_rgb<=1;*/
					      io_to_sprite<=0;
					      /*io_from_ram<=1;
					      io_from_matrix<=0;
					      io_to_sdcard<=0;
					      io_to_banking<=1;*/
				       end
				       
				       //90 to 9f - sample regs
				       
				       'h7f:begin
				            timer1_latch[15:8]<=io_data_in_from_cpu;
				            timer1[15:8]<=io_data_in_from_cpu;
				       end
				       'h7e:begin
				            timer1_latch[7:0]<=io_data_in_from_cpu;
				            timer1[7:0]<=io_data_in_from_cpu;
				       end
				       'h7d:begin
				            timer2_latch[15:8]<=io_data_in_from_cpu;
				            timer2[15:8]<=io_data_in_from_cpu;
				       end
				       'h7c:begin
				            timer2_latch[7:0]<=io_data_in_from_cpu;
				            timer2[7:0]<=io_data_in_from_cpu;
				       end
				       'h7b:begin
				            timer1_loop<=io_data_in_from_cpu[0];
				            timer2_loop<=io_data_in_from_cpu[1];
				            timer1_active<=io_data_in_from_cpu[2];
				            timer2_active<=io_data_in_from_cpu[3];
				       end
				       
				      'h78:   begin
								romsel<=io_data_in_from_cpu!=0;
						end
						'h77:   begin
							bank7<=bank_data;
						end
						'h76:   begin
							bank6<=bank_data;
						end
						'h75:   begin
							bank5<=bank_data;
						end
						'h74:   begin
							bank4<=bank_data;
						end
						'h73:   begin
							bank3<=bank_data;
						end
						'h72:   begin
							bank2<=bank_data;
						end
						'h71:   begin
							bank1<=bank_data;
						end
						'h70:   begin
							bank0<=bank_data;
						end
						
						8'b011011??: begin  //sprite clip register range (6c to 6f)
				          io_data_to_sprite<=io_data_in_from_cpu;
					      io_to_sprite<=0;
				       end
					   
					   8'h53: begin          //AY DATA WRITE					      
				            io_data_to_ay<=io_data_in_from_cpu; 
				            io_to_ay<=0;     //ay wr active high
				            io_reg_to_ay<=1;				            				         
				       end
				       
				       8'h52: begin          //AY ADDRESS WRITE					      
				            io_data_to_ay<=io_data_in_from_cpu; 
				            io_to_ay<=0;     //ay wr active high
				            io_reg_to_ay<=0;				            				         
				       end
					   
					   8'h51: begin          //OPL DATA WRITE					      
				            io_data_to_opl<=io_data_in_from_cpu; 
				            io_to_opl<=0;     //opl wr active low
				            io_reg_to_opl<=1;				            				         
				       end
				       
				       8'h50: begin          //OPL ADDRESS WRITE					      
				            io_data_to_opl<=io_data_in_from_cpu; 
				            io_to_opl<=0;     //opl wr active low
				            io_reg_to_opl<=0;				            				         
				       end
					   
					   8'h4a: begin  //$4a - Sprite DMA
					      io_data_to_DMA<=io_data_in_from_cpu;
					      io_to_DMA<=0;
					   end

					   8'h49: begin  //$49 - Sprite DMA
					      io_data_to_DMA<=io_data_in_from_cpu;
					      io_to_DMA<=0;
					   end


					   8'h48: begin  //$48 - Sprite DMA
					      io_data_to_DMA<=io_data_in_from_cpu;
					      io_to_DMA<=0;
					   end
					   
					   8'b01000???: begin  //$40 to $47 - Sprite DMA
					      io_data_to_DMA<=io_data_in_from_cpu;
					      /*io_data_to_sprite<=8'bZ;
				          io_data_to_banking<=6'bZ;
				          io_data_to_cpu<=8'bZ;
				          io_data_to_rgb<=8'bZ;
				          io_data_to_sid<=8'bZ;
				          io_data_to_sdcard<=8'bZ;
				          io_to_sid<=0;
				          io_to_ram<=1;
				          io_to_rgb<=1;
					      io_to_sprite<=1;
					      io_from_ram<=1;
					      io_from_matrix<=0;
					      io_to_sdcard<=0;
					      io_to_banking<=1;*/
					      io_to_DMA<=0;
					   end
					   
					   /*08'h1f: begin           //for compatibility for spectrum we will use 16 bit decoding here
					      if (io_address_in[15:8]==8'hff) io_reg_to_ay<=io_data_in_from_cpu[3:0];  //AY REG SELECT
				          if (io_address_in[15:8]==8'hbf)
				          begin
				            io_data_to_ay<=io_data_in_from_cpu;     //AY DATA WRITE
				            io_to_ay<=0;     //ay wr active low
				          end
				       end*/
				       
				       
					   
					   08'h1c: begin  //sid register range
				          io_data_to_sid<=io_data_in_from_cpu;
				          io_to_sid<=1;     //sid we is active high
				       end
				       
				       08'h1b: begin  //sid register range
				          io_data_to_sid<=io_data_in_from_cpu;
				          io_to_sid<=1;     //sid we is active high
				       end
				       
				       08'h1a: begin  //sid register range
				          io_data_to_sid<=io_data_in_from_cpu;
				          io_to_sid<=1;     //sid we is active high
				       end
				       
				       08'h19: begin  //sid register range
				          io_data_to_sid<=io_data_in_from_cpu;
				          io_to_sid<=1;     //sid we is active high
				       end
				       
				       08'h18: begin  //sid register range
				          io_data_to_sid<=io_data_in_from_cpu;
				          io_to_sid<=1;     //sid we is active high
				       end
					   
					   08'b00010???: begin  //sid register range (16 to 23 $10 to $17)
				          io_data_to_sid<=io_data_in_from_cpu;
				          io_to_sid<=1;     //sid we is active high
				       end 
				       
				       08'b0000????: begin  //sid register range (0 to 15 $0 to $0f)
				          io_data_to_sid<=io_data_in_from_cpu;
				      /*    io_data_to_banking<=6'bZ;
				          io_data_to_cpu<=8'bZ;
				          io_data_to_rgb<=8'bZ;
				          io_data_to_sprite<=8'bZ;
				          io_data_to_sdcard<=8'bZ;*/
				          io_to_sid<=1;     //sid we is active high
				          /*io_to_ram<=1;
				          io_to_rgb<=1;
					      io_to_sprite<=1;
					      io_from_ram<=1;
					      io_from_matrix<=0;
					      io_to_sdcard<=0;
				          io_to_banking<=1;*/
				       end
				       
				       8'b001000??: begin  //screen register range     20 to 23
				          io_data_to_rgb<=io_data_in_from_cpu;
				          io_to_rgb<=0;
				       end
				       
				       'h3b: begin             //Address element of i2c control (MCP23017 upper 4 bits are hardcoded)                      
				           //i2c_ctrl[23:17]<={4'b0100,io_data_in_from_cpu[2:0]};
							  MCP23017_addr<={4'b0100,io_data_in_from_cpu[3:0]};
				       end
				       
				       'h3a: begin             //Register element of i2c control                      
				           //i2c_ctrl[15:8]<=io_data_in_from_cpu;
							  MCP23017_reg<=io_data_in_from_cpu;
				       end
				       
				       'h39: begin             //Data element of i2c control                      
				           //i2c_ctrl[7:0]<=io_data_in_from_cpu;
							  MCP23017_data<=io_data_in_from_cpu;
				       end
				       
				       'h38: begin             //Enable i2c write control
				            //i2c_ctrl[31:30]<=io_data_in_from_cpu[1:0];//2'b00;
				           /* if (i2c_write_req==0)
				            begin
				                i2c_write_ctrl<=1;
				                io_data_to_i2c<={io_data_in_from_cpu[1:0],i2c_ctrl[29:0]};
				                i2c_data_ack<=0;
				            end
				            i2c_write_req<=1;*/
								case (MCP23017_reg)
									'h00: begin				//IODIRA
										MCP23017_status<=0;
									end
									'h01: begin				//IODIRB/IPOLA
										MCP23017_status<=0;
									end
									'h05: begin				//GPINTENB/IOCON
										MCP23017_status<=0;
										if (MCP23017_mode==1)		//only IOCON if in BANK 1
										begin
											MCP23017_mode<=MCP23017_data[7];
										end
									end
									'h06: begin				//DEFVALA/GPPUA
										MCP23017_status<=0;
									end								
									'h0A: begin				//IOCON/OLATA
										MCP23017_status<=0;
										if (MCP23017_mode==0)		//only IOCON if in BANK 0
										begin
											MCP23017_mode<=MCP23017_data[7];
										end
									end
									'h0C: begin				//GPPUA/#NA
										MCP23017_status<=0;
									end
									'h0D: begin				//GPPUB/#NA
										MCP23017_status<=0;
									end
									'h09: begin 			//INTCONB/Port A (Joy A)
										if (MCP23017_mode)
										begin
											MCP23017_data_out<=joy0;
											MCP23017_status<=8'h10;
										end
										else
										begin
											MCP23017_status<=8'h0;
										end																	
									end
									'h10: begin				//INTCAPA/IODIRB
										MCP23017_status<=0;
									end									
									'h12: begin 			//Port A (Joy A)/GPINTENB
										if (MCP23017_mode)
										begin
											MCP23017_status<=8'h0;
										end
										else
										begin
											MCP23017_data_out<=joy0;
											MCP23017_status<=8'h10;
										end
									end									
									'h13: begin 			//Port B (Joy B)/DEFVALB
										if (MCP23017_mode)
										begin
											MCP23017_status<=8'h0;
										end
										else
										begin
											MCP23017_data_out<=joy1;
											MCP23017_status<=8'h10;
										end
									end
								   'h16: begin				//#NA/GPPUB
										MCP23017_status<=0;
									end									
									'h19: begin 			//#NA/Port B (Joy B)
										if (MCP23017_mode)
										
										begin
											MCP23017_data_out<=joy1;
											MCP23017_status<=8'h10;
										end
										else
										begin
											MCP23017_status<=8'h0;
										end										
									end									
								endcase

				        end
				       
				       'h35:begin
				            sd_data_out_latch[31:24]<=io_data_in_from_cpu;
				            //io_data_to_sdcard[31:24]<=io_data_in_from_cpu;
				       end
				       'h34:begin
				            sd_data_out_latch[23:16]<=io_data_in_from_cpu;
				           // io_data_to_sdcard[23:16]<=io_data_in_from_cpu;
				       end
				       'h33:begin
				            sd_data_out_latch[15:8]<=io_data_in_from_cpu;
				            //io_data_to_sdcard[15:8]<=io_data_in_from_cpu;
				       end
				       'h32:begin
				            sd_data_out_latch[7:0]<=io_data_in_from_cpu;
				            //io_data_to_sdcard[7:0]<=io_data_in_from_cpu;
				       end
                   'h31:begin				            
				            io_addr_to_sdcard<=io_data_in_from_cpu[1:0];
				       end 				       
				       
				       
				       'h30: begin    //SD Card register range ($30 to $33)
				          if ((sd_ack==0) && (sd_ctrl==0))
				          begin
				             io_data_to_sdcard<=sd_data_out_latch;
				             io_to_sdcard<=1;  //1=active for sdcard
				             io_sdcard_we<=1;
				             io_cyc_to_sdcard<=1;
				             //if (sd_ack) 
				             
				          end
				          else
				          begin
				             //io_data_to_sdcard<=sd_data_out_latch;
				             io_to_sdcard<=0;  //1=active for sdcard
				             io_sdcard_we<=0;
				             io_cyc_to_sdcard<=0;
				             sd_ctrl<=1;//sd_ctrl+1;
				          end			          				         				          				          
					   end
					   
					   
				     
				        default: begin
					        io_data_to_ram<=io_data_in_from_cpu;
					    /*   io_data_to_banking<=6'bZ;
					       io_data_to_cpu<=8'bZ;
					       io_data_to_rgb<=8'bZ;
					       io_data_to_sid<=8'bZ;
					       io_data_to_sdcard<=8'bZ;
					       io_data_to_DMA<=8'bZ;*/
				         //  io_to_sid<=0;
					       io_to_ram<=0;
					     /*  io_to_sdcard<=0;
					       io_to_rgb<=1;
					       io_to_sprite<=1;					       
					       io_to_banking<=1;
					       io_to_DMA<=1;*/
					       //i2c_write_ctrl<=0;
					       //i2c_write_req<=0;
					       /*io_from_ram<=1;
					       io_from_matrix<=0;*/
					       
					    end
					endcase
				end  //-4
				if ((io_rd==0) && (io_wr))
				begin  //+4
					/*io_data_to_ram<=8'bZ;
					io_data_to_rgb<=8'bZ;
					io_data_to_sprite<=8'bZ;
					io_data_to_sid<=8'bZ;
					io_data_to_sdcard<=8'bZ;
					io_data_to_banking<=6'bZ;
					io_data_to_DMA<=8'bZ;
				    io_to_sid<=0;
					io_to_ram<=1;
				    io_to_sdcard<=0;
					io_to_rgb<=1;
					io_to_sprite<=1;
					io_to_banking<=1;
					io_to_DMA<=1;*/
					casez (io_address_in[7:0])
					
					
					
					'hff:begin             //interrupt status
					   io_data_to_cpu[7:0]<=int_status;
					   int_status_latch<=int_status ^ 8'hff;       //reverse bits ready to clear flags
					   clear_flags_next_cycle<=7;
					   /*snd_irq_flag<=0;
                       tmr_irq_flag<=0;
                       kbd_irq_flag<=0;
                       iob_irq_flag<=0;
                       ioa_irq_flag<=0;
                       hsc_irq_flag<=0;
                       ras_irq_flag<=0;
                       vsc_irq_flag<=0;*/
					end
					
					'hfe:begin             //interrupt status
					   io_data_to_cpu[7:0]<=int_mask;
					end
					
					08'hfd: begin  //AY DATA READ
					      io_reg_to_ay<=~io_address_in[14];
				          if (io_address_in[15:8]==8'hff) io_data_to_cpu<=io_data_in_from_ay;
				          //io_to_ay<=1;     //sid we is active high
				    end
				    
				    /*'hf4:begin             //timer flags status
					   io_data_to_cpu[7:0]<=timer_status;
					   timer_status<=8'h00;
					   timer1_int<=0;
					end*/
					
					 'hf1:begin
					   io_data_to_cpu[7:0]<={7'b0000000,raster_line[8:8]};
					 end
					
					'hf0:begin
					   io_data_to_cpu[7:0]<=raster_line[7:0];
					 end
					 
					 'hc1:begin
					   //io_data_to_cpu[7:0]<=adc_data_in[15:8];
					   io_data_to_cpu[7:0]<=poty_latch;
					 end
					 
					 'hc0:begin
					   //io_data_to_cpu[7:0]<=adc_data_in[15:8];
					   io_data_to_cpu[7:0]<=potx_latch;
					 end
					 
					 'h7b:begin        //Internal Timer Flags
					   io_data_to_cpu[7:0]<=timer_status;
					   timer_status<=8'h00;
					   timer1_int<=0;  
					 end
					 
					 'h7a:begin        //GPIO Flags
					   io_data_to_cpu[7:0]<={6'b000000,gpio_reg};
					   timer_status<=8'h00;
					   timer1_int<=0;  
					 end
					 
					 
					08'h53: begin  //AY DATA READ
				          io_data_to_cpu<=io_data_in_from_ay;				          
				          io_reg_to_ay<=1;
				          io_to_ay<=1;                  //ay we active high
				    end
			
			        08'h52: begin  //AY STATUS READ
				          io_data_to_cpu<=io_data_in_from_ay;				          
				          io_reg_to_ay<=0;
				          io_to_ay<=1;                  //ay we active high
				    end
				    
				    08'h50: begin  //OPL STATUS READ
				          io_data_to_cpu<=io_data_in_from_opl;
				          //io_to_ay<=1;     //sid we is active high
				          io_reg_to_opl<=0;
				          io_to_opl<=1;             //opl we active low
				    end

					
					'h39:begin
					    //io_data_to_cpu<=io_data_in_from_i2c[7:0];
						 io_data_to_cpu<=MCP23017_data_out;
					end
					
					'h38:begin
					    //io_data_to_cpu<={io_data_in_from_i2c[31:29],i2c_data_ack,io_data_in_from_i2c[27:24]};
						 io_data_to_cpu<=MCP23017_status;
					end
					
					'h3f:begin
				         io_data_to_cpu<=sd_debug[31:24];
				    end				    
				    'h3e:begin
				         io_data_to_cpu<=sd_debug[23:16];
				    end				    
				    'h3d:begin
				         io_data_to_cpu<=sd_debug[15:8];
				    end				    
				    'h3c:begin
				         io_data_to_cpu<=sd_debug[7:0];
				    end
					
					'h35:begin
				         io_data_to_cpu<=sd_data_in_latch[31:24];
				    end
				    'h34:begin
				         io_data_to_cpu<=sd_data_in_latch[23:16];
				    end
				    'h33:begin
				         io_data_to_cpu<=sd_data_in_latch[15:8];
				    end
				    'h32:begin
				         io_data_to_cpu<=sd_data_in_latch[7:0];
				    end
				    'h31:begin           //special - returns the status bits
				         io_data_to_cpu<=sd_data_in_latch[21:14];
				    end
				    'h30:begin
				        if (sd_ctrl==0)
				        begin
				            io_to_sdcard<=1;
				            io_sdcard_we<=0;
				            sd_ctrl<=1;
				            sd_data_in_latch<=io_data_in_from_sdcard;
				        end
				        else
				        begin
				            io_to_sdcard<=0;
				            io_sdcard_we<=0;
				            //sd_data_in_latch<=io_data_in_from_sdcard;
				        end
				        
				    end
					 
					  8'b001000??:begin
				         io_data_to_cpu<=io_data_in_from_rgb;
				         io_from_rgb<=0;
				    end
				        

					
				/*	'b00110???: begin                      //$30 to $37
					   if (io_address_in[7:0]=='h31)       //read ready status
					   begin
					       io_data_to_cpu<={1'b0,io_data_in_from_sdcard[14:8]};
					   end
					   if (io_address_in[7:0]=='h32)       //read data waiting status
					   begin
					       io_data_to_cpu<={3'b000,io_data_in_from_sdcard[19:15]};
					   end
					   if (io_address_in[7:0]=='h30)       //read data
					   begin
					       io_data_to_cpu<=io_data_in_from_sdcard[7:0];
    					end
    					io_from_sdcard<=1;      //1=active
   					    //io_from_ram<=1;         //0=active
   					    //io_from_matrix<=0;      //1=active
   					    
					 end*/
					 
					 'b00010???: begin                      //$10 to $17   ;read keyboard matriz
					    io_data_to_cpu[7:0]<=io_data_in_from_matrix;						
						//io_from_sdcard<=0;      //1=active
					    //io_from_ram<=1;         //0=active
					    io_from_matrix<=1;      //1=active
					 end
					 
					 'h01:begin			//keyboard read
						io_data_to_cpu<=keyboard_in;
						//io_data_to_cpu[7]<=0;
						//io_from_sdcard<=0;      //1=active
					    //io_from_ram<=1;         //0=active
					    //io_from_matrix<=0;      //1=active
					 end
					
										
					default:begin
					   io_data_to_cpu<=io_data_in_from_ram;
					   io_from_ram<=0;
					   //io_from_sdcard<=0;
					   //io_from_matrix<=0;      //1=active
					   //i2c_write_req<=0;
					end
					
					endcase
					
				end  //-4
		
			end  //-3
			else
			//if ((io_req) || (io_m_in==0))
			begin //+3			     
				io_data_to_ram<=8'bZ;
				io_data_to_rgb<=8'bZ;
				io_data_to_sid<=8'bZ;
				io_data_to_sdcard<=32'bZ;
				//io_data_to_banking<=6'bZ;
				io_data_to_DMA<=8'bZ;
				io_data_to_ay<=8'bz;
		      io_reg_to_ay<=0;
		      io_data_to_opl<=8'bz;
		      io_reg_to_opl<=0;
				io_to_sid<=0;
				io_to_ram<=1;
				io_to_rgb<=1;
				io_to_sprite<=1;
				io_to_sdcard<=0;
			//	io_to_banking<=1;
				io_to_DMA<=1;
				io_to_ay<=1;
				io_to_opl<=1;
				io_from_ram<=1;
				io_from_rgb<=1;
				io_from_matrix<=0;      //1=active				
				io_sdcard_we<=0;			
				i2c_write_req<=0;
				i2c_write_ctrl<=0;
				sd_ctrl<=0;
					       //i2c_write_req<=0;
			     if ((io_req==0) && (io_m_in==0)) io_data_to_cpu<=int_data_bus; else io_data_to_cpu<=8'bZ;
    			 
			end  //-3
			//io_data_inout = ((!io_wr) && (!io_req)) ? io_data_in:8'bZ; //if not writing tri-state
			
			
			
		//	if (z80_int)
	//		begin  //+3
			    if ((keyb_int_in==1) && (int_mask[5]) && (keyb_ctrl==0))
			    begin  //+4
                    kbd_irq_flag<=1;
                    keyb_ctrl<=1;
                    //z80_int_timer<='h20;
				end  //-4
				
				
				if ((spr_int_in==0) && (int_mask[4]) && (spr_ctrl==0))
			    begin  //+4				    
                    spr_irq_flag<=1;
                    spr_ctrl<=1;
				end		//-4
				
				if ((GPIO_int_in==0) && (int_mask[3]) && (gpio_ctrl==0))
			    begin  //+4				    
                    ioa_irq_flag<=1;
                    gpio_ctrl<=1;
                    gpio_reg<=({~GPIOA_int_in,~GPIOB_int_in});
				end		//-4
				//else
				//begin  //+4
                //    kbd_irq_flag<=0;
				//end  //-4
				
				if ((timer1_int==1) && (int_mask[6]) && (tmr1_ctrl==0))
			    begin  //+4				    
                    tmr_irq_flag<=1;           
                    tmr1_ctrl<=1;
				end  //-4
				//else
				//begin  //+4				    
                //    tmr_irq_flag<=0;           
				//end  //-4
				if ((timer2_int_in==0) && (int_mask[7]) && (tmr2_ctrl==0))
			    begin  //+4
			        tmr2_ctrl<=1;
				    snd_irq_flag<=1;           
				end  //-4			
				//else	
				//begin  //+4
				//    snd_irq_flag<=0;           
				//end  //-4
				/*if ((timer2_int_in==0) && (int_ctrl==0) && (int_mask[7]) )
			    begin  //+4
				    z80_int<=0;
				    z80_int_timer<='h20;
				    int_ctrl<=1;
				    tmr2_ctrl<=1;
				    int_status<= 8'b10000000;       //set bit to OPL timer interrupt
				    io_data_to_cpu<=int_data_bus;
				end  //-4*/
/*				if ((button_int_in==1) && (int_ctrl==0) && (int_mask[7]) && (button_ctrl==0))
			    begin //+4
				    z80_int<=0;
				    z80_int_timer<='h20;
				    int_ctrl<=1;
				    button_ctrl<=1;
				    int_status<= 8'b10000000;       //set bit to indicate button pressed interrupt
				    io_data_to_cpu<=int_data_bus;
				end  //-4*/
			    if ((vsync_int_in==0) && (int_mask[0]) && (vsync_ctrl==0))
			    begin  //+4				    
                    vsc_irq_flag<=1;
                    vsync_ctrl<=1;
				end		//-4	   
				//else
				//begin  //+4				    
                //    vsc_irq_flag<=0;
				//end		//-4
				if ((hsync_int_in==0) &&  (int_mask[2:1]) && (hsync_ctrl==0)) 
			    begin  //+4
			        hsync_ctrl<=1;
				    case (int_mask[2:1])
				        'h1:begin
				            hsc_irq_flag<=0;
				            if (raster_line==raster_int) ras_irq_flag<=1; else ras_irq_flag<=0;				            				            
				        end
				        'h2:begin				    
                            hsc_irq_flag<=1;
                            ras_irq_flag<=0;
				        end
				        'h3:begin			
				            hsc_irq_flag<=1;	            
				            if (raster_line==raster_int) ras_irq_flag<=1; else ras_irq_flag<=0;
				        end
				        default: begin
				            ras_irq_flag<=0;
				            hsc_irq_flag<=0;
				        end
				    endcase
				end  //-4
				//else
				//begin
				//    ras_irq_flag<=0;
		        //    hsc_irq_flag<=0;
				//end
			//end  //-3
			
			int_status<={snd_irq_flag,tmr_irq_flag,kbd_irq_flag,spr_irq_flag,ioa_irq_flag,hsc_irq_flag,ras_irq_flag,vsc_irq_flag};
			
			if (int_status==8'h00) z80_int<=1; else z80_int<=0;
		
				/*if (z80_int)
			begin  //+3
			end
            else
            begin  //+3
				
				//vsync_int<=(vsync_int_timer==0);
				if (z80_int_timer==0)
				begin  //+4
				    z80_int<=1;
				    int_ctrl<=0;
				    timer1_int<=0;				    
				    //int_status<= 8'b00000000;
				    //io_data_to_cpu<=8'bZ;
				end  //-4
				else z80_int_timer<=z80_int_timer-1;
				
			
				
			end	  //-3*/
			
			//if (z80_int_timer>0) z80_int_timer<=z80_int_timer-1;
					
			if (vsync_int_in) vsync_ctrl<=0;    //reset control once out of vertical blank
			if (hsync_int_in) hsync_ctrl<=0;    //reset control once out of horizontal blank
			if (spr_int_in) spr_ctrl<=0;       //reset control once out of spr int
			if (timer2_int_in) tmr2_ctrl<=0;    //reset control once out of sound timers
			if (timer1_int==0) tmr1_ctrl<=0;    //reset control once out of sound timers
			if (keyb_int_in==0) keyb_ctrl<=0;    //reset control once keyboard new char assertion is lifted or after specified time
			if (GPIO_int_in==0) gpio_ctrl<=0;    //reset control once keyboard new char assertion is lifted or after specified time
//			if (button_int_in==0) button_ctrl<=0;    //reset control once button is released
	   //end  //-2
	   
	   if(pwm_count < pwm_end)begin
            pwm_count = pwm_count+1;
        end           
        else begin
            pwm_count=0;
        end
    end  //-2    
end  //-1
    

    
endmodule