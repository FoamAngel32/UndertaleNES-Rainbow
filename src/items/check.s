item_check_lookup_table:
    .word check_item_nothing
    .word check_item_mk_candy

check_item_nothing:
    jmp return_to_action_item  

check_item_mk_candy:
    jmp return_to_action_item  
    