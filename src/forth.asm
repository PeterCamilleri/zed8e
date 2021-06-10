; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This FORTH is designed to run on bare bones hardware with no O/S or
; other forms of interference or support.
;

    OUTPUT rom_image.dat

    include "helpers.i"
    include "low_page.asm"


; Beyond this point is RAM.
    outend              ;  No bytes should be generated for this region.

    org     $8000
ram_start:

    org     $FEFE       ; The FORTH return stack grows down from here.
init_rs:

    org     $FFFE
init_ds:                ; The FORTH data stack grows down from here.
                        ; Also the system stack.
