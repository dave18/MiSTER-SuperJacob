//============================================================================
//  SuperJacob for MiSTer
//  Copyright (C) 2017-2019 Sorgelig
//
//
//  This program is free software; you can redistribute it and/or modify it
//  under the terms of the GNU General Public License as published by the Free
//  Software Foundation; either version 2 of the License, or (at your option)
//  any later version.
//
//  This program is distributed in the hope that it will be useful, but WITHOUT
//  ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
//  FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
//  more details.
//
//  You should have received a copy of the GNU General Public License along
//  with this program; if not, write to the Free Software Foundation, Inc.,
//  51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
//============================================================================

//`define INTERNAL_CPU_RAM

module emu
(
	//Master input clock
	input         CLK_50M,

	//Async reset from top-level module.
	//Can be used as initial reset.
	input         RESET,

	//Must be passed to hps_io module
	inout  [45:0] HPS_BUS,

	//Base video clock. Usually equals to CLK_SYS.
	output        CLK_VIDEO,

	//Multiple resolutions are supported using different CE_PIXEL rates.
	//Must be based on CLK_VIDEO
	output        CE_PIXEL,

	//Video aspect ratio for HDMI. Most retro systems have ratio 4:3.
	output  [7:0] VIDEO_ARX,
	output  [7:0] VIDEO_ARY,

	output  [7:0] VGA_R,
	output  [7:0] VGA_G,
	output  [7:0] VGA_B,
	output        VGA_HS,
	output        VGA_VS,
	output        VGA_DE,    // = ~(VBlank | HBlank)
	output        VGA_F1,
	output  [1:0] VGA_SL,

	output        LED_USER,  // 1 - ON, 0 - OFF.

	// b[1]: 0 - LED status is system status OR'd with b[0]
	//       1 - LED status is controled solely by b[0]
	// hint: supply 2'b00 to let the system control the LED.
	output  [1:0] LED_POWER,
	output  [1:0] LED_DISK,

	// I/O board button press simulation (active high)
	// b[1]: user button
	// b[0]: osd button
	output  [1:0] BUTTONS,

	input         CLK_AUDIO, // 24.576 MHz
	output [15:0] AUDIO_L,
	output [15:0] AUDIO_R,
	output        AUDIO_S,   // 1 - signed audio samples, 0 - unsigned
	output  [1:0] AUDIO_MIX, // 0 - no mix, 1 - 25%, 2 - 50%, 3 - 100% (mono)

	//ADC
	inout   [3:0] ADC_BUS,

	//SD-SPI
	output        SD_SCK,
	output        SD_MOSI,
	input         SD_MISO,
	output        SD_CS,
	input         SD_CD,

	//High latency DDR3 RAM interface
	//Use for non-critical time purposes
	output        DDRAM_CLK,
	input         DDRAM_BUSY,
	output  [7:0] DDRAM_BURSTCNT,
	output [28:0] DDRAM_ADDR,
	input  [63:0] DDRAM_DOUT,
	input         DDRAM_DOUT_READY,
	output        DDRAM_RD,
	output [63:0] DDRAM_DIN,
	output  [7:0] DDRAM_BE,
	output        DDRAM_WE,

	//SDRAM interface with lower latency
	output        SDRAM_CLK,
	output        SDRAM_CKE,
	output [12:0] SDRAM_A,
	output  [1:0] SDRAM_BA,
	inout  [15:0] SDRAM_DQ,
	output        SDRAM_DQML,
	output        SDRAM_DQMH,
	output        SDRAM_nCS,
	output        SDRAM_nCAS,
	output        SDRAM_nRAS,
	output        SDRAM_nWE,

	input         UART_CTS,
	output        UART_RTS,
	input         UART_RXD,
	output        UART_TXD,
	output        UART_DTR,
	input         UART_DSR,

	// Open-drain User port.
	// 0 - D+/RX
	// 1 - D-/TX
	// 2..6 - USR2..USR6
	// Set USER_OUT to 1 to read from USER_IN.
	input   [6:0] USER_IN,
	output  [6:0] USER_OUT,

	input         OSD_STATUS
);

assign USER_OUT = '1;



assign VGA_F1 = 0;
assign VGA_SL = scale ? scale - 1'd1 : 2'd0;
//assign VGA_SL = 0;

assign {UART_RTS, UART_TXD, UART_DTR} = 0;
//assign {SD_SCK, SD_MOSI, SD_CS} = 'Z;
assign {DDRAM_CLK, DDRAM_BURSTCNT, DDRAM_ADDR, DDRAM_DIN, DDRAM_BE, DDRAM_RD, DDRAM_WE} = 0;

assign AUDIO_S   = 0;
assign AUDIO_MIX = 0;//status[3:2];

assign LED_USER  = io_interface_0_led1;//ioctl_download | tape_led | tape_adc_act;
assign LED_DISK  = {1'b1,io_interface_0_led2};
assign LED_POWER = 0;
assign BUTTONS   = 0;

assign VIDEO_ARX = 8'd4;//status[5:4] ? 8'd16 : 8'd4;
assign VIDEO_ARY = 8'd3;//status[5:4] ? 8'd9  : 8'd3;

wire [1:0] scale = status[3:2];

/*localparam ARCH_ZX48  = 5'b011_00; // ZX 48
localparam ARCH_ZX128 = 5'b000_01; // ZX 128/+2
localparam ARCH_ZX3   = 5'b100_01; // ZX 128 +3
localparam ARCH_P48   = 5'b011_10; // Pentagon 48
localparam ARCH_P128  = 5'b000_10; // Pentagon 128
localparam ARCH_P1024 = 5'b001_10; // Pentagon 1024

localparam CONF_BDI   = "(BDI)";
localparam CONF_PLUSD = "(+D) ";
localparam CONF_PLUS3 = "(+3) ";
*/
`include "build_id.v"
localparam CONF_STR = 
{
	"SuperJacob;;",
	"-;",
	"S0,VHD,Mount Virtual SD Card;",
	"-;",
	"O23,Scandoubler Fx,None,HQ2x,CRT 25%,CRT 50%;",
	"O56,Memory Size,512K,1024K,2048K;",
	"-;",
	"R0,Reset;",
	"V,v",`BUILD_DATE
};

reg  [10:0] ps2_key;
wire [31:0] status;
wire [15:0] joystick_0;
wire [15:0] joystick_1;

wire [1:0] mem_option;

wire  [1:0] buttons;

wire [31:0] sd_lba;
wire        sd_rd;
wire        sd_wr;
wire        sd_ack;
wire  [8:0] sd_buff_addr;
wire  [7:0] sd_buff_dout;
wire  [7:0] sd_buff_din;
wire        sd_buff_wr;
wire        img_mounted;
wire        img_readonly;
wire [63:0] img_size;
wire        sd_ack_conf;

wire        forced_scandoubler;
wire [21:0] gamma_bus;

//wire  [1:0] sdram_sz;

hps_io #(.STRLEN(($size(CONF_STR))>>3), .PS2DIV(4000), .PS2WE(0)) hps_io
(
	.clk_sys(clk_sys),
	.HPS_BUS(HPS_BUS),

	.conf_str(CONF_STR),
	.status(status),
	.buttons(buttons),
	.joystick_0(joystick_0),
	.joystick_1(joystick_1),
//	.sdram_sz(sdram_sz),
	
	//.ps2_kbd_clk_out(ps2_kbd_clk_out),
	//.ps2_kbd_data_out(ps2_kbd_data_out),
	//.ps2_kbd_clk_in(ps2_kbd_clk_in),
	//.ps2_kbd_data_in(ps2_kbd_data_in),
	
	.forced_scandoubler(forced_scandoubler),
	.gamma_bus(gamma_bus),

	.ps2_key(ps2_key),
	.ps2_kbd_led_use(0),
	.ps2_kbd_led_status(0),
	
	.sd_lba(sd_lba),
	.sd_rd(sd_rd),
	.sd_wr(sd_wr),
	.sd_ack(sd_ack),
	.sd_ack_conf(sd_ack_conf),
	.sd_buff_addr(sd_buff_addr),
	.sd_buff_dout(sd_buff_dout),
	.sd_buff_din(sd_buff_din),
	.sd_buff_wr(sd_buff_wr),
	.img_mounted(img_mounted),
	.img_readonly(img_readonly),
	.img_size(img_size)
	
);

