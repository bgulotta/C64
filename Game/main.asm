#import "common.asm"
#import "init_clear_screen.asm"
#import "init_title_screen.asm"
#import "setup_irq.asm"

.var music = LoadSid("resources/jeff_donald.sid")
BasicUpstart2(start)

*=$080e "Game Code"

start:  
    jsr init_screen
    jsr init_title_screen
    jsr music.init
    jsr setup_irq
check_stop:
    jsr $FFE1
    beq exit
    jmp check_stop
exit:
    jsr reset_irq
    jsr $FCE2
    rts
//--------------------------------------------------------- 
*=music.location "Music"
.fill music.size, music.getData(i)
//---------------------------------------------------------- 
// Print the music info while assembling
.print ""
.print "SID Data"
.print "--------"
.print "location=$"+toHexString(music.location) 
.print "init=$"+toHexString(music.init)
.print "play=$"+toHexString(music.play)
.print "songs="+music.songs
.print "startSong="+music.startSong
.print "size=$"+toHexString(music.size)
.print "name="+music.name
.print "author="+music.author
.print "copyright="+music.copyright
.print ""
.print "Additional tech data"
.print "--------------------"
.print "header="+music.header
.print "header version="+music.version 
.print "flags="+toBinaryString(music.flags) 
.print "speed="+toBinaryString(music.speed) 
.print "startpage="+music.startpage
.print "pagelength="+music.pagelength