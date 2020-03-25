BasicUpstart2(start)

/* Swaps the values at 2 memory locations $0380,$0381 */

*=$1000

start:
    .break
    lda $0380 // load contents of memory location $0380 into register a
    ldx $0381 // load conents of memory location $0381 into register x
    stx $0380 // set conents of address $0380 with $0381
    sta $0381 // set conents of address $0381 with $0380
    jmp start