//wire [7:0]joy0=joystick_0[7:0] ^ 8'hFF;
wire [7:0]joy0={~joystick_0[7],~joystick_0[6],~joystick_0[4],~joystick_0[3],~joystick_0[2],~joystick_0[1],~joystick_0[0],~joystick_0[5]};
wire [7:0]joy1={~joystick_1[7],~joystick_1[6],~joystick_1[4],~joystick_1[3],~joystick_1[2],~joystick_1[1],~joystick_1[0],~joystick_1[5]};

assign mem_option[1:0]=status[6:5];


wire locked;
wire locked2;
wire global_reset_n=~global_reset;
//wire global_reset=(~locked) | (~locked2) | sysreset;
wire global_reset=(~locked) | sysreset;
wire constant_high=1;
wire constant_low=0;
wire sysreset  = buttons[1] | status[0];

////////////////////   CLOCKS   ///////////////////


wire clk_out1;
wire clk_out2;
wire clk_out3;
wire clk_out4;
//wire clk_out5;
wire clk_sys=clk_out2;


sjpll sjpll_inst
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_out1),
	.outclk_1(clk_out2),
	.outclk_2(clk_out3),
	.outclk_3(clk_out4),
//	.outclk_4(clk_out5),
	.locked(locked)
);

/*pll pll_inst
(
	.refclk(CLK_50M),
	.rst(0),
	.outclk_0(clk_sys),
	.locked(locked2)
);*/


//assign CLK_VIDEO = clk_out1;
//assign CE_PIXEL=1;

////////////////////// IO INTERFACE ////////////////////

wire GPIO_INTA_1;
wire GPIO_INTB_1;

//wire [15:0] xadc_wiz_0_do_out;
wire [31:0] I2C_master_0_status;
//wire xadc_wiz_0_drdy_out;
wire io_interface_0_led0_b;
wire io_interface_0_led0_g;
wire io_interface_0_led0_r;
wire io_interface_0_led1;
wire io_interface_0_led2;
wire [6:0] io_interface_0_adc_address_out;
wire [7:0] io_interface_0_io_data_to_cpu;
wire io_interface_0_vsync_int;
wire io_interface_0_io_wait_out;
wire io_interface_0_io_to_ram;
wire io_interface_0_io_from_ram;
wire io_interface_0_io_to_sprite;
wire io_interface_0_io_to_rgb;
wire io_interface_0_io_from_rgb;
wire io_interface_0_io_to_sid;
wire io_interface_0_io_to_sdcard;
//wire io_interface_0_io_to_banking;
wire io_interface_0_io_sdcard_we;
wire io_interface_0_io_from_matrix;
wire sdcard_speed;	//not connected
wire sdcard_ss;		//not connected
wire io_interface_0_io_to_DMA;
wire [15:0] io_interface_0_io_address_out;	
wire [7:0] io_interface_0_io_data_to_sprite;
wire [7:0] io_interface_0_io_data_to_rgb;
wire [7:0] io_interface_0_io_data_to_sid;
wire [7:0] io_interface_0_io_data_to_ram;
//wire [5:0] io_interface_0_io_data_to_banking;
wire [31:0] io_interface_0_io_data_to_sdcard;
wire [1:0] io_interface_0_io_addr_to_sdcard;
wire io_interface_0_io_cyc_to_sdcard;
wire [31:0] io_interface_0_io_data_to_i2c;
wire [7:0] io_interface_0_potx_latch;
wire [7:0] io_interface_0_poty_latch;
wire io_interface_0_i2c_write_ctrl;
wire [7:0] io_interface_0_io_data_to_DMA;
wire io_interface_0_i2c_data_ack;
wire io_interface_0_io_to_ay;
wire io_interface_0_io_to_opl;
wire io_interface_0_io_reg_to_AY;
wire io_interface_0_io_reg_to_opl;
wire [7:0] io_interface_0_io_data_to_ay;
wire [7:0] io_interface_0_io_data_to_opl;
wire [7:0] bank7;
wire [7:0] bank6;
wire [7:0] bank5;
wire [7:0] bank4;
wire [7:0] bank3;
wire [7:0] bank2;
wire [7:0] bank1;
wire [7:0] bank0;
wire rom_select;

//wire [7:0] MCP23017_data_out;
//wire [7:0] MCP23017_status;

