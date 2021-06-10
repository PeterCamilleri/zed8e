; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This FORTH is designed to run on bare bones hardware with no O/S or
; other forms of interference or support.
;


;   A macro to step the origin with padding so the output file is not crap.

    macro padorg addr
    assert ($<=addr), "Error, code overrun"
    if $ < addr             ; Add padding
        block addr-$,$C7
    endif
    org addr                ; Set the origin. Why? Does this do anything?
    endm
