#import "../config/symbols.asm"
#import "../config/game_symbols.asm"
#importonce

check_input:
    lda #$01
    bit cia_port_a
    beq move_up
    lda #$02
    bit cia_port_a
    beq move_down
    lda #$04
    bit cia_port_a
    beq move_left
    lda #$08
    bit cia_port_a
    beq move_right
    /*lsr cia_port_a
    bcc jump*/
    rts
jump:
    ldx #$5
jump_loop:
    jmp move_up
    dex
    bne jump_loop
jump_exit:    
    rts
move_up:
    lda spritey
    cmp #sprite_ymin
    beq move_up_exit
    dec spritey
move_up_exit:
    rts
move_down:
    lda spritey
    cmp #sprite_ymax
    beq move_down_exit
    inc spritey
move_down_exit:
    rts
move_right: 
    inc spritex
    jmp check_msb
    rts
move_left:
    dec spritex
    jmp check_msb
    rts
check_msb:
    beq toggle_msb
    lda spritemsb
    bne msb_on
    rts
toggle_msb:
    lda spritemsb
    eor #$01
    sta spritemsb
    rts
msb_on:
    lda spritex
    cmp #$5B
    beq reset_x
    rts
reset_x:
    lda #$00
    sta spritex
    sta spritemsb
    rts

