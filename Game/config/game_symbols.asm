#importonce
#import "../resources/strings.asm"

.const irq_beg_sav      = $03a0
.const irq_end_sav      = $03a1
.const sprite_data      = $0880
.const sprite_meta      = $2900
.const subroutines      = $2200        
.const zero_page1       = $fc
.const zero_page2       = $fe
.const screen_cols      = 40
.const screen_rows      = 25
.const screen_xoffset   = $18
.const screen_yoffset   = $32
.const sprite_ymin      = $32
.const sprite_ymax      = $E5
.const sprite_xmin      = $32
.const sprite_xmax      = $E5

.const title_offset     = screen_cols/2 - (title_length/2) + screen_cols * 16
.const copyright_offset = screen_cols/2 - (copyright_length/2) + screen_cols * 22

*=sprite_meta "Sprite Meta"
spriteon:           .byte   $01, $00, $00, $00, $00, $00, $00, $00
spritepointer:      .byte   $22, $23, $00, $00, $00, $00, $00, $00

// sprite frame offsets
spriteoffsetx1:     .byte   $04, $02, $00, $00, $00, $00, $00, $00 
spriteoffsetx2:     .byte   $0e, $0e, $00, $00, $00, $00, $00, $00
spriteoffsety1:     .byte   $04, $05, $00, $00, $00, $00, $00, $00
spriteoffsety2:     .byte   $0f, $0f, $00, $00, $00, $00, $00, $00
                      
// sprite color data
spritecolormenable: .byte   $01, $01, $00, $00, $00, $00, $00, $00
spritecolor:        .byte   $08, $0e, $00, $00, $00, $00, $00, $00
spritecolormulti1:  .byte   $0c
spritecolormulti2:  .byte   $0a

// sprite locations and other attributes
spritex:            .byte   $0a, $80, $00, $00, $00, $00, $00, $00
spritey:            .byte   $78, $48, $00, $00, $00, $00, $00, $00
spritemsb:          .byte   $01, $00, $00, $00, $00, $00, $00, $00

// sprite hit boxes
spritex1:	        .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex2:	        .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritemsb1:	        .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritemsb2:	        .byte   $00, $00, $00, $00, $00, $00, $00, $00

spritey1:	        .byte   $00, $00, $00, $00, $00, $00, $00, $00						
spritey2:	        .byte   $00, $00, $00, $00, $00, $00, $00, $00

// character hit boxes
spritecol1:         .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritecol2:         .byte   $00, $00, $00, $00, $00, $00, $00, $00
spriterow1:         .byte   $00, $00, $00, $00, $00, $00, $00, $00
spriterow2:         .byte   $00, $00, $00, $00, $00, $00, $00, $00

// sprite movement attributes
spritemovement:     .byte   $FC, $00, $00, $00, $00, $00, $00, $00
spritemovementspd:  .byte   $02, $00, $00, $00, $00, $00, $00, $00
spritejumpdistcov:  .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritejumpdist:     .byte   $1e, $00, $00, $00, $00, $00, $00, $00
spritejumpspeed:    .byte   $00, $00, $00, $00, $00, $00, $00, $00
spriteinitialjs:    .byte   $06, $00, $00, $00, $00, $00, $00, $00
spritefallspeed:     .byte  $04, $01, $00, $00, $00, $00, $00, $00

// sprite collision attributes
spritecollisionspr:  .byte  $00, $00, $00, $00, $00, $00, $00, $00
spritecollisiondir:  .byte  $00, $00, $00, $00, $00, $00, $00, $00 // bit 0 above, bit 1 below, bit 2 left, bit 3 right collision
spritecollisionup:   .byte  $00, $00, $00, $00, $00, $00, $00, $00
spritecollisiondown: .byte  $00, $00, $00, $00, $00, $00, $00, $00
spritecollisionside: .byte  $00, $00, $00, $00, $00, $00, $00, $00

// looping / math 
arithmetic_value:   .byte   $00, $00
num1:               .byte   $00
num2:               .byte   $00
num3:               .byte   $00
num4:               .byte   $00