#!/usr/bin/env bash
set -euo pipefail
TARGET=$1

qemu-system-gnuarmeclipse \
    -cpu cortex-m4 \
    -machine STM32F4-Discovery \
    -gdb tcp::3333 \
    -nographic \
    -kernel "${TARGET}" > /dev/null &
QEMU_PID=$!

if [ ! -d "/proc/${QEMU_PID}" ]
then
    echo -ne "\033[31m Failed to start QEMU"
    echo -e "\033[0m"
    exit 1
fi

function read_address() {
    local ADDRESS=$1
    VALUE=$(gdb-multiarch \
        -q "${TARGET}" \
        -ex "target remote :3333" \
        -ex "x/1xw ${ADDRESS}" \
        --batch | tail -1 | cut -f 2)
}

function test_address() {
    local ADDRESS=$1
    local REGISTER_NAME=$2
    local EX_VALUE=$3

    read_address "${ADDRESS}"
    if [ "$VALUE" = "${EX_VALUE}" ]
    then
        echo -ne "\033[32m✓ ${REGISTER_NAME} correctly set to ${EX_VALUE}"
    else
        echo -ne "\033[31m✘ ${REGISTER_NAME} was ${VALUE}, want ${EX_VALUE}"
    fi

    echo -e "\033[0m"
}

test_address "0x40023830" "AHB1ENR" "0x00000001"
test_address "0x40020000" "GPIOA_MODER" "0xa8010000"
test_address "0x40020014" "GPIOA_ODR" "0x00000100"

kill ${QEMU_PID} &> /dev/null
