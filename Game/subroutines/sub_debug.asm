#importonce
#import "../config/game_symbols.asm"

debug_output:

// draw character top left
jsr zp_screen_pointer
ldy spriterow1
next_row_debug:
beq draw_char
jsr zp_screen_pointer_next_row
dey
jmp next_row_debug
draw_char:
ldy spritecol1
lda #$49 
sta (zero_page1), y

// draw character bottom right
jsr zp_screen_pointer
ldy spriterow2
next_row_debug2:
beq draw_char2
jsr zp_screen_pointer_next_row
dey
jmp next_row_debug2
draw_char2:
ldy spritecol2
lda #$49 
sta (zero_page1), y

rts