#import "../config/symbols.asm"
#import "../config/game_symbols.asm"
#importonce

check_input:
    lda #$10
    bit cia_port_a
    beq jump
check_direction:
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
input_exit:
    rts
jump:
    bit spritemovement 
    beq check_direction
    // reset jump distance covered
    lda #$0
    sta spritejumpdistcov 
    // disable jumping ability
    lda spritemovement
    eor #$10
    sta spritemovement
    jmp check_direction
move_up:
    bit spritemovement
    beq input_exit
    sec 
    lda spritey
    sbc spritemovementspd
    sta spritey
    rts
move_down:
    bit spritemovement
    beq input_exit
    clc 
    lda spritey
    adc spritemovementspd
    sta spritey
    rts
move_right: 
    bit spritemovement
    beq input_exit
    clc 
    lda spritex
    adc spritemovementspd
    sta spritex
    jmp check_msb
    rts
move_left:
    bit spritemovement
    beq input_exit
    sec 
    lda spritex
    sbc spritemovementspd
    sta spritex
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

