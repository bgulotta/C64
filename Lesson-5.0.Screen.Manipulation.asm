BasicUpstart2(start)

/*
    Clear screen. Accept single digit number. If < (BCC) 5 double it ASL and print result. If >= (BCS) 5 divide by 2 LSR and print result
*/

*=$1000

start:  
    lda #$28        // Load number of lines on screen (40 lines) for storage
    sta $03a0       // Store number of screen lines
    ldx $0288       // Find address where screen memory starts
    stx $bc         // Store address where screen memory starts in open zero page
    lda #$00 
    sta $bb
    ldx #$00        
nextline:
    ldy #$04        
nextchar:
    lda ($bb), y    // load current character at current screen position
    cmp #$20        // is this character a space?
    beq updatescr
    eor #$80        // manipulate character adds highlight
updatescr:
    sta ($bb), y    // store updated character on screen
    iny
    cpy #18         // if we pass column 18 go to the next line
    bcc nextchar
    clc             // clear carry flag before addition
    lda $bb         // get start of current line
    adc $03a0       // move to next line
    sta $bb         // update pointer to start at new line
    lda $bc         //
    adc #$00        // handle carry over from previous addition
    sta $bc         //
    inx
    cpx #$0e        // have we done 14 lines?
    bne nextline
    rts