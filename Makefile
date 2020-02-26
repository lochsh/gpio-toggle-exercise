OUT=output/gpio-toggle
all: $(OUT)

$(OUT): gpio-toggle.s link.ld
	mkdir -p output
	arm-none-eabi-as -mcpu=cortex-m4 gpio-toggle.s -c -o output/gpio-toggle.o
	arm-none-eabi-ld -T link.ld output/gpio-toggle.o -o $@

test: $(OUT)
	bash test.sh $<

flash: $(OUT)
	gdb-multiarch -n --batch 				\
		-ex 'tar ext /dev/ttyACM0'  		\
		-ex 'mon tpwr en'					\
		-ex 'mon swdp_scan'					\
		-ex 'att 1' 						\
		-ex 'load' 							\
		-ex 'start' 						\
		-ex 'detach' 						\
		$<

debug: $(OUT)
	gdb-multiarch -n 						\
		-ex 'tar ext /dev/ttyACM0'  		\
		-ex 'mon tpwr en'					\
		-ex 'mon swdp_scan'					\
		-ex 'att 1' 						\
		$<

dis: $(OUT)
	arm-none-eabi-objdump -d $<
