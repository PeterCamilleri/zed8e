; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; Arithmetic primitive: multiply
;

; On entry: BC is the first number
;           DE is the second number
; On exit: DE:HL holds the result
;          A and BC are clobbered.
;
multiply:
    ld      hl,0
    ld      a,16
multiply_loop:
    add     hl,hl           ; Shift DE:HL left.
    rl      e
    rl      d
    jp      nc,multiply_nc  ; If carry set, DE:HL += BC
    add     hl,bc
    jp      nc,multiply_nc
    inc     de
multiply_nc:
    dec     a               ; Until we do this 16 times.
    jp      nz,multiply_loop

    ret
