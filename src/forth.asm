; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This FORTH is designed to run on bare bones hardware with no O/S or
; other forms of interference or support.
;

    output "rom_image.dat"
    define mspace 0

    include "helpers.i"
    include "low_page.asm"

    include "dict_a.asm"

    include "start_up.asm"

; Beyond this point is RAM.
    undefine mspace
    define mspace 1
    outend  ; No bytes should be generated from now on.

    include "ram_defs.asm"
