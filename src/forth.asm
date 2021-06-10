; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This FORTH is designed to run on bare bones hardware with no O/S or 
; other forms of interference or support.
;

    OUTPUT rom_image.dat

    org $0000       ; The system reset entry point.

    ld SP,init_sp  ; Set up the SP register.
    jp start_up

start_up:
    halt            ; Place holder for now.    
    
    org $FFFE
init_sp:
   