io_interface io_interface_0 (
    .nReset(global_reset_n),
    .keyboard_in(ps2_keyboard_to_ascii_0_ascii_code),
    .vsync_int_in(SyncGen_0_v_sync_int),
    .hsync_int_in(SyncGen_0_h_sync_int),
    .GPIOA_int_in(GPIO_INTA_1),
    .GPIOB_int_in(GPIO_INTB_1),
    .keyb_int_in(ps2_keyboard_to_ascii_0_ascii_new),
	 .opl_int_in(jtopl_0_irq_n),
	 .ay_int_in(jt03_0_irq_n),
	 .spr_int_in(spr_int),
    .io_m_in(z80_top_direct_n_0_nM1),
    .io_wait_in(videoInterface_0_cpu_wait),
    .io_data_in_from_cpu(data_to_io),
    .io_data_in_from_ram(videoInterface_0_io_data_out),
	 .io_data_in_from_rgb(createRGB_0_io_data_out),
	 .io_data_in_from_ay(jt03_0_dout),
	 .io_data_in_from_opl(jtopl_0_dout),
    .io_data_in_from_sid(sid8580_wrapper_0_data_out),
    .io_data_in_from_matrix(keyboard_matrix_0_io_data_out),
    .io_data_in_from_sdcard(sdspi_0_o_wb_data),
    .CounterY(SyncGen_0_CounterY),
    //.adc_data_in(xadc_wiz_0_do_out),
	 .adc_1_in(adc_1),
	 .adc_2_in(adc_2),
    .sysclk(clk_out2),
    .io_req(io_status),
    .io_wr(z80_top_direct_n_0_nWR),
    .io_rd(z80_top_direct_n_0_nRD),
    .io_address_in(z80_top_direct_n_0_A),
    .io_data_in_from_i2c(I2C_master_0_status),
    .sd_debug(sdspi_0_o_debug),
    .sd_ack(sdspi_0_o_wb_ack),
	 .joy0(joy0),
	 .joy1(joy1),
    //.adc_ready(xadc_wiz_0_drdy_out),
    .led0_b(io_interface_0_led0_b),
    .led0_g(io_interface_0_led0_g),
    .led0_r(io_interface_0_led0_r),
    .led1(io_interface_0_led1),
    .led2(io_interface_0_led2),
    .adc_address_out(io_interface_0_adc_address_out),
    .io_data_to_cpu(io_interface_0_io_data_to_cpu),
    .z80_int(io_interface_0_vsync_int),
    .io_wait_out(io_interface_0_io_wait_out),
    .io_to_ram(io_interface_0_io_to_ram),
    .io_from_ram(io_interface_0_io_from_ram),
    .io_to_sprite(io_interface_0_io_to_sprite),
    .io_to_rgb(io_interface_0_io_to_rgb),
	 .io_from_rgb(io_interface_0_io_from_rgb),
    .io_to_sid(io_interface_0_io_to_sid),
    .io_to_sdcard(io_interface_0_io_to_sdcard),
//    .io_to_banking(io_interface_0_io_to_banking),
	 .io_to_ay(io_interface_0_io_to_ay),
	 .io_to_opl(io_interface_0_io_to_opl),
    .io_sdcard_we(io_interface_0_io_sdcard_we),
    .io_from_matrix(io_interface_0_io_from_matrix),
    .sdcard_speed(sdcard_speed),
    .sdcard_ss(sdcard_ss),
    .io_to_DMA(io_interface_0_io_to_DMA),
    .io_address_out(io_interface_0_io_address_out),
    .io_data_to_sprite(io_interface_0_io_data_to_sprite),
    .io_data_to_ram(io_interface_0_io_data_to_ram),
    .io_data_to_rgb(io_interface_0_io_data_to_rgb),
    .io_data_to_sid(io_interface_0_io_data_to_sid),
	 .io_reg_to_ay(io_interface_0_io_reg_to_AY),
	 .io_reg_to_opl(io_interface_0_io_reg_to_opl),
	 .io_data_to_ay(io_interface_0_io_data_to_ay),
	 .io_data_to_opl(io_interface_0_io_data_to_opl),
//    .io_data_to_banking(io_interface_0_io_data_to_banking),
    .io_data_to_sdcard(io_interface_0_io_data_to_sdcard),
    .io_addr_to_sdcard(io_interface_0_io_addr_to_sdcard),
    .io_cyc_to_sdcard(io_interface_0_io_cyc_to_sdcard),
    .io_data_to_i2c(io_interface_0_io_data_to_i2c),
    .potx_latch(io_interface_0_potx_latch),
    .poty_latch(io_interface_0_poty_latch),
    .i2c_write_ctrl(io_interface_0_i2c_write_ctrl),
    .io_data_to_DMA(io_interface_0_io_data_to_DMA),
    .i2c_data_ack(io_interface_0_i2c_data_ack),
	 .bank7(bank7),
	 .bank6(bank6),
	 .bank5(bank5),
	 .bank4(bank4),
	 .bank3(bank3),
	 .bank2(bank2),
	 .bank1(bank1),
	 .bank0(bank0),
	 .romsel(rom_select),
	 .mem_option(mem_option)
	 //.MCP23017_data_out(MCP23017_data_out),
	 //,MCP23017_status(MCP23017_status)
  );
  
 ///////////////////// VIDEO INTERFACE //////////////////////
 wire [7:0] videoInterface_0_io_data_out;
 wire [16:0] videoInterface_0_video_address;  //external signal
 wire [7:0] videoInterface_0_v_data_out;
 wire [11:0] videoInterface_0_v_data;
 wire [11:0] videoInterface_0_v_data2;
 wire [15:0] videoInterface_0_p_data_out;
 wire [7:0] videoInterface_0_p_address_read;
 wire [7:0] videoInterface_0_p_address_write;
 wire videoInterface_0_p_wren;
 wire [8:0] videoInterface_0_ls_address;
 wire [11:0] videoInterface_0_ls_data_out;
 wire videoInterface_0_ls_wren;
 wire [8:0] videoInterface_0_ls_address2;
 wire [11:0] videoInterface_0_ls_data_out2;
 wire videoInterface_0_ls_wren2;
 wire [8:0] videoInterface_0_ls_address3;
 wire [0:0] videoInterface_0_ls_data_out3;
 wire videoInterface_0_ls_wren3;
 wire [5:0] videoInterface_0_cr_address;
 wire [7:0] videoInterface_0_cr_data_out;
 wire videoInterface_0_cr_wren;
 wire [10:0] videoInterface_0_character_rom_address;
 wire videoInterface_0_vid_oe;
 wire videoInterface_0_vid_we_out;
 wire [12:0] videoInterface_0_tilemap0_address_write;
 wire [7:0] videoInterface_0_tilemap0_data_out;
 wire [11:0] videoInterface_0_tilemap0_address_read;
 wire videoInterface_0_tilemap0_we;
 wire [12:0] videoInterface_0_tilemap1_address_write;
 wire [7:0] videoInterface_0_tilemap1_data_out;
 wire [11:0] videoInterface_0_tilemap1_address_read;
 wire videoInterface_0_tilemap1_we;
 wire videoInterface_0_foreground_enable;
 wire videoInterface_0_foregroundmask;
 wire videoInterface_0_cpu_wait;
 wire [15:0] videoInterface_0_dac_out;
 wire [15:0] videoInterface_0_dac_out1;
 wire [15:0] videoInterface_0_dac_out2;
 wire [15:0] videoInterface_0_dac_out3;
 wire videoInterface_0_sample_playing;
 wire videoInterface_0_sample_playing1;
 wire videoInterface_0_sample_playing2;
 wire videoInterface_0_sample_playing3;
 
  
 videoInterface videoInterface_0  (
    .clk(clk_out2),
    .vga_v_sync(SyncGen_0_vga_v_sync),
    .CounterX(SyncGen_0_CounterX),
    .CounterY(SyncGen_0_CounterY),
    .inDisplayArea(SyncGen_0_inDisplayArea),
    .p_data_in(palette_ram_0_doutb),
	 .p_data_in2(palette_ram_0_douta),
    .ls_data_in(blk_mem_gen_1_douta),
    .ls_data_in2(line_store_ram_2_douta),
    .ls_data_in3(line_store_ram_3_douta),
    .cr_data_in(blk_mem_gen_2_douta),
    .io_in(io_interface_0_io_to_ram), //io
    .io_out(io_interface_0_io_from_ram), //io
    .io_addr_in(io_interface_0_io_address_out), //io
    .io_data_in(io_interface_0_io_data_to_ram), //io
    .character_rom_in(character_rom_douta),
    .tilemap0_data_in(blk_mem_tilemap_0_doutb),
    .tilemap1_data_in(blk_mem_tilemap_1_doutb),
	 .tilemap0_data_in2(blk_mem_tilemap_0_douta),
    .tilemap1_data_in2(blk_mem_tilemap_1_douta),
    .scanlines(SyncGen_0_scanlines),
    .nreset(global_reset_n),
    .io_data_out(videoInterface_0_io_data_out), //io
    .video_address(videoInterface_0_video_address),
    .v_data(videoInterface_0_v_data),
    .v_data2(videoInterface_0_v_data2),
    .v_data_out(videoInterface_0_v_data_out),
    .v_data_in(sram_tristate_0_data_from_sram),
    .p_address_read(videoInterface_0_p_address_read),
    .p_address_write(videoInterface_0_p_address_write),
    .p_data_out(videoInterface_0_p_data_out),
    .p_wren(videoInterface_0_p_wren),
    .ls_address(videoInterface_0_ls_address),
    .ls_data_out(videoInterface_0_ls_data_out),
    .ls_address2(videoInterface_0_ls_address2),
    .ls_address3(videoInterface_0_ls_address3),
    .ls_data_out2(videoInterface_0_ls_data_out2),
    .ls_data_out3(videoInterface_0_ls_data_out3),
    .ls_wren(videoInterface_0_ls_wren),
    .ls_wren2(videoInterface_0_ls_wren2),
    .ls_wren3(videoInterface_0_ls_wren3),
    .cr_address(videoInterface_0_cr_address),
    .cr_data_out(videoInterface_0_cr_data_out),
    .character_rom_address(videoInterface_0_character_rom_address),
    .cr_wren(videoInterface_0_cr_wren),
    .vid_oe(videoInterface_0_vid_oe),
    .vid_we_out(videoInterface_0_vid_we_out),
    .tilemap0_address_read(videoInterface_0_tilemap0_address_read),
    .tilemap0_address_write(videoInterface_0_tilemap0_address_write),
    .tilemap1_address_read(videoInterface_0_tilemap1_address_read),
    .tilemap1_address_write(videoInterface_0_tilemap1_address_write),
    .tilemap0_we(videoInterface_0_tilemap0_we),
    .tilemap1_we(videoInterface_0_tilemap1_we),
    .tilemap0_data_out(videoInterface_0_tilemap0_data_out),
    .tilemap1_data_out(videoInterface_0_tilemap1_data_out),
    .foreground_enable(videoInterface_0_foreground_enable),
    .cpu_wait(videoInterface_0_cpu_wait),
    .dac_out(videoInterface_0_dac_out),
    .dac_out1(videoInterface_0_dac_out1),
    .dac_out2(videoInterface_0_dac_out2),
    .dac_out3(videoInterface_0_dac_out3),
    .sample_playing(videoInterface_0_sample_playing),
    .sample_playing1(videoInterface_0_sample_playing1),
    .sample_playing2(videoInterface_0_sample_playing2),
    .sample_playing3(videoInterface_0_sample_playing3),
    .foregroundmask(videoInterface_0_foregroundmask)
  );

  
/////////////////// VIDEO RAM - VRAM //////////////
wire [7:0] sram_tristate_0_data_from_sram;


vram	vram_0 (
	.address (videoInterface_0_video_address),
	.clock (clk_out2),
	.data (videoInterface_0_v_data_out),
	.wren (videoInterface_0_vid_we_out),
	.q (sram_tristate_0_data_from_sram)
	);
	
/*vram2port vram_0 (
	.clock (clk_out2),
	.data (videoInterface_0_v_data_out),
	.rdaddress (videoInterface_0_video_address),
	.wraddress (videoInterface_0_video_address),
	.wren (~videoInterface_0_vid_we),
	.q (sram_tristate_0_data_from_sram)
	);*/

  
  
//////////////////////LINE STORE RAM/////////////////////////
wire [11:0] blk_mem_gen_1_douta;
wire [11:0] line_store_ram_2_douta;
wire [0:0] line_store_ram_3_douta;

