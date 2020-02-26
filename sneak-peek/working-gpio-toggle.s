    .cpu cortex-m4
    .global main
    .thumb
    .thumb_func
    .syntax unified
main:
    @ RCC start address 0x40023800
    movw r0, #0x3800
    movt r0, #0x4002

    @ Enable GPIOA clock
    movw r1, #0x01
    str r1, [r0, #0x30]

    @ GPIOA start address 0x40020000
    movw r0, #0x0000
    movt r0, #0x4002

    @ Set PA8 to output
    movw r1, #0x0000
    movt r1, #0xA801
    str r1, [r0]

.loop:
    @ Set PA8 off
    movw r1, #0x0100
    str r1, [r0, #0x18]
    bkpt

    @ Delay
    movw r2, #0x3500
    movt r2, #0x000c
.L1:
    subs r2, #0x0001
    bne .L1

    @ Set PA8 on
    movw r1, #0x0000
    movt r1, #0x0100
    str r1, [r0, #0x18]

    @ Delay
    movw r2, #0x3500
    movt r2, #0x000c
.L2:
    subs r2, #0x0001
    bne .L2

    b .loop

    .cpu cortex-m4
    .global handler
    .thumb
    .thumb_func
    .syntax unified
handler:
    b handler

.section .vector_table.reset_vector
.word main
