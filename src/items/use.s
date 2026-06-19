item_use_lookup_table:
    .word use_item_nothing
    .word use_item_mk_candy

use_item_nothing:
    jmp return_to_action_item 

use_item_mk_candy:
    ldx #$5
    jsr add_health

    lda #$22
    sta ptr1
    lda #$85
    sta ptr1+1
    lda #>dial_hp_maxout
    sta ptr2+1
    lda #<dial_hp_maxout
    sta ptr2
    ldx #1
    lda #2
    jsr undertale_write
    jmp return_to_action_item 

dial_hp_maxout:
    .byte "HP MAXOUT!", $FF