line_store_ram	line_store_ram_1 (
	.address (videoInterface_0_ls_address),
	.clock (clk_out2),
	.data (videoInterface_0_ls_data_out),
	.wren (videoInterface_0_ls_wren),
	.q (blk_mem_gen_1_douta)
	);
	
line_store_ram	line_store_ram_2 (
	.address (videoInterface_0_ls_address2),
	.clock (clk_out2 ),
	.data (videoInterface_0_ls_data_out2),
	.wren (videoInterface_0_ls_wren2),
	.q (line_store_ram_2_douta)
	);
	
line_store_ram_1bit line_store_ram_3 (
	.address (videoInterface_0_ls_address3),
	.clock (clk_out2),
	.data (videoInterface_0_ls_data_out3),
	.wren (videoInterface_0_ls_wren3),
	.q (line_store_ram_3_douta)
	);
  
  
//////////////////////CHARACTER ROM/////////////////////
wire [7:0] character_rom_douta;

character_rom	character_rom_inst (
	.address (videoInterface_0_character_rom_address),
	.clock (clk_out2),
	.q (character_rom_douta)
	);
	
///////////////////// CHARACTER RAM ////////////////////
wire [7:0] blk_mem_gen_2_douta;

character_ram	character_ram_2 (
	.address (videoInterface_0_cr_address),
	.clock (clk_out2 ),
	.data (videoInterface_0_cr_data_out ),
	.wren (videoInterface_0_cr_wren),
	.q (blk_mem_gen_2_douta)
	);

	
///////////////////// TILEMAP RAM //////////////////////
wire [7:0] blk_mem_tilemap_0_douta;
wire [15:0] blk_mem_tilemap_0_doutb;
wire [7:0] blk_mem_tilemap_1_douta;
wire [15:0] blk_mem_tilemap_1_doutb;


blk_mem_tilemap	blk_mem_tilemap_0 (
	.clock (clk_out2),
	.data_a (videoInterface_0_tilemap0_data_out),
	.address_b (videoInterface_0_tilemap0_address_read),
	.address_a (videoInterface_0_tilemap0_address_write),
	.wren_a (videoInterface_0_tilemap0_we),
	.wren_b (constant_low),
	.q_a (blk_mem_tilemap_0_douta),
	.q_b (blk_mem_tilemap_0_doutb)
	);
	
blk_mem_tilemap	blk_mem_tilemap_1 (
	.clock (clk_out2),
	.data_a (videoInterface_0_tilemap1_data_out),
	.address_b (videoInterface_0_tilemap1_address_read),
	.address_a (videoInterface_0_tilemap1_address_write),
	.wren_a (videoInterface_0_tilemap1_we),
	.wren_b (constant_low),
	.q_a (blk_mem_tilemap_1_douta),
	.q_b (blk_mem_tilemap_1_doutb)
	);
	
///////////////////// PALETTE RAM //////////////////////
wire [15:0] palette_ram_0_douta;
wire [15:0] palette_ram_0_doutb;



/*palette_ram	palette_ram_0 (
	.clock (clk_out2),
	.data (videoInterface_0_p_data_out),
	.rdaddress (videoInterface_0_p_address_read),
	.wraddress (videoInterface_0_p_address_write),
	.wren (videoInterface_0_p_wren),
	.q (palette_ram_0_doutb)
	);*/
	
palette_ram_TDP	palette_ram_0 (
	.address_a ( videoInterface_0_p_address_write ),
	.address_b ( videoInterface_0_p_address_read ),
	.clock ( clk_out2),
	.data_a ( videoInterface_0_p_data_out ),
	//.data_b ( data_b_sig ),
	.wren_a (videoInterface_0_p_wren),
	.wren_b ( constant_low ),
	.q_a ( palette_ram_0_douta ),
	.q_b ( palette_ram_0_doutb )
	);
	
	
///////////////// SPRITE GENERATOR /////////////////////
wire [15:0] sprite_gen_0_spr_pal_out;
wire [7:0] sprite_gen_0_spr_pal_address_read;
wire [7:0] sprite_gen_0_spr_pal_address_write;
wire [15:0] sprite_gen_0_spr_pal_out2;
wire [7:0] sprite_gen_0_spr_pal_address_read2;
wire [7:0] sprite_gen_0_spr_pal_address_write2;
wire sprite_gen_0_spr_pal_we;
wire sprite_gen_0_spr_pal_we2;
wire [8:0] sprite_gen_0_line_store_read;
wire [8:0] sprite_gen_0_line_store_write;
wire [8:0] sprite_gen_0_line_store_read2;
wire [8:0] sprite_gen_0_line_store_write2;
wire sprite_gen_0_line_store_we;
wire sprite_gen_0_line_store_we2;
wire [7:0] sprite_gen_0_line_store_data_out;
wire [7:0] sprite_gen_0_line_store_data_out2;
wire [8:0] sprite_gen_0_line_store2_read;
wire [8:0] sprite_gen_0_line_store2_write;
wire [8:0] sprite_gen_0_line_store2_read2;
wire [8:0] sprite_gen_0_line_store2_write2;
wire sprite_gen_0_line_store2_we;
wire sprite_gen_0_line_store2_we2;
wire [7:0] sprite_gen_0_line_store2_data_out;
wire [7:0] sprite_gen_0_line_store2_data_out2;
wire [8:0] sprite_gen_0_line_store_read_2;
wire [8:0] sprite_gen_0_line_store_write_2;
wire [8:0] sprite_gen_0_line_store_read2_2;
wire [8:0] sprite_gen_0_line_store_write2_2;
wire sprite_gen_0_line_store_we_2;
wire sprite_gen_0_line_store_we2_2;
wire [7:0] sprite_gen_0_line_store_data_out_2;
wire [7:0] sprite_gen_0_line_store_data_out2_2;
wire [7:0] sprite_gen_0_spr_data_out;
wire sprite_gen_0_spr_active;
wire sprite_gen_0_spr_active2;
wire [11:0] sprite_gen_0_spr_vid_out;
wire [11:0] sprite_gen_0_spr_vid_out2;
wire sprite_gen_0_spr_we;
wire [9:0] sprite_gen_0_spr_address_read;
wire [13:0] sprite_gen_0_spr_address_write;
wire [7:0] sprite_gen_0_sprite_attr_data_out;
wire sprite_gen_0_spr_attr_we;
wire [6:0] sprite_gen_0_sprite_attr_addr_read;
wire [9:0] sprite_gen_0_sprite_attr_addr_write;



