; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The "main" entry point of FORTH
;

start_up:
    ; Set up system variables.
    ; See ram_defs.asm for details.

    di                  ; Make certain that interrupts are disabled.
    ld      sp,init_ds  ; Set up the FORTH data stack pointer.
    ld      rsp,init_rs ; Set up the FORTH return stack pointer.
    ld      pnext,next  ; pnext always points to next.

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

    ; Set the default console width.
    ld      a,80
    ld      (__width),a

    halt                ; Place holder for now.
