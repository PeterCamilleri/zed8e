; Zed8E FORTH - A direct threaded FORTH for the Z-80
;
; This FORTH is designed to run on bare bones hardware with no O/S or
; other forms of interference or support.
;

    output "rom_image.dat"
    define mspace 0

    include "common.i"      ; Common macros and definitions.
    include "low_page.asm"  ; Code connected to specific Z-80 addresses.
    include "string.asm"    ; String handling primitive.

    include "dict_a.asm"    ; Stack Manipulation and Misc words.
    include "dict_b.asm"    ; Arithmetic and Logical words.

    ; Define the last entry in dictionary.
    define last_entry last_b
    include "start_up.asm"  ; The start up code.

; Beyond this point is RAM.
    undefine mspace
    define mspace 1         ; Data in RAM.
    outend  ; No bytes should be generated from now on.

    include "ram_defs.asm"
