#importonce
#import "common.asm"

/*
    This subroutine loads the games title screen.
*/
init_title_screen:  

title_screen()

.macro title_screen() {
    .const tlen = 14
    .const xpos = scr_cols/2 - tlen/2
    .const ypos = scr_cols * 12
    ldx #0
print:
    lda title, x
    cmp #$ff
    beq exit
    sta scr_ram + xpos + ypos, x
    inx 
    jmp print
exit:
    rts
title: 
    .text "awesomest game"
    .byte $ff
} 
