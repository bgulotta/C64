#importonce
#import "sub_zero_page.asm"

divide_by_8:
jsr zp_arithmetic_value
ldy #3
ldx #0
divide_by_8_loop:
lda (arithmetic_value), x
beq next_byte
lsr (arithmetic_value), x
dey
beq divide_by_8_done
cpx #0
beq push_carry
jmp divide_by_8_loop
push_carry:
inx
ror (arithmetic_value), x
dex
jmp divide_by_8_loop
next_byte:
inx
cpx #2
beq divide_by_8_done
jmp divide_by_8_loop
divide_by_8_done:
rts