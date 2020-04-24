# MiSTER-SuperJacob
My SuperJacob core ported to MiSTER

This is a port of a computer I designed while learning to program FPGAs.  Apologies for the state of the code, this was a learning experiment and started off with me just wanted to generate a VGA output.  Then I started playing and adding bits until it developed into a working and usable computer.  Because of this, there is no consistency to the code or the general structure as I was learning new ways of doing things all the time.

Most things have ported across ok, however the main issue I have is that I cannot get the SDRAM interface working so I'm limited to 256k of memory (using internal RAM) whereas the original used 512K.  There is also a small bug with the SD Card interface, sometimes it fails to initialise after a reset, but another reset usually fixes it.  This doesn't happen on real hardware so I'm not sure what is causing it.

The original core is based on a CMOD-A7 FPGA board which uses an Artix-7 15T.

The machine

Z80 CPU running at 12mhz (uses T80 core), with dedicated 512k (256k on current MiSTER port) memory, bankable in 8k slots.

4 display modes
80 column text
320 x 240 256 colour bitmap mode (scrollable)
512 x 512 scrollable tilemap mode - 320 x 240 visible - 256 colour (8 bit) tiles
512 x 512 scrollable tilemap mode - 320 x 240 visible - 256 colour (4 bit) tiles with palette offset

Each tilemap mode has 2 independantly scrollable tilemaps, background and foreground with the foreground being maskable.
Foreground and background can be independantly disabled

128k gfx memory so total of 2,048 8 bit tiles or 4,096 4 bit tiles
Dedicated tilemap memory 2 x 8k

128 hardware 16x16 sprites - can operate in either 8 bit or 4 bit mode with palette offset.
Can display all 128 sprites on screen at once and approx 90 per scanline
Hardware mirroring and linking.
Can prioritise sprites either in front or behind a foreground tilemap
Independant palette tables for background and foreground sprites
16k dedicated sprite RAM - total of 64 8 bit or 128 4 bit sprite patterns.
Sprite DMA can copy patterns and attribute data at directly from CPU RAM to Sprite RAM

512 colours on screen at once selectable from a palette of 4,096
12 bit colour (R4G4B4)
Separate palettes for Tilemap and Sprites
Separate selectable colour masks for foreground tilemap and sprites
VGA output running at 60hz

SID 8580 sound chip (core taken from MiSTer C64 port)
4 x 8 bit PCM channels - selectable frequency 3.9khz, 7.9khz, 15.8khz, 31.5khz (driven off hblank)
Samples share 128k gfx memory space

2 x 16 bit timers - can run between .75hz and 50khz

Maskable interrupts generated for vblank, hblank, defined raster line, keyboard, GPIOA, GPIOB, Timer 1 and Timer 2
Button driven NMI (Not currently implemented in MiSTER port)

2 programmable GPIO ports - physical MCP23017 via I2C - connect to 9 pin D-Sub joystick connector
GPIO address pulled down to zero but can be overridden via pin header (MiSTER Port just connects these to Joysticks 0 & 1)

2 x analogue inputs (via pin header) - Not implemented in MiSTER port

2 x user LED
1 x user RGB LED  - Not implemented in MiSTER Port

SD Card interface via SPI interface

PS2 keyboard

Rudimentary but functioning operating system, available OS commands are:
DIR                    - List current directory
CD <dir>                - Change directory
BLOAD <file> <address>  - Binary Load a raw bin file into address
SYS <address>           - Execute code at address
CLS                     - Clear the screen
DUMP <address>          - Dump the contents of address to screen
BANK <bank> <val>       - Set memory bank (2 through 7) $4000 through $e000 to val (0 to 63) which is 1 of 64 8k banks withih the 512k
JOYTEST                 - Run the internal joystick test program
GETCHAR <x> <y>         - Get the character as location X Y
LOAD <file.sj>          - Load .SJ file and run
SETLED2 <R> <G> <B>     - Set the RGB LED value
PAPER <byte>            - Set the background colour
INK <byte>              - Set the foreground colour
VOL <x:>                - Set the current SD volume to x - first volume is A so command would be VOL A:
JOY0 <mode>             - Set joystick mode for joystick 0 - 1 = normal, 2 - 3 button megadrive controller
JOY1 <mode>             - Set joystick mode for joystick 1 - 1 = normal, 2 - 3 button megadrive controller

