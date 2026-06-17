.feature c_comments
.feature force_range
.linecont +
/*
                                                                          
88                                            88                          
88                                            88                          
88                                            88                          
88,dPPYba,    ,adPPYba,  ,adPPYYba,   ,adPPYb,88   ,adPPYba,  8b,dPPYba,  
88P'    "8a  a8P_____88  ""     `Y8  a8"    `Y88  a8P_____88  88P'   "Y8  
88       88  8PP"""""""  ,adPPPPP88  8b       88  8PP"""""""  88          
88       88  "8b,   ,aa  88,    ,88  "8a,   ,d88  "8b,   ,aa  88          
88       88   `"Ybbd8"'  `"8bbdP"Y8   `"8bbdP"Y8   `"Ybbd8"'  88          
                                                                          
                                                                          
*/
.segment "HEADER"
.import NES_MAPPER
.import NES_PRG_BANKS,NES_CHR_BANKS
.define RNBW_CHR_ROM      0 ; CHR-ROM only
.define RNBW_CHR_RAM      1 ; CHR-RAM only
.define RNBW_CHR_ROM_RAM  2 ; CHR-ROM + CHR-RAM
.ifndef CHR_CHIPS
  .warning "CHR_CHIPS not defined, using default value (2) : CHR-ROM+CHR-RAM"
  CHR_CHIPS = RNBW_CHR_ROM_RAM
.endif

.if CHR_CHIPS = RNBW_CHR_ROM
  .out "# Building CHR-ROM version"
.endif

.if CHR_CHIPS = RNBW_CHR_RAM
  .out "# Building CHR-RAM version"
.endif

.if CHR_CHIPS = RNBW_CHR_ROM_RAM
  .out "# Building CHR-ROM + CHR-RAM version"
.endif

.out "#"

; NES 2.0 format
.byte "NES",$1A   ; 'NES' + $1A
.byte <NES_PRG_BANKS
.if CHR_CHIPS = RNBW_CHR_RAM
  .byte 0
.else
  .byte <NES_CHR_BANKS
.endif
.byte ((NES_MAPPER&$0F)<<4) |%00000010 
.byte ((NES_MAPPER&$F0)|%00001000) ; upper nybble of mapper number + iNES 2.0
.byte ((NES_MAPPER&$F00)>>8)
.byte ((>NES_CHR_BANKS)<<4)|>NES_PRG_BANKS
.byte $E0 ; PRG-RAM shift counter - (64 << shift counter)
.if CHR_CHIPS <> RNBW_CHR_ROM
  .byte 6 ; CHR-RAM shift counter - (64 << shift counter)
.else
  .byte 0
.endif
.byte $00, $00, $00, $01 ; padding

/*
                                                                                                  
                                                                                                  
                                                                                                  
                                                                                                  
888888888   ,adPPYba,  8b,dPPYba,   ,adPPYba,   8b,dPPYba,   ,adPPYYba,   ,adPPYb,d8   ,adPPYba,  
     a8P"  a8P_____88  88P'   "Y8  a8"     "8a  88P'    "8a  ""     `Y8  a8"    `Y88  a8P_____88  
  ,d8P'    8PP"""""""  88          8b       d8  88       d8  ,adPPPPP88  8b       88  8PP"""""""  
,d8"       "8b,   ,aa  88          "8a,   ,a8"  88b,   ,a8"  88,    ,88  "8a,   ,d88  "8b,   ,aa  
888888888   `"Ybbd8"'  88           `"YbbdP"'   88`YbbdP"'   `"8bbdP"Y8   `"YbbdP"Y8   `"Ybbd8"'  
                                                88                        aa,    ,88              
                                                88                         "Y8bbdP"               
*/


.zeropage
state:                 .res 1
current_chr_bank0:     .res 2
current_chr_bank1:     .res 2
current_chr_bank2:     .res 2
current_chr_bank3:     .res 2

current_prg_bank8:     .res 2
current_prg_bankA:     .res 2
current_prg_bankC:     .res 2

title_irq:             .res 1

ptr1:                  .res 2
ptr2:                  .res 2
temp:                  .res 1
write_wait:                      .res 1
write_used_byte:                 .res 1
write_character:                 .res 1
write_sfx:                       .res 1
nt_data_len:           .res 1
buffer_used:           .res 1
vram_buffer:           .res 128
irq_latch:             .res 1

