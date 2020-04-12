#importonce
#import "../resources/sprite/data.asm"
#import "../resources/strings.asm"

.const irq_beg_sav      = $03a0
.const irq_end_sav      = $03a1
.const sprite_data      = $1600
.const sprite_tables    = $2800
.const zero_page1       = $fc
.const zero_page2       = $fe
.const screen_cols      = 40
.const screen_rows      = 25
.const screen_xoffset   = $18
.const screen_yoffset   = $32

.const title_offset     = screen_cols/2 - (title_length/2) + screen_cols * 12
.const copyright_offset = screen_cols/2 - (copyright_length/2) + screen_cols * 22

.const sprite_ymin         = $32
.const sprite_ymax         = $E5
.const sprite_xmin         = $32
.const sprite_xmax         = $E5

spriteon:           .byte $01, $01, $00, $00, $00, $00, $00, $00
spritepointer:      .byte sprite_bear/$40, sprite_bird/$40, $00, $00, $00, $00, $00, $00
                          
// sprite color data
spritecolormenable: .byte   $01, $01, $00, $00, $00, $00, $00, $00
spritecolor:        .byte   $00, $0b, $00, $00, $00, $00, $00, $00
spritecolormulti1:  .byte   $08
spritecolormulti2:  .byte   $0a

*=$2800 "sprite locations"
// sprite locations and other attributes
spritex:            .byte   $28, $0F, $00, $00, $00, $00, $00, $00
spritey:            .byte   $78, $48, $00, $00, $00, $00, $00, $00
spritemsb:          .byte   $00, $01, $00, $00, $00, $00, $00, $00
spritespeed:        .byte   $01, $01, $00, $00, $00, $00, $00, $00

// sprite frame offsets
spriteoffset:     	.byte   $05, $03, $00, $00, $00, $00, $00, $00 
                    .byte   $0e, $15, $00, $00, $00, $00, $00, $00
                    .byte   $05, $05, $00, $00, $00, $00, $00, $00
                    .byte   $0f, $0f, $00, $00, $00, $00, $00, $00

// sprite hit boxes
spritex1:	       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex2:	       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritemsb1:	       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritemsb2:	       .byte   $00, $00, $00, $00, $00, $00, $00, $00

spritey1:	       .byte   $00, $00, $00, $00, $00, $00, $00, $00						
spritey2:	       .byte   $00, $00, $00, $00, $00, $00, $00, $00

// character hit boxes
spritex1col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex2col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex1row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex2row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey1row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey1col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey2row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey2col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00

arithmetic_value:  .byte   $00, $00
