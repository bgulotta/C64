#importonce
#import "sub_zero_page.asm"
#import "sub_arithmetic.asm"

update_sprite_hitbox:

jsr zp_offset_table

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

// set col1
sec
lda spritex1, x     
sbc #screen_xoffset   
sta arithmetic_value + 1
lda spritemsb1, x 
sbc #$00
sta arithmetic_value

jsr divide_by_8
lda arithmetic_value + 1
sta spritecol1, x

// set x2
lda spritex1, x
clc
ldy #8
adc (zero_page1), y
sta spritex2, x
lda spritemsb, x
adc #$00
sta spritemsb2,x

// sprite col2
sec
lda spritex2, x      
sbc #screen_xoffset  
sta arithmetic_value + 1
lda spritemsb2, x
sbc #$00
sta arithmetic_value

jsr divide_by_8
lda arithmetic_value + 1
sta spritecol2, x

// set y1 & y2
lda spritey, x
clc
ldy #16
adc (zero_page1), y
sta spritey1, x
ldy #24
adc (zero_page1), y
sta spritey2, x

// sprite row1
lda spritey1, x     
sbc #screen_yoffset   
sta arithmetic_value + 1
lda #0
sta arithmetic_value

jsr divide_by_8
lda arithmetic_value + 1
sta spriterow1, x

// sprite x2row
lda spritey2, x      
sbc #screen_yoffset   
sta arithmetic_value + 1
lda #0
sta arithmetic_value

jsr divide_by_8
lda arithmetic_value + 1
sta spriterow2, x

inx
cpx #$07
beq update_sprite_hitbox_done
jsr zp_offset_table_next
jmp set_hit_box
update_sprite_hitbox_done:
rts

check_sprite_collision:

ldx #1

sprite_collision_loop:

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
bcs sprite_collision_loop
rts

handle_sprite_collision:

rts

check_char_collision:

char_under_sprite:

ldx #0
cus_sprite_loop:
ldy spriterow2, x
jsr zp_screen_pointer
cus_next_row:
beq check_bottom
jsr zp_screen_pointer_next_row
dey
jmp cus_next_row
check_bottom:
ldy spritecol1, x
lda (zero_page1), y
cmp #$20
bne cus_hit
jmp cus_no_hit
cus_hit:
// set sprite collision meta
sta spritecollisionchr, x 
lda spritecollisiondir, x
ora #$02
sta spritecollisiondir, x
jmp cus_next_sprite
cus_no_hit:
// clear sprite collision meta
lda #$0
sta spritecollisionchr, x 
lda spritecollisiondir, x
and #$FD
sta spritecollisiondir, x
cus_next_sprite:
inx
cpx #$08
bne cus_sprite_loop
rts

handle_char_collision:
// are we on the ground?
lda #$02
bit spritecollisiondir
bne on_ground
ldy spritejumpframes 
cpy #$0 // are we jumping?
bne hcc_exit
jmp in_air
on_ground:
lda spritemovement
ora #$10
sta spritemovement
jmp hcc_exit
in_air:
inc spritey 
hcc_exit:
rts