#importonce
#import "sub_zero_page.asm"
#import "../resources/maps/debug.asm"

zp_map_pointer:
    lda #<debug_map
    sta zero_page2 
    lda #>debug_map
    sta zero_page2 + 1
    rts
zp_map_pointer_next_row:
    clc
    lda zero_page2         
    adc #screen_cols
    sta zero_page2
    lda zero_page2 + 1
    adc #$00
    sta zero_page2 + 1    
    rts

draw_map:
DrawMap()
draw_map_done:
rts

debug_output:

//DrawRowColInfo()
draw_row_col_info_done:
//DrawCharBoundaries()
draw_char_bounadaries_done:
//DrawMovementInfo()
draw_movement_info_done:
//DrawCollisionInfo()
draw_collision_info_done:
rts

/*
This function will draw all the collision flags for debugging purposes
*/
.macro DrawCollisionInfo(){
ldx #$ff
jsr zp_screen_pointer
lda #$15
ldy #$02
sta (zero_page1), y
iny 
lda #$04
sta (zero_page1), y
iny 
lda #$0C
sta (zero_page1), y
iny 
lda #$12
sta (zero_page1), y

lda #$15
ldy #7
sta (zero_page1), y
iny 
lda #$04
sta (zero_page1), y
iny 
lda #$0C
sta (zero_page1), y
iny 
lda #$12
sta (zero_page1), y

next_sprite:
inx
cpx #$08
bne process_sprite
rts
process_sprite:
jsr zp_screen_pointer_next_row
lda #$30
ldy #$02
sta (zero_page1), y
iny
sta (zero_page1), y
iny
sta (zero_page1), y
iny
sta (zero_page1), y

ldy #7
sta (zero_page1), y
iny
sta (zero_page1), y
iny
sta (zero_page1), y
iny
sta (zero_page1), y

lda spriteon, x
beq next_sprite

lda spritecollisiondir, x
sta num1

check_collision_up:
lda #up
bit num1
bne respond_collision_up
check_collision_down:
lda #down
bit num1
bne respond_collision_down
check_collision_left:
lda #left
bit num1
bne respond_collision_left
check_collision_right:
lda #right
bit num1
bne respond_collision_right
jmp next_sprite
respond_collision_up:
lda #$31
ldy #$02
sta (zero_page1), y
lda spritecollisionup, x
ldy #$07
sta (zero_page1), y
jmp check_collision_down
respond_collision_down:
lda #$31
ldy #$03
sta (zero_page1), y
lda spritecollisiondown, x
ldy #$08
sta (zero_page1), y
jmp check_collision_left
respond_collision_left:
lda #$31
ldy #$04
sta (zero_page1), y
ldy #$09
lda spritecollisionleft, x
sta (zero_page1), y
jmp check_collision_right
respond_collision_right:
lda #$31
ldy #$05
sta (zero_page1), y
ldy #$0a
lda spritecollisionright, x
sta (zero_page1), y
jmp next_sprite
}

/* 
This function will draw all the movement flags for debugging purposes
*/
.macro DrawMovementInfo(){
ldx #$ff
jsr zp_screen_pointer
ldy #33
lda #$15
sta (zero_page1), y
iny 
lda #$04
sta (zero_page1), y
iny 
lda #$0C
sta (zero_page1), y
iny 
lda #$12
sta (zero_page1), y
iny
lda #$0A
sta (zero_page1), y
next_sprite:
inx
cpx #$08
beq draw_movement_info_done
jsr zp_screen_pointer_next_row
lda #$30
ldy #33
sta (zero_page1), y
iny
sta (zero_page1), y
iny
sta (zero_page1), y
iny
sta (zero_page1), y
iny
sta (zero_page1), y

lda spriteon, x
beq next_sprite

lda spritemovement, x
sta num1

check_movement_up:
lda #up
bit num1
bne respond_movement_up
check_movement_down:
lda #down
bit num1
bne respond_movement_down
check_movement_left:
lda #left
bit num1
bne respond_movement_left
check_movement_right:
lda #right
bit num1
bne respond_movement_right
jmp check_movement_jump
check_movement_jump:
lda #jump
bit num1
bne respond_movement_jump
jmp next_sprite
respond_movement_up:
lda #$31
ldy #33
sta (zero_page1), y
jmp check_movement_down
respond_movement_down:
lda #$31
ldy #34
sta (zero_page1), y
jmp check_movement_left
respond_movement_left:
lda #$31
ldy #35
sta (zero_page1), y
jmp check_movement_right
respond_movement_right:
lda #$31
ldy #36
sta (zero_page1), y
jmp check_movement_jump
respond_movement_jump:
lda #$31
ldy #37
sta (zero_page1), y
jmp next_sprite
}

