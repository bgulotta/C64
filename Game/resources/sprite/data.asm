#importonce
#import "../../config/game_symbols.asm"

*=sprite_data

sprite_bear:
    .byte $00,$00,$00,$00,$00,$00,$00,$44
    .byte $00,$00,$44,$00,$01,$55,$00,$05
    .byte $99,$40,$05,$55,$40,$05,$65,$40
    .byte $05,$55,$40,$05,$a9,$40,$05,$b9
    .byte $40,$01,$55,$00,$00,$54,$00,$10
    .byte $54,$10,$15,$55,$50,$10,$54,$10
    .byte $00,$54,$00,$00,$44,$00,$00,$44
    .byte $00,$01,$45,$00,$00,$00,$00,$80

sprite_bird:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$a8,$00,$02
    .byte $aa,$00,$02,$22,$00,$02,$aa,$00
    .byte $c2,$9a,$00,$c2,$96,$0c,$e2,$9a
    .byte $2c,$e8,$a8,$ac,$ea,$aa,$ac,$ea
    .byte $aa,$ac,$ea,$aa,$ac,$ea,$aa,$ac
    .byte $ea,$aa,$ac,$c1,$a9,$0c,$c1,$01
    .byte $00,$05,$45,$40,$00,$00,$00,$8b