		;Assembly Defines
		DIR_SHOW_SECONDS	equ 0	;1 to show seconds in directory lists, 0 to stop an mintues

		;Output Pors
		
		INT_STATUS		equ $FF     ;Interrupt status        [X,X,X,X,X,HSYNC,RASTERLINE,VSYNC]
		INT_EN_FLAG		equ $FE		;Interrupt enable flags  [X,X,X,X,X,HSYNC,RASTERLINE,VSYNC]
		
		TILEMAP_SEL		equ $df     ;Select tilemap to be affected by future IO reqs (any value other than 1 is treated as 0)
		TILEMAP_COLOUR	equ $dd     ;In video mode 2, sets the foreground colour of the tile
		TILEMAP_WRITE	equ $dc		;Write byte to tilemap address.  In video mode 0 even addresses are tile number, odd addresses are tile attributes.  In Video mode 2 this is always tile (char) number
		TILEMAP_INC_ROW	equ $db		;Increases tilemap address by 1 row (64 bytes in video mode 0 or 80 bytes in video mode 2)  (value written is irrelevant)
		TILEMAP_INC		equ $da		;Increases tilemap address by 1   (value written is irrelevant)
		TILEMAP_ADD_VAL	equ	$d9		;Increases tile graphics address by value written to port
		TILEMAP_ADDR_HI	equ	$d7		;Set bits 12 through 8 of tile graphics address
		TILEMAP_ADDR_LO	equ	$d6		;Set bits 7 through 0 of tile graphics address
		TILEMAP_ZERO	equ	$d5		;Zero tile graphics address
		TILEMAP_X_VAL	equ $d4		;Set column position in tilemap.  In video mode 0 6 bit value, in video mode 2 7 bit value.  Values greater than cloumns will wrap
		TILEMAP_Y_VAL	equ $d3		;Set row position in tilemap.  6 bit value.  Values greater than visible are accepted but will wrap if past avaiable memory
		TILEMAP_BG		equ	$d2		;Set Background colour for video mode 2
		TILEMAP_DEC		equ	$d1		;Decreases tilemap address by 1   (value written is irrelevant)
		TILEMAP_DEC_ROW	equ	$d0		;Decreases tilemap address by 1 row (64 bytes in video mode 0 or 80 bytes in video mode 2)  (value written is irrelevant)
		
		SCROLL_X_HI		equ $CB		;Sets MSB of X scroll value - affect video modes 0 & 1
		SCROLL_X_LO     equ	$CA		;Sets low byte of X scroll value - affect video modes 0 & 1
		SCROLL_Y_HI     equ $C9		;Sets MSB of X scroll value - affect video modes 0 & 1
		SCROLL_Y_LO     equ	$C8		;Sets low byte of X scroll value - affect video modes 0 & 1
		
		LED_1			equ $C4
		LED_0			equ $C3
		LED_RED			equ $C2
		LED_GREEN		equ $C1
		LED_BLUE		equ $C0
		
		SPRITE_WRITE_INC equ $AF	;Write byte to sprite memory and increase pointer (not sur ethis works!)
		SPRITE_WRITE	equ	$AE		;Write byte to sprite memory and increase
		SPRITE_MASK		equ $AC		;Set the colour index value for the sprite transparency mask
		SPRITE_X_OFF	equ $AB		;Set te sprite X offset position (where sprite position 0 is compared with physical screen)
		SPRITE_Y_OFF	equ $AA		;Set te sprite X offset position (where sprite position 0 is compared with physical screen)
		SPRITE_X_HI		equ $A9		;High bit of sprite X position    
		SPRITE_X_LO		equ $A8		;Low byte of sprite X position
		SPRITE_Y_HI		equ $A7		;High bit of sprite Y position    
		SPRITE_Y_LO		equ	$A6		;Low byte of sprite Y position
		SPRITE_PAT		equ $A5		;Set sprite pattern - bit 7 = mode, 6 through 0 = pattern
		SPRITE_ATTR		equ $A4		;Set sprite attr bit 7=y flip, bit 6=x flip, [bits 0 through 3 only] palette offset 
		SPRITE_LINK		equ $A3		;Set up sprite linked list

		SPRITE_VISIBLE	equ $A1		;Set sprite either hidden or visible
		SPRITE_SELECT	equ $A0		;Selects which sprite all other sprite operations affect

		
		PAL_VAL_HI		equ $8F		;Latch high 4 bits of palette value 
		PAL_VAL_LO		equ $8E		;Latch low byte of palette value
		PAL_ENTRY		equ $8D		;Latch palette index to write to
		PAL_WRITE		equ $8c		;Write 12 bit latched value to latched palette index
		SPR_PAL_HI		equ $87		;Latch high 4 bits of sprite palette value
		SPR_PAL_LO		equ $86		;Latchlow byte of sprite palette value
		SPR_PAL_ENTRY	equ $85		;Latch palette index to write to
		SPR_PAL_WRITE	equ $84		;Write 12 bit latched value to latched palette index
		
		ROM_OVERLAY		equ $78		;Rom select. 0 = RAM paged into 16k bank at address 0, any other value is ROM paged in
		RAM_BANK_7		equ $77		;Selects one of the 64 8k RAM bank paged into address $E000
		RAM_BANK_6		equ $76		;Selects one of the 64 8k RAM bank paged into address $C000
		RAM_BANK_5		equ $75		;Selects one of the 64 8k RAM bank paged into address $A000
		RAM_BANK_4		equ $74		;Selects one of the 64 8k RAM bank paged into address $8000
		RAM_BANK_3		equ $73		;Selects one of the 64 8k RAM bank paged into address $6000
		RAM_BANK_2		equ $72		;Selects one of the 64 8k RAM bank paged into address $4000
		RAM_BANK_1		equ $71		;Selects one of the 64 8k RAM bank paged into address $2000
		RAM_BANK_0		equ $70		;Selects one of the 64 8k RAM bank paged into address $E000
		
		DMA_ATTR_HI     equ $48 	;DMA Sprite attr memory address high 2 bits
		DMA_ATTR_LO		equ $47     ;DMA Sprite attr memory address low byte
		DMA_LEN_HI		equ $46		;DMA Length high 6 bits
		DMA_LEN_LO		equ $45		;DMA Length low byte - a write here also starts the DMA operation
		DMA_SPR_HI		equ $44		;DMA Sprite memory address high 6 bits
		DMA_SPR_LO		equ $43		;DMA Sprite memory address low byte
		DMA_CPU_HI		equ $42		;DMA CPU memory address high 3 bits
		DMA_CPU_MD		equ $41		;DMA CPU memory address mid byte
		DMA_CPU_LO		equ $40		;DMA CPU memory address low byte

		
		I2C_ADDR		equ $3B		;Address of I2C (bits [3 though 1] select 8 possible addresses, bit 0 is R/W
		I2C_REG			equ	$3A		;Register to read from/write to
		I2C_DATA        equ	$39		;Data to be written during write operations
		I2C_SEND		equ $38		;Send the Address/Register/Data package to the I2C interface

		
		SDCARD_BYTE3	equ $35
		SDCARD_BYTE2	equ $34
		SDCARD_BYTE1	equ $33
		SDCARD_BYTE0	equ $32
		SDCARD_ADDR		equ $31
		SDCARD_WRITE	equ $30
		
		SDCARD_STATUS	equ $31
		SDCARD_READ		equ $30
		
		VIDEO_MODE		equ	$28		;Sets the video mode
		SCREEN_CTRL		equ $20		;Screen Control  Bit 7 - screen enable, Bit 1 - Background enable, Bit 0 - Show scanlines (Foreground enable is reg 27)
		
		;Input Ports
	
		TILEMAP_READ	equ	$DC		;Reads the tile number at the current cursor positon (ie current screen memeory address)
		TILEMAP_READ_X  equ $D4		;Get the current cursor column
		TILEMAP_READ_Y	equ $D3		;Get the current cursor row

		I2C_READ		equ $39		;Read the data send from the I2C interface
		I2C_STATUS		equ $38		;Read the status byte from the I2C interface

		SDCARD_WAITING	equ $32		;Read Data Waiting status of SD Card
		SDCARD_READY	equ $31		;Read ready status of SD card
		SDCARD_DATA		equ	$30     ;Read the last byte returned from the SD Card

		KEY_DATA		equ $01		;Reads the current PS2 keyboard state
		
		
		;JOYSTICK TYPES
		NOJOYTYPE		equ $00
		NORMALJOYTYPE	equ $01
		GENESISJOYTYPE	equ $02
	

	;TODO - need to code for when files/directories are across
		;multiple clusters
		DIR_RAM_BANK	equ	62 		;this is the 1st 8k bank to be used to holding directory listings
									;this and the subsequent bank will be paged in to form a 16k sratchpad
		
		ROMSIZE	equ	16384
		CURSORSPEED equ 32
		KEYDELAYTIME equ 16
		
		;SDCARD COMMANDS
		BASECMD				equ $40
		GO_IDLE_STATE		equ BASECMD+0
		SEND_OP_COND		equ BASECMD+1
		SEND_IF_COND		equ BASECMD+8
		SEND_CSD			equ	BASECMD+9
		SEND_CID			equ BASECMD+10
		SET_BLOCKLEN		equ	BASECMD+16
		READ_SINGLE_BLOCK	equ BASECMD+17		
		ACMD41				equ	BASECMD+41
		APP_CMD				equ BASECMD+55
		READ_OCR			equ BASECMD+58
		SD_SETAUX			equ $ff
		SD_READAUX			equ $bf		
		
		SD_CLEARERR			equ $80
		SD_ALTFIFO			equ $10
		SD_WRITEOP			equ $0c
		SD_FIFO_OP			equ $08
		SD_READREG			equ $02
		
		
		SD_CMD				equ $00
		SD_DATA				equ $01
		SD_FIFO_0			equ $02
		SD_FIFO_1			equ $03
		
		
		CURSOR_TIMER 	equ ROMSIZE+2
		CURSOR 			equ ROMSIZE+3
		TEMP			equ ROMSIZE+4
		SDCARDINFO1		equ	ROMSIZE+5
		SDCARDVOLS		equ	ROMSIZE+6
		SDCURRVOL		equ	ROMSIZE+7
		MATHTEMP		equ ROMSIZE+8	;(9,10,11)
		LASTKEY			equ ROMSIZE+12
		PREVKEY			equ ROMSIZE+13
		KEYREPEATDELAY	equ	ROMSIZE+14
		CMDBUFFPTR		equ ROMSIZE+15 ;(and 16)
		CMDBUFFPTR2		equ ROMSIZE+17 ;(and 18)
		NEWDIRREAD		equ ROMSIZE+19
		DIRREADPOS		equ ROMSIZE+20
		
		SCROLLBUFFER	equ	ROMSIZE+21	;(need space for 160 bytes)
		
		BACKCOL			equ	ROMSIZE+181
		FORECOL			equ	ROMSIZE+182
		
		FILELOADPTR		equ ROMSIZE+183	 ;ptr to address to load next sector into
		FILELOADSIZE	equ ROMSIZE+185	 ;number of bytes to read in
		TEMP16			equ	ROMSIZE+187
		SCROLLY			equ ROMSIZE+189	;hold the screen scroll position (char scroll only)
		LEDRED			equ ROMSIZE+190
		LEDGREEN		equ ROMSIZE+191
		LEDBLUE			equ ROMSIZE+192
		
		B2DINV			equ ROMSIZE+193  ; 8 bytespace for 64-bit input value (LSB first) 
		B2DBUF			equ ROMSIZE+201  ; space for 20 decimal digits
		B2DEND			equ	ROMSIZE+221 ; space for terminating 0
		
		JOYATYPE		equ B2DEND+1
		JOYBTYPE		equ JOYATYPE+1
		
		RAM7			equ JOYBTYPE+1
		RAM6			equ RAM7+1
		RAM5			equ RAM6+1
		RAM4			equ RAM5+1
		RAM3			equ RAM4+1
		RAM2			equ RAM3+1
		RAM1			equ RAM2+1
		RAM0			equ RAM1+1
		
		DEBUG_HL		equ RAM0+1
		DEBUG_DE		equ DEBUG_HL+2
		DEBUG_BC		equ DEBUG_DE+2
		DEBUG_AF		equ DEBUG_BC+2
		DEBUG_IX		equ DEBUG_AF+2
		DEBUG_IY		equ DEBUG_IX+2
		DEBUG_SP		equ DEBUG_IY+2
		DEBUG_PC		equ DEBUG_SP+2
		
		
		;can't go past 255 above with changing offset below
		SDSTRUCTURE		equ	DEBUG_PC+2
		SDVOL0			equ	SDSTRUCTURE
		SDVOL1			equ	SDSTRUCTURE+$10
		SDVOL2			equ	SDSTRUCTURE+$20
		SDVOL3			equ	SDSTRUCTURE+$30
		
		SD83BUFFER		equ SDVOL3+$10		;13 byte buffer for hold 8:3 filenames
		SDSIZEBUFFER	equ	SD83BUFFER+13	;11 byte buffer to hold file size
		NUMFORMATBUF	equ	SDSIZEBUFFER+11	;27 byte buffer to hold formatted numbers
		SDDATEBUFFER	equ	NUMFORMATBUF+27	;11 byte buffer to date
		SDDAY			equ SDDATEBUFFER+12	;holds file creation day
		SDMONTH			equ SDDAY+1			;holds file creation month
		SDYEAR			equ	SDMONTH+1		;holds file creation year
		SDTIMEBUFFER	equ SDYEAR+2		;10 bytes
		SDSECS			equ	SDTIMEBUFFER+10
		SDMINS			equ	SDSECS+1
		SDHOURS			equ	SDMINS+1
		SDFILESECTOR	equ	SDHOURS+2		;start sector for file/dir
		SDCHECKSUM		equ	SDFILESECTOR+4	;short file name checksum
		SDFILESIZE		equ	SDCHECKSUM+1	;size of file in bytes
		SDFSSECTORS		equ	SDFILESIZE+4	;size of file in sectors
		SD_DIR_NUM_ENTRIES equ	SDFSSECTORS+4	;space to store the number of entries in a directory
		SD_DIR_NUM_FILES equ	SD_DIR_NUM_ENTRIES+2	;space to store the number of files in a directory
		SD_DIR_NUM_DIRS equ	SD_DIR_NUM_FILES+2	;space to store the number of sub directories in a directory
		SD_DIR_NUM_BYTES equ	SD_DIR_NUM_DIRS+2	;space to store the number of bytes in all files in a directory
		SD_VOLNAME		equ	SD_DIR_NUM_BYTES+4	;space to store the current volume name
		
		
		
		SDVOLSTRUCT		equ	SD_VOLNAME+12
		;00	= BPB_BytsPerSec	(2)
		;02 = BPB_SecPerClus	(1)
		;03 = BPB_RsvdSecCnt	(2)
		;05 = BPB_NumFATs		(1)
		;06 = BPB_RootEntCnt	(2)
		;08 = BPB_TotSec		(4) derived from either BPB_TotSec16 or BOB_TotSec32
		;0c	= BPB_FATSz			(4) derived from either BPB_FATSz16 or BOB_FATSz32
		;10	= BPB_ExtFlags		(2)
		;12	= BPB_FSVer			(2)
		;14 = BPB_RootClus		(4)
		;18 = BPB_FSInfo		(2)
		;1a	= BPB_BkBootSec		(2)
		;1c = BS_VolID			(4)
		;20 = BS_VolLab			(11+1) for null  termination
		;2c = BSFilSysType		(8)
		;34	= RootDirSectors	(2)
		;36 - FirstDataSector	(4)
		;3a - PartitionAddr		(4)
		;3e	- FDSAbsolute		(4)
		;42 - CurrentSector		(4)
		;46 - PreviousSector	(4)
		;4a - DirSector			(4)
		;4e - FileSector		(4)
		;52	- TotalBytes		(8)
		SD_BPB_BYTSPERSEC	equ	$00
		SD_BPB_SECPERCLUS	equ	$02
		SD_BPB_RSVDSECCNT	equ	$03
		SD_BPB_NUMFATS		equ	$05
		SD_BPB_ROOTENTCNT	equ $06
		SD_BPB_TOTSEC		equ $08
		SD_BPB_FATSZ		equ $0C
		SD_BPB_EXTFLAGS		equ $10
		SD_BPB_FSVER		equ $12
		SD_BPB_ROOTCLUS		equ $14
		SD_BPB_FSINFO		equ $18
		SD_BPB_BKBOOTSEC	equ $1A
		SD_BS_VOLID			equ $1C
		SD_BS_VOLLAB		equ $20
		SD_BSFILSYSTYPE		equ $2c
		SD_ROOT_DIR_SECS	equ $35
		SD_FIRST_DATA_SEC	equ	$37
		SD_PART_ADDR		equ	$3b
		SD_FDS_ABSOLUTE		equ $3f
		SD_CURR_SECTOR		equ	$43
		SD_PREV_SECTOR		equ	$47
		SD_DIR_SECTOR		equ	$4b
		SD_FILE_SECTOR		equ	$4f
		SD_TOTAL_BYTES		equ	$53
		SD_DIR_STRING_LEN	equ $5b
		SD_CURR_DIR_STRING	equ $5d
		
		SDVOLSTRUCT_SIZE	equ SD_CURR_DIR_STRING+512
		
		;test structures can contain extended volume information for up to 4 partitions
		SDVOLSTRUCT0		equ SDVOLSTRUCT+SDVOLSTRUCT_SIZE
		SDVOLSTRUCT1		equ SDVOLSTRUCT0+SDVOLSTRUCT_SIZE
		SDVOLSTRUCT2		equ SDVOLSTRUCT1+SDVOLSTRUCT_SIZE
		SDVOLSTRUCT3		equ SDVOLSTRUCT2+SDVOLSTRUCT_SIZE
		
		SDBUFFER		equ	SDVOLSTRUCT3+SDVOLSTRUCT_SIZE		;(512 bytes)
		LFNBUFFER		equ	SDBUFFER+$200		;(256 bytes)
		
		CMDBUFFER		equ	LFNBUFFER+$100
		CMDBUFFER2		equ	CMDBUFFER+$100	;256 limit on command length?
		
		;channels structure - used to open, read, write and close files
		;00	- filesize in bytes
		;04	- filesize in sectors
		;08 - current cluster
		;12 - current sector
		;16 - current byte
		;20 - in use flag (ie, have we opened a file against this channel)
		CHANNELS		equ CMDBUFFER2+$100
		;size is 16 (0-15) channels at 21 bytes = 336 bytes
		;channel 0 is reserved for OS use
		
		ENDVARS			equ CHANNELS+336
		
		
		org $0000
	
		di
	
		
		jp start
		
		org $0038		;interrupt routine
		jp interrupt
		
		org $0066		;interrupt routine
		jp nmi
	
		
	;keyb_int
	;	in a,(KEY_DATA)		;read keyboard
	;	ld (LASTKEY),a
	;	jr int_return
		
		org $0100
		;jump table for os commands
	JCMD_GetDirectory			;$100
		jp CMD_GetDirectory
	JCMD_ChangeDirectory		;$103
		jp CMD_ChangeDirectory
	JCMD_BinLoad				;$106
		jp CMD_BinLoad
	JCMD_BinLoadDirect			;$109
		jp CMD_BinLoadDirect
	JCMD_Sys					;$10C
		jp CMD_Sys
	JCMD_CLS					;$10F
		jp CMD_CLS
	JCMD_DUMP					;$112
		jp CMD_DUMP				;dump memory contents					
	JCMD_BANK					;$115
		jp CMD_BANK
	JCMD_JOYTEST				;$118
		jp CMD_JOYTEST
	JCMD_Load					;$11b
		jp CMD_Load
	JCMD_GETCHAR				;$11e
		jp CMD_GETCHAR
	JCMD_SETLED2				;$121
		jp CMD_SETLED2
	JCMD_PAPER					;$124
		jp CMD_PAPER
	JCMD_INK					;$127
		jp CMD_INK	
	JCMD_VOL					;$12a
		jp CMD_VOL
	JCMD_JOY0					;$12d
		jp CMD_JOY0
	JCMD_JOY1					;$130
		jp CMD_JOY1
		
		org $0200
		
		;jump table for library routines
		jp CMD_JOYREAD_A		;$200
		jp CMD_JOYREAD_B		;$203
		
	nmi
		di		
		
		ld (DEBUG_SP),sp
		push hl
		ld (DEBUG_HL),hl
		push de
		ld (DEBUG_DE),de
		push bc
		ld (DEBUG_BC),bc
		push ix
		ld (DEBUG_IX),ix
		push iy
		ld (DEBUG_IY),iy
		;push af twice last as need to obtain it back to get flags
		push af
		push af
		pop hl	;l now contains the flags
		ld (DEBUG_AF),hl
		
		ld hl,(DEBUG_SP)
		ld e,(hl)			;retrieve PC
		inc hl
		ld d,(hl)
		ld (DEBUG_PC),de
		ld a,2
		out (VIDEO_MODE),a
		
		ld a,%10000000
		out (SCREEN_CTRL),a			;enable screen, backkground layer and scanlines
		
		ld a,$ff
		out (PAL_VAL_HI),a
		out (PAL_VAL_LO),a
		out (PAL_ENTRY),a
		out (PAL_WRITE),a
		ld (FORECOL),a
		
		ld sp,ENDVARS+$200
				
		call CMD_CLS
		
		ld hl,debug_string1
		call WriteLine
	
		ld hl,(DEBUG_PC)
	
		call DispHLhex
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
				
		ld hl,(DEBUG_SP)
		call DispHLhex
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		
		ld hl,(DEBUG_AF)
		ld c,h
		call OutHex8
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a		
		
		ld hl,(DEBUG_BC)
		call DispHLhex
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		
		ld hl,(DEBUG_DE)
		call DispHLhex
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		
		ld hl,(DEBUG_HL)
		call DispHLhex
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		
		ld hl,(DEBUG_IX)
		call DispHLhex
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		
		ld hl,(DEBUG_IY)
		call DispHLhex
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		
		ld a,0
		out (TILEMAP_X_VAL),a
		out (TILEMAP_INC_ROW),a
		out (TILEMAP_INC_ROW),a
		
		ld hl,debug_string2
		call WriteString
		
		ld a,0
		out (TILEMAP_X_VAL),a
		ld hl,(DEBUG_AF)
		ld a,$FF
		bit 7,l
		jr z,debugs
		ld a,$01
	debugs
		out (TILEMAP_COLOUR),a
		
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		ld a,$FF
		bit 6,l
		jr z,debugz
		ld a,$01
	debugz
		out (TILEMAP_COLOUR),a
		
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		ld a,$FF
		bit 5,l
		jr z,debug5
		ld a,$01
	debug5
		out (TILEMAP_COLOUR),a
		
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		ld a,$FF
		bit 4,l
		jr z,debugh
		ld a,$01
	debugh
		out (TILEMAP_COLOUR),a
		
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		ld a,$FF
		bit 3,l
		jr z,debug3
		ld a,$01
	debug3
		out (TILEMAP_COLOUR),a
		
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		ld a,$FF
		bit 2,l
		jr z,debugp
		ld a,$01
	debugp
		out (TILEMAP_COLOUR),a
		
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		ld a,$FF
		bit 1,l
		jr z,debugn
		ld a,$01
	debugn
		out (TILEMAP_COLOUR),a
		
		out (TILEMAP_INC),a
		out (TILEMAP_INC),a
		ld a,$FF
		bit 0,l
		jr z,debugc
		ld a,$01
	debugc
		out (TILEMAP_COLOUR),a
		
		ld a,0
		out (TILEMAP_X_VAL),a
		out (TILEMAP_INC_ROW),a
		out (TILEMAP_INC_ROW),a
		
		ld hl,(DEBUG_PC)
	
		call CMD_DUMP_HEX_2
		
		call waitkey
		
		pop af
		pop iy
		pop ix
		pop bc
		pop de
		pop hl
		ld sp,(DEBUG_SP)
		ei
		retn
		
	debug_string1
		defb "PC    SP    A   BC    DE    HL    IX    IY",0
	debug_string2
		defb "S Z 5 H 3 P N C",0
		
	interrupt
		push af
		push hl
		push bc
		push ix
		push iy
		
		
		
		;in a,(INT_STATUS)
		;call DispA
		
		in a,(INT_STATUS)
	;	bit 5,a
	;	jr nz,keyb_int
		
		bit 0,a
		jr nz,vb_int
		
	int_return
		in a,(KEY_DATA)		;read keyboard
		ld (LASTKEY),a
	
		pop iy
		pop ix
		pop bc
		pop hl
		pop af
		ei
		reti
		
	vb_int
		;ld a,30				;x pos
		;out (TILEMAP_X_VAL),a			;set x pos
		;ld a,0				;y pos
		;out (TILEMAP_Y_VAL),a			;set y pos
		
		;call PUTCHAR	;put char
		;out ($da),a		;move cursor right 
		;call DispA		;show value
		
		ld hl,CURSOR_TIMER
		dec (hl)
		jr nz,noflash
		ld (hl),CURSORSPEED		
		;ld a,1				;x pos
		;out (TILEMAP_X_VAL),a			;set x pos
		;ld a,5				;y pos
		;out (TILEMAP_Y_VAL),a			;set y pos
		ld a,(CURSOR)
		xor 95
		;out ($dc),a			;write letter to tile
		ld (CURSOR),a
	noflash
		jr int_return	
	
	start
	
	;	Quick memory test code
	;	ld a,255
	;	out (TILEMAP_COLOUR),a
	;	ld a,0
	;	out (TILEMAP_BG),a
	;	ld a,'Z'
	;	ld ($5000),a
	;	ld a,0
	;	ld a,($5000)
	;	out (TILEMAP_ZERO),a
	;	out (TILEMAP_WRITE),a
	;poo
	;	jp poo
	
	
		ld sp,ROMSIZE+8		;assume we at least have 8 bytes to call some init routines
		
		ld a,0
		out (SCROLL_Y_LO),a
		out (SCROLL_X_LO),a
		;ld (SCROLLY),a		;not needed as memcheck routine will zero
		
		out (LED_RED),a		;reset multi colour LED
		out (LED_GREEN),a
		out (LED_BLUE),a
		out (LED_0),a
		out (LED_1),a
		
	
		;clear display
		ld a,2				;set screen mode to 2
		out (VIDEO_MODE),a
		
	;	ld a,127
	;	ld bc,$00A1			;A1 = sprite visible
	;clearspriteloop
	;	out (SPRITE_SELECT),a
	;	out (c),b
	;	dec a
	;	jp p,clearspriteloop
		
		
		ld a,0
		out (PAL_VAL_HI),a
		out (PAL_VAL_LO),a
		out (PAL_ENTRY),a
		out (PAL_WRITE),a
		ld a,$ff
		out (PAL_VAL_HI),a
		out (PAL_VAL_LO),a
		out (PAL_ENTRY),a
		out (PAL_WRITE),a
		
		ld a,$0
		ld (BACKCOL),a
		ld a,$ff
		ld (FORECOL),a
		call ClearDisplay
		
		ld a,%10000010		;turn on display
		out (SCREEN_CTRL),a
	
		
		ld a,0
		out (TILEMAP_ZERO),a
		ld hl,testmemmessage
		call WriteLine
		
		ld a,6
		out (RAM_BANK_6),a
		ld (RAM6),a
		ld a,7
		out (RAM_BANK_7),a
		ld (RAM7),a
	
	;Now the memory is checked - currently only check the first 65536 bytes - need full 512k mem check.
		ld de,$FFFF
		ld a,$3f			;stop mem fill when $3fff is reached
	RAMCHECK
		LD	H,D			;Transfer the value in DE
		LD	L,E			;(START = +FFFF, NEW = RAMTOP).
	RAMFILL
		LD	(HL),+02	;Enter the value of +02 into
		DEC	HL			;every location above +3FFF.
		CP	H
		JR	NZ,RAMFILL
		
	RAMREAD
		AND	A			;Prepare for true subtraction.
		SBC	HL,DE		;The carry flag will become
		ADD	HL,DE		;reset when the top is reached.
		INC	HL			;Update the pointer.
		JR	NC,RAMDONE	;Jump when at top.
		DEC	(HL)		;+02 goes to +01.
		JR	Z,RAMDONE	;But if zero then RAM is faulty. Use current HL as top.
		DEC	(HL)		;+01 goes to +00.
		JR	Z,RAMREAD	;Step to the next test unless it fails.
	RAMDONE
		DEC	HL			;HL points to the last actual location in working order.
		
		ld (ROMSIZE),hl

	
		
		;ld sp,hl		;changed as we want to be able to page memory
		ld sp,ENDVARS+$100	;instead we'll create a 256 byte stack after all the system vars
		
		call clearspriteattr	;clear all sprite attributes to disable them and any linkig info
		
		call flushkeys
		
		ld a,$ff
		ld (FORECOL),a
		
		call setpalette
		
		
		;ld a,0
		;out (SCREEN_CTRL),a			;set to not show scanlines
		
	;	jp tempjump
		
		ld hl,checkdrivesmessage
		call WriteLine
		
		
		call CheckDrives ;check how many valid volumes are on SD Card
		
		
			
		;now enumerate the drives found
		ld a,(SDCARDVOLS)
		ld (SDCURRVOL),a
	enumdrivesloop
		ld a,(SDCURRVOL)	;start at number of drives found
		dec a				;dec once as our first drive number is 0 rather than 1
		jp m,nomoredrives	;if we go below zero exit enumeration
		ld (SDCURRVOL),a	;store current volume
		call SD_GetVolumeDetails	;get volume details
		ld a,(SDCURRVOL)	;get volume numbers
		add a,65			;convert to ASCII letter
		call PUTCHAR		;output to screen
		ld a,':'			;followed by a colon
		call PUTCHAR
	;	ld ix,SDVOLSTRUCT
	;	ld l,(ix+$1c)
	;	ld h,(ix+$1d)
	;	call DispHL
	;	ld l,(ix+$1e)
	;	ld h,(ix+$1f)
	;	call DispHL
		;out (TILEMAP_INC),a			;cursor right
		ld hl,SDVOLSTRUCT+SD_BS_VOLLAB	;point HL to volume name		
		call WriteString		;print them to screen
		
		ld hl,(SDVOLSTRUCT+SD_BS_VOLID+2)		;Display the serial number
		call DispHLhex
		ld a,'-'
		call PUTCHAR
		ld hl,(SDVOLSTRUCT+SD_BS_VOLID)
		call DispHLhex
		
		out (TILEMAP_INC),a
		
		ld hl,SDVOLSTRUCT+SD_BSFILSYSTYPE	;point HL to volume type
		call WriteString		;print them to screen
		
		out (TILEMAP_INC),a
	
		ld hl,(SDVOLSTRUCT+SD_TOTAL_BYTES)
		ld de,(SDVOLSTRUCT+SD_TOTAL_BYTES+2)
		ld bc,(SDVOLSTRUCT+SD_TOTAL_BYTES+4)
		ld ix,(SDVOLSTRUCT+SD_TOTAL_BYTES+6)
		;ld hl,B2DBUF+8
		;ld a,66
		;ld (hl),a
		call B2D64								;get a 64 bit string into B2DBUF
		ld hl,B2DBUF
		call FormatNumber64
		ld hl,NUMFORMATBUF
		
		call WriteString
		ld hl,bytetotstring
		call WriteLine
		
		
		;call EndLine			;carriage return
		jr enumdrivesloop		;loop to show next volume details
	nomoredrives
	
		
	;	ld a,1
	;	call SD_ChangeVolume
	
	
		;initialise IO Chip
		call EndLine		
		call EndLine		
		ld hl,i2cmessage1		;pointer to message
		call WriteLine		;write message to screen 
	
	
		;Set IOCON to Bank 1, Separate Int Ports, Non-Seq Op, Slew dis, active driver output, int active low
		ld a,%01000000			;we've set all bits, however top 4 are ignored are hardware hardcodes this to 0100 to match MCP23017
		out (I2C_ADDR),a				;Set I2C address to 0 - main joystick ports
		ld a,$0a				;IOCON - IO Control Register
		out (I2C_REG),a				;IO Extender register for IOCON
		ld a,%10100000				;we'll write to port $0A first in case we've had a Power on Reset
		out (I2C_DATA),a				;IO Extender data - turn off sequential addressing and set to bank 1
		call I2C_Write
		
		ld a,$05				;IOCON - IO Control Register in Babbj 1
		out (I2C_REG),a				;IO Extender register for IOCON
		
	
		;call I2C_Read_Port
		;jr c,I2C_Init_Error
		;call DispAhex
		;call EndLine
		
		ld a,%10100000				;we'll write to port $05 as well to be safe in case we were already set to bank 1
		out (I2C_DATA),a				;IO Extender data - turn off sequential addressing and set to bank 1
		call I2C_Write		
		jp c,I2C_Init_Error
		call I2C_GetStatus
		jp c,I2C_Init_Error
		and $60					;any acknowledge errors
		jr nz,I2C_Init_Error
		
		
		;call I2C_Read_Port
		;jr c,I2C_Init_Error
		;call DispAhex
		;call EndLine
		
		call set_joy_a_normal
		call set_joy_b_normal
		;call set_joy_a_genesis
		;call set_joy_b_genesis
		jr c,I2C_Init_Error
			
		ld hl,i2cmessage2		;pointer to message
		call WriteLine		;write message to screen 
		
		out (TILEMAP_INC_ROW),a
		jr I2C_Init_End
		
	I2C_Init_Error
		ld hl,i2cmessage3		;pointer to message
		call WriteLine		;write message to screen 
		
		out (TILEMAP_INC_ROW),a
		
		
		
	I2C_Init_End
		call waitkey
		;call SD_ReadDirectory
	tempjump	
		;need to set as cleared by mem check
		ld a,$0
		ld (BACKCOL),a
		ld a,$ff
		ld (FORECOL),a
		call ClearDisplay

		
	;write welcome message
		out (TILEMAP_ZERO),a			;reset cursor
	
		ld hl,welcome		;pointer to message
		call WriteLine		;write message to screen 
		
		ld hl,welcome2		;pointer to message
		call WriteLine	;write message to screen 
				
	
		ld hl,welcome3		;pointer to message
		call WriteLine		;write message to screen 
		
		;ld a,0				;x pos
		;out (TILEMAP_X_VAL),a			;set x pos
		;ld a,3				;y pos
		;out (TILEMAP_Y_VAL),a			;set y pos
		ld hl,(ROMSIZE)		;get ramtop
		ld de,ROMSIZE		;need to subtract romsize
		or a				;clear carry
		sbc hl,de
		inc hl				;adjust as top of RAM is last writeable byte so add 1 to make the actual number of bytes
		call DispHL
		out (TILEMAP_INC),a			;increase to next tile
		;ld b,9				;5 characters in message
		ld hl,welcome4		;pointer to message
		call WriteLine		;write message to screen 
		
		ld hl,welcome5		;pointer to message
		call WriteLine		;write message to screen 

		;ld a,0				;x pos
		;out (TILEMAP_X_VAL),a			;set x pos
		;ld a,5				;y pos
		;out ($d3),a			;set y pos
		;ld a,62
		;out ($dc),a			;write letter to tile
		
		call NewLine		;display drive name and finish init
		

	
	
		
		
		
		;next get response
		
	start2
		;ld a,1
		;out (SDCARD_SS),a			;drive SD card SS high
	;	ld sp,$1ffe
		ld hl,CURSOR_TIMER
		ld (hl),CURSORSPEED
		ld hl,CURSOR
		ld (hl),95
		
		ld a,%00000001				;mask interrupt for VSYNC only
		;ld a,%00100001				;mask interrupt for VSYNC and keyboard
		out (INT_EN_FLAG),a
		
		;ld a,0
		;out ($a0),a
		;ld a,%10000000
		;out ($a5),a
		;ld a,3
		;out ($a1),a
		;ld a,1
		;out ($a0),a
		;ld a,%10000001
		;out ($a5),a
		;ld a,63
		;out ($a8),a
		;out ($a6),a
		;ld a,3
		;out ($a1),a
		
		im 1
		ei
		
	endloop
		halt
		call ProcessKeyboard
		jp endloop
	
	
	ProcessKeyboard
		ld a,(LASTKEY)
		cp 0
		jr z,nokey
		ld b,a
		ld a,(PREVKEY)		;is it same as previous keypressed?
		cp b
		jr nz,newkey
		ld hl,KEYREPEATDELAY
		dec (hl)
		jr nz,repkey
		ld a,4
		ld (hl),a
		ld a,8			;backspace
		cp b
		jr z,backspace
		ld a,13
		cp b
		jr z,enterpressed
		jr oldkey
	newkey
		ld a,KEYDELAYTIME
		ld (KEYREPEATDELAY),a
		ld a,8
		cp b
		jr z,backspace
		ld a,13
		cp b
		jr z,enterpressed
	oldkey
		ld a,(FORECOL)
		out (TILEMAP_COLOUR),a
		ld a,b
		out (TILEMAP_WRITE),a
		out (TILEMAP_INC),a
		ld hl,CMDBUFFER
		ld de,(CMDBUFFPTR)
		add hl,de
		ld (hl),a
		inc de
		ld (CMDBUFFPTR),de
	nokey
		ld (PREVKEY),a
	repkey
		ld a,(CURSOR)
		;ld a,95
		out (TILEMAP_WRITE),a
		ld a,(FORECOL)
		out (TILEMAP_COLOUR),a
		ret
	backspace
		ld (PREVKEY),a
		ld de,(CMDBUFFPTR)
		ld a,0
		cp e
		jr nz,cmdbuffernotzero
		cp d
		jr nz,cmdbuffernotzero
		ret
	cmdbuffernotzero
		dec de
		ld (CMDBUFFPTR),de
		ld a,0
		out (TILEMAP_WRITE),a
		out (TILEMAP_DEC),a
		ret
	enterpressed
		ld (PREVKEY),a
		ld hl,CMDBUFFER
		ld de,(CMDBUFFPTR)
		ld a,0
		out (TILEMAP_WRITE),a				;clear cursor when enter pressed
		cp d
		jr nz,commandbuffernotempty
		cp e
		jr nz,commandbuffernotempty
		call NewLine
		ret
	commandbuffernotempty
		add hl,de
		;ld a,0
		ld (hl),a
		ld (CMDBUFFPTR),de
		ld hl,0
		ld (CMDBUFFPTR2),hl
		call ParseLine
		call CheckIntCmd
		call NewLine
		ret
		
	ParseLine
		ld de,(CMDBUFFPTR)
		ld a,0
		cp e
		jr nz,cmdbuffernotzero2
		cp d
		jr nz,cmdbuffernotzero2
		ret
	cmdbuffernotzero2
		
		call GetNextCmdChunk
		ret
		
	GetNextCmdChunk
		ld bc,(CMDBUFFPTR2)
		ld hl,CMDBUFFER
		add hl,bc
		ld de,CMDBUFFER2
	GetNextCmdChunkLoop
		ld a,(hl)
		cp $20			;space
		jr z,GetCmdEndChunk
		cp 0			;end of line
		jr z,GetCmdEndChunk2
		ld (de),a
		inc bc
		inc hl
		inc de
		jr GetNextCmdChunkLoop
		
	GetCmdEndChunk	
		inc bc
	GetCmdEndChunk2
		ld (CMDBUFFPTR2),bc
		ld a,0
		ld (de),a		;place of of line marker
		ld hl,CMDBUFFER2
		call UpCase
		;call EndLine
		
		;call WriteLine
		ld hl,0
		ld (CMDBUFFPTR),hl
		ret
		
	;This checks whether the entered command is a valid ROM routine
	;command is in buffer CMDBUFFER2 and should already
	;be converted to UCASE
	CheckIntCmd
		ld de,CMDTABLE		;list of valid commands are stored here
							;as null terminated strings
							;along with the address of their routines
							;list is also null terminated
	CheckIntCmdLoop1
		ld hl,CMDBUFFER2
		ld a,(de)
		cp 0				;end of command list
		jr z,CheckIntCmdNoMatches
	CheckIntCmdLoop2
		ld a,(de)
		;push af
		;call DispA
		;pop af
		cp (hl)
		jr nz,CheckIntCmdNotMatched
		cp 0				;is it the end of the string
		jr z,CheckIntCmdMatched
		inc hl
		inc de
		jr CheckIntCmdLoop2
	CheckIntCmdNotMatched
		cp 0
		jr z,CheckIntCmdNotMatched2	;not match and at end of CMD
		;not at end of command so need to advance pointer
	CheckIntCmdAdvancePointer
		inc de
		ld a,(de)
		;push af
		;call DispA
		;pop af
		cp 0
		jr nz,CheckIntCmdAdvancePointer
	CheckIntCmdNotMatched2
		inc de				;skip past bytes holding calling address
		inc de				;of previous command
		inc de
		
		;ld a,(de)
		;push af
		;call DispA
		;pop af
		jr CheckIntCmdLoop1
	CheckIntCmdNoMatches
		call EndLine
		ld hl,cmdnotfoundmessage
		call WriteString
		ret
	
	CheckIntCmdMatched
		ex de,hl
		inc hl
		ld e,(hl)			;get adddress of routine for
		inc hl				;matched command
		ld d,(hl)
		ex de,hl
		jp (hl)				;jump to command routine
							;let ret from that routine return to calling code
	
	;compares string buffers pointer to by DE and HL
	CompareStrings
		CompareStringsLoop
		ld a,(de)
		cp (hl)
		jr nz,CompareStringsNotMatched
		cp 0				;is it the end of the string
		jr z,CompareStringsMatched
		inc hl
		inc de
		inc b
		jr CompareStringsLoop
	CompareStringsNotMatched
		ld a,1
		ret
	CompareStringsMatched
		ret
	
	
	
	;Convert Text String to UpperCase
	UpCase
		ld a,(hl)
		cp 0
		jr z,UpCaseDone		;end of string
		cp 'a'				;a
		jr c,UpCaseNoConvert
		cp 'z'+1			;z + 1
		jr nc,UpCaseNoConvert
		sub 'a'-'A'
		ld (hl),a
	UpCaseNoConvert
		inc hl
		jr UpCase
	UpCaseDone
		ret
		
	
		
	;initialise SD Card
	CheckDrives
		;temp - get current clkdiv
		
		call waitsd		
		
		;clear any previous error state
		ld hl,$0000			;hlde is 32 bit argument
		ld de,$0000
		ld ix,$0080			;ix has additional args for CMD (0x80 is clear error)
		ld a,0
		call send_CMD	
		
		;set sd clock spped to 400khz
		ld hl,$0000			;hlde is 32 bit argument
		ld de,$003E
		ld ix,$0000
		ld a,SD_SETAUX
		call send_CMD		
	
	
	
	;next block is temp to read out the internal config		
		;ld a,0
		;out (SDCARD_ADDR),a  ;set addr to command
		;ld a,$bf	;read internal config
		;out (SDCARD_BYTE0),a
		;out (SDCARD_CMD),a
		;call print_sd_data
	
	
		
	;	ld hl,sdmessage1		;pointer to message
	;	call WriteLine	;write message to screen 
		
	;	ld hl,sdmessage2		;pointer to message
	;	call WriteLine			;write message to screen
		
	
	
		
	;request SD Card go IDLE
	go_idle_loop
		
		ld	a,GO_IDLE_STATE		;CMD 0
		ld	hl,$0000			;ARGS
		ld	de,$0000	
		ld	ix,$0080			;clear any errors
		call send_CMD
		
	;	ld hl,sdmessage4		;pointer to message
	;	call WriteLine	;write message to screen
	
	
	
		call checksdresponse
	
	
	
	
		jr	c,go_idle_loop
		cp $01				;did we get idle response
		jr nz,go_idle_loop
		
	;	ld hl,sdmessage5	;pointer to message
	;	call WriteLine		;write message to screen
		
			
		;Check for compatible card
		
		ld	a,SEND_OP_COND		;CMD 1
		ld	hl,$4000			;ARGS
		ld	de,$0000
		ld	ix,$0000
		call send_CMD
		
	
	
		
	;	ld hl,sdmessage3		;pointer to message
	;	call WriteLine	;write message to screen
		
		ld	a,SEND_IF_COND		;CMD 8
		ld	hl,$0000			;ARGS
		ld	de,$01AA		
		ld	ix,$0003			;R2/R3/r7 Response
		call send_CMD
		
		
	
	;	ld hl,sdmessage4		;pointer to message
	;	call WriteLine			;write message to screen
		
		call checksdresponse
		
		;call print_sd_data
			
		jp c,start2
				
		
		cp $1				;is it a version 2
		jr nz,duffcard
		
	
	;	ld hl,sdmessage5	;pointer to message
	;	call WriteLine		;write message to screen
		call get_sd_data			;return data into hlde
		
		
		ld a,d
		;push af
		;call DispA
		;pop af
		cp $01
		jr nz,duffcard
		ld a,e
		;push af
		;call DispA
		;pop af
		cp $AA
	
		jr nz,duffcard
		jr nextcmd
	duffcard
		
		ld hl,sdmessageerr		;pointer to message
		call WriteLine			;write message to screen
		jp start2			;skip rest of card init
		
	nextcmd
		
		;ld hl,sdmessage6	;pointer to message
		;call WriteLine		;write message to screen
	
	
		
	;APP_CMD
		;call waitsd
	sd_init_loop
		
		
		
	;	ld hl,sdmessage7	;pointer to message
	;	call WriteLine		;write message to screen
		
	;	call flushspi
		
		ld	a,APP_CMD			;CMD 55
		ld	hl,$0000			;ARGS
		ld	de,$0000
		ld	ix,$0000	
		call send_CMD
		
		
	;	ld hl,sdmessage4		;pointer to message
	;	call WriteLine			;write message to screen
		
		call checksdresponse
		jp c,start2
		
	;SEND ACMD41
		
	;	ld hl,sdmessage8	;pointer to message
	;	call WriteLine		;write message to screen
		
		;call flushspi
		
		ld	a,ACMD41			;CMD 41
		ld	hl,$4000			;ARGS
		ld	de,$0000
		ld	ix,$0000				;CRC
		call send_CMD
		
	;	ld hl,sdmessage4		;pointer to message
	;	call WriteLine			;write message to screen
		
		call checksdresponse
		;push af
		;call DispA
		;pop af
		jp c,start2
		
		cp 0				;if not 0 then
		jr z,sd_init_done	;card is not yet ready
		
		
		;ld a,11
		;out (TILEMAP_Y_VAL),a        ;move cursor back up
		jr sd_init_loop
	sd_init_done
		
		
	;Read OCR
	read_ocr_label
		
		
	;	ld hl,sdmessage9	;pointer to message
	;	call WriteLine		;write message to screen
	
	;	call flushspi
		
		ld	a,READ_OCR			;CMD 58
		ld	hl,$0000			;ARGS
		ld	de,$0000
		ld	ix,SD_READREG			
		call send_CMD
		
		
	;	ld hl,sdmessage4		;pointer to message
	;	call WriteLine			;write message to screen
		
		call checksdresponse
	;	push af
	;	call DispA
	;	pop af
		jp c,start2
		
		cp 0			;status byte should be 0 now
		jp nz,duffcard
		
		call get_sd_data
		ld a,h					;sd card type
		and	$40			;get HC flag
		ld (SDCARDINFO1),a
	;	call DispA
		
		ld a,l			;key voltage range byte		
	;	push af
	;	call DispA
	;	pop af
		and $fc			;3.0v to 3.6b (+/- 0.3v)
		cp $fc
		jp nz,duffcard
		
		
		
		
	;	ld hl,sdmessage10		;pointer to message
	;	call WriteLine			;write message to screen
		
	;set block length to 512 for non SDHC cards
		ld a,(SDCARDINFO1)
		and $40				;check SDHC
		jr nz,skipblocklen
		
	
		
		ld	a,SET_BLOCKLEN		;CMD 16
		ld	hl,$0000			;ARGS
		ld	de,$0200
		ld	ix,$0000			;CRC
		call send_CMD
		
		call checksdresponse
	;	push af
	;	call DispA
	;	pop af
		jp c,start2
		
		;ld a,($30)
		;cp 0
		;jp nz,duffcard
		
	skipblocklen
	
	
	
		;set sd clock speed full
		ld hl,$0000			;hlde is 32 bit argument
		ld de,$0001
		ld ix,$0000
		ld a,SD_SETAUX
		call send_CMD		
		
		call SD_GetVolumes	;check for valid volumes
		;will return carry set is no volumes
	
	
	
		jp c,duffcard
		
		ld hl,sdmessage11		;pointer to message
		call WriteString			;write message to screen
		ld a,(SDCARDVOLS)
		call DispA
		call EndLine
		
	
	
		ret
		
	;========================================================
	;Routine to get the next entry from the directory listing
	;========================================================
	SD_ReadDirectory
		ld a,(DIRREADPOS)			;do we need to read a new sector
		inc a
		cp 16						;16 x 32 byte directory entries per 512 byte sector
									;TODO - this hardcodes dector size to 512 bytes
									;should really use the Bytes Per Sector data instead
		jr nz,SD_ReadDirectoryNoIncSector
		
		ld de,(SDVOLSTRUCT+SD_DIR_SECTOR)
		ld hl,(SDVOLSTRUCT+SD_DIR_SECTOR+2)
		call SD_ReadSector
		ld de,(SDVOLSTRUCT+SD_DIR_SECTOR)
		ld hl,(SDVOLSTRUCT+SD_DIR_SECTOR+2)
		ld bc,1						;increase current sector by 1
		call addBC2HLDE
		ld (SDVOLSTRUCT+SD_DIR_SECTOR),de
		ld (SDVOLSTRUCT+SD_DIR_SECTOR+2),hl
		
		ld a,0
		
		
		
	SD_ReadDirectoryNoIncSector
		ld (DIRREADPOS),a
		;calc sector offset (a contains entry number)
		ld bc,32				;size of fat entry
		ld hl,0
	SD_ReadDirectoryCalcOffsetLoop
		cp 0					;Stop adding offset when a get to 0
		jr z,SD_ReadDirectoryCalcOffsetDone
		add hl,bc
		dec a
		jr SD_ReadDirectoryCalcOffsetLoop
	SD_ReadDirectoryCalcOffsetDone
		ld bc,SDBUFFER
		add hl,bc				;hl now points to correct place in buffer
		push hl
		pop ix					;copy into IX
		
		ld a,(ix+11)		;atributes
		
		;push af
		;call DispA
		;pop af
		
		and $0f				;longname
		cp $0f
		jp z,SD_ReadDirectory_LongName		
		ld a,(ix)			;DIR_Name [0]
		cp $00
		jp z,SD_ReadDirectoryFinish
		cp $e5				;empty entry
		jp z,SD_ReadDirectoryNoEntry
		
		
		
		;push hl
		;ld a,0				;x pos
		;out (TILEMAP_X_VAL),a			;set x pos
		;out (TILEMAP_INC_ROW),a			;set y pos
		;ld b,11
		;call writemessage
		;pop hl
		
		;valid entry according to DirName
		
		push hl
		call SD_Convertto83
		
		pop hl					;hl points to start of 11 char filename
		call SD_CalcChecksum
		
		
		
		;read date stamp
		ld a,(ix+24)	;date lo byte
		and $1f			;day - 1 to 31
		ld (SDDAY),a
		ld e,(ix+24)
		ld d,(ix+25)
		rr d
		rr e
		srl e
		srl e
		srl e
		srl e
		ld a,e
		and $f			;month - 1 to 12
		ld (SDMONTH),a
		ld a,(ix+25)	;date hi byte
		srl a
		and $7f			;year - 1980 to 2,107
		ld c,a
		ld b,0
		ex de,hl
		ld hl,1980
		add hl,bc
		ld (SDYEAR),hl
		ld de,SDDATEBUFFER+6
		call word2ascii
		ld hl,SDDATEBUFFER+6
		ld a,'/'
		ld (hl),a
		ld a,(SDMONTH)
		ld hl,SDDATEBUFFER+3
		call byte2ascii
		ld hl,SDDATEBUFFER+3
		ld a,'/'
		ld (hl),a
		ld a,(SDDAY)
		ld hl,SDDATEBUFFER
		call byte2ascii
		ld hl,SDDATEBUFFER
		ld hl,SDDATEBUFFER+11
		ld a,0
		ld (hl),a			;null terminate
		
		;read time stamp
		ld a,(ix+22)	;time lo byte
		sla a
		and $3f			;time - 0 to 58
		ld (SDSECS),a
		ld e,(ix+22)
		ld d,(ix+23)
		rr d
		rr e
		rr d
		rr e
		rr d
		rr e
		srl e
		srl e
		ld a,e
		and $3f			;mins - 0 to 59
		ld (SDMINS),a
		ld a,(ix+23)	;date hi byte
		srl a
		srl a
		srl a
		and $1f			;hours - 0 to 23
		ld (SDHOURS),a
		ld a,(SDSECS)
		ld hl,SDTIMEBUFFER+6
		call byte2ascii
		ld hl,SDTIMEBUFFER+6
		ld a,':'
		ld (hl),a
		ld a,(SDMINS)
		ld hl,SDTIMEBUFFER+3
		call byte2ascii
		ld hl,SDTIMEBUFFER+3
		ld a,':'
		ld (hl),a
		ld a,(SDHOURS)
		ld hl,SDTIMEBUFFER
		call byte2ascii
		ld hl,SDTIMEBUFFER
		ld hl,SDTIMEBUFFER+9
		ld a,0
		ld (hl),a			;null terminate
		
		;get start sector of file/dir
		;call EndLine
		;ld l,(ix+26)
		;ld h,(ix+27)
		;call DispHL
		;call EndLine
		;ld l,(ix+20)
		;ld h,(ix+21)
		;call DispHL
		
		ld l,(ix+26)
		ld h,(ix+27)
		ld e,(ix+20)
		ld d,(ix+21)
		
		ld a,(ix+26)				;hack here as the '..'
		add a,(ix+27)				;entries in folders above root
		add a,(ix+20)				;point to cluster 0 rather than 2
		add a,(ix+21)				;so we check to see if we are going to cluster
		ld bc,0						;0 and if so do not subtract the 2
		cp 0
		jr z,SD_ReadDirectoryRetToRoot
		ld bc,2
	SD_ReadDirectoryRetToRoot
	
		and a						;clear carry
		sbc hl,bc
		jr nc,SD_ReadDirectorySecCalcNC
		dec de
	SD_ReadDirectorySecCalcNC
	
		
		;push hl
		;call EndLine
		;call DispHL
		;pop hl
		
		
		ex de,hl
		
		;push hl
		;call EndLine
		;call DispHL
		;pop hl
		
		ld a,(SDVOLSTRUCT+SD_BPB_SECPERCLUS)		;sectors per cluster
		
		;push af
		;call DispA
		;pop af
		
		call DEHL_Times_A3
		ld (SDFILESECTOR),hl
		ld (SDFILESECTOR+2),de
		
		;call EndLine
		;call DispHL
		;call EndLine
		;ld hl,(SDFILESECTOR+2)
		;call DispHL
		;ld hl,(SDFILESECTOR)
		
		ld de,(SDVOLSTRUCT+SD_FIRST_DATA_SEC)		;first data sector
		add hl,de
		ld (SDFILESECTOR),hl
		jr nc,SD_ReadDirectorySecCalcNC2
		ld hl,SDFILESECTOR+2
		inc hl
	SD_ReadDirectorySecCalcNC2
		
		
		ld a,(ix+11)
		and $10			;is it a directory?
		jr nz,SD_ReadDirectoryIsDir
		ld e,(ix+28)
		ld d,(ix+29)
		ld l,(ix+30)
		ld h,(ix+31)
		ld (SDFILESIZE),de
		ld (SDFILESIZE+2),hl
		ld bc,SDSIZEBUFFER
		call long2ascii
		ld hl,SDSIZEBUFFER
		call FormatNumber32
		jr SD_ReadDirectoryNotDir
	SD_ReadDirectoryIsDir
		ld de,NUMFORMATBUF	;copy <DIR> into string
		ld hl,dirstring
		ld bc,6
		ldir
		ld hl,0
		ld (SDFILESIZE),hl
		ld (SDFILESIZE+2),hl
	SD_ReadDirectoryNotDir
	
		
	
		ld a,$ff
		ret
		
	SD_ReadDirectoryNoEntry
		;ld de,32
		;add ix,de
		;jr SD_ReadDirectory_loop1
		ld a,2
		ret
		
	SD_ReadDirectory_LongName
		ld a,(ix+0)					;get entry number
		and $3f						;mask off last entry bit
		dec a						;position entries start a 1 so adjust for offset calc
		ld bc,13					;length of each LFN sub entry
		ld hl,0
	SD_ReadDirectory_LongName_Loop1
		cp 0
		jr z,SD_ReadDirectory_LongName_Loop1_Done
		add hl,bc
		dec a
		jr SD_ReadDirectory_LongName_Loop1
	SD_ReadDirectory_LongName_Loop1_Done
		;hl now hold correct offset
		ld bc,LFNBUFFER
		add hl,bc
		;hl now hold correct address in buffer
		;each lfn entry is 16 bits but we will only use 8
		ld b,5
		push ix
	SD_ReadDirectory_LongName_Loop2
		ld a,(ix+1)
		ld (hl),a
		inc hl
		inc ix
		inc ix
		djnz SD_ReadDirectory_LongName_Loop2
		pop ix
		
		ld b,6
		push ix
	SD_ReadDirectory_LongName_Loop3
		ld a,(ix+14)
		ld (hl),a
		inc hl
		inc ix
		inc ix
		djnz SD_ReadDirectory_LongName_Loop3
		pop ix
		
		ld a,(ix+28)
		ld (hl),a
		inc hl
		ld a,(ix+30)
		ld (hl),a
		inc hl
		
		ld a,(ix+0)
		and $40
		jr z,SD_ReadDirectory_LongName_NotEnd
		ld a,0
		ld (hl),a
	SD_ReadDirectory_LongName_NotEnd
		;ld de,32
		;add ix,de
		;jr SD_ReadDirectory_loop1
		ld a,1						;return code
		ret
		
	SD_ReadDirectoryFinish
	;if we came here as end of directory then return code is 0
		
		
		ld a,0
		ret
		
		
	;========================================================
	;Routine to copy raw directory listing into RAM
	;========================================================
	SD_ReadDirectory_2_RAM
		ld a,(DIRREADPOS)			;do we need to read a new sector
		inc a
		cp 16						;16 x 32 byte directory entries per 512 byte sector
									;TODO - this hardcodes dector size to 512 bytes
									;should really use the Bytes Per Sector data instead
		jr nz,SD_ReadDirectory_2_RAM_NoIncSector
		
		ld de,(SDVOLSTRUCT+SD_DIR_SECTOR)
		ld hl,(SDVOLSTRUCT+SD_DIR_SECTOR+2)
		call SD_ReadSector
		ld de,(SDVOLSTRUCT+SD_DIR_SECTOR)
		ld hl,(SDVOLSTRUCT+SD_DIR_SECTOR+2)
		ld bc,1						;increase current sector by 1
		call addBC2HLDE
		ld (SDVOLSTRUCT+SD_DIR_SECTOR),de
		ld (SDVOLSTRUCT+SD_DIR_SECTOR+2),hl
		
		ld a,0
		
		
		
	SD_ReadDirectory_2_RAM_NoIncSector
		ld (DIRREADPOS),a
		;calc sector offset (a contains entry number)
		ld bc,32				;size of fat entry
		ld hl,0
	SD_ReadDirectory_2_RAM_CalcOffsetLoop
		cp 0					;Stop adding offset when a get to 0
		jr z,SD_ReadDirectory_2_RAM_CalcOffsetDone
		add hl,bc
		dec a
		jr SD_ReadDirectory_2_RAM_CalcOffsetLoop
	SD_ReadDirectory_2_RAM_CalcOffsetDone
		ld bc,SDBUFFER
		add hl,bc				;hl now points to correct place in buffer
		push hl
		
		
		pop ix					;copy into IX
		
		ld a,(ix)
		cp $00
		ret z
		cp $e5
		ret z
		
		ld a,(ix+11)		;atributes
		
		cp $08
		jr z,SD_ReadDirectory_2_RAM_VolName
		ret
	SD_ReadDirectory_2_RAM_VolName		
		ld de,SD_VOLNAME
		ld bc,11
		ldir					;copy Volume Name into variable
		ld a,0
		ex de,hl
		ld (hl),0				;null terminate
		push ix
		pop hl
		ld a,$e5				;signal to skip retrieving this entry as we now have the volume name
		ret
		
	;========================================================
	;Routine to process a directory listing once in RAM
	;========================================================
	Process_RAM_Dir_Entry
		push ix
		pop hl
		ld a,(ix+11)
		and $0f				;longname
		cp $0f
		jp z,Process_RAM_Dir_Entry_LongName		
		ld a,(ix)			;DIR_Name [0]
				
		push hl
		call SD_Convertto83
		
		pop hl					;hl points to start of 11 char filename
		call SD_CalcChecksum
		
		
		
		;read date stamp
		ld a,(ix+24)	;date lo byte
		and $1f			;day - 1 to 31
		ld (SDDAY),a
		ld e,(ix+24)
		ld d,(ix+25)
		rr d
		rr e
		srl e
		srl e
		srl e
		srl e
		ld a,e
		and $f			;month - 1 to 12
		ld (SDMONTH),a
		ld a,(ix+25)	;date hi byte
		srl a
		and $7f			;year - 1980 to 2,107
		ld c,a
		ld b,0
		ex de,hl
		ld hl,1980
		add hl,bc
		ld (SDYEAR),hl
		ld de,SDDATEBUFFER+6
		call word2ascii
		ld hl,SDDATEBUFFER+6
		ld a,'/'
		ld (hl),a
		ld a,(SDMONTH)
		ld hl,SDDATEBUFFER+3
		call byte2ascii
		ld hl,SDDATEBUFFER+3
		ld a,'/'
		ld (hl),a
		ld a,(SDDAY)
		ld hl,SDDATEBUFFER
		call byte2ascii
		ld hl,SDDATEBUFFER
		ld hl,SDDATEBUFFER+11
		ld a,0
		ld (hl),a			;null terminate
		
		;read time stamp
		ld a,(ix+22)	;time lo byte
		sla a
		and $3f			;time - 0 to 58
		ld (SDSECS),a
		ld e,(ix+22)
		ld d,(ix+23)
		rr d
		rr e
		rr d
		rr e
		rr d
		rr e
		srl e
		srl e
		ld a,e
		and $3f			;mins - 0 to 59
		ld (SDMINS),a
		ld a,(ix+23)	;date hi byte
		srl a
		srl a
		srl a
		and $1f			;hours - 0 to 23
		ld (SDHOURS),a
		ld a,(SDSECS)
		ld hl,SDTIMEBUFFER+6
		call byte2ascii
		ld hl,SDTIMEBUFFER+6
		ld a,':'
		ld (hl),a
		ld a,(SDMINS)
		ld hl,SDTIMEBUFFER+3
		call byte2ascii
		ld hl,SDTIMEBUFFER+3
		ld a,':'
		ld (hl),a
		ld a,(SDHOURS)
		ld hl,SDTIMEBUFFER
		call byte2ascii
		ld hl,SDTIMEBUFFER
	IF	DIR_SHOW_SECONDS		;assembly control whether seconds are displayed
		ld hl,SDTIMEBUFFER+9
	ELSE
		ld hl,SDTIMEBUFFER+6
	ENDIF
		ld a,0
		ld (hl),a			;null terminate
		
		;get start sector of file/dir
		;call EndLine
		;ld l,(ix+26)
		;ld h,(ix+27)
		;call DispHL
		;call EndLine
		;ld l,(ix+20)
		;ld h,(ix+21)
		;call DispHL
		
		ld l,(ix+26)
		ld h,(ix+27)
		ld e,(ix+20)
		ld d,(ix+21)
		
		ld a,(ix+26)				;hack here as the '..'
		add a,(ix+27)				;entries in folders above root
		add a,(ix+20)				;point to cluster 0 rather than 2
		add a,(ix+21)				;so we check to see if we are going to cluster
		ld bc,0						;0 and if so do not subtract the 2
		cp 0
		jr z,Process_RAM_Dir_EntryRetToRoot
		ld bc,2
	Process_RAM_Dir_EntryRetToRoot
	
		and a						;clear carry
		sbc hl,bc
		jr nc,Process_RAM_Dir_EntrySecCalcNC
		dec de
	Process_RAM_Dir_EntrySecCalcNC
	
		
		;push hl
		;call EndLine
		;call DispHL
		;pop hl
		
		
		ex de,hl
		
		;push hl
		;call EndLine
		;call DispHL
		;pop hl
		
		ld a,(SDVOLSTRUCT+SD_BPB_SECPERCLUS)		;sectors per cluster
		
		;push af
		;call DispA
		;pop af
		
		call DEHL_Times_A3
		ld (SDFILESECTOR),hl
		ld (SDFILESECTOR+2),de
		
		;call EndLine
		;call DispHL
		;call EndLine
		;ld hl,(SDFILESECTOR+2)
		;call DispHL
		;ld hl,(SDFILESECTOR)
		
		ld de,(SDVOLSTRUCT+SD_FIRST_DATA_SEC)		;first data sector
		add hl,de
		ld (SDFILESECTOR),hl
		jr nc,Process_RAM_Dir_EntrySecCalcNC2
		ld hl,SDFILESECTOR+2
		inc hl
	Process_RAM_Dir_EntrySecCalcNC2
		
		
		ld a,(ix+11)
		and $10			;is it a directory?
		jr nz,Process_RAM_Dir_EntryIsDir
		ld e,(ix+28)
		ld d,(ix+29)
		ld l,(ix+30)
		ld h,(ix+31)
		ld (SDFILESIZE),de
		ld (SDFILESIZE+2),hl
		;ld bc,SDSIZEBUFFER
		;call long2ascii
		;ld hl,SDSIZEBUFFER
		ex de,hl
		push ix
		call B2D32
		pop ix
		ld hl,B2DEND-10
		call FormatNumber32
		jr Process_RAM_Dir_EntryNotDir
	Process_RAM_Dir_EntryIsDir
		ld de,NUMFORMATBUF	;copy <DIR> into string
		ld hl,dirstring
		ld bc,6
		ldir
		ld hl,0
		ld (SDFILESIZE),hl
		ld (SDFILESIZE+2),hl
		ld a,$fe
		ret
	Process_RAM_Dir_EntryNotDir
		ld hl,(SD_DIR_NUM_BYTES)
		ld de,(SDFILESIZE)
		add hl,de
		ld (SD_DIR_NUM_BYTES),hl
		ld hl,(SD_DIR_NUM_BYTES+2)
		ld de,(SDFILESIZE+2)
		adc hl,de
		ld (SD_DIR_NUM_BYTES+2),hl
		ld a,$ff
		ret
		
	;Process_RAM_Dir_EntryNoEntry
		;ld de,32
		;add ix,de
		;jr SD_ReadDirectory_loop1
	;	ld a,2
	;	ret
		
	Process_RAM_Dir_Entry_LongName
		ld a,(ix+0)					;get entry number
		and $3f						;mask off last entry bit
		dec a						;position entries start a 1 so adjust for offset calc
		ld bc,13					;length of each LFN sub entry
		ld hl,0
	Process_RAM_Dir_Entry_LongName_Loop1
		cp 0
		jr z,Process_RAM_Dir_Entry_LongName_Loop1_Done
		add hl,bc
		dec a
		jr Process_RAM_Dir_Entry_LongName_Loop1
	Process_RAM_Dir_Entry_LongName_Loop1_Done
		;hl now hold correct offset
		ld bc,LFNBUFFER
		add hl,bc
		;hl now hold correct address in buffer
		;each lfn entry is 16 bits but we will only use 8
		ld b,5
		push ix
	Process_RAM_Dir_Entry_LongName_Loop2
		ld a,(ix+1)
		ld (hl),a
		inc hl
		inc ix
		inc ix
		djnz Process_RAM_Dir_Entry_LongName_Loop2
		pop ix
		
		ld b,6
		push ix
	Process_RAM_Dir_Entry_LongName_Loop3
		ld a,(ix+14)
		ld (hl),a
		inc hl
		inc ix
		inc ix
		djnz Process_RAM_Dir_Entry_LongName_Loop3
		pop ix
		
		ld a,(ix+28)
		ld (hl),a
		inc hl
		ld a,(ix+30)
		ld (hl),a
		inc hl
		
		ld a,(ix+0)
		and $40
		jr z,Process_RAM_Dir_Entry_LongName_NotEnd
		ld a,0
		ld (hl),a
	Process_RAM_Dir_Entry_LongName_NotEnd
		;ld de,32
		;add ix,de
		;jr SD_ReadDirectory_loop1
		ld a,1						;return code
		ret
		
	Process_RAM_Dir_EntryFinish
	;if we came here as end of directory then return code is 0
		
		
		ld a,0
		ret		
		
	;search for a file in the current directory
	;filename should be in CMDBUFFER2
	SD_FindFile
		ld a,15					;will trigger new sector read
								;TODO - this hardcodes dector size to 512 bytes
								;should really use the Bytes Per Sector data instead
		ld (DIRREADPOS),a
		ld de,(SDVOLSTRUCT+SD_CURR_SECTOR)		
		ld hl,(SDVOLSTRUCT+SD_CURR_SECTOR+2)
		ld (SDVOLSTRUCT+SD_DIR_SECTOR),de
		ld (SDVOLSTRUCT+SD_DIR_SECTOR+2),hl
	SD_FindFile_Loop
		call SD_ReadDirectory
		cp 0							;is return code 0?
		jr z,SD_FindFile_Done		;if so finish listing
		
		cp $ff							;is is a valid entry
		jr nz,SD_FindFile_Loop		;if not loop to next entry
		
		;compare code here
		;ld hl,SD83BUFFER
		;call WriteLine
		ld hl,SD83BUFFER
		ld de,CMDBUFFER2
		
		call CompareStrings
		
		jr nz,SD_FindFile_Loop
		ld a,$ff ;set return code
	SD_FindFile_Done
		ret
		
	CMD_GetDirectory
		ld a,DIR_RAM_BANK			;page in RAM to store directory listing
		out (RAM_BANK_6),a
		ld a,DIR_RAM_BANK+1
		out (RAM_BANK_7),a
		
		ld hl,0
		ld (SD_DIR_NUM_ENTRIES),hl
		ld (SD_DIR_NUM_FILES),hl
		ld (SD_DIR_NUM_DIRS),hl
		ld (SD_DIR_NUM_BYTES),hl
		ld (SD_DIR_NUM_BYTES+2),hl
		
		ld de,$c000					;position in RAM of next directory entry
		push de
		
		ld a,0					;reset directory entries
		ld (NEWDIRREAD),a
		ld a,15					;will trigger new sector read
								;TODO - this hardcodes dector size to 512 bytes (16 entries * 32 bytes = 512)
								;should really use the Bytes Per Sector data instead
		ld (DIRREADPOS),a
		ld de,(SDVOLSTRUCT+SD_CURR_SECTOR)		
		ld hl,(SDVOLSTRUCT+SD_CURR_SECTOR+2)
		ld (SDVOLSTRUCT+SD_DIR_SECTOR),de
		ld (SDVOLSTRUCT+SD_DIR_SECTOR+2),hl
		
		
	CMD_GetDirectory_Loop		
		call SD_ReadDirectory_2_RAM
		cp 0							;is return code 0?
		jr z,CMD_GetDirectory_Done		;if so finish listing
		
		cp $e5							;is is a valid entry
		jr z,CMD_GetDirectory_Loop		;if not loop to next entry
		
		pop de							;retrieve position in RAM
		ld bc,32						;32 bytes per entry
		ldir							;copy the 32 bytes
		push de							;store DE ready for next loop
		ld hl,(SD_DIR_NUM_ENTRIES)
		inc hl
		ld (SD_DIR_NUM_ENTRIES),hl
		
		
		jr CMD_GetDirectory_Loop
	CMD_GetDirectory_Done
		pop de							;retrieve DE to balance stack
	
		;Display volume name and serial
		call EndLine
		ld hl,volumestring
		call WriteString
		ld a,(SDCURRVOL)		;get current volume number
		add a,65			;convert to drive letter
		call PUTCHAR
		ld hl,volumestring2
		call WriteString
		;out (TILEMAP_INC),a
		ld hl,SD_VOLNAME
		call WriteLine
		ld hl,volserialstring
		call WriteString
		ld hl,(SDVOLSTRUCT+SD_BS_VOLID+2)
		call DispHLhex
		ld a,'-'
		call PUTCHAR
		ld hl,(SDVOLSTRUCT+SD_BS_VOLID)
		call DispHLhex
		call EndLine
		call EndLine
		ld hl,dirofstring
		call WriteString
		ld hl,SDVOLSTRUCT+SD_CURR_DIR_STRING
		call WriteLine
		call EndLine		
		ld a,(SD_DIR_NUM_ENTRIES)
		ld hl,SD_DIR_NUM_ENTRIES+1
		or (hl)
		jp z,CMD_GetDirectory_Empty		
		;ld hl,0
			
		;call EndLine
		ld hl,(SD_DIR_NUM_ENTRIES)
		;call DispHL
		;call EndLine
		push hl
		pop bc						;counter for number of entries to process		
		;ld bc,30
		ld ix,$c000					;point IX to start of data
	CMD_GetDirectory_Process_Loop
		push bc
		call Process_RAM_Dir_Entry
		ld bc,32
		add ix,bc
		cp $fe
		jp c,CMD_GetDirectory_not_Valid
		
		cp $fe
		jr z,CMD_GetDirectory_IncDir
		ld hl,(SD_DIR_NUM_FILES)
		inc hl
		ld (SD_DIR_NUM_FILES),hl
		jr CMD_GetDirectory_IncDir2
	CMD_GetDirectory_IncDir
		ld hl,(SD_DIR_NUM_DIRS)
		inc hl
		ld (SD_DIR_NUM_DIRS),hl
	CMD_GetDirectory_IncDir2
		
		;**** Print Directory Entry Details
		;call DispA
		;ld a,4
		;out (TILEMAP_X_VAL),a
		ld hl,SDDATEBUFFER+1
		call WriteString
		ld a,12
		out (TILEMAP_X_VAL),a
		ld hl,SDTIMEBUFFER+1
		call WriteString
	IF DIR_SHOW_SECONDS
		ld a,23
	ELSE
		ld a,20
	ENDIF
		out (TILEMAP_X_VAL),a
		ld hl,NUMFORMATBUF
		call WriteString
	IF DIR_SHOW_SECONDS
		ld a,37
	ELSE
		ld a,34
	ENDIF
		out (TILEMAP_X_VAL),a
		ld hl,SD83BUFFER
		call WriteString
	IF DIR_SHOW_SECONDS
		ld a,50
	ELSE
		ld a,47
	ENDIF		
		out (TILEMAP_X_VAL),a
		ld hl,LFNBUFFER
		call WriteLine
	
		ld a,0
		ld (LFNBUFFER),a
		
	
		
	CMD_GetDirectory_not_Valid	
		
		pop bc
		dec c
		jr nz,CMD_GetDirectory_Process_Loop
		dec b
		jp p,CMD_GetDirectory_Process_Loop
		ld hl,(SD_DIR_NUM_FILES)
	CMD_GetDirectory_Empty
		;Show Total Files message
		ld a,10
		out (TILEMAP_X_VAL),a
		;ld de,SDSIZEBUFFER
		call B2D16		
		;ld a,0
		;ld (SDSIZEBUFFER+5),a
		;ld hl,SDSIZEBUFFER
		ld hl,B2DEND-5
		call FormatNumber16
		ld hl,NUMFORMATBUF
		call WriteString		
		ld hl,filetotstring
		call WriteString
		
		ld hl,(SD_DIR_NUM_BYTES)
		ld de,(SD_DIR_NUM_BYTES+2)
		ld a,24
		out (TILEMAP_X_VAL),a
		;ld bc,SDSIZEBUFFER
		;call long2ascii		
		call B2D32
		;ld a,0
		;ld (SDSIZEBUFFER+5),a
		ld hl,B2DEND-10
		call FormatNumber32
		ld hl,NUMFORMATBUF
		call WriteString		
		ld hl,bytetotstring
		call WriteLine
		
		ld hl,(SD_DIR_NUM_DIRS)
		ld a,10
		out (TILEMAP_X_VAL),a		
		;ld de,SDSIZEBUFFER
		;call word2ascii		
		call B2D16
		;ld a,0
		;ld (SDSIZEBUFFER+5),a
		;ld hl,SDSIZEBUFFER
		ld hl,B2DEND-5
		call FormatNumber16
		ld hl,NUMFORMATBUF
		call WriteString		
		ld hl,dirtotstring
		call WriteLine
		
		call ClearCMDBuffer
		ret
		
	CMD_GetDirectory2
		call EndLine
		ld hl,volumestring
		call WriteString
		out (TILEMAP_INC),a
		ld a,0					;reset directory entries
		ld (NEWDIRREAD),a
		ld a,15					;will trigger new sector read
								;TODO - this hardcodes dector size to 512 bytes (16 entries * 32 bytes = 512)
								;should really use the Bytes Per Sector data instead
		ld (DIRREADPOS),a
		ld de,(SDVOLSTRUCT+SD_CURR_SECTOR)		
		ld hl,(SDVOLSTRUCT+SD_CURR_SECTOR+2)
		ld (SDVOLSTRUCT+SD_DIR_SECTOR),de
		ld (SDVOLSTRUCT+SD_DIR_SECTOR+2),hl
	CMD_GetDirectory2_Loop
		call SD_ReadDirectory
		cp 0							;is return code 0?
		jr z,CMD_GetDirectory2_Done		;if so finish listing
		
		cp $ff							;is is a valid entry
		jr nz,CMD_GetDirectory2_Loop		;if not loop to next entry
		
		ld hl,SDDATEBUFFER+1
		call WriteString
		ld a,12
		out (TILEMAP_X_VAL),a
		ld hl,SDTIMEBUFFER+1
		call WriteString
		ld a,23
		out (TILEMAP_X_VAL),a
		ld hl,NUMFORMATBUF
		call WriteString
		ld a,37
		out (TILEMAP_X_VAL),a
		ld hl,SD83BUFFER
		call WriteString
		
		ld a,50
		out (TILEMAP_X_VAL),a
		ld hl,LFNBUFFER
		call WriteLine
		
		ld a,0
		ld (LFNBUFFER),a
		
		jr CMD_GetDirectory2_Loop
	CMD_GetDirectory2_Done
		call ClearCMDBuffer
		ret
		
	SD_CalcChecksum
		ld a,0
		ld (SDCHECKSUM),a
		ld b,11
	SD_CalcChecksum_loop
		;ld a,(SDCHECKSUM)
		ld c,a
		srl c
		rr a
		rr a
		and $80
		add a,c
		ld c,a
		ld a,(hl)
		add a,c
		;ld a,c
		inc hl
		
		djnz SD_CalcChecksum_loop
		ld (SDCHECKSUM),a
		ret
		
	;CD command to change directory
	CMD_ChangeDirectory
		call GetNextCmdChunk
		call SD_FindFile
		cp 0
		jp z,CMD_BinLoad_FileNotFound	;re-use file not found code from 'bload'
		ld a,(ix+11)					;get attributes
		and $10
		jr z,CMD_ChangeDirectory_NotDir
		ld hl,(SDFILESECTOR)
		ld (SDVOLSTRUCT+SD_CURR_SECTOR),hl		
		;call EndLine
		;call DispHL
		ld hl,(SDFILESECTOR+2)
		ld (SDVOLSTRUCT+SD_CURR_SECTOR+2),hl		
		;call EndLine
		;call DispHL
		ld bc,SDVOLSTRUCT+SD_CURR_SECTOR
		call MakeAbsolute
		;ld hl,(SDVOLSTRUCT+$41)
		;call EndLine
		;call DispHL
		;ld hl,(SDVOLSTRUCT+$43)
		;call EndLine
		;call DispHL
		call ClearCMDBuffer
		ret
		
	CMD_ChangeDirectory_NotDir
		call EndLine
		ld hl,notdirmessage
		call WriteLine
		;call ClearCMDBuffer
		ret
		
	CMD_VOL
		call GetNextCmdChunk
		ld hl,CMDBUFFER2+2
		ld a,(hl)
		cp 0
		jp nz,CMD_Check_Num_Param_Syntax  ;reuse syntax error code
		dec hl
		ld a,(hl)
		cp ':'
		jp nz,CMD_Check_Num_Param_Syntax  ;reuse syntax error code
		dec hl
		ld a,(hl)
		sub 65
		call SD_ChangeVolume
		call ClearCMDBuffer
		ret
		
	ClearCMDBuffer
		ld a,0
		ld (CMDBUFFPTR),a
		ld (CMDBUFFER),a
		ld (CMDBUFFER+1),a
		ret
		
	MakeAbsolute		;BC points to sector to make absolute
		ld a,(bc)
		ld l,a
		inc bc
		ld a,(bc)
		ld h,a
		ld de,(SDVOLSTRUCT+SD_PART_ADDR)		;Root Data Sectors
		add hl,de
		ld a,h
		ld (bc),a
		dec bc
		ld a,l
		ld (bc),a
		inc bc
		inc bc
		ld a,(bc)
		ld l,a
		inc bc
		ld a,(bc)
		ld h,a
		ld de,(SDVOLSTRUCT+SD_PART_ADDR+2)		;Root Data Sectors
		;jr nc,MakeAbsoluteNC
		;inc hl
	;MakeAbsoluteNC
		adc hl,de
		ld a,h
		ld (bc),a
		dec bc
		ld a,l
		ld (bc),a
	
		ret
	
	
	;BinLoad - Load a binary file at a certain address (limited to 65536 bytes)
	;Direct version - will try to load filename pointed as by HL in address DE
	;filename must be null terminated
	CMD_BinLoadDirect
		;copy the filename in CMDBUFFER2
		ld (TEMP16),de
		ld de,CMDBUFFER2
	CMD_BinLoadDirectCopyLoop
		ld a,(hl)						
		ldi								;copy data from (HL) to CMDBUFFER2
		cp 0							;check for null termination
		jr z,CMD_BinLoadDirectCopyDone	;and exit copy routine if found
		jr CMD_BinLoadDirectCopyLoop
	CMD_BinLoadDirectCopyDone
		ld hl,CMDBUFFER2
		call UpCase
		call SD_FindFile
		cp 0
		jp z,CMD_BinLoadDirect_Error
		ld a,(ix+11)					;get attributes
		
		and $10
		jp nz,CMD_BinLoadDirect_Error
		
		ld hl,(SDFILESIZE)				;copy file size into load size
		ld (FILELOADSIZE),hl
		ld hl,(SDFILESIZE+2)
		
		ld a,h
		or l
		jp nz,CMD_BinLoadDirect_Error
		
		ld hl,(SDFILESECTOR)			;get sector number and make absolute
		ld (SDVOLSTRUCT+SD_FILE_SECTOR),hl		
		ld hl,(SDFILESECTOR+2)
		ld (SDVOLSTRUCT+SD_FILE_SECTOR+2),hl		
		ld bc,SDVOLSTRUCT+SD_FILE_SECTOR
		call MakeAbsolute
		
		ld hl,(TEMP16)					;retrieve load address into HL
		
		ld (FILELOADPTR),hl
		jp CMD_BinLoad_Loop1
		
	CMD_BinLoadDirect_Error
		call ClearCMDBuffer
		scf
		ret
	
	
	;Load - Load an SJ Executable file and run
	CMD_Load
		call GetNextCmdChunk		;get the filename
		call SD_FindFile
		cp 0
		jp z,CMD_BinLoad_FileNotFound
		ld a,(ix+11)					;get attributes
		
		and $10
		jp nz,CMD_BinLoad_IsDir
		
		ld hl,(SDFILESIZE)				;copy file size into load size
		;ld bc,7
		;and a
		;sbc hl,bc
		ld (FILELOADSIZE),hl
		ld hl,(SDFILESIZE+2)
		
		ld a,h
		or l
		jp nz,CMD_BinLoad_FileTooBig
		
		ld hl,(SDFILESECTOR)			;get sector number and make absolute
		ld (SDVOLSTRUCT+SD_FILE_SECTOR),hl		
		ld hl,(SDFILESECTOR+2)
		ld (SDVOLSTRUCT+SD_FILE_SECTOR+2),hl		
		ld bc,SDVOLSTRUCT+SD_FILE_SECTOR
		call MakeAbsolute
		
		ld de,(SDVOLSTRUCT+SD_FILE_SECTOR)
		ld hl,(SDVOLSTRUCT+SD_FILE_SECTOR+2)
		call SD_ReadSector
		ld hl,SDBUFFER
		ld a,(hl)
		cp 'S'
		jr nz,CMD_Load_Invalid
		inc hl
		ld a,(hl)
		cp 'J'
		jr nz,CMD_Load_Invalid
		inc hl
		ld a,(hl)
		cp 'E'
		jr nz,CMD_Load_Invalid
		inc hl
		ld a,(hl)
		cp 'X'
		jr nz,CMD_Load_Invalid
		inc hl
		ld a,(hl)
		cp 'E'
		jr nz,CMD_Load_Invalid
		inc hl
		ld a,(hl)
		ld e,a
		inc hl
		ld a,(hl)
		ld d,a
		;push de
		;ex de,hl
		;call DispHL
		;pop de
		ld (FILELOADPTR),de
		push de
		
		
		ld hl,(SDVOLSTRUCT)				;bytes per sector
		ld a,(FILELOADSIZE+1)			;get high byte of bytes left to read
		and $fe							;mask of bits over 511
		jr nz,CMD_Load_ReadFullSector	;if remaining bytes are less than 512
		ld hl,(FILELOADSIZE)			;make sure we only copy the bytes needed
	CMD_Load_ReadFullSector
		ld bc,7
		and a
		sbc hl,bc
		ld c,l
		ld b,h
		ld hl,SDBUFFER+7				;point to start of binary data (after 7 byte file header)
		call CMD_BinLoad1
		;jp CMD_BinLoad1
		
		;push de
		;push bc
		;ldir
		;pop bc							;retrieve bytes per sector
		;pop hl							;retrieve file load pointer
		;add hl,bc						;inc file load pointer by read bytes
		
		;jp CMD_BinLoad_Exit
		pop hl
		
		di
		exx
		push af
		push bc
		push de
		push hl
		push ix
		push iy
		exx
		push af
		push bc
		push de
		push hl
		push ix
		push iy
		jp CMD_Sys1
		
	CMD_Load_Invalid
		call EndLine
		ld hl,invalidfilegmessage
		call WriteLine
		jp CMD_BinLoad_Exit
	
	;BinLoad - Load a binary file at a certain address (limited to 65536 bytes)
	CMD_BinLoad
		call GetNextCmdChunk		;get the filename
		call SD_FindFile
		cp 0
		jp z,CMD_BinLoad_FileNotFound
		ld a,(ix+11)					;get attributes
		
		and $10
		jp nz,CMD_BinLoad_IsDir
		
		ld hl,(SDFILESIZE)				;copy file size into load size
		ld (FILELOADSIZE),hl
		ld hl,(SDFILESIZE+2)
		
		ld a,h
		or l
		jp nz,CMD_BinLoad_FileTooBig
		
		ld hl,(SDFILESECTOR)			;get sector number and make absolute
		ld (SDVOLSTRUCT+SD_FILE_SECTOR),hl		
		ld hl,(SDFILESECTOR+2)
		ld (SDVOLSTRUCT+SD_FILE_SECTOR+2),hl		
		ld bc,SDVOLSTRUCT+SD_FILE_SECTOR
		call MakeAbsolute
		
		call GetNextCmdChunk		;get the address to load into
		call CMD_Check_Num_Param
		jp c,CMD_BinLoad_Exit		;not a valid address
		ld de,CMDBUFFER2
		call ConvStr16				;get address into HL
	
		ld (FILELOADPTR),hl
		
	CMD_BinLoad_Loop1
		ld de,(SDVOLSTRUCT+SD_FILE_SECTOR)
		ld hl,(SDVOLSTRUCT+SD_FILE_SECTOR+2)
		call SD_ReadSector
		jr c,CMD_BinLoad_Exit
		
		ld bc,(SDVOLSTRUCT)				;bytes per sector
		ld a,(FILELOADSIZE+1)			;get high byte of bytes left to read
		and $fe							;mask of bits over 511
		jr nz,CMD_BinLoad_ReadFullSector	;if remaining bytes are less than 512
		ld bc,(FILELOADSIZE)			;make sure we only copy the bytes needed
	CMD_BinLoad_ReadFullSector
	
		ld hl,SDBUFFER
		ld de,(FILELOADPTR)
	CMD_BinLoad1
		push de
		push bc
		ldir
		pop bc							;retrieve bytes per sector
		pop hl							;retrieve file load pointer
		add hl,bc						;inc file load pointer by read bytes
		ld (FILELOADPTR),hl				;and store
		
		ld de,(SDVOLSTRUCT+SD_FILE_SECTOR)
		ld hl,(SDVOLSTRUCT+SD_FILE_SECTOR+2)
		ld bc,1						;increase current sector by 1
		call addBC2HLDE
		ld (SDVOLSTRUCT+SD_FILE_SECTOR),de
		ld (SDVOLSTRUCT+SD_FILE_SECTOR+2),hl
		
		ld bc,(SDVOLSTRUCT+SD_BPB_BYTSPERSEC)			;bytes per sector
		ld hl,(FILELOADSIZE)
		and a
		sbc hl,bc
		ld (FILELOADSIZE),hl
		
		jr z,CMD_BinLoad_Exit2			;exit if zero bytes left to read
		jp nc,CMD_BinLoad_Loop1			;if not zero loop unless hl goes negative (all sectors read)
		
		jr CMD_BinLoad_Exit2
		
	CMD_BinLoad_FileTooBig
		call EndLine
		ld hl,filetoobigmessage
		call WriteLine
		jr CMD_BinLoad_Exit

	CMD_BinLoad_FileNotFound
		call EndLine
		ld hl,filenotfoundmessage
		call WriteLine
		jr CMD_BinLoad_Exit
		
	CMD_BinLoad_IsDir
		call EndLine
		ld hl,isdirmessage
		call WriteLine
	CMD_BinLoad_Exit			;exit on error - set carry
		call ClearCMDBuffer
		scf
		ret
	CMD_BinLoad_Exit2			;exit of success - clear carry
		call ClearCMDBuffer
		and a
		ret
		
	SYS_LoadFile
		
		
	CMD_GETCHAR
		call GetNextCmdChunk		;get the address to dump
		ld de,CMDBUFFER2
		ld a,(CMDBUFFER2)
		sub 48
		cp 10
		jp nc,CMD_Check_Num_Param_Syntax					;no valid parameter
		call ConvStr16			;get value of dump address in HL
		ld (TEMP16),hl
		call GetNextCmdChunk		;get the address to dump
		ld de,CMDBUFFER2
		ld a,(CMDBUFFER2)
		sub 48
		cp 10
		jp nc,CMD_Check_Num_Param_Syntax					;no valid parameter
		call EndLine
		call ConvStr16			;get value of dump address in HL
		in a,(TILEMAP_READ_Y)				;get cursor y
		ld h,a
		ld a,l
		out (TILEMAP_Y_VAL),a
		in a,(TILEMAP_READ_X)
		ld l,a
		ld a,(TEMP16)
		out (TILEMAP_X_VAL),a
		in a,(TILEMAP_READ)
		ld (TEMP),a
		ld a,l
		out (TILEMAP_X_VAL),a
		ld a,h
		out (TILEMAP_Y_VAL),a
		ld a,(TEMP)
		call DispA
		;call NewLine
		ret
		
	CMD_Sys
		di
		exx
		push af
		push bc
		push de
		push hl
		push ix
		push iy
		exx
		push af
		push bc
		push de
		push hl
		push ix
		push iy
		;should we store the SP somewhere?

		call GetNextCmdChunk		;get the address to jump to
		ld de,CMDBUFFER2
		ld a,(CMDBUFFER2)
		sub 48
		cp 10
		jr nc,CMD_Sys_Syntax					;no valid parameter
		call ConvStr16			;get value of address in HL
		;call to address
	CMD_Sys1
		call CMD_Sys_Jump
		jp CMD_Sys_Exit
		
	CMD_Sys_Syntax
		call EndLine
		ld hl,syntaxerrmessage
		call WriteLine
	
	CMD_Sys_Exit
		
		pop iy
		pop ix
		pop hl
		pop de
		pop bc
		pop af
		exx
		pop iy
		pop ix
		pop hl
		pop de
		pop bc
		pop af
		exx
		im 1
		ei
		ret
		
	CMD_Sys_Jump
		jp (hl)
		
	CMD_Check_Num_Param
		ld a,(CMDBUFFER2)
		sub 48
		cp 10
		jr nc,CMD_Check_Num_Param_Syntax					;no valid parameter
		and a
		ret
	
	CMD_Check_Num_Param_Syntax
		call EndLine
		ld hl,syntaxerrmessage
		call WriteLine
		scf
		ret
		
	CMD_JOY0
		call EndLine
		call GetNextCmdChunk		;get the joystick type
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_JOY_Error
		call ConvStr16			;get value of dump address in HL
		ld a,l
		cp 1
		jr c,CMD_JOY_Error
		cp 3
		jr nc,CMD_JOY_Error
		cp 1
		jp z,set_joy_a_normal
		cp 2
		jp z,set_joy_a_genesis
		ret
		
	CMD_JOY1
		call EndLine
		call GetNextCmdChunk		;get the joystick type
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_JOY_Error
		call ConvStr16			;get value of dump address in HL
		ld a,l
		cp 1
		jr c,CMD_JOY_Error
		cp 3
		jr nc,CMD_JOY_Error
		cp 1
		jp z,set_joy_b_normal
		cp 2
		jp z,set_joy_b_genesis
		ret
		
	CMD_JOY_Error
		ld hl,CMD_JOY_Error_Message
		call WriteLine
		ret
		
	CMD_JOY_Error_Message
		defb "Unknown joystick type",0
	CMD_JOY_A_NORM_Message
		defb "Joystick A set to Normal Mode",0
	CMD_JOY_B_NORM_Message
		defb "Joystick B set to Normal Mode",0
	CMD_JOY_A_GEN_Message
		defb "Joystick A set to MegaDrive Mode",0
	CMD_JOY_B_GEN_Message
		defb "Joystick B set to MegaDrive Mode",0
	CMD_JOY_Err_Message
		defb "Error setting joystick type",0
		
	CMD_CLS
		call ClearDisplay
		out (TILEMAP_ZERO),a				;reset cursor to top
		ret
		
	CMD_PAPER				;set backrpund colour
		;ld hl,$8000			;hardcode to dump from 32768
		call GetNextCmdChunk		;get the filename
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_BANK_Exit
		call ConvStr16			;get value of dump address in HL
		ld a,l
		ld (BACKCOL),a
		out (TILEMAP_BG),a
		ret
		
	CMD_INK				;set backrpund colour
		;ld hl,$8000			;hardcode to dump from 32768
		call GetNextCmdChunk		;get the filename
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_BANK_Exit
		call ConvStr16			;get value of dump address in HL
		ld a,l
		ld (FORECOL),a		
		ret
		
		
	CMD_DUMP				;dump memory
		;ld hl,$8000			;hardcode to dump from 32768
		call GetNextCmdChunk		;get the filename
		ld de,CMDBUFFER2
		call ConvStr16			;get value of dump address in HL
	CMD_DUMP_2
		ld a,48
		ld (TEMP),a
	CMD_DUMP_Loop2
		call EndLine
		push hl
		call DispHL
		pop hl
		ld b,16
	CMD_DUMP_Loop1
		push bc
		out (TILEMAP_INC),a			;move cursor right
		ld a,(hl)
		call DispA
		pop bc
		inc hl
		djnz CMD_DUMP_Loop1
		ld a,(TEMP)
		dec a
		ld (TEMP),a
		jr nz,CMD_DUMP_Loop2
		ret
		
	CMD_DUMP_HEX				;dump memory
		;ld hl,$8000			;hardcode to dump from 32768
		call GetNextCmdChunk		;get the filename
		ld de,CMDBUFFER2
		call ConvStr16			;get value of dump address in HL
	CMD_DUMP_HEX_2
		ld a,48
		ld (TEMP),a
	CMD_DUMP_HEX_Loop2
		call EndLine
		push hl
		call DispHLhex
		pop hl
		ld b,16
	CMD_DUMP_HEX_Loop1
		push bc
		out (TILEMAP_INC),a			;move cursor right
		ld c,(hl)
		call OutHex8
		pop bc
		inc hl
		djnz CMD_DUMP_HEX_Loop1
		ld a,(TEMP)
		dec a
		ld (TEMP),a
		jr nz,CMD_DUMP_HEX_Loop2
		ret
		
	CMD_BANK
		call GetNextCmdChunk		;get the bank number
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_BANK_Exit
		call ConvStr16			;get value into HL
		ld (TEMP16),hl
		ld a,0
		cp h
		jr nz,CMD_BANK_Invalid		;bank number is >255!!!!!!
		ld a,7
		cp l
		jr c,CMD_BANK_Invalid		;bank number is >7
		ld a,2
		cp l
		jr nc,CMD_BANK_Invalid		;bank number is <2
		call GetNextCmdChunk		;get the value to set bank to
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_BANK_Exit
		call ConvStr16			;get value of dump address in HL
		ld a,0
		cp h
		jr nz,CMD_BANK_RangeInvalid		;bank number is >255!!!!!!
		ld a,63
		cp l
		jr c,CMD_BANK_RangeInvalid		;bank value is >63
		;ok - all values are within range
		ld de,(TEMP16)
		ld a,3
		cp e
		jr z,CMD_BANK_3
		ld a,4
		cp e
		jr z,CMD_BANK_4
		ld a,5
		cp e
		jr z,CMD_BANK_5
		ld a,6
		cp e
		jr z,CMD_BANK_6
	CMD_BANK_7			;must be bank 7 by default
		ld c,RAM_BANK_7
		out (c),l
		jr CMD_BANK_Exit
	CMD_BANK_3
		ld c,RAM_BANK_3
		out (c),l
		jr CMD_BANK_Exit
	CMD_BANK_4
		ld c,RAM_BANK_4
		out (c),l
		jr CMD_BANK_Exit
	CMD_BANK_5
		ld c,RAM_BANK_5
		out (c),l
		jr CMD_BANK_Exit
	CMD_BANK_6
		ld c,RAM_BANK_6
		out (c),l
	CMD_BANK_Exit
		ret
	CMD_BANK_Invalid
		call EndLine
		ld hl,invbankerrmessage
		call WriteLine
		ret
	CMD_BANK_RangeInvalid
		call EndLine
		ld hl,invbankvalerrmessage
		call WriteLine
		ret
		
	CMD_SETLED2
		call GetNextCmdChunk		;get the bank number
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_SETLED2_Exit
		call ConvStr16			;get value into HL
		ld a,l
		ld (TEMP),a
		call GetNextCmdChunk		;get the bank number
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_SETLED2_Exit
		call ConvStr16			;get value into HL
		ld a,l
		ld (TEMP16),a
		call GetNextCmdChunk		;get the bank number
		ld de,CMDBUFFER2
		call CMD_Check_Num_Param
		jp c,CMD_SETLED2_Exit
		call ConvStr16			;get value into HL
		ld a,l
		ld (LEDBLUE),a
		out (LED_BLUE),a
		ld a,(TEMP16)
		ld (LEDGREEN),a
		out (LED_GREEN),a
		ld a,(TEMP)
		ld (LEDRED),a
		out (LED_RED),a
		ret
	CMD_SETLED2_Exit
		call EndLine
		ld hl,syntaxerrmessage
		call WriteLine
		scf
		ret
		
	;This routing converts a padding 11 bytes filename to
	;traditional 83 (8).(3) format
	;HL points to original 11 byte buffer
	;it also calculates the checksum for use with LFNs
	SD_Convertto83
		ld de,SD83BUFFER
		ld b,8				;first 8 bytes
	SD_Convertto83Loop
		ld a,(hl)
		cp $20			;is it a space
		jr z,SD_Convertto83IgnoreSpace
		ld (de),a
		inc de
	SD_Convertto83IgnoreSpace
		inc hl
		dec b
		jr nz,SD_Convertto83Loop
		
		ld a,'.'
		ld (de),a
		inc de
		
		ld b,3				;3 extension bytes
		ld c,0				;count if we have any extension so we can remove '.'
	SD_Convertto83Loop2
		ld a,(hl)
		cp $20			;is it a space
		jr z,SD_Convertto83IgnoreSpace2
		ld (de),a
		inc de
		inc c
	SD_Convertto83IgnoreSpace2
		inc hl
		dec b
		jr nz,SD_Convertto83Loop2
		dec c
		jp p,SD_Convertto83HasExt		;if not extension we can
		dec de							;delete the '.'
	SD_Convertto83HasExt
		ld a,0
		ld (de),a		;null terminate string
		ret
		
		
	SD_ChangeVolume
		;change of volume
		;A contains the volume number - valid range is 0 through 3
		cp 4
		jr nc,SD_ChangeVolume_Invalid
		ld hl,SDCARDVOLS
		cp (hl)
		jr nc,SD_ChangeVolume_Invalid
		push af
		ld a,(SDCURRVOL)		;get current volume
		call SD_StoreCurrentVolume
		pop af
		ld (SDCURRVOL),a
		call SD_RetrieveCurrentVolume
		ret
	
	SD_ChangeVolume_Invalid
		call EndLine
		ld hl,changevolerror
		call WriteLine
		ret
		
	SD_RetrieveCurrentVolume
		ld b,a
				
		ld hl,SDVOLSTRUCT0
		ld de,SDVOLSTRUCT_SIZE
		cp 0
		jr z,SD_RetrieveCurrentVolumeLoopDone
	SD_RetrieveCurrentVolumeLoop
		add hl,de		
		djnz SD_RetrieveCurrentVolumeLoop
	SD_RetrieveCurrentVolumeLoopDone
		;hl now contains the address of the structure to copy out of
		;ex de,hl
		ld de,SDVOLSTRUCT
		ld bc,SDVOLSTRUCT_SIZE
		ldir
		ret
		
	SD_StoreCurrentVolume
		ld b,a
						
		
		ld hl,SDVOLSTRUCT0
		ld de,SDVOLSTRUCT_SIZE
		cp 0
		jr z,SD_StoreCurrentVolumeLoopDone
	SD_StoreCurrentVolumeLoop
		add hl,de		
		djnz SD_StoreCurrentVolumeLoop
	SD_StoreCurrentVolumeLoopDone
		;hl now contains the address of the structure to copy into
		ex de,hl
		ld hl,SDVOLSTRUCT
		ld bc,SDVOLSTRUCT_SIZE
		ldir
		ret
		
	SD_GetVolumeDetails
		;a contains volume number
		;need to * 16 to get offset
		ld (TEMP),a
		add a,a ;* 2
		add a,a ;* 4
		add a,a ;* 8
		add a,a ;* 16
		ld d,0
		ld e,a
		ld ix,SDVOL0
		add ix,de		;ix now point to start of volume data
		
		ld e,(ix+$08)	;little endian
		ld d,(ix+$09)
		ld l,(ix+$0a)
		ld h,(ix+$0b)
		
		ld (SDVOLSTRUCT+SD_PART_ADDR),de
		ld (SDVOLSTRUCT+SD_PART_ADDR+2),hl
		
		push ix
		
		;push hl
		;push de
		;call waitkey
		;call flushkeys
		;pop de
		;pop hl
				
		call SD_ReadSector
		
		pop ix
		jp c,SD_GetVolumeDetailsExit
				
		ld de,SDVOLSTRUCT
		
		ld bc,8
		
		ld hl,SDBUFFER+11   ;bytes per sector, sector per cluster
		ldir				;resv sec count, num fats, toor ent count
		
		ld a,(ix+4)			;FAT type
		cp 04				;FAT 16
		jr z,SD_GetVolumeDetails_FAT16
		cp 06
		jr z,SD_GetVolumeDetails_FAT16
		
		;must be FAT32
		ld hl,SDBUFFER+32
		ld de,SDVOLSTRUCT+SD_BPB_TOTSEC
		ld bc,16				;copy TotSec32, FATsz32, ExtFlags
		ldir					;FSVer, RootClus, FSInfo, BkBootSec
		
	;	ld hl,SDBUFFER+67
	;	ld de,SDVOLSTRUCT+SD_BS_VOLID
	;	ld bc,22				;copy VolID, VolLabel, FilSysType
	;	ldir	

		ld hl,SDBUFFER+67
		ld de,SDVOLSTRUCT+SD_BS_VOLID
		ld bc,15
		ldir
		ld a,0
		ld (de),a				;null terminate VOL_LAB
		
		ld hl,SDBUFFER+82
		ld de,SDVOLSTRUCT+SD_BSFILSYSTYPE
		ld bc,8
		ldir
		ld (de),a		
		
		ld a,0
		ld (de),a
		inc de
		ld (de),a
		inc de					;Set RootDirSectors to 0
		
		jr SD_GetVolumeDetailsStructDone
		
		
	SD_GetVolumeDetails_FAT16
		ld hl,SDBUFFER+22
		ld de,SDVOLSTRUCT+SD_BPB_FATSZ
		ldi
		ldi
		ld a,0
		ld (de),a
		inc de
		ld (de),a
		inc de			;load 16bit FATsz into 32 bit struct
		
		ld hl,SDVOLSTRUCT+SD_BPB_EXTFLAGS
		ld de,SDVOLSTRUCT+SD_BPB_EXTFLAGS+1
		ld a,0
		ld (hl),a
		ld bc,11
		ldir					;blank unused struct for FAT16
		
		ld hl,SDBUFFER+39
		ld de,SDVOLSTRUCT+SD_BS_VOLID
		ld bc,15
		ldir
		ld (de),a				;null terminate VOL_LAB
		
		ld hl,SDBUFFER+54
		ld de,SDVOLSTRUCT+SD_BSFILSYSTYPE
		ld bc,8
		ldir
		ld (de),a
		
		ld hl,SDBUFFER+19
		ld a,(hl)			;TotSec16
		ld b,a
		inc hl
		ld a,(hl)
		add a,b
		jr z,SD_GetVolumeDetails_FAT16_2	;0 so use ToSec32 instead
		;TotSec16 is valid
		ld a,0
		ldi
		ldi			;copy 16 bit value into 32 bit struct
		ld (de),a
		inc de
		ld (de),a
		inc de
		jr SD_GetVolumeDetails_FAT16_3
	SD_GetVolumeDetails_FAT16_2
		ld hl,SDBUFFER+32		;TotSec32
		ld de,SDVOLSTRUCT+SD_BPB_TOTSEC
		ld bc,4
		ldir
	SD_GetVolumeDetails_FAT16_3
		;Calc RootDirSectors for FAT16
		;assume RootEndCnt is 512 for FAT so RDS is 33
		ld hl,SDVOLSTRUCT+SD_ROOT_DIR_SECS
		ld a,33		
		ld (hl),a
		inc hl
		ld a,0		
		ld (hl),a
		inc hl
		
		
	
	SD_GetVolumeDetailsStructDone		
		;now we can calc additional information
		
		;ld a,0
		;out (TILEMAP_X_VAL),a
		;out (TILEMAP_INC_ROW),a
				
		ld de,(SDVOLSTRUCT+SD_BPB_FATSZ+2)
		ld hl,(SDVOLSTRUCT+SD_BPB_FATSZ)
		ld a,(SDVOLSTRUCT+SD_BPB_NUMFATS)
		
		;push hl
		;push de
		;push af
		;call waitkey
		;call flushkeys
		;pop af
		;pop de
		;pop hl
		
		call DEHL_Times_A3
		ld (SDVOLSTRUCT+SD_FIRST_DATA_SEC),de
		ld (SDVOLSTRUCT+SD_FIRST_DATA_SEC+2),hl
		
		
		
		ld hl,(SDVOLSTRUCT+SD_FIRST_DATA_SEC)
		ld de,(SDVOLSTRUCT+SD_BPB_RSVDSECCNT)		;resvdseccnt
		add hl,de
		ld (SDVOLSTRUCT+SD_FIRST_DATA_SEC),hl
		jr nc,test
		ld hl,(SDVOLSTRUCT+SD_FIRST_DATA_SEC+2)
		inc hl
		ld (SDVOLSTRUCT+SD_FIRST_DATA_SEC+2),hl
	test
	
		
	
		ld hl,(SDVOLSTRUCT+SD_FIRST_DATA_SEC)
		ld de,(SDVOLSTRUCT+SD_ROOT_DIR_SECS)		;Root Data Sectors
		add hl,de
		ld (SDVOLSTRUCT+SD_FIRST_DATA_SEC),hl
		jr nc,test2
		ld hl,(SDVOLSTRUCT+SD_FIRST_DATA_SEC+2)
		inc hl
		ld (SDVOLSTRUCT+SD_FIRST_DATA_SEC+2),hl
	test2
	
		ld hl,(SDVOLSTRUCT+SD_FIRST_DATA_SEC)
		ld de,(SDVOLSTRUCT+SD_PART_ADDR)		;Root Data Sectors
		add hl,de
		ld (SDVOLSTRUCT+SD_FDS_ABSOLUTE),hl		;Absolute sector
		ld (SDVOLSTRUCT+SD_CURR_SECTOR),hl		;Current sector
		ld (SDVOLSTRUCT+SD_PREV_SECTOR),hl		;Previous sector
		ld hl,(SDVOLSTRUCT+SD_FIRST_DATA_SEC+2)
		jr nc,test3
		inc hl
	test3
		ld de,(SDVOLSTRUCT+SD_PART_ADDR+2)		;Root Data Sectors
		add hl,de
		ld (SDVOLSTRUCT+SD_FDS_ABSOLUTE+2),hl		;Absolute sector
		ld (SDVOLSTRUCT+SD_CURR_SECTOR+2),hl		;Current Sector
		ld (SDVOLSTRUCT+SD_PREV_SECTOR+2),hl		;Previous Sector
		
		
		
		;calculate the total size of the volume
		ld hl,$0000
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES),hl
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES+2),hl
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES+4),hl
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES+6),hl
		ld bc,(SDVOLSTRUCT+SD_BPB_BYTSPERSEC)		;get number of bytes per sector
				
	SD_GetVolumeDetailsTotalSizeLoop
		ld hl,(SDVOLSTRUCT+SD_TOTAL_BYTES)
		ld de,(SDVOLSTRUCT+SD_BPB_TOTSEC)
		add hl,de
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES),hl
		ld hl,(SDVOLSTRUCT+SD_TOTAL_BYTES+2)
		ld de,(SDVOLSTRUCT+SD_BPB_TOTSEC+2)
		adc hl,de
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES+2),hl
		ld hl,(SDVOLSTRUCT+SD_TOTAL_BYTES+4)
		ld de,$0000
		adc hl,de
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES+4),hl
		ld hl,(SDVOLSTRUCT+SD_TOTAL_BYTES+6)
		adc hl,de
		ld (SDVOLSTRUCT+SD_TOTAL_BYTES+6),hl
		dec c
		jr nz,SD_GetVolumeDetailsTotalSizeLoop
		dec b
		jr nz,SD_GetVolumeDetailsTotalSizeLoop
		
		;call EndLine
		;ld hl,(SDVOLSTRUCT+$41)
		;call DispHL
		
		;call EndLine
		;ld hl,(SDVOLSTRUCT+$43)
		;call DispHL
		;call EndLine
		
		;Now copy the volume structure into the appropriate struture to volumes 0 to 3
		ld a,(TEMP)
		add a,65			;convert to ASCII letter
		ld (SDVOLSTRUCT+SD_CURR_DIR_STRING),a		
		ld a,':'			;followed by a colon
		ld (SDVOLSTRUCT+SD_CURR_DIR_STRING+1),a
		ld a,0			;null ternimate
		ld (SDVOLSTRUCT+SD_CURR_DIR_STRING+2),a
		ld a,(TEMP)
		call SD_StoreCurrentVolume
		
		and a			;clear carry if success
	SD_GetVolumeDetailsExit
		ret
	
	SD_GetVolumes
		
		ld a,0
		ld (SDCARDVOLS),a			;set number of valid volumes to 0
		
		ld	hl,$0000			;sector address
		ld	de,$0000
		
		call SD_ReadSector
		jr c,SD_GetVolumesExit
		
		ld a,5
		ld (TEMP),a					;loops + 1
		
		ld ix,SDBUFFER+$1be		;start of partition tables
		ld hl,SDBUFFER+$1be		;start of partition tables
		ld de,SDVOL0			;start of internal partition structure
	SD_GetVolumes_loop1
		ld a,(TEMP)
		dec a
		jr z,SD_GetVolumesDone
		ld (TEMP),a
		ld a,(ix+4)					;Partition type
		;call DispA
		;call EndLine
		;ld a,(ix+4)
		cp $04		;FAT16
		jr z,SD_GetVolumesValidPartition
		cp $06		;FAT16B
		jr z,SD_GetVolumesValidPartition
		cp $0b		;FAT32 (with CHS)
		jr z,SD_GetVolumesValidPartition
		cp $0c		;FAT32 LBA only
		jr z,SD_GetVolumesValidPartition
		;not a supported partition
		ld bc,$10		;move to next partition
		
		add ix,bc
		add hl,bc
		jr SD_GetVolumes_loop1
	SD_GetVolumesValidPartition
		ld bc,$10
		add ix,bc
		ldir
		ld a,(SDCARDVOLS)
		inc a
		ld (SDCARDVOLS),a
		cp 4						;maximum number of supported volumes
		jr z,SD_GetVolumesDone
		jr SD_GetVolumes_loop1
	
	SD_GetVolumesDone
		ld a,(SDCARDVOLS)
		sub 1				;set carry if 0 volumes found
		;call DispA
	SD_GetVolumesExit
		ret
		
	;#######################################################
	;########### READ A SECTOR FROM THE SD CARD ############
	;#######################################################
	SD_ReadSector

		ld a,1
		out (LED_0),a
		;call flushspi
		
		
		;ld hl,$0000
		;ld de,$0700
		;ld ix,$0000
		;ld a,SD_SETAUX
		;call send_CMD
		
		;hl,de hold the 32 bit sector address
		ld	a,READ_SINGLE_BLOCK	;CMD
		ld	ix,SD_CLEARERR | SD_FIFO_OP				;CRC
		call send_CMD
		
		call checksdresponse
		jr c,SD_ReadSectorError
				
		;call SD_WaitFE
		;jr c,SD_ReadSectorError
		
		;now we read 512 bytes into the buffer
	
		
		ld a,SD_FIFO_0			;set address to FIFO 0
		out (SDCARD_ADDR),a
		
		ld hl,SDBUFFER
		ld b,128			;we will get 4 bytes each read so need to loop 128 times
	SD_ReadSector_loop1
		in a,(SDCARD_READ)		;get next 32 bit value across wishbone interface
		in a,(SDCARD_BYTE3)		;get first byte
		ld (hl),a		;store byte		
		inc hl			;advance address
		in a,(SDCARD_BYTE2)		;get first byte
		ld (hl),a		;store byte
		inc hl			;advance address
		in a,(SDCARD_BYTE1)		;get first byte
		ld (hl),a		;store byte		
		inc hl			;advance address
		in a,(SDCARD_BYTE0)		;get first byte
		ld (hl),a		;store byte
		inc hl			;advance address		
		
		djnz SD_ReadSector_loop1
		

		;ld hl,ReadSectorOKMessage
		;call WriteLine
		ld a,0
		out (LED_0),a
		and a				;clear carry
		ret
	SD_ReadSectorError
		ld hl,ReadSectorErrorMessage
		call WriteLine
		ld a,0
		out (LED_0),a
		scf					;set carry flag
		ret
		
	ReadSectorErrorMessage
		defb "Error reading sector",0
		
		
	;listbytes
	;	ld d,6
	;get6bytes
	;	;out (TILEMAP_INC_ROW),a		;move down 1 row
	;	in a,(SDCARD_DATA)		;read from SD card
	;	call DispA
	;	dec d
	;	jr nz,get6bytes
		
	;	ret
		
	waitkey
		ld a,0				;x pos
		out (TILEMAP_X_VAL),a			;set x pos
		out (TILEMAP_INC_ROW),a			;set y pos
		ld b,29				;5 characters in message
		ld hl,waitmessage1		;pointer to message
		call writemessage	;write message to screen
		
		
	waitkeyloop
		in a,(KEY_DATA)
		cp 0
		jr z,waitkeyloop
		ret
		
	;flushspi
	;	ld a,1			;drive CS high
	;	out (SDCARD_SS),a
	;	ld b,16
	;flushspiloop
	;	in a,(SDCARD_DATA)
	;	djnz flushspiloop
	;	ret
		
	
	;==================================
	;Send command to SD Card	
	send_CMD				;send CMD to SD card
							;A holds CMD
							;HL DE hold args
							;B holds CRC

		ld c,SDCARD_ADDR
		ld b,1			;Data address
		out (c),b		;load data register in SPI interface
		inc c
		out (c),e
		inc c
		out (c),d
		inc c
		out (c),l
		inc c
		out (c),h
		;dec c
		
		out (SDCARD_WRITE),a		
		
		
		out (SDCARD_BYTE0),a
		ld a,ixl
		out (SDCARD_BYTE1),a
		ld a,ixh
		out (SDCARD_BYTE2),a
		ld a,0
		out (SDCARD_BYTE3),a		
		out (SDCARD_ADDR),a		
		out (SDCARD_WRITE),a		
		
		call waitsd			
		
		ret
		
		
		
	;send_DATA
	;	call waitsd
	;	ld c,SDCARD_BYTE3
	;	out (c),h
	;	dec c
	;	out (c),l
	;	dec c
	;	out (c),d
	;	dec c
	;	out (c),e
	;	dec c
	;	ld b,1			;Data address
	;	out (c),b		;load data register in SPI interface
	;	out (SDCARD_CMD),a		
	;	
	;	ret
		
		
	delay
		ld b,a
	delay2
		djnz delay2
		ret
		
	waitsd
		ld a,0
		out (SDCARD_ADDR),a  ;set addr to cmd
	waitsdloop
