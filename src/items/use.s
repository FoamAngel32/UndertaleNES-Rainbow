item_use_lookup_table:
    .word use_item_nothing
    .word use_item_mk_candy

use_item_nothing:
    rts 

use_item_mk_candy:
    ldx #$5
    jsr add_health
    rts 
