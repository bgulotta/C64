.cpu _65c02

/*
  Memory Map
  RAM:
    ZP:      $0000 - $00ff
    STACK:   $0100 - $01ff
    PRG:     $0200 - $3dff
    VARS:    $3e00 - $3eff 
    IOBUF:   $3f00 - $3fff
    UNUSED:  $4000 - $5fff // TODO: figure out logic to unlock this portion
  IO:        $6000 - $7fff
  ROM:       
             $8000 - $ffff
*/

* = $8000 "Main Program"

main: 

setup_stack:
  
  ldx #$ff    
  txs // initialize stack pointer
  
  jsr INIT_IO
  jsr INIT_VIA
  jsr SHIFT_IN_EXT

loop:
  jsr IO_BUF_TO_REGB
  jmp loop

  * = $8050 "Symbols"
  #import "symbols.asm"

  * = $8100 "VIA"
  #import "via.asm"

  * = $8200 "IO"
  #import "io.asm"

  //* = $8200 "LCD"
  //#import "lcd.asm"

  * = $a000 "IRQ Handlers"
  #import "irq.asm"

  * = $fffa "Vectors"
  .word nmi
  .word main
  .word irq