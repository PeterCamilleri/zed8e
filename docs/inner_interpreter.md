# Zed8E FORTH Inner Interpreter

Zed8E FORTH uses a direct threaded inner interpreter. This file will take
a deep dive into the design decisions that went into this code.

## Register Mapping

The FORTH virtual machine registers are mapped to the registers of the 
Z-80 are used as follows:

![Register Mapping](./Images/Registers.png)

* BC points to the next virtual machine word.
* IX is the virtual machine's return stack pointer.
* IY is a short-cut pointer to the virtual machine's next routine.
* SP is the virtual machine's data stack pointer.
* All other registers are working registers that are not preserved
accross words.
* Note: On entry to a word, HL points to the start address of that word.

## Code Words

The following shows the activity associated with a code word.

![Code Word](./Images/code_word.png)

As can be seen, the BC register points to a word in the code stream. That
word is fetched into the HL register and execution of the code word
begins at that address.
