#import "../config/symbols.asm"
#import "../config/game_symbols.asm"
#importonce

setup_sprites:

    ldx #$07

setup_sprites_loop:

    // setup sprite pointers
    lda spritepointer, x
    sta vic_scr_ram + $3f8, x

    // set sprite multi color mode
    lda spritecolormenable, x
    cmp #$01
    rol vic_spr_multi_mode

    // set sprite color
    lda spritecolor, x
    sta vic_spr_color, x

    // set sprite multi color 1
    lda spritecolorm1, x
    sta vic_spr_colorm1, x
    
    // set sprite multi color 2
    lda spritecolorm2, x
    sta vic_spr_colorm2, x

    // turn on sprites
    lda spriteon, x
    cmp #$01
    rol vic_spr_enble_reg

    dex
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

    dey
    dey
    dex

    bpl move_sprites_loop

    rts
