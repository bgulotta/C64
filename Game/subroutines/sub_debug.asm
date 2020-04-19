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
DrawCollisionInfo()
draw_collision_info_done:
//DrawCharBoundaries()
draw_char_bounadaries_done:
rts

.macro DrawCollisionInfo(){

lda #$30
sta vic_scr_ram
sta vic_scr_ram + 1
sta vic_scr_ram + 2
sta vic_scr_ram + 3

check_collision_up:
lda #$01
bit spritecollisiondir
bne respond_collision_up
check_collision_down:
lda #$02
bit spritecollisiondir
bne respond_collision_down
check_collision_left:
lda #$04
bit spritecollisiondir
bne respond_collision_left
check_collision_right:
lda #$08
bit spritecollisiondir
bne respond_collision_right
jmp draw_collision_info_done
respond_collision_up:
lda #$31
sta vic_scr_ram
jmp check_collision_down
respond_collision_down:
lda #$31
sta vic_scr_ram + 1
jmp check_collision_left
respond_collision_left:
lda #$31
sta vic_scr_ram + 2
jmp check_collision_right
respond_collision_right:
lda #$31
sta vic_scr_ram + 3
jmp draw_collision_info_done
}
/*
    This method will fill in the characters the sprite is in
*/
.macro DrawCharBoundaries () {
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
    jmp draw_char_bounadaries_done
dcc_loop:
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
    // num2 = num3 all rows finished
    lda spriterow2, x
    sta num3
    lda spriterow1, x
    sta num2
dcc_row_loop:
    // go to the next row
    jsr zp_screen_pointer_next_row
    // start at the last column
    ldy spritecol2, x
dcc_column_loop:   
    // is this character one we need to act on?
    lda #$43
    sta (zero_page1), y
dcc_check_finished:
    // are we done with this row?
    dey
    cpy num1
    bcs dcc_column_loop
    // are we done with all rows?
    dec num3
    lda num3
    cmp num2
    bcs dcc_row_loop
    jmp dcc_next_sprite
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