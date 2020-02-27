/*
   This is a Thumb-2 assembly coding exercise for toggling GPIOA8 on an
   STM32F415 microcontroller. The first two steps have been done for you as an
   example to get you started.

   We will be using the following references:
    [cpu-user-guide]
    http://infocenter.arm.com/help/topic/com.arm.doc.dui0553b/DUI0553.pdf
    This document tells about the assembly we will be writing.

    [mcu-ref-man]
    https://tinyurl.com/f4-ref-man
    This document tells us about the functioning of our microcontroller, which
    will inform what code we will write.

    You should have these open as you work through the exercise.
*/

/*
   You can happily ignore this line and its explanation.

   This preamble tells the assembler what syntax to use for this file. It used
   to be that Thumb and ARM encoded instructions had different syntaxes. The
   introduction of the ARM "Unified Assembler Language" means we can use the
   same syntax for both.
*/
.syntax unified

/*
   The assembly we write will become binary machine code via a defined
   encoding. ARM assembly can have two encodings: ARM and Thumb.

   This preamble tells the assembler that this function is Thumb encoded. This
   is important because our target only supports this encoding.

   The preamble also tells the assembler to expose the symbol `main` to the
   linker.
 */
.thumb_func
.global main
main:
    /*
       In order to use a GPIO, we must enable its clock. If its clock is not
       enabled, it is effectively switched off, and will not respond to any
       reads or writes. The clock defaults to being off in order to save power.

       Section 2.3 in [mcu-ref-man] Section 2.3 shows the memory map of our
       microcontroller, the STM32F4. Look for the "RCC" entry. RCC stands for
       Reset and Clock Control. You should see that the start address for
       registers of this type is 0x40023800.

       Our first task is to store this address in a register. Let's choose r0.
       We can only pass a 16 bit number as the instruction's operand, so we do
       this in two steps. You can read more about these instructions in
       [cpu-user-guide] Sections 3.1 and 3.5.6.
    */
    movw r0, #0x3800  @ Copy 0x3800 to the bottom half of r0
    movt r0, #0x4002  @ Copy 0x4002 to the top half of r0 (t stands for top)

    /*
       r0 now stores the memory address that marks the start of the Reset and
       Clock Control registers. Now we want to look up what register is needed
       for enabling the GPIOA clock.

       In [mcu-ref-man] 7.3.24, there is a map of all the RCC registers. If you
       search for "GPIOAEN", you should see that the register with offset 0x30
       is what we need, and we need to set bit 0.

       You can read more about the str (store) instruction in [cpu-user-guide]
       3.1 and 3.4.2.
    */
    @ Set bit 0 in register r1
    movw r1, #0x01

    @ Store value in r1 at the memory address in r0 with offset 0x30
    str r1, [r0, #0x30]

    /*
       Now it's your turn to write some assembly.

       We've enabled GPIOA's clock, but now we need to set GPIOA to be an
       output. First, find the start address for GPIOA registers from the
       memory map in [mcu-ref-man], and store it in r0.
    */

    /*
       Have a look at [mcu-ref-man] 8.4 for information on GPIO registers. We
       want the GPIOA_MODER register which controls the mode of GPIO port A's
       16 pins. The MODER8 field will control what mode pin 8 is in.

       Find out:

           What is this register's offset from the address we just stored in
               r0?

           What value do we need to set the register to in order to set GPIOA8
               to an output (assuming we don't care about the other pins)?

       Now store that value in the GPIOA_MODER register as before.
    */
.loop:
    bkpt
    b .loop

.section .vector_table.reset_vector
.word main
