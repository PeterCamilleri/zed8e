; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This FORTH is designed to run on bare bones hardware with no O/S or
; other forms of interference or support.
;

    OUTPUT rom_image.dat

    include "helpers.i"

    org $0000           ; The system reset entry point.

    di                  ; Make certain that interrupts are disabled.
    ld      SP,init_ds  ; Set up the SP register.
    jp      start_up

    pad_to  $0008       ; Entry point for rst #$08 or do_does
    ld      (iy),b      ; Push the IP onto the RS
    dec     iy
    ld      (iy),c
    dec     iy
    pop     bc
    jp      ix          ; NEXT

    ; Note rst #$10 is not available.

    pad_to  $0018       ; Entry point for rst #$18 or do_const
    pop     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    push    de
    jp      ix          ; NEXT

    pad_to  $0020       ; Entry point for rst #$20 or do_var
    jp      ix          ; NEXT

    pad_to  $0028       ; Entry point for rst #$20 or do_colon
    ld      (iy),b    ; Push the IP onto the RS
    dec     iy
    ld      (iy),c
    dec     iy
    pop     bc
    jp      ix          ; NEXT

    ; Note rst #$30 is not available.

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

    pad_to  $0066       ; Entry point for Nonmaskable interrupt.
    halt                ; Place holder for now.

next:
    ld      a,(bc)      ; Fetch the next instruction.
    inc     bc
    ld      l,a
    ld      a,(bc)
    inc     bc
    ld      h,a
    jp      hl          ; Execute it.

start_up:
    ld      iy,next     ; IY always points to next.
    ld      ix,init_rs  ; Set up the FORTH RS pointer.
    halt                ; Place holder for now.

; Beyond this point is RAM. No bytes should be generated for this region.
    org     $8000
ram_start:

    org     $FEFE       ; The FORTH return stack grows down from here.
init_rs:

    org     $FFFE
init_ds:                ; The FORTH data stack grows down from here.
                        ; Also the system stack.
