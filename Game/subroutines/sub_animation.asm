#importonce
#import "../config/game_symbols.asm"

update_sprite_frame:
    dec framecounter
    bne usf_done
    lda #sprite_framecnt
    sta framecounter

    ldx #$ff
    usf_next_sprite:
        inx
        // are we finished with all sprites?
        cpx #$08
        bcc usf_loop
    usf_done:
        rts
    usf_loop:
        // is this sprite on?
        lda spriteon, x
        beq usf_next_sprite 
        lda spritedirection, x
        cmp #left
        beq usf_left
        cmp #right
        beq usf_right
        /*cmp #up
        beq usf_up
        cmp #down
        beq usf_down*/
        jmp usf_next_sprite

        usf_left:
            lda spritepointer, x
            cmp spritelframeend, x
            beq usf_left_reset
            bcc usf_left_next
            jmp usf_left_reset
            usf_left_next:
                cmp spritelframebegin, x
                bcc usf_left_reset
                inc spritepointer, x                
                jmp usf_next_sprite          
            usf_left_reset:
                lda spritelframebegin, x
                sta spritepointer, x
                jmp usf_next_sprite

        usf_right:
            lda spritepointer, x
            cmp spriterframeend, x
            beq usf_right_reset
            bcc usf_right_next
            jmp usf_right_reset
            usf_right_next:
                cmp spriterframebegin, x
                bcc usf_right_reset
                inc spritepointer, x                
                jmp usf_next_sprite          
            usf_right_reset:
                lda spriterframebegin, x
                sta spritepointer, x
                jmp usf_next_sprite

        /*usf_up:
            lda spritepointer, x
            cmp spriteuframeend, x
            beq usf_up_reset
            bcc usf_up_next
            jmp usf_up_reset
            usf_up_next:
                cmp spriteuframebegin, x
                bcc usf_up_reset
                inc spritepointer, x                
                jmp usf_next_sprite          
            usf_up_reset:
                lda spriteuframebegin, x
                sta spritepointer, x
                jmp usf_next_sprite

        usf_down:
            lda spritepointer, x
            cmp spritedframeend, x
            beq usf_down_reset
            bcc usf_down_next
            jmp usf_down_reset
            usf_down_next:
                cmp spritedframebegin, x
                bcc usf_down_reset
                inc spritepointer, x                
                jmp usf_next_sprite          
            usf_down_reset:
                lda spritedframebegin, x
                sta spritepointer, x
                jmp usf_next_sprite*/