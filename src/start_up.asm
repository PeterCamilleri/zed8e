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

    ; For now there is no "last" definition. This will change!
    ld      hl,0
    ld      [__last],hl

    ; Clear the language mode.
    ld      a,0
    ld      [__mode],a

    halt                ; Place holder for now.
