#importonce
.cpu _45gs02

.const FP_A  = $80
.const FP_B  = $84
.const FP_C  = $88
.const FP_R  = $8C

// load 32 data from one address to another
.macro FP_MOV(from, to) {
        lda from
        sta to
        lda from+1
        sta to+1
        lda from+2
        sta to+2
        lda from+3
        sta to+3
}

// load 32bit data from one address into two others
.macro FP_MOV2(from, to1, to2) {
        lda from
        sta to1
        sta to2
        lda from+1
        sta to1+1
        sta to2+1
        lda from+2
        sta to1+2
        sta to2+2
        lda from+3
        sta to1+3
        sta to2+3
}

// load whole integer value (8bit)
.macro FP_STOR_II(val, addr) {
        lda #val       // load 8 bit immidiate value
        sta addr+3     // into high byte
        lda #0
        sta addr
        sta addr+1
        sta addr+2     // fraction to zero
}

// check sign of from
// if negative to = 0-from
.macro FP_ABS(from, to) {
        bit from+3
        bpl !pos+
        lda #0
        sec
        sbc from
        sta to
        lda #0
        sbc from+1
        sta to+1
        lda #0
        sbc from+2
        sta to+2
        lda #0
        sbc from+3
        sta to+3
        bra !end+
!pos:
        lda from
        sta to
        lda from+1
        sta to+1
        lda from+2
        sta to+2
        lda from+3
        sta to+3
!end:    
}

// make .addr negative
.macro FP_MINUS(addr) {
        lda #0
        sec
        sbc addr
        sta addr
        lda #0
        sbc addr+1
        sta addr+1
        lda #0
        sbc addr+2
        sta addr+2
        lda #0
        sbc addr+3
        sta addr+3
}

// make .from negative and store in .to
.macro FP_NEG(from, to) {
        lda #0
        sec
        sbc from
        sta to
        lda #0
        sbc from+1
        sta to+1
        lda #0
        sbc from+2
        sta to+2
        lda #0
        sbc from+3
        sta to+3
}

// make .from negative and store in .to1 and .to2
.macro FP_NEG2(from, to1, to2) {
        lda #0
        sec
        sbc from
        sta to1
        sta to2
        lda #0
        sbc from+1
        sta to1+1
        sta to2+1
        lda #0
        sbc from+2
        sta to1+2
        sta to2+2
        lda #0
        sbc from+3
        sta to1+3
        sta to2+3
}

// shift .addr(32) right .count times
.macro FP_SR_X(addr, count) {
        ldx #count
!loop:
        asr addr+3
        ror addr+2
        ror addr+1
        ror addr
        dex
        bne !loop-
}

// shift .addr(32) left .count times
.macro FP_SL_X(addr, count) {
        ldx #count
!loop:
        asl addr
        rol addr+1
        rol addr+2
        rol addr+3
        dex
        bne !loop-
}
