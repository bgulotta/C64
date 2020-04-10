#importonce
//#import "../config/symbols.asm"
//#import "../config/game_symbols.asm"
#import "sub_zero_page.asm"

/*
    This subroutine clears the C64 screen.
    1. Sets background color $d021 and border color $d020 to black
    2. Sets all screen ram locations $0400-$07f7 to a space character #$20
    3. Sets all color ram locations $d800 - $dbe7 to black
*/

init_screen:
    jsr screen_pointer_reset
    ldx #0 
    lda #0  
    sta vic_bg_color 
    sta vic_bdr_color
next_row:
    ldy #0
    lda #$20
next_column:
    sta (zero_page1), y
    iny
    cpy #screen_cols
    bne next_column
    inx
    cpx #screen_rows
    beq init_screen_done
    jsr screen_pointer_next_row
    jmp next_row
init_screen_done:
    rts
