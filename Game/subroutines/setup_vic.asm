#importonce
#import "../config/symbols.asm"

setup_vic_memory:
    lda vic_bnk_swtch_on
    ora #3
    sta vic_bnk_swtch_on
    rts