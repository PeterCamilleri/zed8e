; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; Arithmetic primitive:division
;

; On entry: DE is the divisor
;           HL is the dividend
; On exit: HL is the remainder
;          DE is the quotient
;          Carry is cleared for valid result, set for divide by zero.
;          A and BC are clobbered.
;
; Note: Two versions of divide exist, one for unsigned data and the
;       other for signed data.

u_divide:               ; Unsigned divide.
    ld      a,e         ; Check for divide by zero.
    or      d
    jr      nz, u_divide_ok
    ld      hl,0        ; For divide by zero error, zero out the result.
    ld      d,h
    ld      e,l
    scf                 ; Exit with the carry clag set.
    ret

u_divide_ok:
    ld      c,l         ; A:C = dividend now, quotient when done.
    ld      a,h
    ld      hl,0        ; Initialise the remainder to 0.
    ld      b,16        ; Set up loop counter
    ccf                 ; Clear carry to start.

u_divide_loop:
    rl      c           ; Shift HL:A:C:Cy left by one position.
    rla
    rl      l
    rl      h

    ; If the remainder >= divisor,
    push    hl          ; Save the current remainder.
    sbc     hl,de       ; Subtract divisor from the remainder.
    ccf                 ; Toggle the carry flag.

    jr      c,u_divide_drop
    pop     hl          ; Restore the remainder.
    djnz    u_divide_loop

u_divide_drop:
    inc     sp          ; Drop the saved remainder. It's not needed.
    inc     sp
    djnz    u_divide_loop

    ; Shift the last bit into the quotient.
    rl      c
    ld      e,c
    rla
    ld      d,a

    ccf                 ; Clear carry to show success.

    ret

s_divide:               ; Signed divide.
    ; Temp storage will be in unused RS space.
    define  rem_sign rsp+1
    define  quo_sign rsp+2

    ; Save off sign information we will need later.
    ld      a,h
    ld      (rem_sign),a
    xor     d
    ld      (quo_sign),a

    ; Take the absolute value of the divisor.
    bit     7,d
    jp      z,divisor_positive
    xor     a
    sub     e
    ld      e,a
    sbc     a
    sub     d
    ld      d,a
divisor_positive:

    ; Take the absolute value of the dividend.
    bit     7,h
    jp      z,dividend_positive
    xor     a
    sub     l
    ld      l,a
    sbc     a
    sub     h
    ld      h,a
dividend_positive:

    call    u_divide
    ret     c

; Negate the quotient if it needs to be negative.
    bit     7,(quo_sign)
    jp      z,quotient_positive:
    xor     a
    sub     e
    ld      e,a
    sbc     a,a
    sub     d
    ld      d,a
quotient_positive:

; Negate the remainder if it needs to be negative.
    bit     7,(rem_sign)
    jp      z,remainder_positive:
    xor     a
    sub     l
    ld      l,a
    sbc     a,a
    sub     h
    ld      h,a
remainder_positive:

    ret
