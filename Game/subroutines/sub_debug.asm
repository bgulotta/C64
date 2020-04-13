#importonce
#import "sub_arithmetic.asm"

debug_output:

// draw character at that position
jsr zp_screen_pointer
ldy spriterow1
next_row_debug:
beq draw_char
jsr zp_screen_pointer_next_row
dey
jmp next_row_debug
draw_char:
ldy spritecol1
lda #$48 
sta (zero_page1), y
rts