If anyone was interested in creating anything for it.  The IO port map as follows:
Outputs

Hex NAME            Description

FF  **** Not used ****

FE  INT_EN_FLAG     Interrupt enable flags  [TMR2,TMR1,KEYBOARD,GOPIOB,GPIOA,HSYNC,RASTERLINE,VSYNC]

FD  INT_DATA_BUS    Value that will be presented to the data bus upon interrupt

FC  VID_WRITE       Writes byte to current video address

FB  VID_INC_ROW     Increases video address by 1 row (320 bytes)  (value written is irrelevant)

FA  VID_INC         Increase video address by 1 byte  (value written is irrelevant)

F9  VID_ADD_VAL     Increase video address by value written to port

F8  VID_ADDR_HI     Set MSB of video address

F7  VID_ADDR_MD     Set bits 15 through 8 of video address

F6  VID_ADDR_LO     Set bits 7 through 0 of video address

F5  VID_ZERO        Zero video address

F4  **** Not used ****

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



DF  TILEMAP_SEL     Select tilemap to be affected by future IO reqs (any value other than 1 is treated as 0) - doesn't affect video mode 
2

DE  **** Not used ****

DD  TILEMAP_COLOUR In video mode 2, sets the foreground colour of the tile

DC  TILEMAP_WRITE   Write byte to tilemap address.  In video mode 0 even addresses are tile number, odd addresses are tile attributes.  
In Video mode 2 this is always tile (char) number

DB  TILEMAP_INC_ROW Increases tilemap address by 1 row (64 bytes in video mode 0 or 80 bytes in video mode 2)  (value written is 
irrelevant)

DA  TILEMAP_INC     Increases tilemap address by 1   (value written is irrelevant)

D9  TILEMAP_ADD_VAL Increases tile graphics address by value written to port

D8  **** Not used ****

D7  TILEMAP_ADDR_HI Set bits 12 through 8 of tile graphics address

D6  TILEMAP_ADDR_LO Set bits 7 through 0 of tile graphics address

D5  TILEMAP_ZERO    Zero tile graphics address

D4  TILEMAP_X_VAL   Set column position in tilemap.  In video mode 0 6 bit value, in video mode 2 7 bit value.  Values greater than 
cloumns will wrap

D3  TILEMAP_Y_VAL   Set row position in tilemap.  6 bit value.  Values greater than visible are accepted but will wrap if past avaiable 
memory

D2  TILEMAP_BG      Set Background colour for video mode 2

D1  TILEMAP_DEC     Decreases tilemap address by 1   (value written is irrelevant)

D0  TILEMAP_DEC_ROW Decreases tilemap address by 1 row (64 bytes in video mode 0 or 80 bytes in video mode 2)  (value written is 
irrelevant)



CF  SCROLL_DEC_X    Decreases X scroll value by 1 - affects video modes 0, 1 & 3

CE  SCROLL_INC_X    Increases X scroll value by 1 - affects video modes 0, 1 & 3

CD  SCROLL_DEC_Y    Decreases Y scroll value by 1 - affects all video modes

CC  SCROLL_INC_Y    Increases Y scroll value by 1 - affects all video modes

CB  SCROLL_X_HI     Sets MSB of X scroll value - affects video modes 0, 1 & 3

CA  SCROLL_X_LO     Sets low byte of X scroll value - affects video modes 0, 1 & 3

C9  SCROLL_Y_HI     Sets MSB of X scroll value - affects all video modes

C8  SCROLL_Y_LO     Sets low byte of X scroll value - affects all video modes

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

AD  **** Not used ****

AC  SPRITE_MASK     Set the colour index value for the sprite transparency mask

AB  SPRITE_X_OFF    Set te sprite X offset position (where sprite position 0 is compared with physical screen)

AA  SPRITE_Y_OFF    Set te sprite X offset position (where sprite position 0 is compared with physical screen)

A9  SPRITE_X_HI     High bit of sprite X position    

A8  SPRITE_X_LO     Low byte of sprite X position

A7  SPRITE_Y_HI     High bit of sprite Y position    

A6  SPRITE_Y_LO     Low byte of sprite Y position

A5	SPRITE_PAT      Set sprite pattern - bit 7 = mode, 6 through 0 = pattern

