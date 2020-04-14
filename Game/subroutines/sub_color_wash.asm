#importonce
#import "../resources/table/data.asm"
#import "../config/game_symbols.asm"

color_wash:   
    ldx #$27        // load x-register with #$27 to work through 0-39 iterations
    lda color_wash_data+$27   // init accumulator with the last color from first color table
cycle1:   
    ldy color_wash_data-1,x   // remember the current color in color table in this iteration
    sta color_wash_data-1,x   // overwrite that location with color from accumulator
    sta vic_clr_ram + title_offset, x     // put it into color ram into column x
    tya             // transfer our remembered color back to accumulator
    dex             // decrement x-register to go to next iteration
    bne cycle1      // repeat if there are iterations left
    sta color_wash_data+$27   // otherwise store te last color from accu into color table
    sta vic_clr_ram + title_offset // ... and into Color Ram
                  
color_wash2: 
    ldx #$00        // load x-register with #$00
    lda color_wash_data2+$27  // load the last color from the second color table

cycle2:   
    ldy color_wash_data2,x    // remember color at currently looked color2 table location
    sta color_wash_data2,x    // overwrite location with color from accumulator
    sta vic_clr_ram + copyright_offset,x     // ... and write it to Color Ram
    tya             // transfer our remembered color back to accumulator 
    inx             // increment x-register to go to next iteraton
    cpx #$26        // have we gone through 39 iterations yet?
    bne cycle2      // if no, repeat
    sta color_wash_data2+$27  // if yes, store the final color from accu into color2 table
    sta vic_clr_ram + copyright_offset+$27   // and write it into Color Ram
 
    rts             // return from subroutine