BasicUpstart2(start)

*=$1000

start:
    lda #$48 // 'H' 
    jsr $FFD2 // Print register A to screen
    lda #$49 // 'I'
    jsr $FFD2
    rts
