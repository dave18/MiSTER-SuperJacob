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
	
		
	
		
		org $0100
	
		
	nmi
		retn
		
	
		
	interrupt		
		reti
		
	
	
	start
		
		ld sp,$fffe			;slightly irrelevant as we won't use stack
		
		ld a,0
		out (SCROLL_Y_LO),a
		out (SCROLL_X_LO),a		
		
		out (LED_RED),a		;reset multi colour LED
		out (LED_GREEN),a
		out (LED_BLUE),a
		out (LED_0),a
		out (LED_1),a
		
	
		;clear display
		ld a,2				;set screen mode to 2
		out (VIDEO_MODE),a
			
		
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
		
	ClearDisplay
		ld a,0
		ld (SCROLLY),a
		out (SCROLL_Y_LO),a
		ld a,0
		out (TILEMAP_BG),a			;set background colour to black
		out (TILEMAP_ZERO),a			;reset tilemap memory address to 0
		ld bc,$0020			;loop b (256), c(32) times = 8,192 
	clearmaploop
		ld a,0				;clear char byte
		out (TILEMAP_WRITE),a			;out byte to tile map memory
		ld a,$ff
		out (TILEMAP_COLOUR),a			;set colour to white
		out (TILEMAP_INC),a			;increase tile map memory address
		djnz clearmaploop	;loop 256 times
		dec c
		jp nz,clearmaploop	;keep looping until c is 0
		
		ld a,%10000010		;turn on display
		out (SCREEN_CTRL),a
	
		
		ld a,0
		out (TILEMAP_ZERO),a
		
		ld hl,testmemmessage
	writemessage
		ld a,(hl)			;get letter
		;sub	32			;convert to our numbering system
		cp 0
		jr z,writemessagedone
		out (TILEMAP_WRITE),a			;write letter to tile
		ld a,$FF
		out (TILEMAP_COLOUR),a			;set foreground colour for tile
		out (TILEMAP_INC),a			;increase to next tile
		inc hl
		jr writemessage	;repeat for entire message
	writemessagedone
		ld a,0
		out (TILEMAP_INC_ROW),a
		out (TILEMAP_X_VAL),a
		
	myloop
		
		ld hl,testmemmessage2
	writemessage2
		ld a,(hl)			;get letter
		;sub	32			;convert to our numbering system
		cp 0
		jr z,writemessagedone2
		out (TILEMAP_WRITE),a			;write letter to tile
		ld a,$FF
		out (TILEMAP_COLOUR),a			;set foreground colour for tile
		out (TILEMAP_INC),a			;increase to next tile
		inc hl
		jr writemessage2	;repeat for entire message
	writemessagedone2
		ld a,0
		out (TILEMAP_INC_ROW),a
		out (TILEMAP_X_VAL),a
		
		ld a,$BB
		ld ($8000),a
		
		ld hl,testmemmessage3
	writemessage3
		ld a,(hl)			;get letter
		;sub	32			;convert to our numbering system
		cp 0
		jr z,writemessagedone3
		out (TILEMAP_WRITE),a			;write letter to tile
		ld a,$FF
		out (TILEMAP_COLOUR),a			;set foreground colour for tile
		out (TILEMAP_INC),a			;increase to next tile
		inc hl
		jr writemessage3	;repeat for entire message
	writemessagedone3		
		
		ld a,($8000)
		ld c,a
		ld d,a
		
	OutHex8:
	; Input: C
		ld  a,c
		rra
		rra
		rra
		rra		
	
		and  $0F
		add  a,$90
		daa
		adc  a,$40
		daa
		
		out (TILEMAP_WRITE),a			;write letter to tile
		ld a,$FF
		out (TILEMAP_COLOUR),a			;set foreground colour for tile
		out (TILEMAP_INC),a			;increase to next tile
		
		ld  a,c
		
		and  $0F
		add  a,$90
		daa
		adc  a,$40
		daa
		
		out (TILEMAP_WRITE),a			;write letter to tile
		ld a,$FF
		out (TILEMAP_COLOUR),a			;set foreground colour for tile
		
		ld a,0
		out (TILEMAP_INC_ROW),a			;increase to next tile
		out (TILEMAP_X_VAL),a
		
		ld a,d
		cp $BB
		jp nz,myloop
		
	hanghere
		jp hanghere
				
	
	testmemmessage
		defb "TESTING WRITES TO CPU MEMORY",0
	testmemmessage2
		defb "WRITING VALUE $BB TO MEM LOC $8000",0
	testmemmessage3
		defb "VALUE READ BACK IS ",0
	
		
		