sprite_gen sprite_gen_0 (
    .clk(clk_out2),
    .nReset(global_reset_n),
    .CounterX(SyncGen_0_CounterX),
    .CounterY(SyncGen_0_CounterY),
    .spr_data_in(sprite_ram_doutb),
    .spr_pal_in(palette_ram_1_doutb),
    .spr_pal_in2(spr_palette_ram1_doutb),
    .line_store_data_in(sprite_line_0_doutb),
    .line_store_data_in2(sprite_line_1_doutb),
    .line_store_data_in_2(sprite_line_3_doutb),
    .line_store_data_in2_2(sprite_line_2_doutb),
    .line_store2_data_in(sprite_line_store_doutb),
    .line_store2_data_in2(sprite_line_store1_doutb),
    .io_address_in(io_interface_0_io_address_out),
    .io_data_in(io_interface_0_io_data_to_sprite),
    .io_in(io_interface_0_io_to_sprite),
    .sprite_attr_data_in(sprite_attributes_doutb),
    .spr_pal_out(sprite_gen_0_spr_pal_out),
    .spr_pal_address_read(sprite_gen_0_spr_pal_address_read),
    .spr_pal_address_write(sprite_gen_0_spr_pal_address_write),
    .spr_pal_out2(sprite_gen_0_spr_pal_out2),
    .spr_pal_address_read2(sprite_gen_0_spr_pal_address_read2),
    .spr_pal_address_write2(sprite_gen_0_spr_pal_address_write2),
    .spr_pal_we(sprite_gen_0_spr_pal_we),
    .spr_pal_we2(sprite_gen_0_spr_pal_we2),
    .line_store_read(sprite_gen_0_line_store_read),
    .line_store_write(sprite_gen_0_line_store_write),
    .line_store_read2(sprite_gen_0_line_store_read2),
    .line_store_write2(sprite_gen_0_line_store_write2),
    .line_store_we(sprite_gen_0_line_store_we),
    .line_store_we2(sprite_gen_0_line_store_we2),
    .line_store_data_out(sprite_gen_0_line_store_data_out),
    .line_store_data_out2(sprite_gen_0_line_store_data_out2),
    .line_store2_read(sprite_gen_0_line_store2_read),
    .line_store2_write(sprite_gen_0_line_store2_write),
    .line_store2_read2(sprite_gen_0_line_store2_read2),
    .line_store2_write2(sprite_gen_0_line_store2_write2),
    .line_store2_we(sprite_gen_0_line_store2_we),
    .line_store2_we2(sprite_gen_0_line_store2_we2),
    .line_store2_data_out(sprite_gen_0_line_store2_data_out),
    .line_store2_data_out2(sprite_gen_0_line_store2_data_out2),
    .line_store_read_2(sprite_gen_0_line_store_read_2),
    .line_store_write_2(sprite_gen_0_line_store_write_2),
    .line_store_read2_2(sprite_gen_0_line_store_read2_2),
    .line_store_write2_2(sprite_gen_0_line_store_write2_2),
    .line_store_we_2(sprite_gen_0_line_store_we_2),
    .line_store_we2_2(sprite_gen_0_line_store_we2_2),
    .line_store_data_out_2(sprite_gen_0_line_store_data_out_2),
    .line_store_data_out2_2(sprite_gen_0_line_store_data_out2_2),
    .spr_data_out(sprite_gen_0_spr_data_out),
    .spr_active(sprite_gen_0_spr_active),
    .spr_active2(sprite_gen_0_spr_active2),
    .spr_vid_out(sprite_gen_0_spr_vid_out),
    .spr_vid_out2(sprite_gen_0_spr_vid_out2),
    .spr_we(sprite_gen_0_spr_we),
    .spr_address_read(sprite_gen_0_spr_address_read),
    .spr_address_write(sprite_gen_0_spr_address_write),
    .sprite_attr_data_out(sprite_gen_0_sprite_attr_data_out),
    .spr_attr_we(sprite_gen_0_spr_attr_we),
    .sprite_attr_addr_read(sprite_gen_0_sprite_attr_addr_read),
    .sprite_attr_addr_write(sprite_gen_0_sprite_attr_addr_write)
  );

///////////////// SPRITE PATTERN RAM ///////////////////
wire [127:0] sprite_ram_doutb;

spr_patt_ram	sprite_ram (
	.clock (clk_out2),
	.data (SpriteDMA_0_sprdata),
	.rdaddress (sprite_gen_0_spr_address_read),
	.wraddress (SpriteDMA_0_spraddr),
	.wren (SpriteDMA_0_spr_we),
	.q (sprite_ram_doutb)
	);


///////////////// SPR LINE RAMS ////////////////////////
wire [7:0] sprite_line_0_doutb;

spr_ram	sprite_line_0 (
	.clock (clk_out2),
	.data (sprite_gen_0_line_store_data_out),
	.rdaddress (sprite_gen_0_line_store_read),
	.wraddress (sprite_gen_0_line_store_write),
	.wren (sprite_gen_0_line_store_we),
	.q (sprite_line_0_doutb)
	);
	
wire [7:0] sprite_line_1_doutb;

spr_ram	sprite_line_1 (
	.clock (clk_out2),
	.data (sprite_gen_0_line_store_data_out2),
	.rdaddress (sprite_gen_0_line_store_read2),
	.wraddress (sprite_gen_0_line_store_write2),
	.wren (sprite_gen_0_line_store_we2),
	.q (sprite_line_1_doutb)
	);
	
wire [7:0] sprite_line_2_doutb;

spr_ram	sprite_line_2 (
	.clock (clk_out2),
	.data (sprite_gen_0_line_store_data_out2_2),
	.rdaddress (sprite_gen_0_line_store_read2_2),
	.wraddress (sprite_gen_0_line_store_write2_2),
	.wren (sprite_gen_0_line_store_we2_2),
	.q (sprite_line_2_doutb)
	);
	
wire [7:0] sprite_line_3_doutb;

spr_ram	sprite_line_3 (
	.clock (clk_out2),
	.data (sprite_gen_0_line_store_data_out_2),
	.rdaddress (sprite_gen_0_line_store_read_2),
	.wraddress (sprite_gen_0_line_store_write_2),
	.wren (sprite_gen_0_line_store_we_2),
	.q (sprite_line_3_doutb)
	);
	
wire [7:0] sprite_line_store_doutb;	

spr_ram	sprite_line_store (
	.clock (clk_out2),
	.data (sprite_gen_0_line_store2_data_out),
	.rdaddress (sprite_gen_0_line_store2_read),
	.wraddress (sprite_gen_0_line_store2_write),
	.wren (sprite_gen_0_line_store2_we),
	.q (sprite_line_store_doutb)
	);
	
wire [7:0] sprite_line_store1_doutb;	

spr_ram	sprite_line_store1 (
	.clock (clk_out2),
	.data (sprite_gen_0_line_store2_data_out2),
	.rdaddress (sprite_gen_0_line_store2_read2),
	.wraddress (sprite_gen_0_line_store2_write2),
	.wren (sprite_gen_0_line_store2_we2),
	.q (sprite_line_store1_doutb)
	);
	
///////////// SPRITE PALETTE RAM //////////////////////
wire [15:0] palette_ram_1_doutb;

palette_ram	spr_palette_ram (
	.clock (clk_out2),
	.data (sprite_gen_0_spr_pal_out),
	.rdaddress (sprite_gen_0_spr_pal_address_read),
	.wraddress (sprite_gen_0_spr_pal_address_write),
	.wren (sprite_gen_0_spr_pal_we),
	.q (palette_ram_1_doutb)
	);
	
wire [15:0] spr_palette_ram1_doutb;

palette_ram	spr_palette_ram1 (
	.clock (clk_out2),
	.data (sprite_gen_0_spr_pal_out2),
	.rdaddress (sprite_gen_0_spr_pal_address_read2),
	.wraddress (sprite_gen_0_spr_pal_address_write2),
	.wren (sprite_gen_0_spr_pal_we2),
	.q (spr_palette_ram1_doutb)
	);
	
//////////// SPRITE ATTRIBUTE RAM //////////////////////
wire [63:0] sprite_attributes_doutb;

spr_attr	sprite_attributes (
	.clock (clk_out2),
	.data (SpriteDMA_0_sprdata_attr),
	.rdaddress (sprite_gen_0_sprite_attr_addr_read),
	.wraddress (SpriteDMA_0_spraddr_attr),
	.wren (SpriteDMA_0_spr_we_attr),
	.q (sprite_attributes_doutb)
	);
	
	
////////////////// SPRITE DMA //////////////////////////
wire [7:0] SpriteDMA_0_sprdata;
wire [20:0] SpriteDMA_0_cpuaddr;
wire [13:0] SpriteDMA_0_spraddr;
wire SpriteDMA_0_spr_we;
wire [7:0] SpriteDMA_0_sprdata_attr;
wire [9:0] SpriteDMA_0_spraddr_attr;
wire SpriteDMA_0_spr_we_attr;
wire SpriteDMA_0_DMAassert;
wire SpriteDMA_0_Z80_clk_ctrl;
wire DMA_read;

SpriteDMA SpriteDMA_0 (
    .clk(clk_out2),
    .normal_spr_data_in(sprite_gen_0_spr_data_out),
    .normal_spr_addr_in(sprite_gen_0_spr_address_write),
    .normal_spr_we(sprite_gen_0_spr_we),
    .attr_spr_data_in(sprite_gen_0_sprite_attr_data_out),
    .attr_spr_addr_in(sprite_gen_0_sprite_attr_addr_write),
    .attr_spr_we(sprite_gen_0_spr_attr_we),
    .cpudata(ram_dout),
	 .DMA_read(DMA_read),
    .io_data_in(io_interface_0_io_data_to_DMA),
    .io_addr_in(io_interface_0_io_address_out),
    .sprdata(SpriteDMA_0_sprdata),
    .cpuaddr(SpriteDMA_0_cpuaddr),
    .spraddr(SpriteDMA_0_spraddr),
    .spr_we(SpriteDMA_0_spr_we),
    .sprdata_attr(SpriteDMA_0_sprdata_attr),
    .spraddr_attr(SpriteDMA_0_spraddr_attr),
    .spr_we_attr(SpriteDMA_0_spr_we_attr),
    .DMAassert(SpriteDMA_0_DMAassert),
    .Z80_clk_ctrl(SpriteDMA_0_Z80_clk_ctrl),
    .ioreq(io_interface_0_io_to_DMA),
	 .ram_ready(ram_ready)
  );
  
