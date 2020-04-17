#importonce
#import "sub_zero_page.asm"
#import "sub_arithmetic.asm"

/* 
    This routine looks at sprite collision meta data and performs any necessary
    actions
*/
respond_sprite_collision:

rts

/* 
    This routine looks at char collision meta data and performs any necessary
    actions
*/
respond_char_collision:
    ldx #$0
rcc_loop:
    // is this sprite on?
    lda spriteon, x
    beq rcc_next_sprite
    // is there a character under us?
    lda spritecollisiondir, x
    and #$02
    bne rcc_char_below
rcc_next_sprite:
    inx
    cpx #$08
    bne rcc_loop
    jmp rcc_exit
rcc_char_below:
    lda spritechartype, x
    and #$7C
    bne rcc_move_sprite_char_top
    jmp rcc_next_sprite    
rcc_move_sprite_char_top:
    // this method makes sure that the sprite
    // is always on the top of the character
    lda spritey, x
    lda spriterow2, x
    sta num1
    lda #$08
    sta num2
    jsr multiply
    clc
    adc #screen_yoffset
    sec
    sbc spriteoffsety2, x
    sbc spriteoffsety1, x
    sta spritey, x
rcc_jump_on:
    // reset jump meta data
    lda #$0
    sta spritejumpdistcov, x
    lda spriteinitialjs, x
    sta spritejumpspeed, x 
    // turn on jumping
    lda spritemovement, x
    ora #$10
    sta spritemovement, x
    jmp rcc_next_sprite
rcc_exit:
    rts