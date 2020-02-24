build:
	mkdir -p output
	arm-none-eabi-as -mcpu=cortex-m4 gpio-toggle.s -c -o output/gpio-toggle.o
	arm-none-eabi-ld -T link.ld output/gpio-toggle.o -o output/gpio-toggle