A4	SPRITE_ATTR     Set sprite attr bit 7=y flip, bit 6=x flip, [bits 0 through 3 only] palette offset 

A3	SPRITE_LINK     bit 7 visible & priority, bit 6 flipx flipy & palette offset, bit 54 mode & pattern, bits 32 y pos, bits 10 x pos 

;xpos 00=Take X pos from attribute data

;xpos 01=Same X pos as previous sprite

;xpos 10=X pos = previous sprite - 16

;xpos 11=X pos = previous sprite + 16

;ypos 00=Take Y pos from attribute data

;ypos 01=Same Y pos as previous sprite

;ypos 10=Y pos = previous sprite - 16

;ypos 11=Y pos = previous sprite + 16

;mode & pattern 00=Take from attribute data

;mode & pattern 01=Take from previous sprite

;mode & pattern 10=Take from previous sprite but increase pattern number by 1

;mode & pattern 10=Take from previous sprite but decrease pattern number by 1

;Flip & palette offset 0  = Take from attribute data

;Flip & palette offset 1  = Take from previous sprite data

;Visible & priority 0  = Take from attribute data

;Visible & priority 1  = Take from previous sprite data

A2  **** Not used ****

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

7B  TMR_CTRL        Timer Control - bit 1 = timer 2 restarts on 0, bit 0 timer 1 restarts on 0



78  ROM_OVERLAY     Rom select. 0 = RAM paged into 16k bank at address 0, any other value is ROM paged in

77  RAM_BANK_7      Selects one of the 64 8k RAM bank paged into address $E000

76  RAM_BANK_6      Selects one of the 64 8k RAM bank paged into address $C000

75  RAM_BANK_5      Selects one of the 64 8k RAM bank paged into address $A000

74  RAM_BANK_4      Selects one of the 64 8k RAM bank paged into address $8000

73  RAM_BANK_3      Selects one of the 64 8k RAM bank paged into address $6000

72  RAM_BANK_2      Selects one of the 64 8k RAM bank paged into address $4000

71  RAM_BANK_1      Selects one of the 64 8k RAM bank paged into address $2000

70  RAM_BANK_0      Selects one of the 64 8k RAM bank paged into address $0000



4A  DMA_LEN_LO_A    DMA Length low byte - a write here also starts the  Alternative DMA operation (create a 16 x 16 sprite from 4 8 x 8 
consecutive tiles)

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



35  SDCARD_BYTE3

34  SDCARD_BYTE2

33	SDCARD_BYTE1

32  SDCARD_BYTE0

31	SDCARD_ADDR

30	SDCARD_WRITE



28  VIDEO_MODE      Sets the video mode

27  FOREGROUND_EN   Enables the foreground layer in video mode 0    



20  SCREEN_CTRL     Screen Control  Bit 7 - screen enable, Bit 1 - Background enable, Bit 0 - Show scanlines (Foreground enable is reg 
27)



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



39  I2C_READ        Read the data send from the I2C interface

38  I2C_STATUS      Read the status byte from the I2C interface



32  SDCARD_WAITING  Read Data Waiting status of SD Card

31  SDCARD_READY    Read ready status of SD card

30  SDCARD_DATA     Read the last byte returned from the SD Card



17  KEY_MATRIX_7    Read Keyboard byte 7 -  ,   .   / RCTL SPC  LT  DN  RT 

16  KEY_MATRIX_6    Read Keyboard byte 6 - LCTL Z   X   C   V   B   N   M

15  KEY_MATRIX_5    Read Keyboard byte 5 -  K   L   ;   '   #   F2  UP  RSFT

14  KEY_MATRIX_4    Read Keyboard byte 4 - LSFT A   S   D   F   G   H   J

13  KEY_MATRIX_3    Read Keyboard byte 3 -  I   O   P   [   ]  LALT RALT RET

12  KEY_MATRIX_2    Read Keyboard byte 2 - TAB  Q   W   E   R   T   Y   U

11  KEY_MATRIX_1    Read Keyboard byte 1 -  7   8   9   0   -   =  BSP  F1

10  KEY_MATRIX_0    Read Keyboard byte 0 - ESC  `   1   2   3   4   5   6



01  KEY_DATA        Reads the most recent ASCII value PS2 keyboard state

