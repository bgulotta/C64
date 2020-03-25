BasicUpstart2(start)

*=$1000

start:
    .break
    lda $0381 // a = 2 
    ldx $0380 // x = 1 
    stx $0381 // 1,1,3,4,5 
    ldx $0382 // x = 3 
    sta $0382 // 1,1,2,4,5 
    lda $0383 // a = 4
    stx $0383 // 1,1,2,3,5
    ldx $0384 // x = 5 
    sta $0384 // 1,1,2,3,4
    stx $0380 // 5,1,2,3,4
    jmp start