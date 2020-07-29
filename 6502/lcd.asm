.cpu _65c02
#importonce
#import "symbols.asm"

    setup_sequence:   // sequence of commands to setup lcd before sending data
        .byte $00, $02, $05, $06, $07

    init_sequence: 
        .byte $01, $01, $01, $00, $04, $06, $05, $03, $07   
    init_wait_low:
    //  .byte $04, $64, $64, $25, $f0, $25, $25, $25, $00
        .byte $20, $20, $20, $20, $20, $20, $10, $10, $00
    init_wait_high:
    //  .byte $10, $00, $00, $00, $05, $00, $00, $00, $00
        .byte $00, $00, $00, $00, $00, $00, $00, $00, $00
    
    instructions:     // list of instructions available to send to the lcd
        .byte $38, $30, $0e, $0c, $08, $06, $01, $ff 
    instruction_wait_low: // max execution time of instruction in microseconds
        .byte $25, $25, $25, $25, $25, $25, $f0, $00  // T1L
    instruction_wait_high:
        .byte $00, $00, $00, $00, $00, $00, $05, $00  // T1H
        
    data:
        .text "HELLO WORLD"
        .byte $ff

    data_wait_low:
        .byte $25
    data_wait_high:
        .byte $00

initialize_lcd:
  
    sei 

    // initialize index and instruction 
    lda #$ff
    sta LCD_INST 
    sta LCD_INX

    // mark lcd as busy
    lda #$80
    sta LCD_BUSY

    // set pointer to the initialize lcd commands
    lda #<init_sequence
    sta LCD_CMDS
    lda #>init_sequence
    sta LCD_CMDS + 1
    
    // set the t1 jmp location
    lda #<initialze_irq
    sta VIA1T1_JMP
    lda #>initialze_irq
    sta VIA1T1_JMP + 1
   
    // Enable T1 Interrupts
    lda #%11000000 
    sta VIA1IER

    // One Shot Mode
    lda #%00000000 
    sta VIA1ACR 

    // start first timer 15ms after startup
    //lda #$98 
    lda #$01
    sta VIA1T1CL    
    //lda #$3A 
    lda #$00
    sta VIA1T1CH       

    cli 

    rts

/*
    When this ISR returns it will have set the LCD_INST, cleared the LCD_BUSY flag, 
    and stored the amount of time to wait after executing LCD_INST into LCD_INITL/LCDINITH.
    Once execution is returned to the main program loop, LCD_INST should then get sent to the lcd via a call
    to the send_instruction subroutine.
*/
initialze_irq:
init_irq_save_registers:
    pha
    phy
    phx
    ldy LCD_INX
    iny 
    sty LCD_INX
init_irq_set_instruction:
    lda (LCD_CMDS), y
    tax
    lda instructions, x
    sta LCD_INST
init_irq_set_wait_time:
    lda init_wait_low, y       
    sta LCD_INITL
    lda init_wait_high, y 
    sta LCD_INITH
init_irq_clear_busy:
    lda #0
    sta LCD_BUSY
init_irq_restore_registers:
    plx  
    ply
    pla
    rti

/*
    This subroutine will send the instruction held in LCD_INST. 
    It will then clear the LCD_Busy flag and start the T1 Timer.
*/
send_instruction: 
    lda LCD_BUSY
    bmi send_instruction_exit
    lda LCD_INST
    cmp #$ff
    beq send_instruction_exit
set_lcd_write_ir:
  lda #%10000000
    sta VIA1REGA 
    nop
    nop
//    ora #%10000000
//    sta VIA1REGA
//    nop
//    nop
set_instruction:
    lda LCD_INST
    sta VIA1REGB
send_lcd_instruction:
    lda #%00000000
    sta VIA1REGA
    nop
    nop
send_instr_lcd_busy:
    lda #$80
    sta LCD_BUSY
send_instr_wait:      // wait before processing next instruction if any
    lda LCD_INITL
    sta VIA1T1CL
    lda LCD_INITH
    sta VIA1T1CH    
send_instruction_exit:
    rts

/*
instruction_irq:
instr_irq_save_registers:
    pha
    phy
    phx
instr_irq_set_instruction:
    // set instruction
    ldy LCD_INX
    lda (LCD_CMDS), y
    tax
    lda instructions, x
    sta LCD_INST
instr_irq_set_wait_time:  
    lda instruction_wait_low, x       
    sta LCD_INITL
    lda instruction_wait_high, x
    sta LCD_INITH
instr_irq_set_lcd_not_busy:
    lsr LCD_BUSY_STATE
instr_irq_restore_registers:
    plx  
    ply
    pla  
    rti

data_irq:
data_irq_save_registers:
    pha
    phy
data_irq_set_data:
    // set char data
    ldy LCD_INX
    lda (LCD_CMDS), y
    sta LCD_DATA
data_irq_set_wait_time:
    // set wait time
    lda data_wait_low       
    sta LCD_INITL
    lda data_wait_high
    sta LCD_INITH
data_irq_set_lcd_not_busy:
    lsr LCD_BUSY_STATE
data_irq_restore_registers:
    ply
    pla  
    rti

send_data:
    bit LCD_BUSY_STATE
    bmi send_data_exit
    lda LCD_DATA
    cmp #$ff
    beq send_data_exit
set_lcd_write_dr:
    lda #%00100000
    sta VIA1REGA  
    ora #%10000000
    sta VIA1REGA
set_data:
    lda LCD_DATA
    sta VIA1REGB
send_lcd_data:
    lda #%00100000
    sta VIA1REGA
send_data_set_lcd_busy:
    lda #$80
    sta LCD_BUSY_STATE 
send_data_next:
    inc LCD_INX
send_data_start_wait_time: 
    lda LCD_INITL
    sta VIA1T1CL
    lda LCD_INITH
    sta VIA1T1CH       
send_data_exit:
    rts
*/