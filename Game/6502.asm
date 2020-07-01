.cpu _65c02

.const PORTB = $6000
.const PORTA = $6001
.const DDRB = $6002
.const DDRA = $6003

.const E  = %10000000
.const RW = %01000000
.const RS = %00100000

* = $8000 "Main Program"

reset: 
  ldx #$ff
  txs

  lda #%11111111 // Set all pins on port B to output
  sta DDRB
  lda #%11100000 // Set top 3 pins on port A to output
  sta DDRA

  lda #%00111000 // Set 8-bit mode; 2-line display; 5x8 font
  jsr lcd_instruction
  lda #%00001110 // Display on; cursor on; blink off
  jsr lcd_instruction
  lda #%00000110 // Increment and shift cursor; don't shift display
  jsr lcd_instruction
  lda #$00000001 // Clear display
  jsr lcd_instruction

  ldx #$00

  /*wait: 
    ldy #$ff     // one option is to use a VideoRam based implementation and 
    wait2:       // Instead of using this direct hardware call 
      dey
      bne wait2
    dex
    bne wait
    */

print:
  lda message,x
  beq loop
  cmp #$0A
  bne do_print
cursor_next_line:
  pha 
  lda #%11000000 // Set cursor to start of 2nd line
  jsr lcd_instruction
  pla
  jmp advance_next_char
do_print:
  jsr print_char
advance_next_char:
  inx
  jmp print

loop:
  jmp loop

message: 
    .text @"6502\$0AIT'S ALIVE!"
    .byte $00

lcd_wait:
  pha
  lda #%00000000   // Port B is input
  sta DDRB
lcdbusy:
  jsr clear_control_bits
  lda #(RW | E)
  sta PORTA
  lda PORTB
  and #%10000000
  bne lcdbusy
  jsr clear_control_bits
  lda #%11111111  // Port B is output
  sta DDRB
  pla
  rts

clear_control_bits:
  lda #0         // Clear RS/RW/E bits
  sta PORTA
  rts

lcd_instruction:
  jsr lcd_wait
  sta PORTB
  lda #E         // Set E bit to send instruction
  sta PORTA
  jsr clear_control_bits
  rts

print_char:
  jsr lcd_wait
  sta PORTB
  lda #(RS | E)   // Set E bit to send instruction
  sta PORTA
  jsr clear_control_bits
  rts

  * = $fffc "Reset Vector"
  .word reset