////////////////////// Z80 ROM /////////////////////////
wire [7:0]z80_rom_0_douta;
wire [13:0] rom_addr;

z80_rom z80_rom_0 (
	.address(rom_addr),
	.clock(clk_out2),
	.q(z80_rom_0_douta)
);

/*

////////////////////////ROM INTERFACE ///////////////////
wire [7:0] rom_interface_0_data_out;
wire [18:0] ram_output_addr;
wire [13:0] rom_interface_0_rom_output_addr;
wire [7:0] data_write;
wire we_out;
wire rd_out;
wire ram_wait;
wire [7:0] z80_data_tristate_0_cpu_data_out;
wire [7:0] z80_data_tristate_0_data_to_io;
wire z80_data_tristate_0_io_low;


rom_interface rom_interface_0 (
    .clk(clk_out2),
    .nReset(global_reset_n),
    .dma_addr(SpriteDMA_0_cpuaddr),
    .dma_assert(SpriteDMA_0_DMAasset),
    .input_addr(z80_top_direct_n_0_A),
    .rom_data(z80_rom_0_douta),
    .we(z80_top_direct_n_0_nWR),
	 .rd(z80_top_direct_n_0_nRD),
//    .data_in(z80_data_tristate_0_data_in_from_device),
	 //.data_in(T80a_0_data_out),
    .mem_req(z80_top_direct_n_0_nMREQ),
    .m1(z80_top_direct_n_0_nM1),
    .io_address_in(io_interface_0_io_address_out),
    .io_data_in(io_interface_0_io_data_to_banking),
    .io_req(io_interface_0_io_to_banking),
    .nmi_in(constant_high),
    .ram_output_addr(ram_output_addr),	//address to external memory
    .rom_output_addr(rom_interface_0_rom_output_addr),
 //   .data_out(rom_interface_0_data_out),
    .we_out(we_out),				//we to external memory
	 .rd_out(rd_out),				//we to external memory
    .data_write(data_write),	//data to external memory
	 //.ram_data(ram_data),
	 .ram_data(ram_data),
	 .ram_ready(ram_ready),
	 .ram_wait(ram_wait),
	 .cpu_data_out(z80_data_tristate_0_cpu_data_out),
	 .cpu_data_in(T80a_0_data_out),
	 .data_from_io(io_interface_0_io_data_to_cpu),
    .data_to_io(z80_data_tristate_0_data_to_io),
    .io_low(z80_data_tristate_0_io_low)
  );
*/
/////////////////////Z80 DATA TRISTATE //////////////////

//wire [7:0] z80_data_tristate_0_data_in_from_device;
//wire [7:0] z80_data_tristate_0_cpu_data_out;
//wire [7:0] z80_data_tristate_0_data_to_io;
//wire z80_data_tristate_0_io_low;

 //z80_data_tristate z80_data_tristate_0 (
//    .clk(clk_out2),
//    .mreq(z80_top_direct_n_0_nMREQ),
//    .rd(z80_top_direct_n_0_nRD),
//    .wr(z80_top_direct_n_0_nWR),
//    .ioreq(T80a_0_IORQ_n),
//    .m1(z80_top_direct_n_0_nM1),
//    .data_from_memory(rom_interface_0_data_out),
//    .cpu_data_in(T80a_0_data_out),
//    .cpu_data_out(z80_data_tristate_0_cpu_data_out),
//    .data_to_memory(z80_data_tristate_0_data_in_from_device),
//    .data_from_io(io_interface_0_io_data_to_cpu),
//    .data_to_io(z80_data_tristate_0_data_to_io),
//    .io_low(z80_data_tristate_0_io_low)
  //);
  
  
reg  [24:0] ram_addr;
reg   [7:0] ram_din;
reg         ram_we;
reg         ram_rd;
wire  [7:0] ram_dout;
wire        ram_ready;
reg	[7:0]	data_to_io;
reg			ram_wait;

always_comb begin
	casex({SpriteDMA_0_DMAassert,z80_top_direct_n_0_A[15:13]})
		'b0_XXX: ram_addr = SpriteDMA_0_cpuaddr;
		'b1_111: ram_addr={bank7,z80_top_direct_n_0_A[12:0]};
		'b1_110: ram_addr={bank6,z80_top_direct_n_0_A[12:0]};
		'b1_101: ram_addr={bank5,z80_top_direct_n_0_A[12:0]};
		'b1_100: ram_addr={bank4,z80_top_direct_n_0_A[12:0]};
		'b1_011: ram_addr={bank3,z80_top_direct_n_0_A[12:0]};
		'b1_010: ram_addr={bank2,z80_top_direct_n_0_A[12:0]};
		'b1_001: ram_addr={bank1,z80_top_direct_n_0_A[12:0]};
		'b1_000: ram_addr={bank0,z80_top_direct_n_0_A[12:0]};
	
	endcase
	rom_addr=z80_top_direct_n_0_A[13:0];
	
	ram_din=T80a_0_data_out;
	data_to_io=T80a_0_data_out;
	
	casex({(~z80_top_direct_n_0_nMREQ & ~z80_top_direct_n_0_nRD),~DMA_read})
		2'b11,2'b10,2'b01: ram_rd=1;
		2'b00: ram_rd=0;
	endcase
	
	casex ({(~z80_top_direct_n_0_nMREQ & ~z80_top_direct_n_0_nWR),SpriteDMA_0_DMAassert})
		2'b11: ram_we=1;
		2'b10,2'b01,2'b00: ram_we=0;
	endcase
	
	//ram_rd = (~z80_top_direct_n_0_nMREQ & ~z80_top_direct_n_0_nRD) | ~DMA_read;
	//ram_we = (~z80_top_direct_n_0_nMREQ & ~z80_top_direct_n_0_nWR & SpriteDMA_0_DMAassert);
	
	ram_wait = z80_top_direct_n_0_nMREQ | ram_ready;		//only halt cpu if mem_req goes low while ram_ready is low
end




sdram ram
(
	.*,
	.init(~locked),
	.clk(clk_out2),
	.dout(ram_dout),
	.din (ram_din),	
	.addr(ram_addr),
	.we(ram_we),
	.rd(ram_rd),
	.ready(ram_ready)
);

  
/////////////////////// Z80 CLK CTRL ///////////////////
wire z80_clk_ctrl_0_outclk;

z80_clk_ctrl z80_clk_ctrl_0 (
    .clk(clk_out2),
	 .clk2(clk_out3),
    .clk_ctrl(io_interface_0_io_wait_out),
//	 .sdram_ready(ram_ready),
    .clk_ctrl_DMA(SpriteDMA_0_Z80_clk_ctrl),	 
	 .ram_wait(ram_wait),
    .outclk(z80_clk_ctrl_0_outclk)
  );

/////////////////////// T80 ////////////////////////////
wire z80_top_direct_n_0_nM1;
wire z80_top_direct_n_0_nMREQ;
wire T80a_0_IORQ_n;
wire z80_top_direct_n_0_nRD;
wire z80_top_direct_n_0_nWR;
wire [15:0] z80_top_direct_n_0_A;
wire [7:0] T80a_0_data_out;

wire nRFSH;
wire nBUSACK;
wire [7:0] cpu_din;

T80a #(
    .Mode(0)
  ) T80a_0 (
	.RESET_n(global_reset_n),
	.CLK_n(z80_clk_ctrl_0_outclk),
	.WAIT_n(constant_high),
	.INT_n(io_interface_0_vsync_int),
	.NMI_n(constant_high),
	.BUSRQ_n(constant_high),
	.M1_n(z80_top_direct_n_0_nM1),
	.MREQ_n(z80_top_direct_n_0_nMREQ),
	.IORQ_n(T80a_0_IORQ_n),
	.RD_n(z80_top_direct_n_0_nRD),
	.WR_n(z80_top_direct_n_0_nWR),
	.RFSH_n(nRFSH),
	.BUSAK_n(nBUSACK),
	.A(z80_top_direct_n_0_A),
	.data_in(cpu_din),
	.data_out(T80a_0_data_out)
);


reg io_status;

