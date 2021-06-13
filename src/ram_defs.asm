; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; RAM definitions. Since this is RAM not ROM, no code should be emitted here.
;

    org     $8000
ram_start:

__here:     reserve 2   ; The next byte to be used in the dictionary
__last:     reserve 2   ; The last word to be defined.
__current:  reserve 2   ; The word currently being defined.
__mode:     reserve 1   ; The current language mode.

free_start:

    org     $FEFE       ; The FORTH return stack grows down from here.
init_rs:

    org     $FFFE
init_ds:                ; The FORTH data stack grows down from here.
                        ; Also the system stack.
