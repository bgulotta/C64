#importonce
#import "../subroutines/sub_sprites.asm"
#import "../subroutines/color_wash.asm"
#import "../subroutines/sub_input.asm"
#import "../subroutines/sub_collision.asm"
#import "../subroutines/sub_debug.asm"

setup_irq:
    sei

    ldy #$7f    // $7f = %01111111
    sty $dc0d   // Turn off CIAs Timer interrupts
    sty $dd0d   // Turn off CIAs Timer interrupts
    
    // listen for raster beam events
    lda #$01
    sta vic_intrpt_ctrl

    // set bit indicating screen has completed cycle to 0
    lda vic_ctrl_reg   
    and #$7f    
    sta vic_ctrl_reg 

    // trigger first interrupt at row zero
    lda #$00    
    sta vic_rstr_reg

    // store original irq address so we can set things
    // back to their original state via the indirect address
    lda vic_irq_beg
    sta irq_beg_sav
    lda vic_irq_end
    sta irq_end_sav

    // point 0314 to our custom interrupt code irq
    lda #<irq
    sta vic_irq_beg
    lda #>irq 
    sta vic_irq_end

    cli
    rts

// restore system interrupt to original address
reset_irq:
    sei
    lda irq_beg_sav
    sta vic_irq_beg
    lda irq_end_sav
    sta vic_irq_end
    cli
    rts

// custom interrupt routine
irq:
    // acknowledge the raster interrupt
    dec vic_intrpt_sts  
    jsr color_wash

    jsr check_input
    jsr move_sprites
    jsr check_sprite_collision
    jsr debug_output

    jmp (irq_beg_sav)