always_comb begin
	casex({z80_top_direct_n_0_nMREQ,T80a_0_IORQ_n,rom_select,z80_top_direct_n_0_A[15:14]})
		5'b0X0_XX,5'b0X1_1X,5'b0X1_X1: cpu_din = ram_dout;
		//5'b0X1_1X: cpu_din = ram_dout;
		//5'b0X1_X1: cpu_din = ram_dout;
		5'b0X1_00: cpu_din = z80_rom_0_douta;
		5'b10X_XX: cpu_din = io_interface_0_io_data_to_cpu;
		5'b11X_XX: cpu_din = 8'bz;
		default : cpu_din = ram_dout;
	endcase
	
	casex({~z80_top_direct_n_0_nM1 | T80a_0_IORQ_n})
		'b0: io_status = 0;
		'b1: io_status = 1;
	endcase
	
	
	
end

//defparam T80a_0.Mode = 0;

	/*RESET_n         : in std_logic;
		CLK_n           : in std_logic;
		WAIT_n          : in std_logic;
		INT_n           : in std_logic;
		NMI_n           : in std_logic;
		BUSRQ_n         : in std_logic;
		M1_n            : out std_logic;
		MREQ_n          : out std_logic;
		IORQ_n          : out std_logic;
		RD_n            : out std_logic;
		WR_n            : out std_logic;
		RFSH_n          : out std_logic;
		HALT_n          : out std_logic;
		BUSAK_n         : out std_logic;
		A                       : out std_logic_vector(15 downto 0);
		--D			: inout std_logic_vector(7 downto 0)
		data_in             : in  std_logic_vector(7 downto 0);
        data_out            : out std_logic_vector(7 downto 0)    
*/


/////////////////  RESET  /////////////////////////

wire reset = RESET | status[0] | buttons[1] | (~status[12] & img_mounted);

