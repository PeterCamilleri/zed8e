; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; The "main" entry point of FORTH
;

start_up:
    ld      iy,next     ; IY always points to next.
    ld      ix,init_rs  ; Set up the FORTH RS pointer.
    halt                ; Place holder for now.
