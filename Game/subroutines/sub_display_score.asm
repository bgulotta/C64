#importonce
#import "../config/game_symbols.asm"

display_scores:
    jsr display_score_player1
    jsr display_score_player2
    rts

display_score_player1:
        ldx #$00
        ldy #10
    dsp1_loop:
        lda scores, x
        pha
        and #$0f
        jsr dsp1_display_digit
        pla
        lsr
        lsr
        lsr
        lsr
        jsr dsp1_display_digit
        inx
        cpx #$03
        bcc dsp1_loop
        rts
    dsp1_display_digit:   
        clc 
        adc #48
        sta vic_scr_ram, y
        dey 
        rts

display_score_player2:
        ldx #$03
        ldy #34
    dsp2_loop:
        lda scores, x
        pha
        and #$0f
        jsr dsp2_display_digit
        pla
        lsr
        lsr
        lsr
        lsr
        jsr dsp2_display_digit
        inx
        cpx #$06
        bcc dsp2_loop
        rts
    dsp2_display_digit:   
        clc 
        adc #48
        sta vic_scr_ram, y
        dey 
        rts