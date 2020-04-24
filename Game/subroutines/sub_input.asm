#import "../config/symbols.asm"
#import "../config/game_symbols.asm"
#importonce

check_player1_input:
    lda #jump
    bit cia_port_a
    beq start_jump
check_direction:
    lda #up
    bit cia_port_a
    beq move_up
    lda #down
    bit cia_port_a
    beq move_down
    lda #left
    bit cia_port_a
    beq move_left
    lda #right
    bit cia_port_a
    beq move_right
input_exit:
    rts
start_jump:
    bit spritemovement 
    beq check_direction
    // disable jumping ability
    lda spritemovement
    eor #jump
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
    lda #right
    sta spritedirection
    clc 
    lda spritex
    adc spritemovementspd
    sta spritex
    bcs toggle_msb
    rts
move_left:
    bit spritemovement
    beq input_exit
    lda #left
    sta spritedirection    
    sec 
    lda spritex
    sbc spritemovementspd
    sta spritex
    bcc toggle_msb
    rts
toggle_msb:
    lda spritemsb
    eor #$01
    sta spritemsb
    rts

check_player2_input:
    lda #jump
    bit cia_port_b
    beq start_jump2
check_direction2:
    lda #up
    bit cia_port_b
    beq move_up2
    lda #down
    bit cia_port_b
    beq move_down2
    lda #left
    bit cia_port_b
    beq move_left2
    lda #right
    bit cia_port_b
    beq move_right2
input_exit2:
    rts
start_jump2:
    bit spritemovement + 1 
    beq check_direction2
    // disable jumping ability
    lda spritemovement + 1
    eor #jump
    sta spritemovement + 1
    jmp check_direction2
move_up2:
    bit spritemovement + 1
    beq input_exit2
    sec 
    lda spritey + 1
    sbc spritemovementspd + 1
    sta spritey + 1
    rts
move_down2:
    bit spritemovement + 1
    beq input_exit2
    clc 
    lda spritey + 1
    adc spritemovementspd + 1
    sta spritey + 1
    rts
move_right2: 
    bit spritemovement + 1
    beq input_exit2
    lda #right
    sta spritedirection + 1
    clc 
    lda spritex + 1
    adc spritemovementspd + 1
    sta spritex + 1
    bcs toggle_msb2
    rts
move_left2:
    bit spritemovement + 1
    beq input_exit2 
    lda #left
    sta spritedirection + 1    
    sec 
    lda spritex + 1
    sbc spritemovementspd + 1
    sta spritex + 1
    bcc toggle_msb2
    rts
toggle_msb2:
    lda spritemsb + 1
    eor #$01
    sta spritemsb + 1
    rts
