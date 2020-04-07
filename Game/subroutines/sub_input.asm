#import "../config/symbols.asm"
#import "../config/game_symbols.asm"
#importonce

setup_input:

rts
 
toggle_msb:
    lda spritemsb
    eor #$01
    sta spritemsb
msb_on:
    lda spritex
    cmp #$5B
    bne input_exit
reset_x:
    lda #$00
    sta spritex
    sta spritemsb
    jmp input_exit
check_input:
    lsr cia_port_a
    bcc move_up
    lsr cia_port_a
    bcc move_down
    lsr cia_port_a
    bcc move_left
    lsr cia_port_a
    bcc move_right
    jmp input_exit
move_up:
    lda spritey
    cmp #sprite_ymin
    beq input_exit
    dec spritey
    jmp input_exit
move_down:
    lda spritey
    cmp #sprite_ymax
    beq input_exit
    inc spritey
    jmp input_exit
move_right: 
    inc spritex
    jmp check_msb
move_left:
    dec spritex
check_msb:
    beq toggle_msb
    lda spritemsb
    bne msb_on
input_exit:
    rts