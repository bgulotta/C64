#importonce
/*
    This file stores common values common to the C64 architecture
*/

// Memory pointers
.const bg_color   = $d021
.const bdr_color  = $d020
.const scr_ram    = $0400
.const clr_ram    = $d800
.const irq_beg_sav = $03a0
.const irq_end_sav = $03a1
.const irq_beg = $0314
.const irq_end = $0315
.const irq_enable = $d01a
.const irq_ack   = $d019
.const rstr_reg   = $d021
.const rstr_cycle = $d011
.const scr_cols   = 40
.const scr_rows   = 25

// Enumerations for colors, ascii codes
.enum { enable_raster = 1 }
.enum { black, white }
.enum { space = $20 }