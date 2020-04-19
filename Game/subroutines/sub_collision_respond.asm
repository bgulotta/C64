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
    ldx #$ff
rcc_next_sprite:
    inx
    cpx #$08
    bne rcc_loop
    jmp rcc_exit
rcc_loop:
    // is this sprite on?
    lda spriteon, x
    beq rcc_next_sprite
    // store which directions we have collided with for comparision below
    lda spritecollisiondir, x
    sta num1
check_collision_up:
    lda #$01
    bit num1
    bne respond_collision_up
check_collision_down:
    lda #$02
    bit num1
    bne respond_collision_down
check_collision_left:
    lda #$04
    bit num1
    bne respond_collision_left
check_collision_right:
    lda #$08
    bit num1
    bne respond_collision_right
    jmp rcc_next_sprite  
respond_collision_up:
    // TODO: add top collision logic
    jmp check_collision_down
respond_collision_left:
    // TODO: add left collision logic
    jmp check_collision_right
respond_collision_right:
    // TODO: add right collision logic
    jmp rcc_next_sprite
respond_collision_down:
    lda spritecollisiondown, x
    and #$10 // did we collide with a platform type?
    bne check_collision_left
move_sprite_to_top_of_char:
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
reset_jump:
    // reset jump meta data
    lda #$0
    sta spritejumpdistcov, x
    lda spriteinitialjs, x
    sta spritejumpspeed, x 
    // turn on jumping
    lda spritemovement, x
    ora #$10
    sta spritemovement, x
    jmp check_collision_left    
rcc_exit:
    rts