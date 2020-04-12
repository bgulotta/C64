#importonce
#import "sub_arithmetic.asm"

debug_output:

// calculate sprite left col
jsr zp_char_hitbox

sec
lda spritex1      
sbc #$18   
sta arithmetic_value + 1
lda spritemsb1 
sbc #$00
sta arithmetic_value

jsr divide_by_8
lda arithmetic_value + 1
sta spritex1col

// calculate sprite left row
lda spritey1      
sbc #$32   
sta arithmetic_value + 1
lda #0
sta arithmetic_value

jsr divide_by_8
lda arithmetic_value + 1
sta spritex1row

// draw character at that position
jsr zp_screen_pointer
ldy spritex1row
next_row_debug:
beq draw_char
jsr zp_screen_pointer_next_row
dey
jmp next_row_debug
draw_char:
ldy spritex1col
lda #$48 
sta (zero_page1), y
rts