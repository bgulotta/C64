#importonce
#import "sub_zero_page.asm"
#import "sub_arithmetic.asm"

/* 
    This routine checks for sprite to sprite collisions and sets appropriate
    meta data for collision routine to respond accordingly
*/
detect_sprite_collision:
    ldy #0
dsc_outer_loop:
    ldx #2
dsc_inner_loop:
    // is the player sprite on?
    lda spriteon, y
    beq dsc_next_sprite
    // is the non player sprite on?
    lda spriteon, x
    beq dsc_next_sprite
    //y_overlaps = (a.top < b.bottom) && (a.bottom > b.top)
    lda spritey1, y     
    cmp spritey2, x  
    bcs dsc_next_sprite // a.top >= b.bottom
    lda spritey1, x          
    cmp spritey2, y        
    bcs dsc_next_sprite // b.top >= a.bottom
    //x_overlaps = (a.left < b.right) && (a.right > b.left)
    sec
    lda spritex1, y      
    sbc spritex2, x   
    lda spritemsb1, y    
    sbc spritemsb2, x 
    bcs dsc_next_sprite // a.left >= b.right
    sec
    lda spritex1, x         
    sbc spritex2, y       
    lda spritemsb1, x  
    sbc spritemsb2, y      
    bcs dsc_next_sprite // b.left >= a.right
    jsr dsc_sprite_collision
dsc_next_sprite:
    inx
    cpx #$09
    bcc dsc_inner_loop
    iny 
    cpy #$02
    bcc dsc_outer_loop
    rts
dsc_sprite_collision:
    // TODO: set sprite to sprite collision meta data
    // move this to sprite collision response routine
    cpy #$00
    beq dsc_player1
dsc_player2:
    sed
    clc 
    lda scores + 3
    adc #$10
    sta scores + 3
    bcc update_score_done
    lda scores + 4
    adc #$00
    sta scores + 4
    bcc update_score_done
    lda scores + 5
    adc #$00
    sta scores + 5
    jmp update_score_done
dsc_player1:
    sed
    clc 
    lda scores
    adc #$10
    sta scores
    bcc update_score_done
    lda scores + 1
    adc #$00
    sta scores + 1
    bcc update_score_done
    lda scores + 2
    adc #$00
    sta scores + 2
update_score_done:
    cld
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
    sta spritecollisiondir, x
    sta spritecollisionup, x
    sta spritecollisiondown, x
    sta spritecollisionleft, x
    sta spritecollisionright, x 
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
    lda (zero_page1), y
    cmp #char_collapsing
    bcs dcc_hit
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
dcc_hit:
    cmp #char_dead 
    bcs dcc_hit_deadly_platform
    cmp #char_solid 
    bcs dcc_hit_solid_platform
    cmp #char_semi_solid 
    bcs dcc_hit_semi_solid_platform
    cmp #char_ladder 
    bcs dcc_hit_ladder_platform
    cmp #char_conveyer 
    bcs dcc_hit_conveyers_platform
    jmp dcc_hit_collapsing_platform 
dcc_hit_deadly_platform:
    lda #dead
    jmp dcc_determine_direction
dcc_hit_solid_platform:
    lda #solid
    jmp dcc_determine_direction
dcc_hit_semi_solid_platform:
    lda #semi_solid
    jmp dcc_determine_direction
dcc_hit_ladder_platform:
    lda #ladder
    jmp dcc_determine_direction
dcc_hit_conveyers_platform:
    lda #conveyer
    jmp dcc_determine_direction
dcc_hit_collapsing_platform:
    lda #collapsing
    jmp dcc_determine_direction
dcc_determine_direction:
    pha
    lda num3
    cmp spriterow2, x
    beq dcc_set_direction_up
    cmp spriterow1, x
    beq dcc_set_direction_down
dcc_set_direction_side:
    tya
    cmp spritecol2, x
    beq dcc_set_direction_right
dcc_set_direction_left:
    pla
    sta spritecollisionleft, x
    lda spritecollisiondir, x
    ora #left
    sta spritecollisiondir, x
    jmp dcc_hit_done
dcc_set_direction_right:
    pla
    sta spritecollisionright, x
    lda spritecollisiondir, x
    ora #right
    sta spritecollisiondir, x
    jmp dcc_hit_done
dcc_set_direction_up:
    pla
    sta spritecollisionup, x
    lda spritecollisiondir, x
    ora #up
    sta spritecollisiondir, x
    jmp dcc_hit_done
dcc_set_direction_down:
    pla 
    sta spritecollisiondown, x
    lda spritecollisiondir, x
    ora #down
    sta spritecollisiondir, x
    jmp dcc_hit_done
dcc_hit_done:
    jmp dcc_check_finished