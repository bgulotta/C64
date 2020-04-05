#importonce
#import "../resources/sprite/data.asm"
#import "../resources/strings.asm"

.const irq_beg_sav      = $03a0
.const irq_end_sav      = $03a1
.const scr_cols         = 40
.const scr_rows         = 25

.const title_offset     = scr_cols/2 - (title_length/2) + scr_cols * 12
.const copyright_offset = scr_cols/2 - (copyright_length/2) + scr_cols * 22
.const sprite_data      = $1600

spriteon:           .byte $01, $01, $00, $00, $00, $00, $00, $00
spritepointer:      .byte sprite_bear/$40, sprite_bird/$40, $00, $00, $00, $00, $00, $00
spritex:            .byte $28, $57, $00, $00, $00, $00, $00, $00
spritey:            .byte $78, $58, $00, $00, $00, $00, $00, $00
spritemsb:          .byte $00, $01, $00, $00, $00, $00, $00, $00
spritecolormenable: .byte $01, $01, $00, $00, $00, $00, $00, $00
spritecolor:        .byte $00, $0b, $00, $00, $00, $00, $00, $00
spritecolorm1:      .byte $08, $08, $00, $00, $00, $00, $00, $00
spritecolorm2:      .byte $0a, $0a, $00, $00, $00, $00, $00, $00

