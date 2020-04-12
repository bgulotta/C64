#importonce
#import "../config/symbols.asm"
#import "../config/game_symbols.asm"

zp_screen_pointer:
    lda #<vic_scr_ram
    sta zero_page1 
    lda #>vic_scr_ram
    sta zero_page1 + 1
    rts
zp_screen_pointer_next_row:
    clc
    lda zero_page1         
    adc #screen_cols
    sta zero_page1
    lda zero_page1 + 1
    adc #$00
    sta zero_page1 + 1    
    rts
zp_sprite_pointer:
    lda #<vic_scr_ram + $3f8
    sta zero_page1 
    lda #>vic_scr_ram + $3f8
    sta zero_page1 + 1
    rts
zp_arithmetic_value:
    lda #<arithmetic_value
    sta zero_page1 
    lda #>arithmetic_value
    sta zero_page1 + 1
    rts
zp_offset_table:
    lda #<spriteoffset
    sta zero_page1 
    lda #>spriteoffset
    sta zero_page1 + 1
    rts
zp_offset_table_next:
    clc
    lda zero_page1         
    adc #1
    sta zero_page1
    lda zero_page1 + 1
    adc #$00
    sta zero_page1 + 1    
    rts
zp_char_hitbox:
    lda #<spritex1row
    sta zero_page2
    lda #>spritex1row
    sta zero_page2 + 1
    rts
zp_char_hitbox_next:
    clc
    lda zero_page2        
    adc #1
    sta zero_page2
    lda zero_page2 + 1
    adc #$00
    sta zero_page2 + 1    
    rts