frisk_down0_data:


	.byte   2,  0,$01,0
	.byte  10,  0,$03,0
	.byte   2, 16,$05,0
	.byte  10, 16,$07,0

	.byte - 6,  8,$09,0
	.byte  18,  9,$0b,0
	.byte $80


frisk_down1_data:


	.byte   2,- 1,$01,0
	.byte  10,- 1,$03,0
	.byte   2, 15,$0d,0
	.byte  10, 15,$0f,0

	.byte - 6,  7,$09,0
	.byte  18,  8,$0b,0
	.byte $80


frisk_down2_data:


	.byte   2,- 1,$01,0
	.byte  10,- 1,$03,0
	.byte   2, 15,$11,0
	.byte  10, 15,$13,0

	.byte - 6,  7,$09,0
	.byte  18,  8,$0b,0
	.byte $80


frisk_right0_data:


	.byte   2,  0,$15,0
	.byte  10,  0,$17,0
	.byte   2, 16,$1b,0
	.byte  10, 16,$1d,0

	.byte  18,  0,$19,0
	.byte  0,  0,$23,0
	.byte $80


frisk_right1_data:


	.byte   2,  1,$15,0
	.byte  10,  1,$17,0
	.byte   2, 17,$1f,0
	.byte  10, 17,$21,0

	.byte  18,  1,$19,0
	.byte  0,  0,$23,0
	.byte $80


frisk_up0_data:


	.byte   2,  0,$25,0
	.byte  10,  0,$27,0
	.byte   2, 16,$29,0
	.byte  10, 16,$2b,0

	.byte - 6,  8,$2d,0
	.byte  18,  8,$2f,0
	.byte $80


frisk_up1_data:


	.byte   2,- 1,$25,0
	.byte  10,- 1,$27,0
	.byte   2, 15,$31,0
	.byte  10, 15,$33,0

	.byte - 6,  7,$2d,0
	.byte  18,  7,$2f,0
	.byte $80


frisk_up2_data:


	.byte   2,- 1,$25,0
	.byte  10,- 1,$27,0
	.byte   2, 15,$35,0
	.byte  10, 15,$37,0

	.byte - 6,  7,$2d,0
	.byte  18,  7,$2f,0
	.byte $80


frisk_left0_data:


	.byte  10,  0,$15,0|OAM_FLIP_H
	.byte   2,  0,$17,0|OAM_FLIP_H
	.byte  10, 16,$1b,0|OAM_FLIP_H
	.byte   2, 16,$1d,0|OAM_FLIP_H

	.byte - 6,  0,$19,0|OAM_FLIP_H
	.byte  0,  0,$23,0
	.byte $80


frisk_left1_data:


	.byte  10,  1,$15,0|OAM_FLIP_H
	.byte   2,  1,$17,0|OAM_FLIP_H
	.byte  10, 17,$1f,0|OAM_FLIP_H
	.byte   2, 17,$21,0|OAM_FLIP_H

	.byte - 6,  1,$19,0|OAM_FLIP_H
	.byte  0,  0,$23,0
	.byte $80


frisk_down_pointers:
	.word frisk_down0_data
	.word frisk_down1_data
	.word frisk_down0_data
	.word frisk_down2_data
frisk_right_pointers:
	.word frisk_right0_data
	.word frisk_right1_data
	.word frisk_right0_data
	.word frisk_right1_data
frisk_up_pointers:
	.word frisk_up0_data
	.word frisk_up1_data
	.word frisk_up0_data
	.word frisk_up2_data
frisk_left_pointers:
	.word frisk_left0_data
	.word frisk_left1_data
	.word frisk_left0_data
	.word frisk_left1_data