;		;temp - read debug registers
;		in a,($3f)
;		call DispA
;		in a,($3e)
;		call DispA
;		in a,($3d)
;		call DispA
;		in a,($3c)
;		call DispA
;		call EndLine
		in a,(SDCARD_READ)	;load status into latch
		in a,(SDCARD_STATUS)	;read status registers		
		;push af
		;call DispA
		;call EndLine
		;pop af
		and $01			;test busy bit		
		;cp 0
		jr nz,waitsdloop
		
		ret
		
	;SD_WaitFE
	;	ld b,0
	;SD_WaitFE_loop1
	;	dec b
	;	jr z,SD_WaitFE_Fail
	;	in a,(SDCARD_DATA)
	;	cp $fe
	;	jr nz,SD_WaitFE_loop1
	;	ret
	;SD_WaitFE_Fail
	;	scf
	;	ret
		
		
	;waitcmdaccepted
	;	call waitsd
		
	;	ld a,0
	;	out ($31),a		;set to cmd address
	;	ld d,8				;how many bytes to check - 8 enough??
	;waitcmdaccloop
	;	call checksdresponse
	;	cp 0
	;	scf					;set carry indicates error response
	;	jr z,cmdnoresponse	;no resonse at at all (exit with 0)
	;	in a,($32)			;check response
	;	push af
	;	call DispA
	;	call EndLine
	;	pop af
	;	ld e,a		
	;	and $fe				;check no bits other than 0 are set
	;	jr z,cmdgoodresponse
	;	dec d
	;	jr nz,waitcmdaccloop
	;	scf
	;	ld a,e
	;	jr cmdnoresponse
	;cmdgoodresponse
	;	ld a,e
	;	and a				;clear carry
	;cmdnoresponse
	;	ret
		
	checksdresponse		
		ld a,0
		out (SDCARD_ADDR),a
	
		in a,(SDCARD_READ)
		in a,(SDCARD_BYTE0)
		;push af
		;call DispA
		;call EndLine
		;pop af
		ld c,a
		and $fe
		;cp 0
		jr z,responsemade		
		scf
	responsemade
		ld a,c
		;call DispA
		;call EndLine
		ret
		
	get_sd_data
		ld a,1
		out (SDCARD_ADDR),a  ;set addr to data
		in a,(SDCARD_READ)	 ;load latch with 32 bit value
		in a,(SDCARD_BYTE3)  ;get top byte		
		ld h,a		
		in a,(SDCARD_BYTE2)  ;get top byte		
		ld l,a		
		in a,(SDCARD_BYTE1)  ;get top byte		
		ld d,a		
		in a,(SDCARD_BYTE0)  ;get top byte		
		ld e,a
		ret
	
	print_sd_data
		ld a,1
		out (SDCARD_ADDR),a  ;set addr to data
		in a,(SDCARD_READ)	 ;load latch with 32 bit value
		call EndLine
		call EndLine
		in a,(SDCARD_BYTE3)  ;get top byte		
		call DispA
		call EndLine
		in a,(SDCARD_BYTE2)  ;get top byte		
		call DispA
		call EndLine
		in a,(SDCARD_BYTE1)  ;get top byte		
		call DispA
		call EndLine
		in a,(SDCARD_BYTE0)  ;get top byte		
		call DispA
		call EndLine
		ret
	
	;read I2C busy signal  - Z flag set if ready
	I2CBusy
		in a,(I2C_STATUS)
		;push af
		;call DispA
		;call NewLine
		;pop af
		;and $80
		bit 7,a
		ret
		
	;read I2C Data Ready signal  - Z flag set if data ready
	I2CDataReady
		in a,(I2C_STATUS)
	;	push af
	;	push bc
	;	call DispAhex
	;	call EndLine
	;	pop bc
	;	pop af
	;	and $10
		bit 4,a
		ret
	
	I2C_Write
		;call NewLine
		;ld	hl,i2cmessage5
		;call WriteLine
		ld b,0
	I2C_Write_Wait
		dec b
		jr z,I2C_Write_Timeout
		call I2CBusy			;check if I2C bus is still busy - returns with Z flag set if still busy
		jr nz,I2C_Write_Wait
		;push bc
		;ld a,b
		;call DispA
		;call NewLine
		;pop bc
		ld a,%00000000
		out (I2C_SEND),a				;write I2C control string
		and a					;clear carry
		ret
	I2C_Write_Timeout
		;ld a,b
		;call DispA
		
		call NewLine
		ld	hl,i2cmessage4
		call WriteLine
		scf						;set carry on timeout
		ret
		
	I2C_GetStatus
		;call NewLine
		;ld	hl,i2cmessage6
		;call WriteLine
		ld b,0
	I2C_GetStatus_Wait
		dec b
		jr z,I2C_Write_Timeout
		call I2CBusy			;check if I2C bus is still busy - returns with Z flag set if still busy
		jr nz,I2C_GetStatus_Wait
		;push af
		;push bc
		;ld a,b
		;call DispA
		;call NewLine
		;pop bc
		;pop af
		and a					;clear carry
		ret
	
	
	
	I2C_Read_Port
		call I2CBusy
		jr nz,I2C_Read_Port
		ld a,%00000010			;Set to Read command
		out (I2C_SEND),a
		ld b,0					;timeout control - if data is not ready after 10 attempts we will return with carry set
	I2C_Read_Port_WaitDataReady
		dec b
		jr z,I2C_Read_Port_Timeout
		call I2CDataReady
		jr z,I2C_Read_Port_WaitDataReady
		and a					;clear carry
		in a,(I2C_READ)				;get I2C value
		ret
	I2C_Read_Port_Timeout
		scf					;set carry
		ld hl,joyerr1
		call WriteLine
		ret					;and return with status in A


	flushkeys				;flush keyboard	
		in a,(KEY_DATA)		;read keyboard
		cp 0
		jr nz,flushkeys
		ld (LASTKEY),a
		ret
		
	clearspriteattr
		ld a,$83					;and copy 1024 bytes (high byte bit 2 set) and flag attr copy using bit 7
		out (DMA_LEN_HI),a
		ld hl,$8000				;as this is called after memory test this location contains zeroes
		ld a,h
		out (DMA_CPU_MD),a		;We want to copy from CPU memory location 0
		ld a,l
		out (DMA_CPU_LO),a
		ld a,$0
		out (DMA_CPU_HI),a
	
		out (DMA_ATTR_LO),a
		out (DMA_ATTR_HI),a
		ld a,$ff				;and copy 1024 bytes (low byte set)
		out (DMA_LEN_LO),a   ;This also starts the DMA Transfer
		ret
		
	set_joy_a_normal
			;Set IODIRA - All pins as input
		ld a,$00
		out (I2C_REG),a				;IO Extender register for IODIRA
		ld a,%11111111
		out (I2C_DATA),a				;IO Extender data - set all pins to input *** no longer except pin 7 (bit 6)
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jp nz,set_joy_error
	
		;Set Pull Ups for Port A - All Input pins set to Pull Up
		ld a,$06				;set Pull ups for port A
		out (I2C_REG),a				;IO Extender register for GPPUA
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jp nz,set_joy_error
		
		ld a,NORMALJOYTYPE
		ld (JOYATYPE),a		
		
		ld hl,CMD_JOY_A_NORM_Message
		call WriteLine
		
		and a			;clear carry flag
		ret
		
	set_joy_b_normal
		;Set IODIRB - All pins as input
		ld a,$10
		out (I2C_REG),a				;IO Extender register for IODIRA
		ld a,%11111111
		out (I2C_DATA),a				;IO Extender data - set all pins to input *** no longer except pin 7 (bit 6)
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jp nz,set_joy_error
				
		;Set Pull Ups for Port B - All Input pins set to Pull Up
		ld a,$16				;set Pull ups for port B
		out (I2C_REG),a				;IO Extender register for GPPUB
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jr nz,set_joy_error
		
		ld a,NORMALJOYTYPE		
		ld (JOYBTYPE),a
		
		ld hl,CMD_JOY_B_NORM_Message
		call WriteLine
		
		and a			;clear carry flag
		ret
		
	set_joy_a_genesis
			;Set IODIRA - All pins as input other than pins 5 and 7 (bits 0 and 6)
		ld a,$00
		out (I2C_REG),a				;IO Extender register for IODIRA
		ld a,%10111110
		out (I2C_DATA),a				;IO Extender data - set all pins to input *** no longer except pin 7 (bit 6)
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jr nz,set_joy_error
		
	
		;Set Pull Ups for Port A - All Input pins set to Pull Up
		ld a,$06				;set Pull ups for port A
		out (I2C_REG),a				;IO Extender register for GPPUA
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jr nz,set_joy_error
		
		ld a,GENESISJOYTYPE
		ld (JOYATYPE),a
		
		ld hl,CMD_JOY_A_GEN_Message
		call WriteLine
		
		and a			;clear carry flag
		ret
		
	set_joy_b_genesis
		;Set IODIRB - All pins as input other than pins 5 and 7 (bits 0 and 6)
		ld a,$10
		out (I2C_REG),a				;IO Extender register for IODIRA
		ld a,%10111110
		out (I2C_DATA),a				;IO Extender data - set all pins to input *** no longer except pin 7 (bit 6)
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jr nz,set_joy_error
		
		;Set Pull Ups for Port B - All Input pins set to Pull Up
		ld a,$16				;set Pull ups for port B
		out (I2C_REG),a				;IO Extender register for GPPUB
		call I2C_Write
		ret c
		call I2C_GetStatus
		ret c
		and $60					;any acknowledge errors
		jr nz,set_joy_error
		
		ld a,GENESISJOYTYPE		
		ld (JOYBTYPE),a
		ld hl,CMD_JOY_B_GEN_Message
		call WriteLine
		
		and a			;clear carry flag
		ret
	
	set_joy_error
		ld a,NOJOYTYPE
		ld (JOYATYPE),a
		ld (JOYBTYPE),a
		ld hl,CMD_JOY_Err_Message
		call WriteLine
		scf
		ret
	
	CMD_JOYREAD_A
		ld a,$09					;GPIOA
		out (I2C_REG),a
		call I2C_Read_Port
		ret
		
	CMD_JOYREAD_A_GEN		
		ld a,$0a					;OLATA
		out (I2C_REG),a
		ld a,%00000001				;select pin to low
		out (I2C_DATA),a
		call I2C_Write

		ld a,$09					;GPIOA
		out (I2C_REG),a
		call I2C_Read_Port
		jr c,joyerror
		ld l,a

		ld a,$0a					;OLATA
		out (I2C_REG),a
		ld a,%01000001				;select pin to high
		out (I2C_DATA),a
		call I2C_Write

		ld a,$09					;GPIOA
		out (I2C_REG),a
		call I2C_Read_Port
		jr c,joyerror
