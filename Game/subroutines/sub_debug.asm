#importonce
#import "sub_zero_page.asm"

debug_output:

jsr draw_border_bottom
//jsr draw_char_boundaries
//debug_char_under_sprite()
rts

/*
    This method will fill in the characters the sprite is in
*/
draw_char_boundaries:
    ldx #0
dcb_loop:
    // is this sprite on?
    lda spriteon, x
    beq dcb_next_sprite
    ldy spriterow2, x
    jsr zp_screen_pointer
dcb_next_row:
    beq dcb_check_bottom
    jsr zp_screen_pointer_next_row
    dey
    jmp dcb_next_row
dcb_check_bottom:
    lda spritecol1, x
    sta num1
    ldy spritecol2, x
dcb_cb_loop:   
    lda (zero_page1), y
    cmp #$20
    bne dcb_next_sprite
    lda #$46
    sta (zero_page1), y
    dey
    cpy num1
    bcs dcb_cb_loop
dcb_next_sprite:
    inx
    cpx #$08
    bne dcb_loop
    // TODO: COLLISIONS ON LEFT/RIGHT/ABOVE
    rts

draw_border_bottom:

jsr zp_screen_pointer
ldy #20

next_row_border_bottom:
beq draw_char_border_bottom
jsr zp_screen_pointer_next_row
dey
jmp next_row_border_bottom

draw_char_border_bottom:
lda #$80
sta (zero_page1), y
iny
cpy #screen_cols
bne draw_char_border_bottom
exit_debug:
rts


.macro debug_char_under_sprite () {
char_under_sprite:

ldx #0
cus_next_sprite:
ldy spriterow2, x
jsr zp_screen_pointer
cus_next_row:
beq check_bottom
jsr zp_screen_pointer_next_row
dey
jmp cus_next_row
check_bottom:
ldy spritecol1, x
lda (zero_page1), y
cmp #$20
bne cus_hit
inc spritey, x
cus_hit:
inx
cpx #$08
bne cus_next_sprite
rts                
}

