# Zed8E FORTH Inner Interpreter

Zed8E FORTH uses a direct threaded inner interpreter. This file will take
a deep dive into the design decisions that went into this code.

## Register Mapping

The FORTH virtual machine registers are mapped to the registers of the
Z-80 as follows:

![Register Mapping](./Images/Registers.png)

* BC points to the next virtual machine word.
* IX is the virtual machine's return stack pointer.
* IY is a short-cut pointer to the virtual machine's next routine.
* SP is the virtual machine's data stack pointer.
* All other registers are working registers that are not preserved
across words.
* Note: On entry to a word, HL points to the start address of that word.

## About the rst #$nn instructions

The Z-80 has eight operation codes (inherited from the 8080) that are
specialized subroutine calls. These are the `rst #$nn` instructions. They
are single byte instructions that allow subroutines to be called at
certain specific addresses. When possible, Zed8E FORTH uses these
unusual instructions because they save space, 1 byte vs. 3 bytes and time,
11 clock cycles vs. 17 clock cycles. The big limitation of the `rst` op
codes is the target address which may only be: $00, $08, $10, $18, $20,
$28, $30, and $38. Thus `rst` handlers must be eight bytes or less or
straddle more than one `rst` allocation making overlapped targets
unavailable.

## Code Words

The following shows the activity associated with a code word.

![Code Word](./Images/code_word3.png)

As can be seen, the BC register points to a word in the code stream. That
word is fetched into the HL register and execution of the code word
begins at that address.

The simple code that gets this done is:

```
next:
    ld      a,(bc)      ; Fetch the next instruction.
    inc     bc
    ld      l,a
    ld      a,(bc)
    inc     bc
    ld      h,a
    jp      hl          ; Execute it.
```

## Threaded Words

The following shows the activity associated with a high level threaded word.

![Code Word](./Images/threaded_word2.png)

The action of the fetch and dispatch are unchanged. The key difference
is the `rst $08` instruction that invokes the do_colon handler located at
address $08. Recall that the `rst` instruction pushes the address of the
byte following it onto the stack. This code is shown below.

```
do_rst_08:
    ld      (ix),b      ; Push the IP onto the RS
    dec     ix
    ld      (ix),c
    dec     ix
    pop     bc          ; Get the address saved by rst #$08.

    ; code falls through to the "next" code (see above).
```

This code pushes the current virtual instruction pointer (bc) onto the FORTH
return stack and then pops the return address (put there by the rst $28)
into bc to start threaded execution there. The jump to next (via ix) starts
execution at the new starting point.

## Builds Does Code Words

This next section deals with classic FORTH `<builds ... does>` words where
the implementation of the `does>` portion is in assembly code.

![Builds Does Code Word](./Images/builds_does.png)

Since the target for the does portion can be almost anywhere in memory,
the restrictions of the `rst` instruction cannot be used and the full
three byte `call` instruction is required. The destination of this `call`
is the `does>` assembly code.
