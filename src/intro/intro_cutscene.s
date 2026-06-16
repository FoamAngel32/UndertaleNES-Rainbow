wait_between_time      = $20
wait_between_time_long = $FF
intro_9_y_bottom       = 112
.segment "BANK35"
intro_cutscene:
  lda #$00
  sta title_irq
  lda #$01
  sta MAP_NT_A_BANK
  sta MAP_NT_C_BANK
  sta MAP_BSRAM_RW_INC
  lda #$00
  sta MAP_NT_B_BANK
  sta MAP_NT_D_BANK
  lda #36
  sta MAP_PRG_A_LO
  sta current_prg_bankA
  lda #$6
  sta PPU::palFadeDelay
  lda #<palette_story
  ldx #>palette_story
  jsr PPU::pal_bg
@intro_scene_0:
  lda #$03
  sta current_chr_bank0
  sta current_chr_bank1
  lda #>STORY0
  sta ptr2+1
  lda #<STORY0
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  jsr PPU::waitNMI
  lda #$22
  sta ptr1
  lda #$85
  sta ptr1+1
  lda #>intro_dial0_line0
  sta ptr2+1
  lda #<intro_dial0_line0
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$C5
  sta ptr1+1
  lda #>intro_dial0_line1
  sta ptr2+1
  lda #<intro_dial0_line1
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$23
  sta ptr1
  lda #$05
  sta ptr1+1
  lda #>intro_dial0_line2
  sta ptr2+1
  lda #<intro_dial0_line2
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$00
  jsr PPU::fadePaletteWait
@intro_scene_1:
  lda #$04
  sta current_chr_bank0
  lda #$05
  sta current_chr_bank1
  lda #>STORY1
  sta ptr2+1
  lda #<STORY1
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  jsr PPU::waitNMI
  lda #04
  jsr PPU::fadePaletteWait

  lda #$22
  sta ptr1
  lda #$85
  sta ptr1+1
  lda #>intro_dial1_line0
  sta ptr2+1
  lda #<intro_dial1_line0
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$C5
  sta ptr1+1
  lda #>intro_dial1_line1
  sta ptr2+1
  lda #<intro_dial1_line1
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$23
  sta ptr1
  lda #$05
  sta ptr1+1
  lda #>intro_dial1_line2
  sta ptr2+1
  lda #<intro_dial1_line2
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$00
  jsr PPU::fadePaletteWait
@intro_scene_2:
  lda #$06
  sta current_chr_bank0
  lda #$07
  sta current_chr_bank1

  lda #>STORY2
  sta ptr2+1
  lda #<STORY2
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  jsr PPU::waitNMI
  lda #04
  jsr PPU::fadePaletteWait

  lda #$22
  sta ptr1
  lda #$85
  sta ptr1+1
  lda #>intro_dial2_line0
  sta ptr2+1
  lda #<intro_dial2_line0
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$C5
  sta ptr1+1
  lda #>intro_dial2_line1
  sta ptr2+1
  lda #<intro_dial2_line1
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$23
  sta ptr1
  lda #$05
  sta ptr1+1
  lda #>intro_dial2_line2
  sta ptr2+1
  lda #<intro_dial2_line2
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$00
  jsr PPU::fadePaletteWait
@intro_scene_3:
  lda #$08
  sta current_chr_bank0
  lda #$09
  sta current_chr_bank1

  lda #>STORY3
  sta ptr2+1
  lda #<STORY3
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  jsr PPU::waitNMI
  lda #04
  jsr PPU::fadePaletteWait

  lda #$22
  sta ptr1
  lda #$83
  sta ptr1+1
  lda #>intro_dial3_line0
  sta ptr2+1
  lda #<intro_dial3_line0
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$C3
  sta ptr1+1
  lda #>intro_dial3_line1
  sta ptr2+1
  lda #<intro_dial3_line1
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$23
  sta ptr1
  lda #$03
  sta ptr1+1
  lda #>intro_dial3_line2
  sta ptr2+1
  lda #<intro_dial3_line2
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$00
  jsr PPU::fadePaletteWait
@intro_scene_4:
  jsr PPU::ppu_off_all
@clean_nametable:
  lda #$20
  sta PPU_ADDR
  lda #$40
  sta PPU_ADDR
  lda #$00
  ldy #$BF
  ldx #$04
@clean_loop:
  sta PPU_DATA
  dey 
  bne @clean_loop
  ldy #$BF
  dex 
  bne @clean_loop

  jsr PPU::ppu_on_all
  jsr PPU::waitNMI
  lda #$04
  jsr PPU::fadePaletteWait

  lda #$22
  sta ptr1
  lda #$85
  sta ptr1+1
  lda #>intro_dial4_line0
  sta ptr2+1
  lda #<intro_dial4_line0
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$00
  jsr PPU::fadePaletteWait
