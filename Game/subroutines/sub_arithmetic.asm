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


multiply:
// General 8bit * 8bit = 8bit multiply
// by White Flame 20030207

// Multiplies "num1" by "num2" and returns result in .A
// Instead of using a bit counter, this routine early-exits when num2 reaches zero, thus saving iterations.


// Input variables:
//   num1 (multiplicand)
//   num2 (multiplier), should be small for speed
//   Signedness should not matter

// .X and .Y are preserved
// num1 and num2 get clobbered

lda #$00
beq enterLoop

doAdd:
 clc
 adc num1
loop:
 asl num1
enterLoop: 
//For an accumulating multiply (.A = .A + num1*num2),
//set up num1 andnum2, then enter here
 lsr num2
 bcs doAdd
 bne loop

end:
rts