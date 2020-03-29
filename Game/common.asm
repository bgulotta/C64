#importonce
/*
    This file stores common values common to the C64 architecture
*/

// C64 POINTERS
.const bdr_color        = $d020 // 
.const bg_color         = $d021 // background (screen) color; in hi-res mode characters 0 bits have this color; in multi-color mode characters 00 bit pairs have this color
.const bg_color_2       = $d022 // background color 2; in multi-color mode characters 01 bit pairs have this color
.const bg_color_3       = $d023 // background color 3; in multi-color mode characters 10 bit pairs have this color
.const scr_ram_sel      = $d018 // contains byte. bits 7-4 control scr_ram location
.const chr_set_sel      = $d018 // contains byte. bits 3-1 control where your 2k byte character set is located
.const scr_ram          = $0400 // 1000 addresses each contains a byte 256 possible characters.
.const clr_ram          = $d800 // 1000 addresses each contains a nybble 16 possible colors; in multi-color mode characters 11 bit pairs have this color (specified by the lower 3 bits) 
.const enable_bnk_swtch = $dd02 // turning on bits 0,1 ORA 3 enables VIC-II bank switching
.const vic_bnk_sel      = $dd00 // contains a byte first 2 bits control which bank the VIC-II is looking at
.const vic_ctrl_reg     = $d011 // VIC-II control register 1; bit 0-2 yscroll; bit 3 high 25 row mode, low 24 row mode; bit 7 raster register cycle complete; 
.const vic_ctrl_reg2    = $d016 // VIC-II control register 2; bit 4 high turns on multi-color mode; bit 3 low turns on 38 column mode 
.const rstr_reg         = $d012 // VIC-II raster register;
.const vic_bnk_0        = $0000 // pointer to VIC-II bank 0: 16k bytes video memory
.const vic_bnk_1        = $4000 // pointer to VIC-II bank 1: 16k bytes video memory
.const vic_bnk_2        = $8000 // pointer to VIC-II bank 2: 16k bytes video memory
.const vic_bnk_3        = $C000 // pointer to VIC-II bank 3: 16k bytes video memory
.const intrpt_ctrl      = $d01a 
.const intrpt_sts       = $d019
.const irq_beg_sav      = $03a0
.const irq_end_sav      = $03a1
.const irq_beg          = $0314
.const irq_end          = $0315
.const scr_cols         = 40
.const scr_rows         = 25

// Enumerations for colors, ascii codes
.enum { black, white }
.enum { space = $20 }

.const tlen = 14
.const clen = 18
.const xpos_c = scr_cols/2 - clen/2
.const xpos_t = scr_cols/2 - tlen/2
.const ypos_t = scr_cols * 12
.const ypos_c = scr_cols * 13
.const copyright_offset = xpos_c + ypos_c
.const title_offset = xpos_t + ypos_t