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
    ldx #$ff
dcc_next_sprite:
    inx
    // are we finished with all sprites?
    cpx #$08
    bcc dcc_loop
    rts
dcc_loop:
    
    // clear out any previous collision meta data
    lda #$0
    sta spritechartype, x
    sta spritecollisionchr, x 
    lda spritecollisiondir, x
    and #$FD
    sta spritecollisiondir, x

    // is this sprite on?
    lda spriteon, x
    beq dcc_next_sprite
    // set zero page screen memory pointer 
    jsr zp_screen_pointer
    // keep moving down a row until we get to the start of the sprite
    ldy spriterow1, x
dcc_next_row:
    cpy #$1
    beq dcc_check_sprite
    jsr zp_screen_pointer_next_row
    dey
    jmp dcc_next_row
dcc_check_sprite:
    // y = num1 current row is finished
    lda spritecol1, x
    sta num1
    // num2 = 0 sprite finished
    sec 
    lda spriterow2, x
    sbc spriterow1, x
    sta num2
dcc_row_loop:
    // go to the next row
    jsr zp_screen_pointer_next_row
    // start at the last column
    ldy spritecol2, x
dcc_column_loop:   
    // is this character one we need to act on?
    lda (zero_page1), y
    sta vic_scr_ram
    cmp #$80
    bcs dcc_hit
dcc_check_finished:
    // are we done with this row?
    dey
    cpy num1
    bcs dcc_column_loop
    // are we done with all rows?
    dec num2
    lda num2
    beq dcc_next_sprite
    jmp dcc_row_loop
dcc_hit:
    // store char we collided with (TODO: may be able to get rid of this)
    sta spritecollisionchr, x 
    cmp #$f0 // Death (spikes etc)
    bcs dcc_hit_deadly_platform
    cmp #$c0 // Solid platforms (cannot pass through)
    bcs dcc_hit_solid_platform
    cmp #$9a // Semi solid platforms
    bcs dcc_hit_semi_solid_platform
    cmp #$90 // Conveyers
    bcs dcc_hit_conveyers_platform
    jmp dcc_hit_collapsing_platform // Collapsing platforms
dcc_hit_deadly_platform:
    lda #$10
    jmp dcc_store_char_type
dcc_hit_solid_platform:
    lda #$08
    jmp dcc_store_char_type
dcc_hit_semi_solid_platform:
    lda #$04
    jmp dcc_store_char_type
dcc_hit_conveyers_platform:
    lda #$02
    jmp dcc_store_char_type
dcc_hit_collapsing_platform:
    lda #$01
    jmp dcc_store_char_type
dcc_store_char_type:
    // store char type
    sta spritechartype, x
dcc_store_char_direction:
    // TODO: store collision direction
    lda spritecollisiondir, x
    ora #$02
    sta spritecollisiondir, x

    jmp dcc_check_finished