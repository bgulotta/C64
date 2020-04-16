#importonce
#import "sub_zero_page.asm"

debug_output:

jsr draw_border_bottom
//debug_char_under_sprite()

rts

draw_char_boundaries:
ldx #0
draw_char_boundary_loop:
jsr zp_screen_pointer
// draw character top left
ldy spriterow1, x
next_row_debug:
beq draw_char
jsr zp_screen_pointer_next_row
dey
jmp next_row_debug
draw_char:
ldy spritecol1,x
lda #$49 
sta (zero_page1), y

// draw character bottom right
jsr zp_screen_pointer
ldy spriterow2, x
next_row_debug2:
beq draw_char2
jsr zp_screen_pointer_next_row
dey
jmp next_row_debug2
draw_char2:
ldy spritecol2,x
lda #$49 
sta (zero_page1), y

inx
cpx #8
beq exit_debug
jmp draw_char_boundary_loop

draw_border_bottom:

jsr zp_screen_pointer
ldy #20
lda #$49 

next_row_border_bottom:
beq draw_char_border_bottom
jsr zp_screen_pointer_next_row
dey
jmp next_row_border_bottom

draw_char_border_bottom:

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

