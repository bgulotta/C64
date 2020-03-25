BasicUpstart2(start)

/*
    Clears screen and prints HELLO WORLD!
*/

*=$1000

start:  
    ldx #$0
    lda #$93
    jsr $FFD2
loop:   
    lda text,x
    cmp #$ff
    beq out 
    jsr $FFD2
    inx 
    jmp loop
out:    
    rts
text:   
    .text "HELLO WORLD!"
    .byte $ff