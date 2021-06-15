; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; String handling primitives.
;

; Compare two string to see if they are equal.
; On entry: HL points to the length field of the first string.
;           DE points to the length field of the second string.
; On exit: Z flag is set if the strings are equal.
;          The B, DE, and HL registers are clobbered.
;
streq:
    ; Compare the lengths first.
    ld      a,(de)
    cp      (hl)
    jr      nz,streq_done

    ; Check for empty strings.
    and     a
    jr      z,streq_done

    ; Set up the length counter.
    ld      b,a

    ; Check the characters of the string.
streq_loop:
    inc     de
    inc     hl
    ld      a,(de)
    cp      (hl)
    jr      nz,streq_done
    djnz    streq_loop

streq_done:
    ret
