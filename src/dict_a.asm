; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The FORTH ROM dictionary part A, stack manipulation.
;

__drop:     ; a --
    word    0   ; This is the end of the line
    byte    0
    byte    4
    abyte   0 "drop"
    pop     hl
    jp      pnext

__dup:      ; a -- a a
    word    __drop
    byte    0
    byte    3
    abyte   0 "dup"
    pop     hl
    push    hl
    push    hl
    jp      pnext

__swap:     ; a b -- b a
    word    __dup
    byte    0
    byte    4
    abyte   0 "swap"
    pop     hl
    pop     de
    push    hl
    push    de
    jp      pnext

__over:     ; a b -- b a b
    word    __swap
    byte    0
    byte    4
    abyte   0 "over"
    pop     hl
    pop     de
    push    de
    push    hl
    push    de
    jp      pnext

__rot:      ; a b c -- c a b
    word    __over
    byte    0
    byte    3
    abyte   0 "rot"
    exx
    pop     hl
    pop     de
    pop     bc
    push    de
    push    hl
    push    bc
    exx
    jp      pnext

__qdup:     ; a -- a a if a <> 0
            ; a -- 0   if a == 0
    word    __rot
    byte    0
    byte    4
    abyte   0 "?dup"
    pop     hl
    push    hl
    ld      a,l
    or      h
    jr      z,__qdup_z
    push    hl
__qdup_z:
    jp      pnext

