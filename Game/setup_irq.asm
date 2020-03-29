#importonce
#import "common.asm"
#import "sub_color_wash.asm"

setup_irq:
    sei

    //ldy #$7f    // $7f = %01111111
    //sty $dc0d   // Turn off CIAs Timer interrupts
    //sty $dd0d   // Turn off CIAs Timer interrupts
    //lda $dc0d   // cancel all CIA-IRQs in queue/unprocessed
    //lda $dd0d   // cancel all CIA-IRQs in queue/unprocessed

    // listen for raster beam events
    lda #$01
    sta intrpt_ctrl

    // set bit indicating screen has completed cycle to 0
    lda vic_ctrl_reg   
    and #$7f    
    sta vic_ctrl_reg 

    // trigger first interrupt at row zero
    lda #$00    
    sta rstr_reg

    // store original irq address so we can set things
    // back to their original state via the indirect address
    lda irq_beg
    sta irq_beg_sav
    lda irq_end
    sta irq_end_sav

    // point 0314 to our custom interrupt code irq
    lda #<irq
    sta irq_beg
    lda #>irq 
    sta irq_end

    cli
    rts

// restore system interrupt to original address
reset_irq:
    sei
    lda irq_beg_sav
    sta irq_beg
    lda irq_end_sav
    sta irq_end
    cli
    rts

// custom interrupt routine
irq:
    // acknowledge the raster interrupt
    dec intrpt_sts      
    jsr color_wash  
    jmp (irq_beg_sav)

