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
    jsr check_boundary_collision
    jmp rcc_next_sprite

check_boundary_collision:

    cbc_left:
        lda spritecol1, x
        bne cbc_right 

        lda spritemovement, x
        and #$FB
        sta spritemovement, x

    cbc_right:
        lda spritecol2, x
        cmp #screen_cols
        bcc cbc_exit

        lda spritemovement, x
        and #$F7
        sta spritemovement, x

    cbc_exit:
    rts

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
            rts
        huc_conveyer:
            rts
        huc_collapsing:
            rts
        huc_stop_jumping:
            // turn off jumping
            lda spritejumpdist, x
            sta spritejumpdistcov, x
            lda spritemovement, x
            and #$0F  
            sta spritemovement, x
            rts
        huc_turn_off_left_right_movement:
            lda spritemovement, x
            and #$F3
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
            jsr hdc_turn_on_left_right_movement
            jsr hdc_turn_off_up_down_movement
            jsr hdc_move_sprite_top
            rts
        hdc_semi_solid:
            jsr hdc_enable_jumping
            jsr hdc_turn_on_left_right_movement
            jsr hdc_turn_off_up_down_movement
            jsr hdc_move_sprite_top
            rts
        hdc_ladder:
            lda spritecollisiondir, x
            cmp #down
            beq hdc_turn_on_up_down_movement
            // if we have no other collision types but sitting on top 
            // of a ladder then make sure that we enable left and right movement
            cmp #$03
            bcc hdc_turn_on_left_right_movement
            rts
        hdc_conveyer:
            jsr hdc_turn_off_up_down_movement
            jsr hdc_move_sprite_top
            rts
        hdc_collapsing:
            jsr hdc_turn_off_up_down_movement
            jsr hdc_move_sprite_top
            rts
        hdc_enable_jumping:
            cpx #$00
            bne hdc_enable_jumping_do
            lda #jump
            bit cia_port_a
            beq hdc_enable_jumping_done            
            hdc_enable_jumping_do:
                lda #$00
                sta spritejumpdistcov, x
                lda spriteinitialjs, x
                sta spritejumpspeed, x
                lda spritemovement, x
                ora #jump 
                sta spritemovement, x
            hdc_enable_jumping_done:
                rts
        hdc_stop_jumping:
            // turn off jumping
            lda spritejumpdist, x
            sta spritejumpdistcov, x
            lda spritemovement, x
            and #$0F  
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
        hdc_turn_on_left_right_movement:
            lda spritemovement, x
            ora #left
            ora #right
            sta spritemovement, x
            rts
        hdc_turn_on_up_down_movement:
            lda spritemovement, x
            ora #up
            ora #down
            sta spritemovement, x
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
    jsr hlc_no_collision
    rts
    handle_left_collision:
        lda spritecollisionleft, x
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
            jsr hlc_disable_move_left
            rts
        hlc_semi_solid:
            rts
        hlc_ladder:
            lda spritecollisionright, x
            cmp #ladder
            beq hlc_turn_on_up_down_movement
            beq hlc_stop_jumping
            rts
        hlc_conveyer:
            rts
        hlc_collapsing:
            rts
        hlc_move_sprite_right:
            clc
            lda spritex, x
            adc spritemovementspd, x
            sta spritex, x 
            beq hlc_toggle_msb
            rts
        hlc_toggle_msb:
            lda spritemsb, x
            eor #$01
            sta spritemsb, x
            rts    
        hlc_disable_move_left:
            lda spritemovement, x
            and #$FB
            sta spritemovement, x
            rts
        hlc_turn_on_up_down_movement:
            lda spritemovement, x
            ora #up
            ora #down
            sta spritemovement, x
            rts
        hlc_turn_off_up_down_movement:
            lda spritemovement, x
            and #$FC
            sta spritemovement, x
            rts
        hlc_stop_jumping:
            // turn off jumping
            lda spritejumpdist, x
            sta spritejumpdistcov, x
            lda spritemovement, x
            and #$0F  
            sta spritemovement, x
            rts
    hlc_no_collision:
        rts

check_right_collision:
    lda spritecollisiondir, x
    and #right
    bne handle_right_collision
    jsr hrc_no_collision
    rts
    handle_right_collision:
        lda spritecollisionright, x
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
            jsr hrc_disable_move_right
            rts
        hrc_semi_solid:
            rts
        hrc_ladder:
            lda spritecollisionleft, x
            cmp #ladder
            beq hrc_turn_on_up_down_movement
            beq hrc_stop_jumping
            rts
        hrc_conveyer:
            rts
        hrc_collapsing:
            rts
        hrc_move_sprite_left:
            sec
            lda spritex, x
            sbc spritemovementspd, x
            sta spritex, x
            bcc hrc_toggle_msb
            rts
        hrc_toggle_msb:
            lda spritemsb, x
            eor #$01
            sta spritemsb, x
            rts    
        hrc_disable_move_right:
            lda spritemovement, x
            and #$F7
            sta spritemovement, x
            rts
        hrc_turn_on_up_down_movement:
            lda spritemovement, x
            ora #up
            ora #down
            sta spritemovement, x
            rts
        hrc_turn_off_up_down_movement:
            lda spritemovement, x
            and #$FC
            sta spritemovement, x
            rts
        hrc_stop_jumping:
            // turn off jumping
            lda spritejumpdist, x
            sta spritejumpdistcov, x
            lda spritemovement, x
            and #$0F  
            sta spritemovement, x
            rts
    hrc_no_collision:
        rts


