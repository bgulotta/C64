.cpu _65c02
#importonce
#import "symbols.asm"
#import "io.asm"

// Interrupt handler
irq:
    pha
    phx
    lda VIA1IFR
    bmi service_via1
    jmp irq_done
service_via1:
    and VIA1IER
    asl 
    bmi service_t1
    asl
    asl
    asl
    asl
    bmi service_sr
    jmp irq_done
service_t1:
    lda VIA1T1CL     // ACK IRQ
    jmp irq_done
service_sr:
    lda VIA1SR       // ACK IRQ
    jsr WR_BYTE      // Write the byte to our IO Buffer.
    jsr BUF_DIF      // Now see how full the buffer is.
    cmp #$ff         // If our IO Buffer is full,
    beq irq_done     // then do not send the byte received ACK yet. 
    lda VIA1REGA     // Send byte received ack out CA2. This will clear the IFR.
irq_done:
    plx
    pla
rti

// Non-maskable interrupt handler
nmi:
    rti