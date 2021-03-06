; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The FORTH ROM dictionary part A, stack manipulation.
;

__drop:     ; a --
            ; Drop the top of data stack.
    word    0   ; This is the last entry in the dictionary.
    byte    xix
    byte    4
    abyte   0 "drop"
cfa_drop:
    pop     hl
    jp      pnext

__dup:      ; a -- a a
            ; Duplicate the top of data stack.
    word    __drop
    byte    xix
    byte    3
    abyte   0 "dup"
cfa_dup:
    pop     hl
    push    hl
    push    hl
    jp      pnext

__swap:     ; a b -- b a
            ; Swap the top and next of the data stack.
    word    __dup
    byte    xix
    byte    4
    abyte   0 "swap"
cfa_swap:
    pop     hl
    pop     de
    push    hl
    push    de
    jp      pnext

__over:     ; a b -- b a b
            ; Pull a copy of the next of stack over the top.
    word    __swap
    byte    xix
    byte    4
    abyte   0 "over"
cfa_over:
    pop     hl
    pop     de
    push    de
    push    hl
    push    de
    jp      pnext

__rot:      ; a b c -- c a b
            ; Rotate the top three data stack elements.
    word    __over
    byte    xix
    byte    3
    abyte   0 "rot"
cfa_rot:
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
            ; Duplicate the top of the data stack if it's not zero.
    word    __rot
    byte    xix
    byte    4
    abyte   0 "?dup"
cfa_qdup:
    pop     hl
    push    hl
    ld      a,l
    or      h
    jr      z,__qdup_z
    push    hl
__qdup_z:
    jp      pnext

__2drop:    ; da --
            ; a b --
            ; Drop the double data top of data stack.
    word    __qdup
    byte    xix
    byte    5
    abyte   0 "2drop"
cfa_2drop:
    pop     hl
    pop     hl
    jp      pnext

__2dup:     ; da -- da da
            ; a b -- a b a b
            ; Duplicate the double top of data stack.
    word    __2drop
    byte    xix
    byte    4
    abyte   0 "2dup"
cfa_2dup:
    pop     hl
    pop     de
    push    de
    push    hl
    push    de
    push    hl
    jp      pnext

__2swap:    ; da db -- db da
            ; a b c d -- c d a b
            ; Swap the double top and next.
    word    __2dup
    byte    xix
    byte    5
    abyte   0 "2swap"
cfa_2swap:
    pop     hl
    pop     de
    exx
    pop     hl
    pop     de
    exx
    push    de
    push    hl
    exx
    push    de
    push    hl
    exx
    jp      pnext

__2over:    ; 2a 2b -- 2b 2a 2b
            ; a b c d -- c d a b c d
            ; Pull a copy of the double next of stack over the top.
    word    __2swap
    byte    xix
    byte    5
    abyte   0 "2over"
cfa_2over:
    pop     hl
    pop     de
    exx
    pop     hl
    pop     de
    push    de
    push    hl
    exx
    push    de
    push    hl
    exx
    push    de
    push    hl
    exx
    jp      pnext

__2rot:     ; da db dc -- dc da db
            ; a b c d e f -- e f a b c d
            ; Rotate the top three double data stack elements.
    word    __2over
    byte    xix
    byte    4
    abyte   0 "2rot"
cfa_2rot:
    pop     hl
    pop     de
    exx
    pop     hl
    pop     de
    pop     bc
    pop     pnext
    push    de
    push    hl
    exx
    push    de
    push    hl
    exx
    push    pnext
    push    bc
    exx
    ld      pnext,next  ; pnext always points to next.
    jp      pnext

    ; Define the last entry in dictionary section 'a'.
    define last_a __2rot