;		ld a,$60
		ld h,a
		ret
		
	joyerror
		ld hl,joyerr1
		call WriteLine
		ret
		
	
		
	CMD_JOYREAD_B
		ld a,$19					;GPIOB
		out (I2C_REG),a
		call I2C_Read_Port
		ret
		
		
	CMD_JOYREAD_B_GEN

		ld a,$1a					;OLATA
		out (I2C_REG),a
		ld a,%00000001				;select pin to low
		out (I2C_DATA),a
		call I2C_Write

		ld a,$19					;GPIOA
		out (I2C_REG),a
		call I2C_Read_Port
		jr c,joyerror1
		ld l,a

		ld a,$1a					;OLATA
		out (I2C_REG),a
		ld a,%01000001				;select pin to high
		out (I2C_DATA),a
		call I2C_Write

		ld a,$19					;GPIOA
		out (I2C_REG),a
		call I2C_Read_Port
		jr c,joyerror1
;		ld a,$60
		ld h,a
		ret
		
	joyerror1
		ld hl,joyerr2
		call WriteLine
		ret
		
		
	CMD_JOYTEST				;test input for both joystick ports
		call CMD_CLS
		;call NewLine
		ld	hl,joytestmessage1
		call WriteLine
		ld	hl,joytestmessage2
		call WriteLine
	CMD_JOYTEST_loop
		halt
		ld a,(LASTKEY)
		cp 'q'
		jr z,CMD_JOYTEST_exit
		ld a,(JOYATYPE)
		cp NOJOYTYPE
		jr z,CMD_JOYTEST_SkipA
		cp GENESISJOYTYPE
		jr z,CMD_JOYTEST_GEN_A
		ld a,0
		out (TILEMAP_X_VAL),a
		ld a,2
		out (TILEMAP_Y_VAL),a
		ld hl,joytestmessage3
		call WriteLine
		call CMD_JOYREAD_A
		call DispAhex
		jr CMD_JOYTEST_SkipA
	CMD_JOYTEST_GEN_A
		ld a,0
		out (TILEMAP_X_VAL),a
		ld a,2
		out (TILEMAP_Y_VAL),a
		ld hl,joytestmessage4
		call WriteLine
		call CMD_JOYREAD_A_GEN
		call DispHLhex
	CMD_JOYTEST_SkipA
	
		ld a,20
		out (TILEMAP_X_VAL),a
	
		ld a,(JOYBTYPE)
		cp NOJOYTYPE
		jr z,CMD_JOYTEST_SkipB
		cp GENESISJOYTYPE
		jr z,CMD_JOYTEST_GEN_B
		ld a,20
		out (TILEMAP_X_VAL),a
		ld a,2
		out (TILEMAP_Y_VAL),a
		ld hl,joytestmessage3
		call WriteLine
		ld a,20
		out (TILEMAP_X_VAL),a
		call CMD_JOYREAD_B
		call DispAhex
		jr CMD_JOYTEST_SkipB
	CMD_JOYTEST_GEN_B
		ld a,20
		out (TILEMAP_X_VAL),a
		ld a,2
		out (TILEMAP_Y_VAL),a
		ld hl,joytestmessage4
		call WriteLine
		ld a,20
		out (TILEMAP_X_VAL),a
		call CMD_JOYREAD_B_GEN
		call DispHLhex
	CMD_JOYTEST_SkipB
	
		jr CMD_JOYTEST_loop
	CMD_JOYTEST_exit
		ret

		
	joytestmessage1
		defb "Press Q to Exit Joystick Test",0
	joytestmessage2
		defb "JOY A               JOY B",0
	joytestmessage3
		defb "Normal     ",0
	joytestmessage4
		defb "Megadrive  ",0
	joytestmessage5
		defb "No Joystick",0
	joyerr1
		defb "Error reading joystick A",0
	joyerr2
		defb "Error reading joystick B",0
		
	ClearDisplay
		ld a,0
		ld (SCROLLY),a
		out (SCROLL_Y_LO),a
		ld a,(BACKCOL)
		out (TILEMAP_BG),a			;set background colour to black
		out (TILEMAP_ZERO),a			;reset tilemap memory address to 0
		ld bc,$0020			;loop b (256), c(32) times = 8,192 
	clearmaploop
		ld a,0				;clear char byte
		out (TILEMAP_WRITE),a			;out byte to tile map memory
		ld a,(FORECOL)
		out (TILEMAP_COLOUR),a			;set colour to white
		out (TILEMAP_INC),a			;increase tile map memory address
		djnz clearmaploop	;loop 256 times
		dec c
		jp nz,clearmaploop	;keep looping until c is 0
		ret
		
	;puts a 64 bit number into xx,xxx,xxx,xxx,xxx,xxx,xx0 format
	;hl points to buffer with existing number
	FormatNumber64			
		ld de,NUMFORMATBUF
		ld c,$20				;space - this changes to , once we have our first non-zero
		ld b,2
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,0
		ld (de),a
		ret
		
	;puts a 32 bit number into x,xxx,xxx,xx0 format
	;hl points to buffer with existing number
	FormatNumber32			
		ld de,NUMFORMATBUF
		ld c,$20				;space - this changes to , once we have our first non-zero
		ld b,1
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet
		ld a,0
		ld (de),a
		ret
		
	;puts a 16 bit number into xx,xx0 format
	;hl points to buffer with existing number
	FormatNumber16
		ld de,NUMFORMATBUF
		ld c,$20				;space - this changes to , once we have our first non-zero
		ld b,2
		call FormatNumberTuplet
		ld a,c
		ld (de),a
		inc de
		ld b,3
		call FormatNumberTuplet		
		ld a,0
		ld (de),a
		ret
		
	FormatNumberTuplet
		ld a,(hl)
		bit 2,c				;check to see if we've change to a comma
		jr nz,FormatNumberisNotZero
		cp ' '
		jr nz,FormatNumberisNotZero
		ld a,$20
		jr FormatNumberisZero
	FormatNumberisNotZero
		ld c,44
	FormatNumberisZero
		ld (de),a
		inc hl
		inc de
		dec b
		jr nz,FormatNumberTuplet
		ret
		
	NewLine
		call EndLine
		ld a,(SDCURRVOL)		;get current volume number
		add a,65			;convert to drive letter
		call PUTCHAR
		ld a,':'
		call PUTCHAR
		ret
		
	WriteLine
		call WriteString
		call EndLine
		ret
	WriteString
		call writemessage	;write message to screen 
		ret
	EndLine
		push bc
		out (TILEMAP_INC_ROW),a			;go to next line
		ld a,0				;x pos
		out (TILEMAP_X_VAL),a			;set x pos
		ld a,(SCROLLY)
		add a,60
		and 63
		ld b,a
		in a,(TILEMAP_READ_Y)			;get cursor position
		cp b				;are we at bottom of screen
		call z,ScrollScreen;if so call the scroll routine
		pop bc
		ret
	
	writemessage:
		ld a,(hl)			;get letter
		;sub	32			;convert to our numbering system
		cp 0
		jr z,writemessagedone
		out (TILEMAP_WRITE),a			;write letter to tile
		ld a,(FORECOL)
		out (TILEMAP_COLOUR),a			;set foreground colour for tile
		out (TILEMAP_INC),a			;increase to next tile
		inc hl
		jr writemessage	;repeat for entire message
	writemessagedone
		ret
		
	ScrollScreen	
		ld b,80
		ld a,0
	ClearLine
		out (TILEMAP_WRITE),a			;clear next line to be shown prior to scrolling
		;xor 255
		;out (TILEMAP_COLOUR),a
		;xor 255
		out (TILEMAP_INC),a
		djnz ClearLine
		out (TILEMAP_DEC_ROW),a			;move cursor back up to row just cleared
		ld a,(SCROLLY)					;and scroll the screen by one character line
		inc a
		and 63
		ld (SCROLLY),a
		out (SCROLL_Y_LO),a
		
		;in a,(TILEMAP_READ_Y)
		;call DispA
		
		;out (TILEMAP_DEC_ROW),a			;move cursor back up to row just cleared
		
		
		ret
	
	
		push hl
		push bc
		
		
		out (TILEMAP_ZERO),a			;reset cursor
		out (TILEMAP_INC_ROW),a			;move to row 1
		ld c,59
		
	ScrollScreenLoop1
		ld b,80
		ld hl,SCROLLBUFFER
	ScrollScreenLoop2
		in a,(TILEMAP_READ)
		ld (hl),a
		inc hl
		out (TILEMAP_INC),a			;move cursor right
		
		djnz ScrollScreenLoop2
		
		out (TILEMAP_DEC_ROW),a			;move cursor up
		out (TILEMAP_DEC_ROW),a			;move cursor up
	
		;ld a,0
		;out (TILEMAP_X_VAL),a
		
		ld b,80
		ld hl,SCROLLBUFFER
	ScrollScreenLoop3
		ld a,(hl)
		out (TILEMAP_WRITE),a
		inc hl
		out (TILEMAP_INC),a			;move cursor right
		djnz ScrollScreenLoop3
		
		out (TILEMAP_INC_ROW),a			;move cursor down
		;out (TILEMAP_INC_ROW),a			;move cursor down
		
		;ld a,0
		;out (TILEMAP_X_VAL),a
		
		dec c
		jr nz,ScrollScreenLoop1
		
		out (TILEMAP_DEC_ROW),a			;move cursor up
		ld b,80
		ld a,0
	ScrollScreenLoop4
		out (TILEMAP_WRITE),a
		;out (TILEMAP_COLOUR),a
		out (TILEMAP_INC),a
		djnz ScrollScreenLoop4
		
		out (TILEMAP_DEC_ROW),a			;move cursor up
		
		pop bc
		pop hl
		
		
		ret
		
	setpalette
		ld a,$00
		ld hl,$0000		
		ld b,0
	setpaletteloop
		ld c,a
		out (PAL_ENTRY),a
		out (SPR_PAL_ENTRY),a
		ld a,h
		out (PAL_VAL_HI),a
		out (SPR_PAL_HI),a
		ld a,l
		out (PAL_VAL_LO),a
		out (SPR_PAL_LO),a
		out (PAL_WRITE),a			;write colour entry to screen palette entry
		ld l,a
		ld a,3
		out (SPR_PAL_WRITE),a		;write colour entry to both sprite palette entries
		ld a,l
		add a,$4
		ld l,a
		cp $F0
		jr nz,palettenoredcarry
		ld l,0
		inc h
		inc h
		jr setpaletteloopend
	palettenoredcarry
		bit 4,l
		jr z,setpaletteloopend
		ld a,l
		add a,$10
		ld l,a
	setpaletteloopend
		ld a,c
		inc a
		djnz setpaletteloop
		ret
		
		
		

		
	addBC2HLDE	
		ex de,hl
		add hl,bc
		jr nc,addBC2HLDENoCarry
		inc de
	addBC2HLDENoCarry
		ex de,hl
		ret
		
	;subBCfromHLDE	
	;	and a			;reset carry
	;	ex de,hl
	;	sbc hl,bc
	;	jr nc,subBCfromHLDENoCarry
	;	dec de
	;subBCfromHLDENoCarry
	;	ex de,hl
	;	ret
		
	subBCfromHLDE		;changed to set carry status (and other flags) of final result
		and a			;reset carry
		ex de,hl
		sbc hl,bc
		ex de,hl
		ld bc,0
		sbc hl,bc		;will only subtract 1 when carry is set
		ret
		
	;===============================================================
	ConvStr16
	;===============================================================
	;Input: 
	;     DE points to the base 10 number string in RAM. 
	;Outputs: 
	;     HL is the 16-bit value of the number 
	;     DE points to the byte after the number 
	;     BC is HL/10 
	;     z flag reset (nz)
	;     c flag reset (nc)
	;Destroys: 
	;     A (actually, add 30h and you get the ending token) 
	;Size:  23 bytes 
	;Speed: 104n+42+11c
	;       n is the number of digits 
	;       c is at most n-2 
	;       at most 595 cycles for any 16-bit decimal value 
	;===============================================================
		ld hl,0          ;  10 : 210000 
	ConvLoop             ; 
		ld a,(de)        ;   7 : 1A 
		sub 30h          ;   7 : D630 
		cp 10            ;   7 : FE0A 
		ret nc           ;5|11 : D0 
		inc de           ;   6 : 13 
                      ; 
		ld b,h           ;   4 : 44 
		ld c,l           ;   4 : 4D 
		add hl,hl        ;  11 : 29 
		add hl,hl        ;  11 : 29 
		add hl,bc        ;  11 : 09 
		add hl,hl        ;  11 : 29 
                      ; 
		add a,l          ;   4 : 85 
		ld l,a           ;   4 : 6F 
		jr nc,ConvLoop   ;12|23: 30EE 
		inc h            ; --- : 24 
		jr ConvLoop      ; --- : 18EB
		
	

	;=====================================
	; Routine to Store a 32 bit number as string
	; HL:DE INPUT
	; BC POINTS TO OUTPUT

	long2ascii
						; HL = HIGH WORD
		PUSH	DE
		EXX
		POP		HL		; HL' = LOW WORD
		EXX

		LD  E,C
		LD  D,B
				
		;LD  BC,-1000000000/0x10000 -1
		LD  BC,$c466 -1
		EXX
		;LD  BC,-1000000000&0xFFFF
		LD  BC,$3600
		EXX
		CALL    NUM1
		
		;LD  BC,-100000000/0x10000 -1
		LD  BC,$fa0b -1
		EXX
		;LD  BC,-100000000&0xFFFF
		LD  BC,$1f00
		EXX
		CALL    NUM1
		
		;LD  BC,-10000000/0x10000 -1
		LD  BC,$ff68 -1
		EXX
		LD  BC,$6980
		EXX
		CALL    NUM1
		
		;LD  BC,-1000000/0x10000 -1
		LD  BC,$fff1 -1
		EXX
		;LD  BC,-1000000&0xFFFF
		LD  BC,$bdc0
		EXX
		CALL    NUM1
		
		;LD  BC,-100000/0x10000 -1
		LD  BC,$ffff -1
		EXX
		;LD  BC,-100000&0xFFFF
		LD  BC,$7960
		
		EXX
		CALL    NUM1
		
		;LD  BC,-10000/0x10000 -1
		LD  BC,$0000 -1
		EXX
		;LD  BC,-10000&0xFFFF
		LD  BC,$d8f0
		
		EXX
		CALL    NUM1
		
		;LD  BC,-1000/0x10000 -1
		LD  BC,$0000 -1
		EXX
		;LD  BC,-1000&0xFFFF
		LD  BC,$fc18
		EXX
		CALL    NUM1
		
		;LD  BC,-100/0x10000 -1
		LD  BC,$0000 -1
		EXX
		;LD  BC,-100&0xFFFF
		LD  BC,$ff9c
		EXX
		CALL    NUM1
		
		;LD  BC,-10/0x10000 -1
		LD  BC,$0000 -1
		EXX
		;LD  BC,-10&0xFFFF
		LD  BC,$fff6
		EXX
		CALL    NUM1
		
		LD  BC,$0000 -1
		EXX
		;LD  BC,-1&0xFFFF
		LD  BC,$ffff
		EXX
		CALL    NUM1
		RET

	NUM1
		LD  A,'0'-1  ; '0' IN THE TILESET

	NUM2
		INC A
		EXX
		add	HL,BC		; low word
		EXX
		ADC	HL,BC		; high word
		jp  C,NUM2
		
		EXX
		SBC HL,BC		; low word
		EXX
		SBC HL,BC		; high word
		
		LD  (DE),A
		INC DE
		RET
		
	
	DEHL_Times_A3
		push bc
		push ix
		push hl
		pop bc
		;push de
		;pop ix
		ld hl,0
		ld ix,0
	DEHL_Times_A3_Loop
		add ix,de
		jr nc,DEHL_Times_A3_NC
		inc hl
	DEHL_Times_A3_NC
		add hl,bc
		dec a
		jr nz,DEHL_Times_A3_Loop
		push ix
		pop de
		pop ix
		pop bc
		ex de,hl
		ret
		
	; Combined routine for conversion of different sized binary numbers into
	; directly printable ASCII(Z)-string
	; Input value in registers, number size and -related to that- registers to fill
	; is selected by calling the correct entry:
	;
	;  entry  inputregister(s)  decimal value 0 to:
	;   B2D8             A                    255  (3 digits)
	;   B2D16           HL                  65535   5   "
	;   B2D24         E:HL               16777215   8   "
	;   B2D32        DE:HL             4294967295  10   "
	;   B2D48     BC:DE:HL        281474976710655  15   "
	;   B2D64  IX:BC:DE:HL   18446744073709551615  20   "
	;
	; The resulting string is placed into a small buffer attached to this routine,
	; this buffer needs no initialization and can be modified as desired.
	; The number is aligned to the right, and leading 0's are replaced with spaces.
	; On exit HL points to the first digit, (B)C = number of decimals
	; This way any re-alignment / postprocessing is made easy.
	; Changes: AF,BC,DE,HL,IX
	; P.S. some examples below

	; by Alwin Henseler


	B2D8:
		LD H,0
		LD L,A
	B2D16:  
		LD E,0
	B2D24:  
		LD D,0
	B2D32:  
		LD BC,0
	B2D48:  
		LD IX,0          ; zero all non-used bits
	B2D64:  
		LD (B2DINV),HL
		LD (B2DINV+2),DE
		LD (B2DINV+4),BC
		LD (B2DINV+6),IX ; place full 64-bit input value in buffer
		LD HL,B2DBUF
		LD DE,B2DBUF+1
		ld a,' '
		LD (HL),a;" "
	;B2DFILC: EQU $-1         ; address of fill-character
		LD BC,18
		LDIR            ; fill 1st 19 bytes of buffer with spaces
		LD (B2DEND-1),BC ;set BCD value to "0" & place terminating 0
		LD E,1          ; no. of bytes in BCD value
		LD HL,B2DINV+8  ; (address MSB input)+1
		LD BC,#0909
		XOR A
	B2DSKP0:
		DEC B
		JR Z,B2DSIZ     ; all 0: continue with postprocessing
		DEC HL
		OR (HL)         ; find first byte <>0
		JR Z,B2DSKP0
	B2DFND1:
		DEC C
		RLA
        JR NC,B2DFND1   ; determine no. of most significant 1-bit
        RRA
        LD D,A          ; byte from binary input value
	B2DLUS2:
		PUSH HL
        PUSH BC
	B2DLUS1:
		LD HL,B2DEND-1  ; address LSB of BCD value
        LD B,E          ; current length of BCD value in bytes
        RL D            ; highest bit from input value -> carry
	B2DLUS0:
		LD A,(HL)
        ADC A,A
        DAA
        LD (HL),A       ; double 1 BCD byte from intermediate result
        DEC HL
        DJNZ B2DLUS0    ; and go on to double entire BCD value (+carry!)
        JR NC,B2DNXT
        INC E           ; carry at MSB -> BCD value grew 1 byte larger
        LD (HL),1       ; initialize new MSB of BCD value
	B2DNXT:
		DEC C
        JR NZ,B2DLUS1   ; repeat for remaining bits from 1 input byte
        POP BC          ; no. of remaining bytes in input value
        LD C,8          ; reset bit-counter
        POP HL          ; pointer to byte from input value
        DEC HL
        LD D,(HL)       ; get next group of 8 bits
        DJNZ B2DLUS2    ; and repeat until last byte from input value
	B2DSIZ:
		LD HL,B2DEND    ; address of terminating 0
        LD C,E          ; size of BCD value in bytes
        OR A
        SBC HL,BC       ; calculate address of MSB BCD
        LD D,H
        LD E,L
        SBC HL,BC
        EX DE,HL        ; HL=address BCD value, DE=start of decimal value
        LD B,C          ; no. of bytes BCD
        SLA C           ; no. of bytes decimal (possibly 1 too high)
        LD A,'0'
        RLD             ; shift bits 4-7 of (HL) into bit 0-3 of A
        CP '0'          ; (HL) was > 9h?
        JR NZ,B2DEXPH   ; if yes, start with recording high digit
        DEC C           ; correct number of decimals
        INC DE          ; correct start address
        JR B2DEXPL      ; continue with converting low digit
	B2DEXP:
		RLD             ; shift high digit (HL) into low digit of A
	B2DEXPH:
		LD (DE),A       ; record resulting ASCII-code
        INC DE
	B2DEXPL:
		RLD
        LD (DE),A
        INC DE
        INC HL          ; next BCD-byte
        DJNZ B2DEXP     ; and go on to convert each BCD-byte into 2 ASCII
        SBC HL,BC       ; return with HL pointing to 1st decimal
        RET

	
		
		
	;===============================================================
	DEHL_Times_A:
	;===============================================================
	;Inputs:
	;     DEHL is a 32 bit factor
	;     A is an 8 bit factor
	;Outputs:
	;     interrupts disabled
	;     BC is not changed
	;     AHLDE is the 40-bit result
	;     D'E' is the lower 16 bits of the input
	;     H'L' is the lower 16 bits of the output
	;     B' is 0
	;     C' is not changed
	;     A' is not changed
	;===============================================================
		di
		push hl
		or a
		sbc hl,hl
		exx
		pop de
		sbc hl,hl
		ld b,8
	mul32Loop:
		add hl,hl
		exx
		adc hl,hl
		exx
		add a,a
		jr nc,$+8
			add hl,de
			exx
			adc hl,de
			inc a
			exx
		djnz mul32Loop
		push hl
		exx
		pop de
		ei
		ret
		
		;===============================================================
	DEHL_Times_A2:
	;===============================================================
	;Inputs:
	;     DEHL is a 32 bit factor
	;     A is an 8 bit factor
	;Outputs:
	;     interrupts disabled
	;     BC is not changed
	;     AHLDE is the 40-bit result
	;     D'E' is the lower 16 bits of the input
	;     H'L' is the lower 16 bits of the output
	;     B' is 0
	;     C' is not changed
	;     A' is not changed
	;===============================================================
		di
		push hl
		or a
		sbc hl,hl
		exx
		pop de
		sbc hl,hl
		ld b,8
	mul32Loop2:
		add hl,hl
		rl e
		rl d
		add a,a
		jr nc,$+8
		add hl,de
        exx
        adc hl,de
        inc a
        exx
		djnz mul32Loop2
		push hl
		exx
		pop de
		ei
		ret
		
	;Number in hl to decimal ASCII
	;Thanks to z80 Bits
	;inputs:	hl = number to ASCII
	;example: hl=300 outputs '00300'
	;destroys: af, bc, hl, de used
	DispHL:
		ld	bc,-10000
		call	Num1
		ld	bc,-1000
		call	Num1
		ld	bc,-100
		call	Num1
		ld	c,-10
		call	Num1
		ld	c,-1
	Num1:	ld	a,'0'-1
	Num2:	inc	a
		add	hl,bc
		jr	c,Num2
		sbc	hl,bc
		call PUTCHAR
		ret 
		
	;Display a 16- or 8-bit number in hex.
	DispAhex:
		ld c,a
		jr OutHex8
	DispHLhex:
	; Input: HL
		ld  c,h
		call  OutHex8
		ld  c,l
	OutHex8:
	; Input: C
		ld  a,c
		rra
		rra
		rra
		rra
		call  Conv
		ld  a,c
	Conv:
		and  $0F
		add  a,$90
		daa
		adc  a,$40
		daa
		call PUTCHAR  ;replace by bcall(_PutC) or similar
		ret
		
	;Number in a to decimal ASCII
	;adapted from 16 bit found in z80 Bits to 8 bit by Galandros
	;Example: display a=56 as "056"
	;input: a = number
	;Output: a=0,value of a in the screen
	;destroys af,bc (don't know about hl and de)
	DispA:
		ld	c,-100
		call	Na1
		ld	c,-10
		call	Na1
		ld	c,-1
	Na1:	ld	b,'0'-1
	Na2:	inc	b
		add	a,c
		jr	c,Na2
		sub	c		;works as add 100/10/1
		push af		;safer than ld c,a
		ld	a,b		;char is in b
		CALL	PUTCHAR	;plot a char. Replace with bcall(_PutC) or similar.
		pop af		;safer than ld a,c
		ret
		
		
	word2ascii
		ld	bc,-10000
		call	w2aNum1
		ld	bc,-1000
		call	w2aNum1
		ld	bc,-100
		call	w2aNum1
		ld	c,-10
		call	w2aNum1
		ld	c,-1
	w2aNum1:	ld	a,'0'-1
	w2aNum2:	inc	a
		add	hl,bc
		jr	c,w2aNum2
		sbc	hl,bc
		ex de,hl
		ld (hl),a
		inc hl
		ex de,hl
		ret 
	
	byte2ascii
		ld	c,-100
		call	b2aNa1
		ld	c,-10
		call	b2aNa1
		ld	c,-1
	b2aNa1:	ld	b,'0'-1
	b2aNa2:	inc	b
		add	a,c
		jr	c,b2aNa2
		sub	c		;works as add 100/10/1
		push af		;safer than ld c,a
		ld	a,b		;char is in b
		ld (hl),a
		inc hl
		pop af		;safer than ld a,c
		ret

		
	PUTCHAR
		;sub	32			;convert to our numbering system
		out (TILEMAP_WRITE),a			;write letter to tile
		ld a,(FORECOL)
		out (TILEMAP_COLOUR),a			;set foreground colour for tile
		out (TILEMAP_INC),a			;increase to next tile
		ret
		
	CMDTABLE
		defb	"DIR",0,LOW JCMD_GetDirectory,HIGH JCMD_GetDirectory
		defb	"CD",0,LOW JCMD_ChangeDirectory,HIGH JCMD_ChangeDirectory
		defb	"BLOAD",0,LOW JCMD_BinLoad,HIGH JCMD_BinLoad
		defb	"SYS",0,LOW JCMD_Sys,HIGH JCMD_Sys
		defb	"CLS",0,LOW JCMD_CLS,HIGH JCMD_CLS
		defb	"DUMP",0,LOW JCMD_DUMP,HIGH JCMD_DUMP						;dump memory contents
		defb	"BANK",0,LOW JCMD_BANK,HIGH JCMD_BANK
		defb	"JOYTEST",0,LOW JCMD_JOYTEST,HIGH JCMD_JOYTEST
		defb	"GETCHAR",0,LOW JCMD_GETCHAR,HIGH JCMD_GETCHAR
		defb	"LOAD",0,LOW JCMD_Load,HIGH JCMD_Load
		defb	"SETLED2",0,LOW JCMD_SETLED2,HIGH JCMD_SETLED2
		defb	"PAPER",0,LOW JCMD_PAPER,HIGH JCMD_PAPER
		defb	"INK",0,LOW JCMD_INK,HIGH JCMD_INK
		defb	"VOL",0,LOW JCMD_VOL,HIGH JCMD_VOL
		defb	"JOY0",0,LOW JCMD_JOY0,HIGH JCMD_JOY0
		defb	"JOY1",0,LOW JCMD_JOY1,HIGH JCMD_JOY1
		defb	0		;end of command table
	
	testmemmessage
		defb	"Testing Memory",0
	checkdrivesmessage
		defb	"Checking Drives",0
	cmdnotfoundmessage
		defb	"Unknown Command",0
	filenotfoundmessage
		defb	"File not found",0
	notdirmessage
		defb	"Not a directory",0
	isdirmessage
		defb	"Must be a file, not a directory",0
	syntaxerrmessage
		defb	"Syntax Error",0
	filetoobigmessage
		defb	"File exceeds 65536 bytes",0
	invbankerrmessage
		defb	"Invalid bank number (valid range is 3 to 7)",0
	invbankvalerrmessage
		defb	"Invalid bank value (valid range is 0 to 63)",0
	invalidfilegmessage
		defb	"Not a valid Super Jacob Executable",0
	changevolerror
		defb	"Invalid Volume",0
	
	volumestring
		defb 	"Volume in drive ",0
	volumestring2
		defb 	" is ",0
	volserialstring
		defb	"Volume Serial Number is ",0
	dirstring	
		defb	"<DIR>",0
	filetotstring
		defb	" File(s)",0
	dirtotstring
		defb	" Dir(s)",0
	bytetotstring
		defb	" bytes",0
	dirofstring
		defb	"Directory of ",0
		
	welcome
		defb	"SUPER JACOB",0
	welcome2:
		defb	"Douglas Computing Ltd.",0
	welcome3:
		defb	"Copyright 2018",0
	welcome4:
		defb	"RAM Bytes",0
	welcome5:
		defb	"Ready",0
		
	waitmessage1
		defb	"Press any key to continue",0
		
	sdmessage1
		defb  "WAITING FOR CARD TO BE READY",0
	sdmessage2
		defb  "SENDING CMD 0 - GO IDLE STATE",0
	sdmessage3
		defb  "SENDING CMD 8 - SEND_IF_COND",0
	sdmessage4
		defb  "AWAITING RESPONSE",0
	sdmessage5
		defb  "RECEIVED IDLE RESPONSE",0
	sdmessage6
		defb  "COMPATIBLE CARD FOUND",0
	sdmessage7
		defb  "SENDING CMD 55 - APP_CMD",0
	sdmessage8
		defb  "SENDING CMD 41 - ACMD41",0
	sdmessage9
		defb  "SENDING CMD 58 - READ_OCR",0
	sdmessage10
		defb  "VOLTAGE RANGE CORRECT",0
	sdmessage11
		defb "Number of Volumes Found ",0
	sdmessageerr
		defb  "FAILED TO INIT SD CARD",0
	i2cmessage1
		defb	"INTIALISING MCP23017",0
	i2cmessage2
		defb	"MCP23017 INITIALISTION COMPLETE",0
	i2cmessage3
		defb	"MCP23017 INITIALISTION FAILURE",0
	i2cmessage4
		defb	"I2C Interface Timeout",0
	i2cmessage5
		defb	"Init I2C Write",0
	i2cmessage6
		defb	"Init I2C GetStatus",0
	
		
		