scroll_x:              .res 2
scroll_y:              .res 2
keyHeld:               .res 1
/*
                                                                                  
88                           88                        88                         
""                           88                        88                         
                             88                        88                         
88  8b,dPPYba,    ,adPPYba,  88  88       88   ,adPPYb,88   ,adPPYba,  ,adPPYba,  
88  88P'   `"8a  a8"     ""  88  88       88  a8"    `Y88  a8P_____88  I8[    ""  
88  88       88  8b          88  88       88  8b       88  8PP"""""""   `"Y8ba,   
88  88       88  "8a,   ,aa  88  "8a,   ,a88  "8a,   ,d88  "8b,   ,aa  aa    ]8I  
88  88       88   `"Ybbd8"'  88   `"YbbdP'Y8   `"8bbdP"Y8   `"Ybbd8"'  `"YbbdP"'  
                                                                                  
                                                                                  
*/

; MAPPER REGISTERS
.include "mapper-registers.s"

; BUILD VERSION
.include "version.s"
.out .sprintf( "# version %s", STR_VERSION )
.out .sprintf( "# build %s", STR_BUILD )
.out ""
.segment "BANK1"
  .incbin "famistudio/music_bank0.dmc"
.segment "BANK2"
  .incbin "famistudio/music_bank1.dmc"
.segment "BANK3"
  .incbin "famistudio/music_bank2.dmc"
