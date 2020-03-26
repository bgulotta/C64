BasicUpstart2(start)

/*
    Clear screen. Accept single digit number. If < (BCC) 5 double it ASL and print result. If >= (BCS) 5 divide by 2 LSR and print result
*/

*=$1000

start:  
    lda #$93  // load {clear} in a 
    jsr $FFD2 // PRINT a
getnumber:
    jsr input // get input with decimal value stored in a
    cmp #$5  // compare a to ascii character '5'
    bcs halve
    jsr double
    rts
double:
    asl       // shift left
    jmp output
halve:
    lsr       // shift right
    jmp output
output:
    ora #$30  // convert to ascii
    jsr $FFD2 // print a
    lda #$0d  // load 'CR' in a
    jsr $ffd2 // PRINT a
    jmp getnumber
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
