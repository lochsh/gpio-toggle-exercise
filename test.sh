#!/usr/bin/env bash
set -eu
TARGET=$1

qemu-system-gnuarmeclipse \
    -cpu cortex-m4 \
    -machine STM32F4-Discovery \
    -nographic \
    -semihosting-config enable=on,target=native \
    -gdb tcp::3333 \
    -kernel $1 &> /dev/null &
QEMU_PID=$!

function read_address() {
    local ADDRESS=$1
    VALUE=$(gdb-multiarch \
        -q ${TARGET} \
        -ex "target remote :3333" \
        -ex "x/1xw ${ADDRESS}" \
        --batch | tail -1 | cut -f 2)
}

function test_address() {
    local ADDRESS=$1
    local REGISTER_NAME=$2
    local EX_VALUE=$3

    read_address ${ADDRESS}
    if [ $VALUE = ${EX_VALUE} ]
    then
        echo -e "\033[32m✓ ${REGISTER_NAME} set correctly to ${EX_VALUE}"
    else
        echo -e "\033[31m✘ ${REGISTER_NAME} was ${VALUE}, want ${EX_VALUE}"
    fi
}

test_address "0x40023830" "AHB1ENR" "0x00000001"
test_address "0x40020000" "GPIOA_MODER" "0xa8010000"
test_address "0x40020014" "GPIOA_ODR" "0x00000100"

kill ${QEMU_PID} &> /dev/null