/*
This function will draw all the collision flags for debugging purposes
*/
.macro DrawRowColInfo(){
ldx #$ff
jsr zp_screen_pointer
ldy #25
lda #$12
sta (zero_page1), y
iny 
lda #$03
sta (zero_page1), y
iny 
lda #$12
sta (zero_page1), y
iny 
lda #$03
sta (zero_page1), y

next_sprite:
inx
cpx #$08
bne process_sprite
jmp draw_row_col_info_done

process_sprite:
lda spriteon, x
beq next_sprite

jsr zp_screen_pointer_next_row
ldy #25
lda spriterow1, x
sta (zero_page1), y
iny 
lda spritecol1, x
sta (zero_page1), y
iny 
lda spriterow2, x
sta (zero_page1), y
iny 
lda spritecol2, x
sta (zero_page1), y

jsr zp_screen_pointer_next_row
ldy #25
lda spritemsb1, x
sta (zero_page1), y
iny 
iny
lda spritemsb2, x
sta (zero_page1), y

jmp next_sprite
}
/*
    This method will fill in the characters the sprite is in
*/
.macro DrawCharBoundaries () {
detect_char_collision:
    ldx #$ff
dcc_next_sprite:
    inx
    // are we finished with all sprites?
    cpx #$08
    bcc dcc_loop
    jmp draw_char_bounadaries_done
dcc_loop:
    // is this sprite on?
    lda spriteon, x
    beq dcc_next_sprite
    // set zero page screen memory pointer 
    jsr zp_screen_pointer
    // keep moving down a row until we get to the start of the sprite
    ldy spriterow1, x
dcc_screen_next_row:
    cpy #$00
    beq dcc_check_sprite
    dey  
    // go to the next row
    jsr zp_screen_pointer_next_row
    jmp dcc_screen_next_row
dcc_check_sprite:
    // y = num1 current row is finished
    lda spritecol1, x
    sta num1
    // num2 = num3 all rows finished
    lda spriterow2, x
    sta num3
    lda spriterow1, x
    sta num2
dcc_row_loop:
    // start at the last column
    ldy spritecol2, x
dcc_column_loop:  
    // is this character one we need to act on?
    lda #$43
    sta (zero_page1), y
dcc_check_finished:
    // are we done with this row?
    dey
    cpy #$ff // boundary check
    beq dcc_check_rows_finished
    cpy num1
    bcs dcc_column_loop
dcc_check_rows_finished:    
    // are we done with all rows?
    dec num3
    lda num3
    cmp #$ff // boundary check    
    beq dcc_move_next_sprite
    cmp num2
    bcs dcc_sprite_next_row
dcc_move_next_sprite:
    jmp dcc_next_sprite
dcc_sprite_next_row:
  jsr zp_screen_pointer_next_row
  jmp dcc_row_loop  
}

.macro DrawMap() {
jsr zp_map_pointer
jsr zp_screen_pointer
// row counter
ldx #$00
draw_row_loop:
// column counter
ldy #$00
draw_col_loop:
lda (zero_page2), y
sta (zero_page1), y
iny
cpy #screen_cols
bcc draw_col_loop
inx
cpx #screen_rows
bcc draw_next_row
jmp draw_map_done
draw_next_row:
jsr zp_screen_pointer_next_row
jsr zp_map_pointer_next_row
jmp draw_row_loop
}