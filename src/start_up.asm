; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The "main" entry point of FORTH
;

start_up:
    ld      pnext,next  ; pnext always points to next.
    ld      rsp,init_rs ; Set up the FORTH return stack pointer.

    ; Set up the initial here pointer.
    ld      hl,free_start
    ld      [__here],hl

    ; Point to the "last" definition.
    ld      hl,last_entry
    ld      [__last],hl

    ; Clear the language mode.
    xor     a
    ld      [__mode],a

    ; There is no current definition at this time.
    ld      l,a
    ld      h,a
    ld      [__current],hl

    halt                ; Place holder for now.
