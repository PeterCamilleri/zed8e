; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This file contains code connected to specific low page addresses in the
; Z-80 processor like the special rst $nn call, the mode 1 interrupt
; handler and the nonmaskable interrupt handler.
;

    org $0000           ; The system reset entry point.

    ; The processor RESET entry point. It all starts here.
    jp      start_up

    ; A code signature string.
    abyte   0 "Zed8E"

    ; The entry point for colon definitions.
    pad_to  $0008       ; Entry point for rst $08 or do_colon
    define  do_colon rst $08
    ld      (rsp),b     ; Push the IP onto the RS
    inc     rsp
    ld      (rsp),c
    inc     rsp
    pop     bc
    ; Deliberate fall through to the next routine.

    ; Execute the next high level instruction word.
next:
    ld      a,(bc)      ; Fetch the next instruction.
    inc     bc
    ld      l,a
    ld      a,(bc)
    inc     bc
    ld      h,a
    jp      hl          ; Execute it.

    ; Note: rst $10 is not available.
    ; Note: rst $18 is not available.

    ; Push a constant onto the data stack.
    pad_to  $0020       ; Entry point for rst $20 or do_const
    pop     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    push    de
    jp      pnext       ; NEXT

    ; Push the address of a variable onto the data stack.
    pad_to  $0028       ; Entry point for rst $28 or do_var
    jp      pnext       ; NEXT

    pad_to  $0030       ; Entry point for rst $30 - unused.

    ; The mode 1 interrupt handler.
    pad_to  $0038       ; Entry point for rst $38 or interrupt mode 1.
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

    ; Mark the end of a high level code word. The compliment of do_colon.
cfa_do_semi:
    dec     rsp         ; Pop the IP from the RS
    ld      b,(rsp)
    dec     rsp
    ld      c,(rsp)
    jp      pnext

    ; The NMI handler.
    pad_to  $0066       ; Entry point for nonmaskable interrupt.
    halt                ; Place holder for now.
