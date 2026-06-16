palette_story:
  .byte $0F, $07, $17, $27
  .byte $0F, $00, $10, $30
  .byte $0F, $30, $30, $30
  .byte $0F, $30, $30, $30
STORY0:
  .incbin "gfx/intro/intro1.nam"
STORY1:
  .incbin "gfx/intro/intro2.nam"
STORY2:
  .incbin "gfx/intro/intro3.nam"
STORY3:
  .incbin "gfx/intro/intro4.nam"
STORY4:
  .incbin "gfx/intro/intro5.nam"
STORY5:
  .incbin "gfx/intro/intro6.nam"
.segment "BANK36"
STORY6:
  .incbin "gfx/intro/intro7.nam"
STORY7:
  .incbin "gfx/intro/intro8.nam"
STORY9:
  .incbin "gfx/intro/introA.nam"
STORY9_attr:
  .incbin "gfx/intro/introA.ext"
STORYA:
  .incbin "gfx/intro/introB.nam"
title:
  .incbin "gfx/title.nam"