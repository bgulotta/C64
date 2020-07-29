.cpu _65c02
#importonce
#import "symbols.asm"
#import "io.asm"

INIT_VIA:
 
    sei 

    // Disable all VIA Interrupts
    lda #%01111111 
    sta VIA1IER
    
    // Clear IFR
    lda #$00
    sta VIA1IFR

    lda #%11111111 // Set all pins on port B to output
    sta VIA1DDRB
    lda #%11100000 // Set top 3 pins on port A to output
    sta VIA1DDRA

    cli

    rts

SHIFT_IN_EXT:

    sei

    // shift in under control of ext clock 011
    lda VIA1ACR
    ora #%00001100
    sta VIA1ACR

    // set PCR to pulse ack on CA2
    lda VIA1PCR
    ora #%00001010
    sta VIA1PCR

    // enable SR interrupts
    lda #%10000100 
    sta VIA1IER

    // reset shift register
    lda VIA1SR
    
    // clear any CA IFR that may exist
    lda VIA1REGA  

    cli
    
    rts

IO_BUF_TO_REGB:
    jsr BUF_DIF
    beq btp_exit
    tay
    jsr RD_BYTE
    sta VIA1REGB
    tya
    cmp #$ff      // If the buffer was not full,
    bne btp_exit  // then exit the subroutine. Otherwise,
    lda VIA1REGA  // send the byte received ack out CA2. Freeing up the sender.
btp_exit:
    rts