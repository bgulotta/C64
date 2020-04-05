#import "resources/sprite/data.asm"
#import "subroutines/clear_screen.asm"
#import "subroutines/title_screen.asm"
#import "subroutines/setup_irq.asm"
#import "subroutines/setup_vic.asm"
#import "subroutines/sub_sprites.asm"
#import "subroutines/sub_input.asm"

BasicUpstart2(main)

*=$c000 "Application"

main:   
    jsr setup_vic_memory
    jsr init_screen
    jsr init_title_screen
    jsr setup_sprites
    jsr setup_input
    jsr setup_irq
check_stop:
    jsr $FFE1
    beq exit
    jmp check_stop
exit:
    jsr reset_irq
    jsr $FCE2
    rts