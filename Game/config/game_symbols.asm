#importonce
#import "../resources/sprite/data.asm"
#import "../resources/strings.asm"

.const irq_beg_sav      = $03a0
.const irq_end_sav      = $03a1
.const sprite_data      = $1600

.const spritepointerzp     = $fc
.const screenpointerzp     = $fe
.const screen_cols         = 40
.const screen_rows         = 25

.const title_offset     = screen_cols/2 - (title_length/2) + screen_cols * 12
.const copyright_offset = screen_cols/2 - (copyright_length/2) + screen_cols * 22

.const sprite_ymin      = $32
.const sprite_ymax      = $E5
.const sprite_xmin      = $32
.const sprite_xmax      = $E5

spriteon:           .byte $01, $01, $00, $00, $00, $00, $00, $00
spritepointer:      .byte sprite_bear/$40, sprite_bird/$40, $00, $00, $00, $00, $00, $00
spritex:            .byte $28, $5B, $00, $00, $00, $00, $00, $00
spritey:            .byte $78, $58, $00, $00, $00, $00, $00, $00
spritemsb:          .byte $00, $01, $00, $00, $00, $00, $00, $00
spritecolormenable: .byte $01, $01, $00, $00, $00, $00, $00, $00
spritecolor:        .byte $00, $0b, $00, $00, $00, $00, $00, $00
spritecolormulti1:  .byte $08
spritecolormulti2:  .byte $0a

