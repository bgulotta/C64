#importonce
#import "sub_zero_page.asm"
#import "sub_arithmetic.asm"

update_hit_boxes:

jsr zp_offset_table
jsr zp_char_hitbox

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
pha
pla
// set x1col
/*sec
lda spritex1, x
sbc #screen_xoffset   
sta arithmetic_value + 1
pla
sbc #$00
sta arithmetic_value
jsr divide_by_8
ldy #0
sta (zero_page2), y*/

/*
spritex1col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex2col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex1row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritex2row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey1row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey1col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey2row:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
spritey2col:       .byte   $00, $00, $00, $00, $00, $00, $00, $00
*/

// set x2
lda spritex1, x
clc
ldy #8
adc (zero_page1), y
sta spritex2, x
lda spritemsb, x
adc #$00
sta spritemsb2,x
pha
pla
// set x2col
/*sec
lda spritex2, x
sbc #screen_xoffset   
sta arithmetic_value + 1
pla
sbc #$00
sta arithmetic_value
jsr divide_by_8
ldy #8
sta (zero_page2), y
*/

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
jsr zp_offset_table_next
jsr zp_char_hitbox_next
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