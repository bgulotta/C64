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
