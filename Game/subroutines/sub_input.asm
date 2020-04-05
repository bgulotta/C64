#import "../config/symbols.asm"
#import "../config/game_symbols.asm"
#importonce

setup_input:

rts
 
toggle_msb:
    lda spritemsb
    eor #$01
    sta spritemsb
msb_on:
    lda spritex
    cmp #$59
    bne input_exit
reset_x:
    lda #$00
    sta spritex
    sta spritemsb
    jmp input_exit
check_input:
    inc spritex
    beq toggle_msb
    lda spritemsb
    bne msb_on
input_exit:
    rts