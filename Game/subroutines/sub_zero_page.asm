#importonce
#import "../config/symbols.asm"
#import "../config/game_symbols.asm"

screen_pointer_reset:
    lda #<vic_scr_ram
    sta zero_page1 
    lda #>vic_scr_ram
    sta zero_page1 + 1
    rts
sprite_pointer_reset:
    lda #<vic_scr_ram + $3f8
    sta zero_page1 
    lda #>vic_scr_ram + $3f8
    sta zero_page1 + 1
    rts
offset_table_reset:
    lda #<spriteoffset
    sta zero_page1 
    lda #>spriteoffset
    sta zero_page1 + 1
    rts
offset_table_next:
    clc
    lda zero_page1         
    adc #1
    sta zero_page1
    lda zero_page1 + 1
    adc #$00
    sta zero_page1 + 1    
    rts
screen_pointer_next_row:
    clc
    lda zero_page1         
    adc #screen_cols
    sta zero_page1
    lda zero_page1 + 1
    adc #$00
    sta zero_page1 + 1    
    rts