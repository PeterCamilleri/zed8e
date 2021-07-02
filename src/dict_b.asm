; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The FORTH ROM dictionary part B, arithmetic operations.
;

__add:      ; a b -- b+a
    word    last_a      ; Link to the last entry in section 'a'
    byte    xix
    byte    1
    abyte   0 "+"
cfa_add:
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
cfa_sub:
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
cfa_mul:
    exx
    pop     de
    pop     bc

    ; This code performs the operation HL=BC*DE
    ld      hl,0
    ld      a,16
__mul_loop:
    add     hl,hl           ; Shift HL left.
    sla     e               ; Shift DE left.
    rl      d
    jp      nc,__mul_nc     ; If carry set, HL += BC
    add     hl,bc
__mul_nc:
    dec     a               ; Until we do this 16 times.
    jp      nz,__mul_loop

    push    hl
    exx
    jp      pnext

__div:      ; a b -- b/a
    word    __mul
    byte    xix
    byte    1
    abyte   0 "/"
cfa_div:
    exx
    pop     de
    pop     hl
    call    s_divide
    push    de
    exx
    jp      pnext

__mod:      ; a b -- b%a
    word    __div
    byte    xix
    byte    3
    abyte   0 "mod"
cfa_mod:
    exx
    pop     de
    pop     hl
    call    s_divide
    push    hl
    exx
    jp      pnext

__divmod:   ; a b -- b%a b/a
    word    __mod
    byte    xix
    byte    4
    abyte   0 "/mod"
cfa_divmod:
    exx
    pop     de
    pop     hl
    call    s_divide
    push    de
    push    hl
    exx
    jp      pnext

__udiv:     ; ua ub -- u(ub/ua)
    word    __divmod
    byte    xix
    byte    2
    abyte   0 "u/"
cfa_udiv:
    exx
    pop     de
    pop     hl
    call    u_divide
    push    de
    exx
    jp      pnext

__umod:      ; ua ub -- u(ub%ua)
    word    __udiv
    byte    xix
    byte    4
    abyte   0 "umod"
cfa_umod:
    exx
    pop     de
    pop     hl
    call    u_divide
    push    hl
    exx
    jp      pnext

__udivmod:   ; ua ub -- u(b%a) u(b/a)
    word    __umod
    byte    xix
    byte    5
    abyte   0 "u/mod"
cfa_udivmod:
    exx
    pop     de
    pop     hl
    call    u_divide
    push    de
    push    hl
    exx
    jp      pnext

__mmul:     ; ua ub -- ud(ub*ua)
    word    __udivmod
    byte    xix
    byte    2
    abyte   0 "m*"
cfa_mmul:
    exx
    pop     de
    pop     bc

    call    multiply

    push    de
    push    hl
    exx

    jp      pnext

__2times:   ; a -- 2*a
    word    __mmul
    byte    xix
    byte    2
    abyte   0 "2*"
cfa_2times:
    pop     hl
    add     hl,hl
    push    hl
    jp      pnext

    ; Define the last entry in dictionary section 'b'.
    define last_b __2times
