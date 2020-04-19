#importonce
#import "sub_zero_page.asm"

debug_output:

jsr draw_border_bottom
//DrawCharBoundaries()
draw_hill()
//debug_char_under_sprite()
rts

/*
    This method will fill in the characters the sprite is in
*/
.macro DrawCharBoundaries () {
                /* 
    This routine checks for sprite to character collisions and sets appropriate
    meta data for collision routine to respond accordingly
*/
detect_char_collision:
    ldx #$ff
dcc_next_sprite:
    inx
    // are we finished with all sprites?
    cpx #$08
    bcc dcc_loop
    rts
dcc_loop:
    // is this sprite on?
    lda spriteon, x
    beq dcc_next_sprite
    // set zero page screen memory pointer 
    jsr zp_screen_pointer
    // keep moving down a row until we get to the start of the sprite
    ldy spriterow1, x
dcc_next_row:
    cpy #$1
    beq dcc_check_sprite
    jsr zp_screen_pointer_next_row
    dey
    jmp dcc_next_row
dcc_check_sprite:
    // y = num1 current row is finished
    lda spritecol1, x
    sta num1
    // num2 = num3 all rows finished
    lda spriterow2, x
    sta num3
    lda spriterow1, x
    sta num2
dcc_row_loop:
    // go to the next row
    jsr zp_screen_pointer_next_row
    // start at the last column
    ldy spritecol2, x
dcc_column_loop:   
    // is this character one we need to act on?
    lda #$43
    sta (zero_page1), y
dcc_check_finished:
    // are we done with this row?
    dey
    cpy num1
    bcs dcc_column_loop
    // are we done with all rows?
    dec num3
    lda num3
    cmp num2
    bcs dcc_row_loop
    jmp dcc_next_sprite
}

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

.macro draw_hill() {
    draw_border_bottom:

jsr zp_screen_pointer
ldy #19

next_row_border_bottom:
beq draw_char_border_bottom
jsr zp_screen_pointer_next_row
dey
jmp next_row_border_bottom

draw_char_border_bottom:
lda #$80
sta (zero_page1), y
iny
cpy #$0c
bne draw_char_border_bottom
exit_debug:
rts
}

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

