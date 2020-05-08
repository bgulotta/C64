#importonce
#import "../resources/strings.asm"

.const irq_beg_sav      = $03a0
.const irq_end_sav      = $03a1
.const sprite_data      = $0880
.const sprite_meta      = $2200
.const subroutines      = $3000        
.const zero_page1       = $fc
.const zero_page2       = $fe
.const screen_cols      = 40
.const screen_cols_oob  = 41
.const screen_rows      = 25
.const screen_rows_oob  = 26
.const screen_xoffset   = $18
.const screen_yoffset   = $32
.const sprite_framecnt  = $0a

.const title_offset     = screen_cols/2 - (title_length/2) + screen_cols * 16
.const copyright_offset = screen_cols/2 - (copyright_length/2) + screen_cols * 22
.enum { char_dead=$f0, char_solid=$c0, char_semi_solid=$9a, char_ladder=$95, char_conveyer=$90, char_collapsing=$80 }
.enum { dead=$20, solid=$10, semi_solid=$08, ladder=$04, conveyer=$02, collapsing=$01 }
.enum { up=$01, down=$02, left=$04, right=$08, jump=$10 }

*=sprite_meta "Sprite Meta"
spriteon:           .byte   $01, $01, $01, $00, $00, $00, $00, $00
spritepointer:      .byte   $22, $22, $26, $29, $30, $00, $00, $00
spritehorzexpand:   .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritevertexpand:   .byte   $00, $00, $00, $00, $00, $00, $00, $00

// sprite frame meta data
framecounter:       .byte   $0a
spriteuframebegin:  .byte   $22, $22, $00, $00, $00, $00, $00, $00
spriteuframeend:    .byte   $23, $23, $00, $00, $00, $00, $00, $00
spritedframebegin:  .byte   $24, $24, $00, $00, $00, $00, $00, $00
spritedframeend:    .byte   $25, $25, $00, $00, $00, $00, $00, $00
spritelframebegin:  .byte   $22, $22, $26, $00, $00, $00, $00, $00
spritelframeend:    .byte   $23, $23, $28, $00, $00, $00, $00, $00
spriterframebegin:  .byte   $24, $24, $00, $00, $00, $00, $00, $00
spriterframeend:    .byte   $25, $25, $00, $00, $00, $00, $00, $00

// sprite frame offsets
spriteoffsetx1:     .byte   $04, $04, $06, $00, $00, $00, $00, $00 
spriteoffsetx2:     .byte   $0c, $0c, $0a, $00, $00, $00, $00, $00
spriteoffsety1:     .byte   $02, $02, $08, $00, $00, $00, $00, $00
spriteoffsety2:     .byte   $10, $10, $05, $00, $00, $00, $00, $00

// sprite color data
spritecolormenable: .byte   $01, $01, $01, $00, $00, $00, $00, $00
spritecolor:        .byte   $07, $07, $07, $00, $00, $00, $00, $00
spritecolormulti1:  .byte   $01
spritecolormulti2:  .byte   $00

// sprite locations and other attributes
spritex:            .byte   $40, $00, $60, $00, $00, $00, $00, $00
spritey:            .byte   $38, $48, $50, $00, $00, $00, $00, $00
spritemsb:          .byte   $00, $01, $00, $00, $00, $00, $00, $00

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
spritedirection:    .byte   $00, $00, $04, $00, $00, $00, $00, $00
spritemovement:     .byte   $FF, $FF, $00, $00, $00, $00, $00, $00
spritemovementspd:  .byte   $01, $01, $00, $00, $00, $00, $00, $00
spritejumpdistcov:  .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritejumpdist:     .byte   $1c, $1c, $00, $00, $00, $00, $00, $00
spritejumpspeed:    .byte   $00, $00, $00, $00, $00, $00, $00, $00
spriteinitialjs:    .byte   $04, $04, $00, $00, $00, $00, $00, $00
spritefallspeed:    .byte   $01, $01, $00, $00, $00, $00, $00, $00

// sprite collision attributes
spritecollisionspr:   .byte  $00, $00, $00, $00, $00, $00, $00, $00
spritecollisiondir:   .byte  $00, $00, $00, $00, $00, $00, $00, $00 // bit 0 above, bit 1 below, bit 2 left, bit 3 right collision
spritecollisionup:    .byte  $00, $00, $00, $00, $00, $00, $00, $00
spritecollisiondown:  .byte  $00, $00, $00, $00, $00, $00, $00, $00
spritecollisionleft:  .byte  $00, $00, $00, $00, $00, $00, $00, $00
spritecollisionright: .byte  $00, $00, $00, $00, $00, $00, $00, $00

// looping / math 
scores:               .byte $00, $00, $00, $00, $00, $00
bits:                 .byte $01, $02, $04, $08, $10, $20, $40, $80
arithmetic_value:     .byte $00, $00
num1:                 .byte $00
num2:                 .byte $00
num3:                 .byte $00
num4:                 .byte $00