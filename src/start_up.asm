; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The "main" entry point of FORTH
;

start_up:
    ld      pnext,next  ; pnext always points to next.
    ld      rsp,init_rs ; Set up the FORTH return stack pointer.
    halt                ; Place holder for now.
