#importonce
#import "sub_zero_page.asm"
#import "sub_arithmetic.asm"

/*
    This routine sets up sprites in vic register based 
    on current configuration data.
*/
setup_sprites:

    jsr zp_sprite_pointer
    ldy #$07

setup_sprites_loop:

    // setup sprite pointers
    lda spritepointer, y
    sta (zero_page1), y

    // set sprite multi color mode
    lda spritecolormenable, y
    cmp #$01
    rol vic_spr_multi_mode

    // set sprite color
    lda spritecolor, y
    sta vic_spr_color, y

    // set sprite multi color 1
    lda spritecolormulti1
    sta vic_spr_colorm1
    
    // set sprite multi color 2
    lda spritecolormulti2
    sta vic_spr_colorm2
    
       // set sprite vert double
    lda spritevertexpand, y
    cmp #$01
    rol vic_spr_vert_exp

    // set sprite horz double
    lda spritehorzexpand, y
    cmp #$01
    rol vic_spr_horz_exp

    // turn on sprites
    lda spriteon, y
    cmp #$01
    rol vic_spr_enble_reg

    dey
    bpl setup_sprites_loop
    rts

/*
    This routine does the actual updating of the vic registers to move the sprites
    based on their x,y positions
*/
move_sprites:
        
    ldx #$07
    ldy #$0e
    jsr zp_sprite_pointer

move_sprites_loop:

     // is this sprite on?
    lda spriteon, x
    beq ms_next_sprite

    // set sprite ypos
    lda spritey, x
    sta vic_spr_ypos, y

    // set sprite xpos
    lda spritex, x
    sta vic_spr_xpos, y

    // set sprite xpos msb
    lda spritemsb, x
    cmp #$01
    beq turn_on_bit
    turn_off_bit:
        lda bits, x
        eor #$ff 
        sta num1
        lda vic_spr_xpos_msb         
        and num1
        sta vic_spr_xpos_msb
        jmp ms_pointer
    turn_on_bit:
        lda vic_spr_xpos_msb 
        ora bits, x
        sta vic_spr_xpos_msb
    ms_pointer:
    // update sprite pointer with any changes
    tya
    pha
    txa
    tay
    lda spritepointer, x
    sta (zero_page1), y
    pla 
    tay

    ms_next_sprite:

    dey
    dey
    dex

    bpl move_sprites_loop

    rts

/*
    This routine checks to see if a sprite is in a jump/fall sequence
    and moves the sprite accordingly
*/
check_sprite_airborne:
    ldx #$ff
csa_next_sprite:
    inx
    cpx #$08
    beq csa_exit
    jmp csa_next_sprite_loop
csa_next_sprite_loop:
     // is this sprite on?
    lda spriteon, x
    beq csa_next_sprite
    // are we in a jump? 
    lda spritemovement, x
    and #jump
    beq csa_jump
    jmp csa_check_fall
csa_jump:    
   // have we jumped the configured distance
    lda spritejumpdistcov, x
    cmp spritejumpdist, x
    bcs csa_check_fall
    // continue jumping
    lda spritey, x
    sec
    sbc spritejumpspeed, x 
    sta spritey, x
    // add to the distance covered
    lda spritejumpdistcov, x
    clc
    adc spritejumpspeed, x 
    sta spritejumpdistcov, x
    
    lda spritejumpspeed, x
    cmp #$01
    beq csa_next_sprite
    dec spritejumpspeed, x
    jmp csa_next_sprite
csa_check_fall:
    // do we have platform under us?
    lda spritecollisiondir, x
    and #down
    bne csa_next_sprite
csa_fall:
    csa_enable_jumping:
        cpx #$02
        bcs csa_enable_jumping_do
        cpx #$00
        beq csa_ej_player1
        jmp csa_ej_player2
        csa_ej_player1:
            lda #jump
            bit cia_port_a
            jmp csa_ej_check
        csa_ej_player2:
            lda #jump
            bit cia_port_b
        csa_ej_check:
        beq csa_continue_fall
        csa_enable_jumping_do:
        lda #$00
        sta spritejumpdistcov, x
        lda spriteinitialjs, x
        sta spritejumpspeed, x
        lda spritemovement, x
        ora #jump 
        sta spritemovement, x

    csa_continue_fall:           
    // continue falling
    lda spritey, x
    clc
    adc spritefallspeed, x
    sta spritey, x
    jmp csa_next_sprite
csa_exit:
    rts

/*
    This routine takes the current sprite position and
    calculates the exact sprite coordinates based on 
    the sprite offset data. It then calculates the character
    row and columns touched by the sprite
*/
update_sprite_hitbox:
    ldx #$ff
    ush_loop:
        inx
        cpx #$07
        bne ush_check_sprite_on
        rts
    ush_check_sprite_on:
        // is this sprite on?
        lda spriteon, x
        beq ush_loop
    ush_x1:
        // set x1
        lda spritex, x
        clc
        adc spriteoffsetx1, x
        sta spritex1, x
        lda spritemsb, x
        adc #$00
        sta spritemsb1,x
    ush_col1:
        // set col1
        sec
        lda spritex1, x     
        sbc #screen_xoffset   
        sta arithmetic_value + 1
        lda spritemsb1, x 
        sbc #$00
        sta arithmetic_value
        jsr divide_by_8
        lda arithmetic_value + 1
        cmp #screen_cols_oob
        bcc ush_col1_set
        lda #$00
    ush_col1_set:
        sta spritecol1, x
    ush_x2:
        // set x2
        lda spritex1, x
        clc
        adc spriteoffsetx2, x
        sta spritex2, x
        lda spritemsb1, x
        adc #$00
        sta spritemsb2,x
    ush_col2:
        // sprite col2
        sec
        lda spritex2, x      
        sbc #screen_xoffset  
        sta arithmetic_value + 1
        lda spritemsb2, x
        sbc #$00
        sta arithmetic_value
        jsr divide_by_8
        lda arithmetic_value + 1
        cmp #screen_cols_oob
        bcc ush_col2_set
        lda #$00
    ush_col2_set:
        sta spritecol2, x
    ush_y1:
        // set y1 & y2
        lda spritey, x
        clc
        adc spriteoffsety1, x
        sta spritey1, x
    ush_y2:
        adc spriteoffsety2, x
        sta spritey2, x
    ush_row1:
        // sprite row1
        sec
        lda spritey1, x     
        sbc #screen_yoffset   
        sta arithmetic_value + 1
        lda #$00
        sta arithmetic_value
        jsr divide_by_8
        lda arithmetic_value + 1
        cmp #screen_rows_oob
        bcc ush_row1_set
        lda #$00
    ush_row1_set:
        sta spriterow1, x
    ush_row2:
        // sprite row2
        sec
        lda spritey2, x      
        sbc #screen_yoffset   
        sta arithmetic_value + 1
        lda #0
        sta arithmetic_value
        jsr divide_by_8
        lda arithmetic_value + 1
        cmp #screen_rows_oob
        bcc ush_row2_set
        lda #$00
    ush_row2_set:
        sta spriterow2, x
        jmp ush_loop