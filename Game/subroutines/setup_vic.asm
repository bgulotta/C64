#importonce
#import "../config/symbols.asm"
#import "../config/game_symbols.asm"

setup_vic_memory:
    lda vic_bnk_swtch_on
    ora #3
    sta vic_bnk_swtch_on
screen_pointer_reset:
    lda #<vic_scr_ram
    sta screenpointerzp 
    lda #>vic_scr_ram
    sta screenpointerzp + 1
sprite_pointer_reset:
    lda #<vic_scr_ram + $3f8
    sta spritepointerzp 
    lda #>vic_scr_ram + $3f8
    sta spritepointerzp + 1
    rts
screen_pointer_next_row:
    lda screenpointerzp         
    adc #screen_cols
    sta screenpointerzp
    lda screenpointerzp + 1
    adc #$00
    sta screenpointerzp + 1    
    rts