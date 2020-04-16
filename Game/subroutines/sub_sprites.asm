#importonce
#import "sub_zero_page.asm"

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
    
move_sprites:

    ldx #$07
    ldy #$0e

move_sprites_loop:

    // set sprite xpos
    lda spritex, x
    sta vic_spr_xpos, y

    // set sprite ypos
    lda spritey, x
    sta vic_spr_ypos, y

    // set sprite xpos msb
    lda spritemsb, x
    cmp #$01
    rol vic_spr_xpos_msb

    // todo: update sprite frame pointer

    dey
    dey
    dex

    bpl move_sprites_loop

    rts

check_sprite_airborne:
    ldx #$0
csa_next_sprite_loop:
    // are we in a jump? 
    lda spritemovement, x
    and #$10
    cmp #$00
    beq csa_jump
    jmp csa_fall
csa_next_sprite:
    inx
    cpx #$08
    beq csa_exit
    jmp csa_next_sprite_loop
csa_jump:    
    // have we jumped the configured distance
    lda spritejumpdistcov, x
    cmp spritejumpdist, x
    bcs csa_fall
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
    jmp csa_next_sprite
csa_fall:
    // are we on solid ground?
    lda spritecollisiondir, x
    and #$02
    bne csa_next_sprite
    // continue falling
    lda spritey, x
    clc
    adc spritefallspeed, x
    sta spritey, x
    jmp csa_next_sprite    
csa_exit:
    rts

