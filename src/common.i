; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; Some helper macros

;   A macro to step the origin with padding so the output file is not crap.
;   Padding is with $C7 (rst $00) so lost code will reset. Only for ROM.
    macro pad_to addr
    assert (mspace = 0), "Must be in rom"
    assert ($<=addr), "Error, code overrun"
    if $ < addr             ; Add padding
        block addr-$,$C7
    endif
    endm

;   A macro for reserving space without emitting any bytes for that space.
;   Only for use in RAM, never for ROM.
    macro reserve size
    assert (mspace = 1), "Must be in ram"
    org $+size
    endm

; Some defines to reduce errors and mix ups.

    define rsp ix       ; The FORTH Return Stack Pointer
    define pnext iy     ; A pointer to the FORTH next primitive.
    ; The sp is the FORTH dsp but since it almost never used by name,
    ; there is little point in giving it an alias.

; Some defines for word flags byte.

cmo equ $0  ; Compile in compile mode, error in execute mode.
xix equ $1  ; Execute in execute mode, compile in compile mode.
xic equ $2  ; Execute in compile mode, error in execute mode.
xia equ $3  ; Execute in any mode.