; .segment "BANK4"
;   .incbin "famistudio/music_bank3.dmc"
; .segment "BANK5"
;   .incbin "famistudio/music_bank4.dmc"
; .segment "BANK6"
;   .incbin "famistudio/music_bank5.dmc"
; .segment "BANK7"
;   .incbin "famistudio/music_bank6.dmc"
; NES LIB - thanks Shiru (http://shiru.untergrund.net/code.shtml)
.segment "CODE"
.include "nes-lib/nes-lib.s"

; RAINBOW
; documentation: https://github.com/BrokeStudio/rainbow-lib
.segment "CODE"
.include "rainbow-lib/rainbow.s"

/*
                                                                               
                                                                               
             ,d                               ,d                               
             88                               88                               
,adPPYba,  MM88MMM  ,adPPYYba,  8b,dPPYba,  MM88MMM  88       88  8b,dPPYba,   
I8[    ""    88     ""     `Y8  88P'   "Y8    88     88       88  88P'    "8a  
 `"Y8ba,     88     ,adPPPPP88  88            88     88       88  88       d8  
aa    ]8I    88,    88,    ,88  88            88,    "8a,   ,a88  88b,   ,a8"  
`"YbbdP"'    "Y888  `"8bbdP"Y8  88            "Y888   `"YbbdP'Y8  88`YbbdP"'   
                                                                  88           
                                                                  88           
*/

.segment "CODE"
vector_reset:

  ; initialize the NES
  cld
  sei
  ldx #$FF
  txs

initPPU1:
  lda PPU_STATUS
  bpl initPPU1
initPPU2:
  lda PPU_STATUS
  bpl initPPU2

  ldx #$00
  stx PPU_MASK
  stx DMC_FREQ
  stx PPU_CTRL        ;no NMI

clearRAM:
  txa
:
  sta $000,x
  sta $100,x
  sta $200,x
  sta $300,x
  sta $400,x
  sta $500,x
  sta $600,x
  sta $700,x
  inx
  bne :-

  jsr PPU::oam_clear

  lda #%10000000
  sta <PPU::CTRL_VAR
  sta PPU_CTRL        ; enable NMI
  lda #%00000110
  sta <PPU::MASK_VAR

waitSync3:
  lda PPU::FRAME_CNT1
:
  cmp PPU::FRAME_CNT1
  beq :-

  ; get TV system
  ; 0 : NTSC
  ; 1 : PAL
  ; 2 : dendy
  ; 3 : unknown
  jsr PPU::getTVSystem

  ; initialize sound APU
  ldx #$00
apu_clear_loop:
  sta $4000, X            ; write 0 to most APU registers
  inx
  cpx #$13
  bne apu_clear_loop
  ldx #$00
  stx $4015               ; turn off square/noise/triangle/DPCM channels

  ; acknowledge/disable both APU IRQs
  ; (frame counter and DMC completion)
  lda #$40
  sta $4017  ; APU IRQ: OFF!
  lda $4015  ; APU IRQ: ACK!

  ; disable ESP for now
  lda #0
  sta RNBW::CONFIG

  ; init Rainbow RX/TX RAM addresses
config_game:
  lda #>RNBW::BUF_IN
  sta RNBW::RX_ADD
  lda #>RNBW::BUF_OUT
  sta RNBW::TX_ADD
  lda #%10000000
  sta MAP_PRG_6_HI
  lda #0
  sta MAP_PRG_6_LO
  sta MAP_PRG_7_HI
  sta MAP_PRG_8_HI
  sta MAP_PRG_9_HI
  sta MAP_PRG_A_HI
  sta MAP_PRG_B_HI
  sta MAP_PRG_C_HI
  sta MAP_PRG_D_HI
  sta MAP_PRG_F_HI
  sta current_prg_bank8
  sta MAP_PRG_8_LO
  lda #$01
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #$02
  sta current_prg_bankC
  sta MAP_PRG_C_LO
  lda #$03
  sta MAP_PRG_E_LO
  lda #%00000011
  sta MAP_PRG_CONTROL

  jsr PPU::getTVSystem
  cmp #0
  beq @is_NTSC
@non_NTSC:
  lda #0
  jmp @skip_NTSC
@is_NTSC:
  lda #1
@skip_NTSC:
  ; init famistudio
	ldx #<music_data_undertale
	ldy #>music_data_undertale
  jsr famistudio_init
  ldx #<sounds
  ldy #>sounds
  jsr famistudio_sfx_init
  jsr clean_vram_buffer
  ; disable rendering
  jsr PPU::off

  ; set brightness to 4
  lda #4
  sta PPU::palBrightness
  jsr PPU::setPaletteBrightness

  ; push palette updates
  jsr PPU::flushPalette

  ; set BG CHR page
  lda #0
  jsr PPU::setBG_bank

  ; set SPR CHR page
  lda #1
  jsr PPU::setSPR_bank

  ; enable ESP / disable IRQ
  lda #1
  sta RNBW::CONFIG
  cli 
  jsr PPU::waitNMI
  jmp main
.include "famistudio/famistudio_ca65.s"

; .segment "BANK7"
.segment "CODE"
/*
                                                                         
                                             88  88                      
                                             88  ""    ,d                
                                             88        88                
 ,adPPYba,  8b,dPPYba,   ,adPPYba,   ,adPPYb,88  88  MM88MMM  ,adPPYba,  
a8"     ""  88P'   "Y8  a8P_____88  a8"    `Y88  88    88     I8[    ""  
8b          88          8PP"""""""  8b       88  88    88      `"Y8ba,   
"8a,   ,aa  88          "8b,   ,aa  "8a,   ,d88  88    88,    aa    ]8I  
 `"Ybbd8"'  88           `"Ybbd8"'   `"8bbdP"Y8  88    "Y888  `"YbbdP"'  
                                                                         
                                                                         
*/

  ; credits+build
  credits:
  .byte "/UNDERTALE RAINBOW NES PORT"
  build:
  .byte STR_BUILD
  .byte "/(c) 2021-2023 Broke Studio/code Antoine Gohin/"
  .byte "(C) PORT BY FOAM ANGEL 32"

/*
                                     
                                 88  
                                 ""  
                                     
8b,dPPYba,   88,dPYba,,adPYba,   88  
88P'   `"8a  88P'   "88"    "8a  88  
88       88  88      88      88  88  
88       88  88      88      88  88  
88       88  88      88      88  88  
                                     
                                     
*/
.segment "CODE"

.proc vector_nmi
  ; save stack
  pha 
  txa 
  pha 
  tya 
  pha 
  ; if rendering is disabled, do not access the VRAM at all
  lda PPU::MASK_VAR
  and #%00011000
  bne doUpdate
  jmp skipAll
  
doUpdate:

  ; update OAM
  ldx #$00
  stx PPU_OAM_ADDR
  lda #>OAM_BUF
  sta PPU_OAM_DMA

  ; update palette if needed
  lda <PPU::palUpdate
  beq updVRAM
  bmi fadePal
  jmp flushPal
fadePal:

  jsr PPU::fadePalette
  jmp updVRAM

flushPal:

  jsr PPU::flushPalette

updVRAM:

  lda PPU::VRAM_UPDATE
  beq skipUpd
  ldx #$00
  stx PPU::VRAM_UPDATE
  
  lda buffer_used
  beq skipUpd
  lda #$00
  sta buffer_used
  jsr PPU::flush_vram_update_nmi
skipUpd:

  lda #$00
  sta PPU_ADDR
  sta PPU_ADDR

  sta PPU_SCROLL
  sta PPU_SCROLL

skipAll:

  lda PPU::CTRL_VAR
  sta PPU_CTRL

  lda PPU::MASK_VAR
  sta PPU_MASK

skipClassicNMI:

  inc PPU::FRAME_CNT1
  inc PPU::FRAME_CNT2
  lda PPU::FRAME_CNT2
  cmp #$06
  bne skipNtsc
  lda #$00
  sta PPU::FRAME_CNT2
skipNtsc:
  
  ; update sound/music here
  lda #0
  sta MAP_PRG_8_LO
  lda #1
  sta MAP_PRG_A_LO

  jsr famistudio_update
  
  lda current_prg_bank8
  sta MAP_PRG_8_LO
  lda current_prg_bankA
  sta MAP_PRG_A_LO
  ; update prng
  jsr system::prng

end_nmi:
  ldx 6
:
  dex 
  cpx #$00 
  beq @pad_end
  ldy #0
  jsr pad::read
  sta temp
  ldy #0
  jsr pad::read
  cmp temp
  bne :-
  sta keyHeld
@pad_end:
  ; restore stack
  pla 
  tay   
  pla 
  tax     
  pla     

  ; return
  rti  

.endproc

/*
                             
88                           
""                           
                             
88  8b,dPPYba,   ,adPPYb,d8  
88  88P'   "Y8  a8"    `Y88  
88  88          8b       88  
88  88          "8a    ,d88  
88  88           `"YbbdP'88  
                         88  
                         88  
*/

.segment "CODE"
.proc vector_irq
  pha 
  txa 
  pha 
  tya 
  pha 

  lda MAP_PPU_IRQ_STATUS
  and #$01
  bne @irq_wifi
  lda state
  bne @end_state0 ; state != 0 jump
; state 0 irq
  lda irq_latch

  cmp #220
  beq @resetCHR_state0    ;irq_latch == 220 jump

  lda #$00
  sta MAP_CHR_0_HI
  sta MAP_CHR_0_LO
  lda #220
  sta MAP_PPU_IRQ_LATCH
  sta irq_latch
  jmp @end
@resetCHR_state0:
  lda title_irq
  bne @title_irq_enabled
  lda #152
  sta MAP_PPU_IRQ_LATCH
  sta irq_latch
  jmp @end_title_irq
@title_irq_enabled:
  lda #127
  sta MAP_PPU_IRQ_LATCH
  sta irq_latch
@end_title_irq:
  lda current_chr_bank0+1
  sta MAP_CHR_0_HI
  lda current_chr_bank0+0
  sta MAP_CHR_0_LO
 
  lda current_chr_bank1+1
  sta MAP_CHR_1_HI
  lda current_chr_bank1+0
  sta MAP_CHR_1_LO
 
  lda current_chr_bank2+1
  sta MAP_CHR_2_HI
  lda current_chr_bank2+0
  sta MAP_CHR_2_LO

  lda current_chr_bank3+1
  sta MAP_CHR_3_HI
  lda current_chr_bank3+0
  sta MAP_CHR_3_LO

  jmp @end
@end_state0:
  jmp @end
@irq_wifi:
@end:
  pla 
  tay 
  pla 
  tax 
  pla 
  ; return
  rti 

.endproc

/*
                                              
         88                                   
         88                ,d                 
         88                88                 
 ,adPPYb,88  ,adPPYYba,  MM88MMM  ,adPPYYba,  
a8"    `Y88  ""     `Y8    88     ""     `Y8  
8b       88  ,adPPPPP88    88     ,adPPPPP88  
"8a,   ,d88  88,    ,88    88,    88,    ,88  
 `"8bbdP"Y8  `"8bbdP"Y8    "Y888  `"8bbdP"Y8  
                                              
                                              
*/
.segment "MUSBANK"
.include "famistudio/music.s"
.include "famistudio/sounds.s"
.segment "BANK35"
.include "intro/intro_bg.s"
.segment "BANKDIAL0"
.include "intro/intro_dial.s"

/*
                                     
            88                       
            88                       
            88                       
 ,adPPYba,  88,dPPYba,   8b,dPPYba,  
a8"     ""  88P'    "8a  88P'   "Y8  
8b          88       88  88          
"8a,   ,aa  88       88  88          
 `"Ybbd8"'  88       88  88          
                                     
                                     
*/
.if CHR_CHIPS <> RNBW_CHR_RAM

  .segment "CHR00"
    .incbin "gfx/font/font_def.chr"
    .incbin "gfx/font/font_sans.chr"
    .incbin "gfx/font/font_papy.chr"
    .incbin "gfx/intro/intro1.chr"
    .incbin "gfx/intro/intro2.chr"
    .incbin "gfx/intro/intro3.chr"
    .incbin "gfx/intro/intro4.chr"
    .incbin "gfx/intro/intro5.chr"
    .incbin "gfx/intro/intro6.chr"
    .incbin "gfx/intro/intro7.chr"
    .incbin "gfx/intro/intro8.chr"
    .incbin "gfx/title.chr"
    .incbin "gfx/intro/introA.chr"
    .incbin "gfx/intro/introB.chr"
    .incbin "gfx/obj/frisk.chr"

.endif

/*
                                                                                 
                                                                                 
                                       ,d                                        
                                       88                                        
8b       d8   ,adPPYba,   ,adPPYba,  MM88MMM  ,adPPYba,   8b,dPPYba,  ,adPPYba,  
`8b     d8'  a8P_____88  a8"     ""    88    a8"     "8a  88P'   "Y8  I8[    ""  
 `8b   d8'   8PP"""""""  8b            88    8b       d8  88           `"Y8ba,   
  `8b,d8'    "8b,   ,aa  "8a,   ,aa    88,   "8a,   ,a8"  88          aa    ]8I  
    "8"       `"Ybbd8"'   `"Ybbd8"'    "Y888  `"YbbdP"'   88          `"YbbdP"'  
                                                                                 
                                                                                 
*/

.segment "VECTORS"
  .word vector_nmi    ; $FFFA vblank nmi
  .word vector_reset  ; $FFFC reset
  .word vector_irq    ; $FFFE irq / brk
  
/*                                          
,adPPYba,  ,adPPYYba,  
I8[    ""  ""     `Y8  
 `"Y8ba,   ,adPPPPP88  
aa    ]8I  88,    ,88  
`"YbbdP"'  `"8bbdP"Y8    
*/




/*
                                                 
                                88               
                                ""               
                                                 
88,dPYba,,adPYba,   ,adPPYYba,  88  8b,dPPYba,   
88P'   "88"    "8a  ""     `Y8  88  88P'   `"8a  
88      88      88  ,adPPPPP88  88  88       88  
88      88      88  88,    ,88  88  88       88  
88      88      88  `"8bbdP"Y8  88  88       88  
                                                 
                                                 
*/
.segment "CODE"
; [a]:char
; [x]:MSB
; [y]:LSB
.proc one_vram_buffer
  pha              ; char in stack
  tya              ; y -> a
  pha              ; LSB in stack
  txa              ; x -> a
  pha              ; MSB in stack
  ldy buffer_used  ; y = buffer_used
  pla              ; a = MSB
  sta vram_buffer, y
  iny 
  pla             ; a = LSB
  sta vram_buffer, y
  iny 
  pla             ; a = char
  sta vram_buffer, y
  iny 
  sty buffer_used
  lda #$01
  sta PPU::VRAM_UPDATE
  rts 
.endproc
; examples
; write at $2285, char is #$01
  ; lda #$01
  ; ldx #$22
  ; ldy #$85
  ; jsr one_vram_buffer
; [a]:len
; [x]:NT_UPD_HORZ or NT_UPD_VERT
; [y]:same char or not
; ptr1: MSB, LSB
; ptr2: data_pointer or char num
.proc multi_vram_buffer
  pha              ; len in stack
  tya 
  pha              ; same char or not in stack
  ldy buffer_used  ; y = buffer_used
  lda ptr1         ; a = MSB
  stx temp
  ora temp         ; a |= temp actually is MSB |= temp
  sta vram_buffer, y
  iny 
  lda ptr1+1       ; a = LSB
  sta vram_buffer, y
  iny 
  pla              ; a = same char or not
  sta temp
  pla              ; a = len
  sta vram_buffer, y
  iny 
  sty buffer_used
  clc 
  adc buffer_used
  tax              ; a -> y or y = len
@loop:
  lda temp
  cmp #$00
  beq @load_data
  jmp @load_char
@load_data:
  lda (ptr2), y
  jmp @end_load
@load_char:
  lda ptr2
@end_load:
  sta vram_buffer, y
  iny              ; y++
  dex              ; x--
  bne @loop
  sty temp
  lda buffer_used 
  clc 
  adc temp
  sta buffer_used
  lda #$01
  sta PPU::VRAM_UPDATE
  rts 
.endproc
;[x] in, add how much
;[a] out, how much in total
.proc add_health
  lda #$0B
  jsr famistudio_sfx_sample_play
  stx temp
  lda frisk_health
  clc 
  adc temp
  cmp frisk_max_health
  bcc @not_max_out    
  lda frisk_max_health
@not_max_out:
  sta frisk_health
  rts 
.endproc
; examples
; write at $2286, char is #$02
; len is 7 bytes
  ; ldx #$22
  ; ldy #$86
  ; stx ptr1+0
  ; sty ptr1+1
  ; lda #$02
  ; sta ptr2
  ; lda #$7
  ; ldx #NT_UPD_HORZ
  ; ldy #$01
  ; jsr multi_vram_buffer
; [a]: frame to wait between each character, 
; [x]: sfx
; ptr1: MSB LSB
; ptr2: text 
; less than $20 data will be seen as delay and end with $FF
.proc undertale_write
  stx write_sfx
  sta write_wait
  ldy #$00
  lda #$00
  sta write_used_byte
@loop:
  lda write_wait
  asl 
  tax 
  jsr system::delayNMI
  lda (ptr2), y
  sta write_character
  cmp #$FF
  beq @end
  cmp #$20
  bcc @wait
  lda #00
  sta MAP_PRG_8_LO
  lda #01
  sta MAP_PRG_A_LO
  lda write_sfx
  ldx #FAMISTUDIO_SFX_CH0
  jsr famistudio_sfx_play
  lda current_prg_bank8
  sta MAP_PRG_8_LO
  lda current_prg_bankA
  sta MAP_PRG_A_LO
  lda write_sfx
  ldx ptr1
  clc 
  lda ptr1+1
  adc write_used_byte
  tay 
  lda write_character
  jsr one_vram_buffer
  jmp @end_loop
@wait:
  ldy write_used_byte
  lda (ptr2), y
  asl                  
  asl                  
  sta temp              
  lda (ptr2), y
  asl                    
  asl                   
  asl                   
  asl                   
  clc 
  adc temp 
  tax 
  jsr system::delayNMI
@end_loop:
  inc write_used_byte
  ldy write_used_byte
  jmp @loop
@end:
  rts 
.endproc

; [x]:PPU_ADDR HI
; [y]:PPU_ADDR LO
; [ptr2]:address
.proc load_nametable
  jsr PPU::ppu_off_all
  stx PPU_ADDR
  sty PPU_ADDR     
  ldx #$4
  ldy #$0
@loop:
  lda (ptr2),y  
  sta PPU_DATA
  iny       
  bne @loop 
  inc ptr2+1   
  dex   
  bne @loop    
  jmp PPU::ppu_on_all
.endproc
.proc load_nametable_attr_FPGA
  stx MAP_BSRAM_RW_HI_ADD
  sty MAP_BSRAM_RW_LO_ADD     
  lda #1
  sta MAP_BSRAM_RW_INC
  ldx #$4
  ldy #$0
@loop:
  lda (ptr2),y  
  sta MAP_BSRAM_RW_DATA
  iny       
  bne @loop 
  inc ptr2+1   
  dex   
  bne @loop    
  rts 
.endproc
main:
  lda #39
  sta current_prg_bank8
  sta MAP_PRG_8_LO
  jsr init_state_title
  lda #0
  sta current_prg_bank8
  sta MAP_PRG_8_LO
@main_loop:
  jsr PPU::oam_clear
  ; detect state 0
  lda state
  bne @end_state_title
  lda #39
  sta current_prg_bank8
  sta MAP_PRG_8_LO
  jsr update_state_title
  lda #0
  sta current_prg_bank8
  sta MAP_PRG_8_LO
  jmp @end_state
@end_state_title:
@end_state_mainmenu:
  ; detect state 1
  cmp #$02
  bne @end_state
  lda #39
  sta current_prg_bank8
  sta MAP_PRG_8_LO
  jsr update_mainplay
  lda #0
  sta current_prg_bank8
  sta MAP_PRG_8_LO
  jsr PPU::waitNMI
@end_state:
  lda PPU::VRAM_UPDATE
  beq @skipClear
  jsr clean_vram_buffer
@skipClear:
  jsr PPU::waitNMI
  jmp @main_loop

clean_vram_buffer:
  ldx #$00    
  ldy #$80        
  lda #NT_UPD_EOF       
@clear_loop:
  lda vram_buffer, x  
  cmp #NT_UPD_EOF
  beq @end
  lda #NT_UPD_EOF       
  sta vram_buffer, x    
  inx            
  dey            
  bne @clear_loop  
@end:
  rts 

.segment "BANK35"
init_state_title:
  
  lda #$00
  sta state
  sta current_chr_bank0+1
  sta current_chr_bank1+1
  jsr PPU::waitNMI
  lda #152
  sta MAP_PPU_IRQ_LATCH
  sta irq_latch

  lda #$FF
  sta MAP_PPU_IRQ_ENABLE

  lda #CHR_MODE_2
  sta MAP_CHR_CONTROL
  jsr PPU::on

  lda #<vram_buffer
  ldx #>vram_buffer
  jsr PPU::set_vram_update

  lda #0
  jsr famistudio_music_play

  ; jsr intro_cutscene

  lda #$01
  sta title_irq
  jsr famistudio_music_stop
  lda #17
  sta current_chr_bank0
  sta current_chr_bank1
  sta MAP_CHR_0_LO
  sta MAP_CHR_1_LO

  lda #40
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #>title
  sta ptr2+1
  lda #<title
  sta ptr2
  ldx #$20
  ldy #$00
  jsr PPU::waitNMI
  jsr load_nametable
  lda #1
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #<palette_title
  ldx #>palette_title
  jsr PPU::pal_bg
  jsr PPU::waitNMI
  lda #$04
  jsr PPU::setPaletteBrightness
  lda #$8
  jsr famistudio_sfx_sample_play
  ldx #$50
  jsr system::delayNMI
  lda #$22
  sta ptr1
  lda #$12
  sta ptr1+1
  lda #>title_line0
  sta ptr2+1
  lda #<title_line0
  sta ptr2
  ldx #1
  lda #2
  jmp undertale_write
update_state_title:
  lda keyHeld
  beq @not_init
  jsr init_mainplay
@not_init:
  rts 
.include "intro/intro_cutscene.s"
palette_title:
  .byte $0F, $15, $00, $30
  .byte $0F, $00, $10, $30
  .byte $0F, $00, $10, $30
  .byte $0F, $00, $10, $30
title_line0:
  .byte "NES Edition", $FF
palette_obj_ruins:
  .byte $0F, $07, $22, $27
  .byte $0F, $00, $10, $30
  .byte $0F, $00, $10, $30
  .byte $0F, $00, $10, $30
.include "frisk/frisk.s"
init_mainplay:
  lda #%01000000
  sta MAP_NT_A_CONTROL
  sta MAP_NT_B_CONTROL
  sta MAP_NT_C_CONTROL
  sta MAP_NT_D_CONTROL
  lda #$00
  sta MAP_NT_A_BANK
  lda #$01
  sta MAP_NT_B_BANK
  lda #$02
  sta MAP_NT_C_BANK
  lda #$03
  sta MAP_NT_D_BANK
  lda #2
  sta PPU::palFadeDelay
  lda #2
  jsr famistudio_music_play
  lda #00
  jsr PPU::fadePaletteWait
  lda #$02
  sta state
  sta MAP_PPU_IRQ_DISABLE
  lda #25
  sta current_chr_bank2
  sta MAP_CHR_2_LO
  clc 
  adc #$01
  sta current_chr_bank3
  sta MAP_CHR_3_LO

  lda PPU::PPU_CTRL_VAR
  ora #%00100000
  sta PPU::PPU_CTRL_VAR

  lda #<palette_obj_ruins
  ldx #>palette_obj_ruins
  jsr PPU::pal_spr

  ldx #$05
  jsr system::delayNMI
  lda #04
  jmp PPU::fadePaletteWait
update_mainplay:
  jsr update_frisk
  jmp draw_frisk
.segment "BANK37"
  .include "items/use.s"
.segment "BANK38"
  .include "items/check.s"
