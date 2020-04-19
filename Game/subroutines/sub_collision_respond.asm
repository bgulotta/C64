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
    sta num4
check_collision_up:
    lda #$01
    bit num4
    bne respond_collision_up
check_collision_down:
    lda #$02
    bit num4
    bne respond_collision_down
check_collision_left:
    lda #$04
    bit num4
    bne respond_collision_left
check_collision_right:
    lda #$08
    bit num4
    bne respond_collision_right
    jmp rcc_next_sprite  
/*
dcc_hit_deadly_platform:
    lda #$10
    jmp dcc_determine_direction
dcc_hit_solid_platform:
    lda #$08
    jmp dcc_determine_direction
dcc_hit_semi_solid_platform:
    lda #$04
    jmp dcc_determine_direction
dcc_hit_conveyers_platform:
    lda #$02
    jmp dcc_determine_direction
dcc_hit_collapsing_platform:
    lda #$01
    jmp dcc_determine_direction
*/
respond_collision_up:
    // TODO: add top collision logic
    lda spritecollisionup, x
    and #$10 // did we collide with a deadly platform type?  
    bne check_collision_down // TODO: handle deadly platform collision
    lda spritecollisionup, x
    and #$08 // did we collide with a solid platform type?
    beq check_collision_down
    jsr stop_jump
    jmp check_collision_down
respond_collision_left:
    // TODO: add left collision logic
    lda spritecollisionside, x
    and #$10 // did we collide with a deadly platform type?  
    bne check_collision_right // TODO: handle deadly platform collision
    lda spritecollisionside, x
    and #$08 // did we collide with a solid platform type?
    beq check_collision_right
    jsr stop_jump
    // TODO: handle MSB
    clc
    lda spritex, x
    adc spritemovementspd, x
    sta spritex, x
    jmp check_collision_right
respond_collision_right:
    lda spritecollisionside, x
    and #$10 // did we collide with a deadly platform type?  
    bne rcc_next_sprite // TODO: handle deadly platform collision
    lda spritecollisionside, x
    and #$08 // did we collide with a solid platform type?
    beq rcc_next_sprite
    jsr stop_jump
    // TODO: handle MSB
    sec
    lda spritex, x
    sbc spritemovementspd, x
    sta spritex, x
    jmp rcc_next_sprite
respond_collision_down:
    lda spritecollisiondown, x
    and #$10 // did we collide with a deadly platform type?
    bne check_collision_left // TODO: handle deadly platform collision
    jsr move_sprite_to_top_of_char
    jsr reset_jump
    jmp check_collision_left
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
    rts
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
    rts
stop_jump:
    // if we are in a jump then stop it
    lda spritemovement, x
    and #$10
    bne sj_exit
    lda spritejumpdist, x
    sta spritejumpdistcov, x
sj_exit:
    rts
rcc_exit:
    rts