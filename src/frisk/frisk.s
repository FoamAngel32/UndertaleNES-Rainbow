FRISK_FLAG_FAST0_PLAYED1= %00000001
FRISK_FLAG0_FRAME       = %00000110
FRISK_FLAG0_FRAME_DELAY = %00111000
FRISK_FLAG0_FACE        = %11000000
FRISK_FLAG1_MOVEABLE    = %00000010
FRISK_FLAG1_STEP_COUNTER= %01111100
FRISK_FLAG1_MENU_LOADED = %10000000

FRISK_FLAG0_FACE_UP     = %10000000
FRISK_FLAG0_FACE_LEFT   = %01000000
FRISK_FLAG0_FACE_RIGHT  = %11000000


.segment "BANK35"
.include "frisk/gfx.s"
.zeropage
frisk_health:   .res 1
frisk_max_health:   .res 1
frisk_x:        .res 2
frisk_y:        .res 2
frisk_flag0:    .res 1
frisk_flag1:    .res 1
; 7 BIT  1
; 00000000
; |||||||+-FRISK MOVE FAST HORZ
; |||||++--FRAME
; ||+++----FRAME DELAY
; ++-------FACE
; 7 BIT  1
; 00000000
; |||||||+-Played Animation
; ||||||+--Movable (global.interact)
; |+++++---Step Counter
; +--------Menu loaded
.segment "BANK35"

draw_frisk:
  lda frisk_flag0
  and #FRISK_FLAG0_FRAME 
  sta temp
  lda frisk_flag0
  and #FRISK_FLAG0_FACE 
  ldx #3
:
  lsr 
  dex 
  bne :-

  clc 
  adc temp
  tax 
  lda frisk_down_pointers, X
  sta PPU::PTR
  lda frisk_down_pointers+1, X
  sta PPU::PTR+1
  ldx frisk_x
  ldy frisk_y
  lda #$00
  jmp PPU::oam_meta_spr

update_frisk:
  lda frisk_flag0
  eor #1
  sta frisk_flag0
  lda frisk_flag1
  and #(~FRISK_FLAG_FAST0_PLAYED1)
  sta frisk_flag1
  and #FRISK_FLAG1_MOVEABLE
  beq @moveable
  lda #0
  sta keyHeld
@moveable:
  lda keyHeld
  and #PAD_UP
  bne @up_pressed
  lda keyHeld
  and #PAD_DOWN
  bne @down_pressed
  jmp @end_up_down
@up_pressed:
  lda frisk_y 
  sec 
  sbc #3
  sta frisk_y
  lda frisk_flag0
  and #(~FRISK_FLAG0_FACE)
  ora #FRISK_FLAG0_FACE_UP     
  sta frisk_flag0
  jsr @play_anim
  jmp @end_up_down
@down_pressed:
  lda frisk_y 
  clc 
  adc #3
  sta frisk_y
  lda frisk_flag0
  and #(~FRISK_FLAG0_FACE)
  sta frisk_flag0
  jsr @play_anim
@end_up_down:
  lda keyHeld
  and #PAD_LEFT
  bne @left_pressed
  lda keyHeld
  and #PAD_RIGHT
  bne @right_pressed
  lda frisk_flag1
  and #FRISK_FLAG_FAST0_PLAYED1
  bne @skip_move
  jmp @not_move
@left_pressed:
  lda frisk_flag0
  and #FRISK_FLAG_FAST0_PLAYED1     
  bne @slow_left
  lda frisk_x
  sec 
  sbc #2
  jmp @end_left
@slow_left:
  lda frisk_x
  sec 
  sbc #3 
@end_left:
  sta frisk_x
  lda frisk_flag0
  and #(~FRISK_FLAG0_FACE)
  ora #FRISK_FLAG0_FACE_LEFT  
  sta frisk_flag0
  jsr @play_anim
  jmp @an_rts
@right_pressed:
  lda frisk_flag0
  and #FRISK_FLAG_FAST0_PLAYED1
  bne @slow_right
  lda frisk_x
  clc 
  adc #2
  jmp @end_right
@slow_right:
  lda frisk_x
  clc 
  adc #3 
@end_right:
  sta frisk_x
  lda frisk_flag0
  and #(~FRISK_FLAG0_FACE)
  ora #FRISK_FLAG0_FACE_RIGHT
  sta frisk_flag0
  jsr @play_anim
  jmp @skip_move
@not_move:
  lda frisk_flag0
  and #(~(FRISK_FLAG0_FRAME | FRISK_FLAG0_FRAME_DELAY))
  sta frisk_flag0
@skip_move:
  lda keyHeld
  and #PAD_SELECT
  beq @skip_load

  lda frisk_flag1
  and #FRISK_FLAG1_MENU_LOADED
  bne @skip_load

  lda #1
  sta MAP_WINDOW_X_START
  lda #9
  sta MAP_WINDOW_X_END
  lda #24
  sta MAP_WINDOW_Y_START
  lda #160
  sta MAP_WINDOW_Y_END
  lda #0
  sta MAP_WINDOW_X_SCROLL
  lda #8
  sta MAP_WINDOW_Y_SCROLL
  lda #0
  sta MAP_BG_EXT_BANK
  lda #%0001001
  sta MAP_NT_W_CONTROL
  jsr PPU::waitNMI

  lda #40
  sta current_prg_bankA
  sta MAP_PRG_A_LO

  ldx #0
  ldy #0
  lda #>pause_menu
  sta ptr2+1
  lda #<pause_menu
  sta ptr2
  jsr load_nametable_attr_FPGA

  lda #1
  sta current_prg_bankA
  sta MAP_PRG_A_LO
@end_load_FPGA:
  lda #(CHR_MODE_2 | %00010000)  ; enable window
  sta MAP_CHR_CONTROL 
  lda frisk_flag1
  ora #FRISK_FLAG1_MENU_LOADED
  sta frisk_flag1
@skip_load:
@an_rts:
  rts 
@play_anim:
  lda frisk_flag1
  and #FRISK_FLAG_FAST0_PLAYED1
  bne @an_rts
  lda frisk_flag1
  ora #FRISK_FLAG_FAST0_PLAYED1
  sta frisk_flag1
  lda frisk_flag0       
  clc 
  adc #%00001000
  and #FRISK_FLAG0_FRAME_DELAY
  sta temp 
  lda frisk_flag0       
  and #(~FRISK_FLAG0_FRAME_DELAY)
  ora temp
  sta frisk_flag0     
  and #FRISK_FLAG0_FRAME_DELAY
  bne @an_rts
  lda frisk_flag0       
  clc 
  adc #FRISK_FLAG1_MOVEABLE
  and #FRISK_FLAG0_FRAME
  sta temp 
  lda frisk_flag0       
  and #(~FRISK_FLAG0_FRAME)
  ora temp
  sta frisk_flag0      
  lda frisk_flag1  
  clc 
  adc #%00000100
  and #FRISK_FLAG1_STEP_COUNTER
  sta temp 
  lda frisk_flag1       
  and #(~FRISK_FLAG1_STEP_COUNTER)
  ora temp
  sta frisk_flag1      
  jmp @an_rts
.segment "BANK36"
pause_menu:
  .incbin "gfx/UI/pause_menu.nam"
.segment "BANK35"
