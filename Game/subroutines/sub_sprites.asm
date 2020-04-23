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
    rol vic_spr_xpos_msb

    // todo: update sprite frame pointer for animation

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
update_sprite_hitbox_done:
rts
update_sprite_hitbox:
ldx #$ff
ush_loop:
inx
cpx #$07
beq update_sprite_hitbox_done

// is this sprite on?
lda spriteon, x
beq ush_loop

// set x1
lda spritex, x
clc
adc spriteoffsetx1, x
sta spritex1, x
lda spritemsb, x
adc #$00
sta spritemsb1,x

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
bcc ush_store_col1
lda #$00
ush_store_col1:
    sta spritecol1, x

// set x2
lda spritex1, x
clc
adc spriteoffsetx2, x
sta spritex2, x
lda spritemsb1, x
adc #$00
sta spritemsb2,x

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
bcc ush_store_col2
lda #$00
ush_store_col2:
    sta spritecol2, x

// set y1 & y2
lda spritey, x
clc
adc spriteoffsety1, x
sta spritey1, x
adc spriteoffsety2, x
sta spritey2, x

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
bcc ush_store_row1
lda #$00
ush_store_row1:
    sta spriterow1, x

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
bcc ush_store_row2
lda #$00
ush_store_row2:
    sta spriterow2, x

jmp ush_loop
rts
