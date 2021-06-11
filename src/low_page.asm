; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This file contains code connected to specific low page addresses in the
; Z-80 processor like the special rst #$nn call, the mode 1 interrupt
; handler and the nonmaskable interrupt handler.
;

    org $0000           ; The system reset entry point.

    di                  ; Make certain that interrupts are disabled.
    ld      SP,init_ds  ; Set up the SP register.
    jp      start_up

    pad_to  $0008       ; Entry point for rst #$08 or do_colon
    ld      (ix),b      ; Push the IP onto the RS
    dec     ix
    ld      (ix),c
    dec     ix
    pop     bc

next:
    ld      a,(bc)      ; Fetch the next instruction.
    inc     bc
    ld      l,a
    ld      a,(bc)
    inc     bc
    ld      h,a
    jp      hl          ; Execute it.

    ; Note: rst #$10 is not available.
    ; Note: rst #$18 is not available.

    pad_to  $0020       ; Entry point for rst #$20 or do_const
    pop     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    push    de
    jp      iy          ; NEXT

    pad_to  $0028       ; Entry point for rst #$28 or do_var
    jp      iy          ; NEXT

    pad_to  $0030       ; Entry point for rst #$30 - unused.

    pad_to  $0038       ; Entry point for rst #$38 or interrupt mode 1.
    push    af          ; Save all registers.
    push    bc
    push    de
    push    hl
    ex      af,af'
    exx
    push    af
    push    bc
    push    de
    push    hl
    push    ix
    push    iy

    halt                ; Place holder for now.

    pop     iy          ; Restore all registers
    pop     ix
    pop     hl
    pop     de
    pop     bc
    pop     af
    ex      af,af'
    exx
    pop     hl
    pop     de
    pop     bc
    pop     af
    reti

    pad_to  $0066       ; Entry point for nonmaskable interrupt.
    halt                ; Place holder for now.
