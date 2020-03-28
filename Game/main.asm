#import "common.asm"
#import "init_clear_screen.asm"
#import "init_title_screen.asm"
#import "setup_irq.asm"

BasicUpstart2(start)

*=$1000

start:  
    jsr init_screen
    jsr init_title_screen
    jsr setup_irq
check_stop:
    jsr $FFE1
    beq exit
    jmp check_stop
exit:
    jsr reset_irq
    jsr $FCE2
    rts