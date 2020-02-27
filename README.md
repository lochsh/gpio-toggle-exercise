# Getting started with ARM assembly
This includes some resources for learning about ARM assembly, including an
exercise for toggling a GPIO on an STM32 microcontroller, with emulation for
testing.

## Where to begin?

This ["Introduction to ARM assembly basics" from Azeria labs](https://azeria-labs.com/writing-arm-assembly-part-1/)
is a great starting point, but it does assume some knowledge of computer
architecture and hardware.

These are some key concepts that are worth making sure you have a basic
understanding of first:

### Register
Our ARM processor will have a small number of very fast, small storage
locations, called registers. These are directly accessed by the CPU. Some are
used for general purpose storage, others have specific purposes, like the
program counter register (PC). The CPU is hardwired to execute whatever
instruction is at the memory location stored in the PC.

In our exercise, we will be writing assembly to run on an STM32F4
microcontroller. The microcontroller contains a Cortex M4 CPU, flash memory,
RAM, and a lot of peripherals. Some peripherals are used for specific purposes,
like communication over a protocol. There are also General Purpose Input Output
peripherals.

Each of these peripherals has registers associated with it, which are mapped in
memory. The peripherals can be controlled by writing to these registers. This
is what our coding exercise will consist of.

### Instruction
You can think of a CPU instruction as the smallest possible unit of software
that a CPU can execute. When you compile a executeable C program, it is
compiled to machine code, and that machine code is made up of instructions.

When we write assembly, we are writing out instructions in a human readable
format, instead of writing the raw machine code.

The CPU processes instructions by:
1. *fetching* the next instruction to be executed (from the program counter
        register we mentioned above)
2. *decoding* the instruction is the CPU interpreting the instruction and
preparing to execute
3. *executing* the instruction

## ARM assembly coding exercise
`gpio-toggle.s` contains a partly complete ARM assembly coding exercise, with
comments explaining the existing code and what to do.

The comments also link to the Cortex M4 User Guide and the reference manual for
various STM32F4 models, which you'll need during the exercise

### Using docker for testing the assembly you write in the exercise
Docker can be used to run the tests for the exercise so that you can check your
assembly is doing the right thing, even if you don't have a development board
to run your code on. We use a [distribution](https://xpack.github.io/qemu-arm/)
of [QEMU](https://www.qemu.org/), the emulation tool.

Installation: https://docs.docker.com/install/

Then, you can run the tests like this:
```bash
$ docker build -t gpio-toggle .
$ docker run gpio-toggle
```

This should give you output similar to this:
```
✓ AHB1ENR correctly set to 0x00000001
✘ GPIOA_MODER was 0xa8000000, want 0xa8010000
✘ GPIOA_ODR was 0x00000000, want 0x00000100
```


### Testing the assembly without Docker
It's intended that the testing is done via Docker for the sake of portability.
If you're willing to figure some things out for yourself, here is what you need
to run the tests without Docker:

* https://xpack.github.io/qemu-arm/
* binutils-arm-none-eabi
* gdb-multiarch

`make test` will run the tests, assuming that `qemu-system-gnuarmeclipse` is
on the path.

### Running the code on real hardware
Getting this working is dependent on what hardware you have, but `make flash`
should program over a [Black Magic](https://github.com/blacksphere/blackmagic/wiki)
probe. The exercise toggles GPIOA8, which is connected to an LED on a
[1bitsy](https://1bitsy.org/).
