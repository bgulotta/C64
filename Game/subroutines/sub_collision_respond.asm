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
    rts
rcc_loop:
    // is this sprite on?
    lda spriteon, x
    beq rcc_next_sprite      
    jsr check_down_collision
    jsr check_up_collision
    jsr check_left_collision
    jsr check_right_collision
    jmp rcc_next_sprite

check_up_collision:
    lda spritecollisiondir, x
    and #up
    bne handle_up_collision
    jsr huc_no_collision
    rts
    handle_up_collision:
        lda spritecollisionup, x
        cmp #dead
        bcs huc_dead
        cmp #solid
        bcs huc_solid
        cmp #semi_solid
        bcs huc_semi_solid
        cmp #ladder
        bcs huc_ladder
        cmp #conveyer
        bcs huc_conveyer
        cmp #collapsing
        bcs huc_collapsing
        huc_dead:
        rts
        huc_solid:
        jsr huc_stop_jumping
        rts
        huc_semi_solid:
        rts
        huc_ladder:
        jsr huc_stop_jumping
        lda spritemovement, x
        ora #up
        sta spritemovement, x
        rts
        huc_conveyer:
        jsr huc_stop_jumping
        rts
        huc_collapsing:
        jsr huc_stop_jumping
        rts
        huc_stop_jumping:
            // turn off jumping
            lda spritejumpdist, x
            sta spritejumpdistcov, x
            lda spritemovement, x
            and #$0f  
            sta spritemovement, x
            rts
    huc_no_collision:     
    rts

check_down_collision:
    lda spritecollisiondir, x
    and #down
    bne handle_down_collision
    jsr hdc_no_collision
    rts
    handle_down_collision:
        lda spritecollisiondown, x
        cmp #dead
        bcs hdc_dead
        cmp #solid
        bcs hdc_solid
        cmp #semi_solid
        bcs hdc_semi_solid
        cmp #ladder
        bcs hdc_ladder
        cmp #conveyer
        bcs hdc_conveyer
        cmp #collapsing
        bcs hdc_collapsing
        hdc_dead:
        rts
        hdc_solid:
        jsr hdc_enable_jumping
        jsr hdc_turn_off_up_down_movement
        jsr hdc_move_sprite_top
        rts
        hdc_semi_solid:
        jsr hdc_enable_jumping
        jsr hdc_turn_off_up_down_movement
        jsr hdc_move_sprite_top
        rts
        hdc_ladder:
        lda spritemovement, x
        ora #down
        sta spritemovement, x
        rts
        hdc_conveyer:
        jsr hdc_enable_jumping
        jsr hdc_turn_off_up_down_movement
        jsr hdc_move_sprite_top
        rts
        hdc_collapsing:
        jsr hdc_enable_jumping
        jsr hdc_turn_off_up_down_movement
        jsr hdc_move_sprite_top
        rts
        hdc_enable_jumping:
            lda #$00
            sta spritejumpdistcov, x
            lda spriteinitialjs, x
            sta spritejumpspeed, x
            lda spritemovement, x
            ora #jump 
            sta spritemovement, x
            rts
        hdc_move_sprite_top:
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
        hdc_turn_off_up_down_movement:
            lda spritemovement, x
            and #$FC
            sta spritemovement, x
            rts
    hdc_no_collision:
        jsr hdc_turn_off_up_down_movement
        rts

check_left_collision:
    lda spritecollisiondir, x
    and #left
    bne handle_left_collision
    rts
    handle_left_collision:
        lda spritecollisionside, x
        cmp #dead
        bcs hlc_dead
        cmp #solid
        bcs hlc_solid
        cmp #semi_solid
        bcs hlc_semi_solid
        cmp #ladder
        bcs hlc_ladder
        cmp #conveyer
        bcs hlc_conveyer
        cmp #collapsing
        bcs hlc_collapsing
        hlc_dead:
        rts
        hlc_solid:
        jsr hlc_move_sprite_right
        rts
        hlc_semi_solid:
        rts
        hlc_ladder:
        rts
        hlc_conveyer:
        jsr hlc_move_sprite_right
        rts
        hlc_collapsing:
        jsr hlc_move_sprite_right
        rts
        hlc_move_sprite_right:
            // TODO: handle MSB
            clc
            lda spritex, x
            adc spritemovementspd, x
            sta spritex, x 
            rts

check_right_collision:
    lda spritecollisiondir, x
    and #right
    bne handle_right_collision
    rts
    handle_right_collision:
        lda spritecollisionside, x
        cmp #dead
        bcs hrc_dead
        cmp #solid
        bcs hrc_solid
        cmp #semi_solid
        bcs hrc_semi_solid
        cmp #ladder
        bcs hrc_ladder
        cmp #conveyer
        bcs hrc_conveyer
        cmp #collapsing
        bcs hrc_collapsing
        hrc_dead:
        rts
        hrc_solid:
        jsr hrc_move_sprite_left
        rts
        hrc_semi_solid:
        rts
        hrc_ladder:
        rts
        hrc_conveyer:
        jsr hrc_move_sprite_left
        rts
        hrc_collapsing:
        jsr hrc_move_sprite_left
        rts
        hrc_move_sprite_left:
            // TODO: handle MSB
            sec
            lda spritex, x
            sbc spritemovementspd, x
            sta spritex, x
            rts
