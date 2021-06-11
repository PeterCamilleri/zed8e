; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; Some helper macros

;   A macro to step the origin with padding so the output file is not crap.
;   Padding is with $C7 (rst #$00) so lost code will reset.
    macro pad_to addr
    assert ($<=addr), "Error, code overrun"
    if $ < addr             ; Add padding
        block addr-$,$C7
    endif
    endm

; Some defines to reduce errors and mix usp.

    define rsp ix
    define pnext iy
    ; The sp is the FORTH dsp but since it almost never used by name,
    ; there is little point in giving it an alias.
