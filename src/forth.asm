; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This FORTH is designed to run on bare bones hardware with no O/S or
; other forms of interference or support.
;

    OUTPUT rom_image.dat

    include "helpers.i"

    org $0000           ; The system reset entry point.

    di                  ; Make certain that interrupts are disabled.
    ld      SP,init_sp  ; Set up the SP register.
    jp      start_up

    pad     $0008       ; Entry point for rst #$08 or do_does
    ld      (iy+0),b    ; Push the IP onto the RS
    dec     iy
    ld      (iy+0),c
    dec     iy
    pop     bc
    jp      ix          ; NEXT

    ; Note rst #$10 is not available.

    pad     $0018       ; Entry point for rst #$18 or do_const
    pop     hl
    ld      e,(hl)
    inc     hl
    ld      d,(hl)
    push    de
    jp      ix          ; NEXT

    pad     $0020       ; Entry point for rst #$20 or do_var
    jp      ix          ; NEXT

    pad     $0028       ; Entry point for rst #$20 or do_colon
    ld      (iy+0),b    ; Push the IP onto the RS
    dec     iy
    ld      (iy+0),c
    dec     iy
    pop     bc
    jp      ix          ; NEXT

    ; Note rst #$30 is not available.

    pad     $0038       ; Entry point for rst #$38 or interrupt mode 1.
    halt                ; Place holder for now.

    pad     $0066       ; Entry point for Non-maskable interrupt.
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
    ld      iy, next    ; IY always points to next.
    halt                ; Place holder for now.
    
; Beyond this point is RAM. No code should be generated for this region.    

    org $FFFE
init_sp:

