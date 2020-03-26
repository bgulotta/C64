BasicUpstart2(start)

/*
    Clears screen. Accepts any 2 numbers and adds them up (if the value is < 10).
*/

*=$1000

start:  
    lda #$93  // load {clear} in a 
    jsr $FFD2 // PRINT a
addition:
    jsr input // get input with decimal value stored in a
    sta $03c0 // save value of a in memory $03c0
    lda #$02b // load '+' in a
    jsr $FFD2 // PRINT a
    jsr input // get input with decimal value stored in a
    tax       // store a -> x
    lda #$3d  // load '=' in a
    jsr $FFD2 // PRINT a
    txa       // store x -> a
    clc       // clear carry flag
    adc $03c0 // add a to value stored in $03c0
    ora #$30  // convert to ascii
    jsr $ffd2 // PRINT a
    lda #$0d  // load 'CR' in a
    jsr $ffd2 // PRINT a
    jmp addition
    rts
input:
    jsr $FFE1 // STOP
    beq out   // exit 
    jsr $FFE4 // GETIN
    cmp #$30  // compare a to '0'
    bcc input // if a < 0; wait for another key press
    cmp #$3a  // compare a to first ascii character after 9
    bcs input // branch if a >= ':'
    jsr $FFD2 // PRINT a
    and #$0f  // convert ascii to decimal, store in a
    jmp out
 out:   rts   // return to subroutine
