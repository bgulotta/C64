#importonce
#import "../config/game_symbols.asm"

INIT_IO:
    lda IO_RPTR
    sta IO_WPTR
rts

WR_BYTE:
    ldx IO_WPTR
    sta IO_BUF, x
    inc IO_WPTR
rts

RD_BYTE:
    ldx IO_RPTR
    lda IO_BUF, x
    inc IO_RPTR
rts

BUF_DIF: 
    .break
    lda  IO_WPTR     // Find difference between number of bytes written
    sec              // and how many read.
    sbc  IO_RPTR     // Ends with A showing the number of bytes left to read.
rts