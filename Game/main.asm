
BasicUpstart2(main)

*=$c000 "Application"

main:   
    jsr setup_vic_memory
    jsr init_screen
    jsr init_title_screen
    jsr draw_map
    jsr setup_sprites
    jsr setup_irq
check_stop:
    jsr $FFE1
    beq exit
    jmp check_stop
exit:
    jsr reset_irq
    jsr $FCE2
    rts

*=$0840 "Symbols" 
#import "config/symbols.asm"
#import "config/game_symbols.asm"
*=sprite_data "Sprite Data"
#import "resources/sprite/data.asm"

*=subroutines "Subroutines"
#import "subroutines/sub_zero_page.asm"
#import "subroutines/sub_clear_screen.asm"
#import "subroutines/sub_title_screen.asm"
#import "subroutines/sub_sprites.asm"
#import "subroutines/sub_arithmetic.asm"
#import "subroutines/sub_collision_detect.asm"
#import "subroutines/sub_collision_respond.asm"
#import "subroutines/sub_debug.asm"
#import "subroutines/sub_input.asm"
#import "subroutines/sub_title_screen.asm"
#import "subroutines/sub_setup_vic.asm"
#import "subroutines/sub_setup_irq.asm"
