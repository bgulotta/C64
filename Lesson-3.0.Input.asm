BasicUpstart2(start)

/*
    Clears screen. Accepts any number as input and prints it to the screen
*/

*=$1000

start:  
    lda #$93
    jsr $FFD2
input:
    jsr $FFE1
    beq out
    jsr $FFE4
    cmp #$30
    bcc input // branch if a < 0
    cmp #$3a
    bcs input // branch if a > 9
    jsr $FFD2
    jmp input
 out:    
    rts
text:   
    .text "HELLO WORLD!"
    .byte $ff