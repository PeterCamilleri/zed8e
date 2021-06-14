; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; RAM definitions. Since this is RAM not ROM, no code should be emitted here.
;

    org     $8000
ram_start:

__here:     reserve 2   ; The next byte to be used in the dictionary
__last:     reserve 2   ; The LFA of the last word to be defined.
__current:  reserve 2   ; The LFA of the word currently being defined.
__mode:     reserve 1   ; The current mode. 0 is interpret else compiling.

free_start:

    org     $FF00       ; The FORTH return stack grows up from here.
init_rs:

    org     $FFFF
init_ds:                ; The FORTH data stack grows down from here.
                        ; Also the system stack.
