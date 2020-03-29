#importonce
#import "common.asm"

/*
    This subroutine loads the games title screen.
*/
init_title_screen:  

title_screen()

.macro title_screen() {
    ldx #0
loop_t:
    lda title, x
    cmp #$ff
    beq print_copyright
    sta scr_ram + title_offset, x
    inx 
    jmp loop_t 
print_copyright:
    ldx #0
loop_c:    
    lda copyright, x
    cmp #$ff
    beq exit
    sta scr_ram + copyright_offset, x
    inx 
    jmp loop_c
exit:
    rts

title: 
    .text "awesomest game"
    .byte $ff
copyright:
    .text "2020 gulotta games"
    .byte $ff

} 
