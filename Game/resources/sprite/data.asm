#importonce
#import "../../config/game_symbols.asm"

*=sprite_data "Sprite Data"

sprite_bear: 
    .byte $00,$00,$00,$00,$00,$00,$00,$88
    .byte $00,$00,$88,$00,$02,$aa,$00,$0a
    .byte $22,$80,$0a,$aa,$80,$0a,$8a,$80
    .byte $0a,$aa,$80,$0a,$02,$80,$0a,$32
    .byte $80,$02,$aa,$00,$00,$a8,$00,$20
    .byte $a8,$20,$2a,$aa,$a0,$20,$a8,$20
    .byte $00,$a8,$00,$00,$88,$00,$00,$88
    .byte $00,$02,$8a,$00,$00,$00,$00,$88
sprite_bird:
    .byte $00,$00,$00,$00,$00,$00,$00,$00
    .byte $00,$00,$00,$00,$00,$a8,$00,$02
    .byte $aa,$00,$02,$22,$00,$02,$aa,$00
    .byte $c2,$ba,$00,$c2,$be,$0c,$e2,$ba
    .byte $2c,$e8,$a8,$ac,$ea,$aa,$ac,$ea
    .byte $aa,$ac,$ea,$aa,$ac,$ea,$aa,$ac
    .byte $ea,$aa,$ac,$c3,$ab,$0c,$c3,$03
    .byte $00,$0f,$cf,$c0,$00,$00,$00,$8e