@intro_scene_5:
  lda #$0A
  sta current_chr_bank0
  sta current_chr_bank1
  lda #>STORY4
  sta ptr2+1
  lda #<STORY4
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  jsr PPU::waitNMI

  lda #04
  jsr PPU::fadePaletteWait
  lda #$22
  sta ptr1
  lda #$8C
  sta ptr1+1
  lda #>intro_dial5_line0
  sta ptr2+1
  lda #<intro_dial5_line0
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$22
  sta ptr1
  lda #$CE
  sta ptr1+1
  lda #>intro_dial5_line1
  sta ptr2+1
  lda #<intro_dial5_line1
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$00
  jsr PPU::fadePaletteWait
@intro_scene_6:
  lda #$0B
  sta current_chr_bank0
  lda #$0C
  sta current_chr_bank1

  lda #>STORY5
  sta ptr2+1
  lda #<STORY5
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  jsr PPU::waitNMI
  lda #04
  jsr PPU::fadePaletteWait

  lda #$22
  sta ptr1
  lda #$85
  sta ptr1+1
  lda #>intro_dial6_line0
  sta ptr2+1
  lda #<intro_dial6_line0
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$C5
  sta ptr1+1
  lda #>intro_dial6_line1
  sta ptr2+1
  lda #<intro_dial6_line1
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$23
  sta ptr1
  lda #$05
  sta ptr1+1
  lda #>intro_dial6_line2
  sta ptr2+1
  lda #<intro_dial6_line2
  sta ptr2
  ldx #1
  lda #2
  jsr undertale_write

  lda #$00
  jsr PPU::fadePaletteWait
@intro_scene_B:
  lda #40
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  jsr PPU::waitNMI
  lda #$17
  sta current_chr_bank0
  lda #$18
  sta current_chr_bank1
  lda #>STORYA
  sta ptr2+1
  lda #<STORYA
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  lda #1
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #04
  jsr PPU::fadePaletteWait


  lda #00
  jsr PPU::fadePaletteWait
@intro_scene_7:
  lda #40
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #$0D
  sta current_chr_bank0
  lda #$0E
  sta current_chr_bank1
  lda #>STORY6
  sta ptr2+1
  lda #<STORY6
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  lda #1
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #04
  jsr PPU::fadePaletteWait


  lda #00
  jsr PPU::fadePaletteWait
@intro_scene_8:
  lda #40
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  jsr PPU::waitNMI
  lda #$0F
  sta current_chr_bank0
  lda #$10
  sta current_chr_bank1
  lda #>STORY7
  sta ptr2+1
  lda #<STORY7
  sta ptr2
  ldx #$20
  ldy #$00
  jsr load_nametable
  lda #1
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #04
  jsr PPU::fadePaletteWait


  lda #00
  jsr PPU::fadePaletteWait
@intro_scene_9:
  lda #$00
  sta MAP_BG_EXT_BANK
  lda #%00000101
  sta MAP_NT_W_CONTROL
  lda #$01
  sta MAP_PPU_IRQ_DISABLE
  lda #(CHR_MODE_2 | %00010000)  ; enable window
  sta MAP_CHR_CONTROL
  lda #3
  sta MAP_WINDOW_X_START
  lda #28
  sta MAP_WINDOW_X_END
  lda #17
  sta MAP_WINDOW_Y_START
  lda #127
  sta MAP_WINDOW_Y_END
  lda #intro_9_y_bottom
  sta MAP_WINDOW_Y_SCROLL
  lda #40
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  lda #>STORY9
  sta ptr1+1
  lda #<STORY9
  sta ptr1
  ldx #$00
  ldy #$00
  jsr load_nametable_attr_FPGA
  lda #>STORY9_attr
  sta ptr1+1
  lda #<STORY9_attr
  sta ptr1 
  ldx #$04
  ldy #$00
  jsr load_nametable_attr_FPGA
  lda #1
  sta current_prg_bankA
  sta MAP_PRG_A_LO
  jsr PPU::ppu_on_all
  jsr PPU::waitNMI
  lda #04
  jsr PPU::fadePaletteWait

  lda #intro_9_y_bottom
@move_up_camera:
  pha 
  ldx #$03
  jsr system::delayNMI
  pla 
  sec  
  sbc #1
  sta MAP_WINDOW_Y_SCROLL
  bne @move_up_camera

  lda #00
  jsr PPU::fadePaletteWait
  lda #(CHR_MODE_2 | %00000000)       ; disble window
  sta MAP_CHR_CONTROL

  lda #$01
  sta MAP_PPU_IRQ_ENABLE
  jsr PPU::waitNMI
  lda #1
  sta MAP_PRG_A_LO
  sta current_prg_bankA
  rts 

