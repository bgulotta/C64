#importonce
#import "../config/symbols.asm"

open_borders:
    
    lda #$00
    sta $3fff

ob_loop:
    lda #$f9
    cmp vic_rstr_reg
    bne ob_loop

    lda vic_ctrl_reg
    and #$f7
    sta vic_ctrl_reg

ob_loop2:
    lda #$ff
    cmp vic_rstr_reg
    bne ob_loop2

    lda vic_ctrl_reg
    ora #$08
    sta vic_ctrl_reg

    rts