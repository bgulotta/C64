#importonce
#import "common.asm"
/*
    This subroutine clears the C64 screen.
    1. Sets background color $d021 and border color $d020 to black
    2. Sets all screen ram locations $0400-$07f7 to a space character #$20
    3. Sets all color ram locations $d800 - $dbe7 to black
*/

init_screen:  

    lda #black  
    ldx #0    // index  
 
    sta bg_color 
    sta bdr_color

    clear_screen()

.macro clear_screen() {
loop: 
    lda #space 
    sta scr_ram + 0 * $100,x 
    lda #space
    sta scr_ram + 1 * $100,x 
    lda #space
    sta scr_ram + 2 * $100,x 
    lda #space
    sta scr_ram + 3 * $100,x
    inx
    bne loop
    rts
}   