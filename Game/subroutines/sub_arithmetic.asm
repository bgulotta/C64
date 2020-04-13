#importonce
#import "../config/game_symbols.asm"

divide_by_8:

txa
pha
tya
pha

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
pla
tay
pla
tax
rts