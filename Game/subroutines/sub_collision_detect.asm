#importonce
#import "sub_zero_page.asm"
#import "sub_arithmetic.asm"

/* 
    This routine checks for sprite to sprite collisions and sets appropriate
    meta data for collision routine to respond accordingly
*/
detect_sprite_collision:
ldx #1
dsc_loop:
// is this sprite on?
lda spriteon, x
beq dsc_next_sprite
//y_overlaps = (a.top < b.bottom) && (a.bottom > b.top)
lda spritey1     
cmp spritey2, x  
bcs dsc_next_sprite // a.top >= b.bottom

lda spritey1, x          
cmp spritey2        
bcs dsc_next_sprite // b.top >= a.bottom

//x_overlaps = (a.left < b.right) && (a.right > b.left)
sec
lda spritex1      
sbc spritex2, x   
lda spritemsb1    
sbc spritemsb2, x 
bcs dsc_next_sprite // a.left >= b.right

sec
lda spritex1, x         
sbc spritex2       
lda spritemsb1, x  
sbc spritemsb2      
bcs dsc_next_sprite // b.left >= a.right

dsc_sprite_collision:
// TODO: set sprite to sprite collision meta data
inc vic_bdr_color

dsc_next_sprite:
inx
cpx #9
bcs dsc_loop
rts

/* 
    This routine checks for sprite to character collisions and sets appropriate
    meta data for collision routine to respond accordingly
*/
detect_char_collision:

dcc_under_sprite:
    ldx #0
cus_loop:
    // is this sprite on?
    lda spriteon, x
    beq cus_next_sprite
    ldy spriterow2, x
    jsr zp_screen_pointer
cus_next_row:
    beq cus_check_bottom
    jsr zp_screen_pointer_next_row
    dey
    jmp cus_next_row
cus_check_bottom:
    lda spritecol1, x
    sta num1
    ldy spritecol2, x
cus_cb_loop:   
    lda (zero_page1), y
    cmp #$80
    bcs cus_hit
cus_cb_next_char:
    dey
    cpy num1
    bcs cus_cb_loop
    jmp cus_no_hit
cus_hit:
// store char we collided with (TODO: may be able to get rid of this)
    sta spritecollisionchr, x 
cus_solid_platform:
    lda #$04
    jmp cus_store_char_type
// TODO: CHECK OTHER CHAR TYPES
cus_store_char_type:
// store char type
    sta spritechartype, x
// store bottom collision
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
    bne cus_loop
    // TODO: COLLISIONS ON LEFT/RIGHT/ABOVE
    rts