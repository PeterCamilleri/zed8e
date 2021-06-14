; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The FORTH ROM dictionary part A, stack manipulation.
;

__add:      ; a b -- b+a
    word    last_a      ; Link to the last entry in section 'a'
    byte    xix
    byte    1
    abyte   0 "+"
    pop     de
    pop     hl
    add     hl,de
    push    hl
    jp      pnext

__sub:      ; a b -- b-a
    word    __add
    byte    xix
    byte    1
    abyte   0 "-"
    pop     de
    pop     hl
    ccf
    sbc     hl,de
    push    hl
    jp      pnext

__mul:      ; a b -- b*a
    word    __sub
    byte    xix
    byte    1
    abyte   0 "*"
    exx
    pop     de
    pop     bc

    ; This code performs the operation DEHL=BC*DE
    ld      hl,0
    ld      a,16
__mul_loop:
    add     hl,hl
    rl      e
    rl      d
    jp      nc,__mul_nc
    add     hl,bc
    jp      nc,__mul_nc
    inc     de
__mul_nc:
    dec     a
    jp      nz,__mul_loop

    push    hl
    exx
    jp      pnext

__div:      ; a b -- b/a
    word    __mul
    byte    xix
    byte    1
    abyte   0 "/"
    pop     de
    pop     hl
    ; wip
    push    hl
    jp      pnext

__mod:      ; a b -- b%a
    word    __div
    byte    xix
    byte    3
    abyte   0 "mod"
    pop     de
    pop     hl
    ; wip
    push    hl
    jp      pnext

    ; Define the last entry in dictionary section 'b'.
    define last_b __mod
