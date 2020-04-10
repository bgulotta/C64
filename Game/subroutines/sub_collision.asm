#importonce
//#import "../config/symbols.asm"
//#import "../config/game_symbols.asm"
#import "sub_zero_page.asm"

update_hit_boxes:

jsr offset_table_reset
ldx #0

set_hit_box:

// set x1
lda spritex, x
clc
ldy #0
adc (zero_page1), y
sta spritex1, x
lda spritemsb, x
adc #$00
sta spritemsb1,x

// set x2
lda spritex1, x
clc
ldy #8
adc (zero_page1), y
sta spritex2, x
lda spritemsb, x
adc #$00
sta spritemsb2,x

// set y1 & y2
lda spritey, x
clc
ldy #16
adc (zero_page1), y
sta spritey1, x
ldy #24
adc (zero_page1), y
sta spritey2, x

inx
cpx #$07
beq update_hit_boxes_done
jsr offset_table_next
jmp set_hit_box
update_hit_boxes_done:
rts

check_sprite_collision:

jsr update_hit_boxes
ldx #1

collision_loop:

//y_overlaps = (a.top < b.bottom) && (a.bottom > b.top)
lda spritey1     
cmp spritey2, x  
bcs check_next_sprite // a.top >= b.bottom

lda spritey1, x          
cmp spritey2        
bcs check_next_sprite // b.top >= a.bottom

//x_overlaps = (a.left < b.right) && (a.right > b.left)
sec
lda spritex1      
sbc spritex2, x   
lda spritemsb1    
sbc spritemsb2, x 
bcs check_next_sprite // a.left >= b.right

sec
lda spritex1, x         
sbc spritex2       
lda spritemsb1, x  
sbc spritemsb2      
bcs check_next_sprite // b.left >= a.right

hitbysprite:
inc vic_bdr_color
rts

check_next_sprite:
inx
cpx #9
bcs collision_loop
rts