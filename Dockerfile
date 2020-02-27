FROM ubuntu:18.04

# Install dependencies
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    binutils-arm-none-eabi \
    gdb-multiarch \
    wget \
    build-essential \
    xorg

RUN wget https://github.com/xpack-dev-tools/qemu-arm-xpack/releases/download/v2.8.0-8/xpack-qemu-arm-2.8.0-8-linux-x64.tgz && \
        tar xvf xpack-qemu-arm-2.8.0-8-linux-x64.tgz

ENV PATH="xPacks/qemu-arm/2.8.0-8/bin:${PATH}"

# Copy necessary files
COPY gpio-toggle.s .
COPY link.ld .
COPY Makefile .
COPY test.sh .

CMD make test