////////////////////// SD CARD SDSPI ////////////////////////
wire o_wb_stall;
wire [31:0] sdspi_0_o_wb_data;
wire [31:0] sdspi_0_o_debug;
wire sdspi_0_o_wb_ack;
wire o_int;

  
 
  sdspi #(
    .OPT_CARD_DETECT(1'B1),
    .LGFIFOLN(7),
    .POWERUP_IDLE(1000),
    .STARTUP_CLOCKS(75),
    .CKDIV_BITS(8),
    .INITIAL_CLKDIV(8'B01111100),
    .OPT_SPI_ARBITRATION(1'B0),
    .OPT_EXTRA_WB_CLOCK(1'B0)
  ) sdspi_0 (
    .i_clk(clk_out2),
    .i_sd_reset(global_reset),  //reset is high for this module
    .i_wb_cyc(io_interface_0_io_cyc_to_sdcard),
    .i_wb_stb(io_interface_0_io_to_sdcard),
    .i_wb_we(io_interface_0_io_sdcard_we),
    .i_wb_addr(io_interface_0_io_addr_to_sdcard),
    .i_wb_data(io_interface_0_io_data_to_sdcard),
    .i_wb_sel(constant_low),
    .o_wb_stall(o_wb_stall),
    .o_wb_ack(sdspi_0_o_wb_ack),
    .o_wb_data(sdspi_0_o_wb_data),
    .o_cs_n(sdss),
    .o_sck(sdclk),
    .o_mosi(sdmosi),
    .i_miso(sdmiso),
    .i_card_detect(constant_high),
    .o_int(o_int),
    .i_bus_grant(constant_high),
    .o_debug(sdspi_0_o_debug)
  );
  
  //assign SD_CD=constant_high;
  
//////////////////////// SD CARD /////////////////////

wire sdclk;
wire sdmosi;
wire sdmiso = vsd_sel ? vsdmiso : SD_MISO;
wire sdss;//=constant_low;
//wire sdss_other;

reg vsd_sel = 0;
always @(posedge clk_out2) if(img_mounted) vsd_sel <= |img_size;

//virtual SD interface
wire vsdmiso;
sd_card sd_card
(
	.*,
	.reset(global_reset),
	.clk_sys(clk_out2),
	.clk_spi(clk_out2),
	.sdhc(1),
	.sck(sdclk),
	.ss(sdss | ~vsd_sel),
	.mosi(sdmosi),
	.miso(vsdmiso)
);

//signal to physical second SD card - only active when vsd_sel is 0
assign SD_CS   = sdss   |  vsd_sel;
assign SD_SCK  = sdclk  & ~vsd_sel;
assign SD_MOSI = sdmosi & ~vsd_sel;

reg sd_act;

always @(posedge clk_out2) begin
	reg old_mosi, old_miso;
	integer timeout = 0;

	old_mosi <= sdmosi;
	old_miso <= sdmiso;

	sd_act <= 0;
	if(timeout < 2000000) begin
		timeout <= timeout + 1;
		sd_act <= 1;
	end

	if((old_mosi ^ sdmosi) || (old_miso ^ sdmiso)) timeout <= 0;
end
  
////////////////////// PS2 KEYBOARD /////////////////
wire ps2_keyboard_to_ascii_0_ascii_new;
wire [6:0] ps2_keyboard_to_ascii_0_ascii_code;
wire ps2_keyboard_to_ascii_0_f_out;
wire ps2_keyboard_to_ascii_0_e_out;
wire ps2_keyboard_to_ascii_0_ps2_sig_out;
wire [7:0] ps2_keyboard_to_ascii_0_ps2_code_out;
wire [7:0] keyboard_matrix_0_io_data_out;



  ps2_keyboard_to_ascii #(
    .clk_freq(50000000),
    .ps2_debounce_counter_size(8)
  ) ps2_keyboard_to_ascii_0 (
    .clk(clk_out2),
    .ps2_clk(constant_high),//ps2_kbd_clk_out),
    .ps2_data(constant_high),//ps2_kbd_data_out),
	 .ps2_key(ps2_key),
    .ascii_new(ps2_keyboard_to_ascii_0_ascii_new),
    .ascii_code(ps2_keyboard_to_ascii_0_ascii_code),
    .f_out(ps2_keyboard_to_ascii_0_f_out),
    .e_out(ps2_keyboard_to_ascii_0_e_out),
    .ps2_sig_out(ps2_keyboard_to_ascii_0_ps2_sig_out),
    .ps2_code_out(ps2_keyboard_to_ascii_0_ps2_code_out)
  );
  
   keyboard_matrix keyboard_matrix_0 (
    .clk(clk_out2),
    .nReset(global_reset_n),
    .ps2_sig_in(ps2_keyboard_to_ascii_0_ps2_sig_out),
    .e_in(ps2_keyboard_to_ascii_0_e_out),
    .f_in(ps2_keyboard_to_ascii_0_f_out),
    .ps2_code(ps2_keyboard_to_ascii_0_ps2_code_out),
    .io_req(io_interface_0_io_from_matrix),
    .io_addr(io_interface_0_io_address_out),
    .io_data_out(keyboard_matrix_0_io_data_out)
  );
  
////////////////////// 1MHZ Clock (for 8580) ///////
wire clk1mhz_0_clkout;

  clk1mhz clk1mhz_0 (
    .clkin(clk_out4),
    .clkout(clk1mhz_0_clkout)
  );
  
  
////////////////////// 3.5MHZ Clock (for YMs) ///////
wire ay_clock_div_0_ay_sig;

  ay_clock_div ay_clock_div_0 (
    .clk(clk_out2),
    .ay_sig(ay_clock_div_0_ay_sig)
  );
  
///////////////////// SID 8580 //////////////////////
wire [7:0] sid8580_wrapper_0_data_out;
wire [15:0] sid8580_wrapper_0_audio_data;

 sid8580 sid8580_0 (
    .reset(global_reset),
    .clk(clk1mhz_0_clkout),
    .fastclk(clk_out2),
    .ce_1m(constant_high),
    .we(io_interface_0_io_to_sid),
    .addr(io_interface_0_io_address_out),
    .data_in(io_interface_0_io_data_to_sid),
    .data_out(sid8580_wrapper_0_data_out),
    .pot_x(io_interface_0_potx_latch),
    .pot_y(io_interface_0_poty_latch),
    .extfilter_en(constant_high),
    .audio_data(sid8580_wrapper_0_audio_data)
    );
	 
	 
/////////////////////// YM 2203 /////////////////////
wire [7:0] jt03_0_dout;
wire jt03_0_irq_n;
wire [7:0] psg_A;
wire [7:0] psg_B;
wire [7:0] psg_C;
wire [15:0] fm_snd;
wire [9:0] psg_snd;
wire [15:0] jt03_0_snd;
wire snd_sample;

jt03 jt03_0 (
	.rst(global_reset),
	.clk(clk_out2),
	.cen(ay_clock_div_0_ay_sig),
	.din(io_interface_0_io_data_to_ay),
	.addr(io_interface_0_io_reg_to_AY),
	.cs_n(constant_low),
	.wr_n(io_interface_0_io_to_ay),
	.dout(jt03_0_dout),
	.irq_n(jt03_0_irq_n),
	.psg_A(psg_A),
	.psg_B(psg_B),
	.psg_C(psg_C),
	.fm_snd(fm_snd),
	.psg_snd(psg_snd),
	.snd(jt03_0_snd),
	.snd_sample(snd_sample)
);



/////////////////////// YM 3526 /////////////////////
wire [7:0] jtopl_0_dout;
wire jtopl_0_irq_n;
wire [15:0] jtopl_0_snd;
wire sample;

jtopl jtopl_0 (
	.rst(global_reset),
	.clk(clk_out2),
	.cen(ay_clock_div_0_ay_sig),
	.din(io_interface_0_io_data_to_opl),
	.addr(io_interface_0_io_reg_to_opl),
	.cs_n(constant_low),
	.wr_n(io_interface_0_io_to_opl),
	.dout(jtopl_0_dout),
	.irq_n(jtopl_0_irq_n),
	.snd(jtopl_0_snd),
	.sample(sample)
);

	 
/////////////////////// PWM /////////////////////////
wire pwm_0_pwm_out; //not currently connected as pwm function built into MiSTER
wire [15:0] pwm_0_mixed;

  pwm pwm_0 (
    .clk(clk1mhz_0_clkout),
    .pwm_in(sid8580_wrapper_0_audio_data),
	 .ts_in_l(jt03_0_snd),
	 .opl_in(jtopl_0_snd),
    .dac_in(videoInterface_0_dac_out),
    .dac_in1(videoInterface_0_dac_out1),
    .dac_in2(videoInterface_0_dac_out2),
    .dac_in3(videoInterface_0_dac_out3),
    .sample_playing(videoInterface_0_sample_playing),
    .sample_playing1(videoInterface_0_sample_playing1),
    .sample_playing2(videoInterface_0_sample_playing2),
    .sample_playing3(videoInterface_0_sample_playing3),
    .pwm_out(pwm_0_pwm_out),
	 .mixed(pwm_0_mixed)
  );
  
  assign AUDIO_L=pwm_0_mixed;//sid8580_wrapper_0_audio_data;
  assign AUDIO_R=pwm_0_mixed;

////////////////////// SYNC GEN /////////////////////



wire SyncGen_0_vga_h_sync;
wire SyncGen_0_vga_v_sync;
wire SyncGen_0_v_sync_int;
wire SyncGen_0_h_sync_int;
wire SyncGen_0_inDisplayArea;
wire [9:0] SyncGen_0_CounterX;
wire [9:0] SyncGen_0_CounterY;
wire SyncGen_0_scanlines;
wire my_h_blank;
wire my_v_blank;

SyncGen SyncGen_0 (
    .clk(clk_out1),
    .vga_h_sync(SyncGen_0_vga_h_sync),
    .vga_v_sync(SyncGen_0_vga_v_sync),
	 .v_sync_int(SyncGen_0_v_sync_int),
	 .h_sync_int(SyncGen_0_h_sync_int),
    .inDisplayArea(SyncGen_0_inDisplayArea),
    .CounterX(SyncGen_0_CounterX),
    .CounterY(SyncGen_0_CounterY),
    .scanlines(SyncGen_0_scanlines),
	 .h_blank(my_h_blank),
	 .v_blank(my_v_blank)
);

////////////////////// CREATE RGB /////////////////////

wire createRGB_0_vga_h_sync2;
wire createRGB_0_vga_v_sync2;

wire [7:0] createRGB_0_io_data_out;

wire R;
wire G;
wire B;
wire R1;
wire G1;
wire B1;
wire R2;
wire G2;
wire B2;
wire R3;
wire G3;
wire B3;
wire spr_int;

createRGB createRGB_0 (
	.clk(clk_out1),
	.vga_v_sync(SyncGen_0_vga_v_sync),
	.vga_h_sync(SyncGen_0_vga_h_sync),
	.CounterX(SyncGen_0_CounterX),
	.CounterY(SyncGen_0_CounterY),
	.inDisplayArea(SyncGen_0_inDisplayArea),
	.v_data(videoInterface_0_v_data),        //main video data 12 bit colour
	.v_data2(videoInterface_0_v_data2),       //foreground tilemap 12 bit color
	.spr_data(sprite_gen_0_spr_vid_out),      //hardware sprites 12 bit color
	.spr_data2(sprite_gen_0_spr_vid_out2),      //hardware sprites 12 bit color
	.foreground_enable(videoInterface_0_foreground_enable),
	.spr_active(sprite_gen_0_spr_active),
	.spr_active2(sprite_gen_0_spr_active2),
	.io_in(io_interface_0_io_to_rgb),
	.io_out(io_interface_0_io_from_rgb),
	.io_data_in(io_interface_0_io_data_to_rgb),
	.io_address_in(io_interface_0_io_address_out),
	.foregroundmask(videoInterface_0_foregroundmask),
	.cpuwait(io_interface_0_io_wait_out),
	.io_data_out(createRGB_0_io_data_out),
	.vga_R(R),
	.vga_G(G),
	.vga_B(B),
	.vga_R1(R1),
	.vga_G1(G1),
	.vga_B1(B1),
	.vga_R2(R2),
	.vga_G2(G2),
	.vga_B2(B2),
	.vga_R3(R3),
	.vga_G3(G3),
	.vga_B3(B3),
	.vga_v_sync2(createRGB_0_vga_v_sync2),
	.vga_h_sync2(createRGB_0_vga_h_sync2),
	.spr_int(spr_int)
	);
	
	
assign CLK_VIDEO = clk_sys;
video_mixer #(768, 1, 1) mixer
(
	.clk_vid(CLK_VIDEO),
	
	.ce_pix(clk_out1),
	.ce_pix_out(CE_PIXEL),

	.hq2x(scale == 1),
	.scanlines(0),
	.scandoubler(scale || forced_scandoubler),
	.gamma_bus(gamma_bus),

	.R({R3,R2,R1,R}),
	.G({G3,G2,G1,G}),
	.B({B3,B2,B1,B}),

	.mono(0),

	.HSync(~createRGB_0_vga_h_sync2),
	.VSync(~createRGB_0_vga_v_sync2),
	.HBlank(my_h_blank),
	.VBlank(my_v_blank),

	.VGA_R(VGA_R),
	.VGA_G(VGA_G),
	.VGA_B(VGA_B),
	.VGA_VS(VGA_VS),
	.VGA_HS(VGA_HS),
	.VGA_DE(VGA_DE)
);
	 
//assign VGA_HS = ~createRGB_0_vga_h_sync2;		//postive h-sync
//assign VGA_VS = ~createRGB_0_vga_v_sync2;		//positive v-sync
//assign VGA_DE = SyncGen_0_inDisplayArea;//~(VGA_HS | VGA_VS);

/*assign VGA_R  = {R3,R3,R2,R2,R1,R1,R,R};
assign VGA_G  = {G3,G3,G2,G2,G1,G1,G,G};
assign VGA_B  = {B3,B3,B2,B2,B1,B1,B,B};*/

/*assign VGA_R  = {R3,R2,R1,R,R,R,R,R};
assign VGA_G  = {G3,G2,G1,G,G,G,G,G};
assign VGA_B  = {B3,B2,B1,B,B,B,B,B};*/

//assign VGA_R  = {R3,R2,R1,R,4'b0000};
//assign VGA_G  = {G3,G2,G1,G,4'b0000};
//assign VGA_B  = {B3,B2,B1,B,4'b0000};


// **** USE MiSTER ADC to replicate SJ ADC channels ****


reg [7:0] adc_1;
reg [7:0] adc_2;

wire [23:0] adc_data;
wire adc_sync;
ltc2308 ltc2308_ADC
(
	.reset(global_reset),
	.clk(clk_out1),
	.ADC_BUS(ADC_BUS),
	.dout(adc_data),
	.dout_sync(adc_sync)
);

reg adc_flipflop;

always @(posedge clk_out2) begin
	reg adc_sync_d;
	
	adc_sync_d<=adc_sync;
	if (adc_sync_d ^ adc_sync) begin
		adc_1<=adc_data[11:4];
		adc_2<=adc_data[23:16];
	end
end


endmodule
