#!/bin/bash
#
# Usage ./build-memory-injector.sh

set -ex

function exit_with_error() {
    error=$1
    echo "ERROR: $error"
    exit 1
}

if [ ! -f "/root/.build_gpu/update" ] && [ ! -f "/root/.build_gpu/update_memory_injector" ]; then
    exit 0
fi

SRC_PATH=/root/.build_gpu/memory-injector
export HOME=/root
mkdir -p /root/.build_gpu/.stamp || true

if [ ! -d "$SRC_PATH" ]; then
    exit_with_error "$SRC_PATH does not exist"
fi

if [ ! -f "/root/.build_gpu/.stamp/BUILD_MEMORY_INJECTOR" ]; then
    KDIR=/lib/modules/$(uname -r)/build
    if [ ! -d "$KDIR" ]; then
        exit_with_error "Kernel build directory $KDIR does not exist"
    fi
    apt-get install -y make gcc || true

    cd $SRC_PATH
    make clean || true
    make -j$(nproc) || exit_with_error "Compiling memory injector has failed"

    install -D -m 644 memory_injector.ko /lib/modules/$(uname -r)/extra/memory_injector.ko || exit_with_error "Installing memory injector has failed"
    depmod -a
    echo "memory_injector" > /etc/modules-load.d/memory-injector.conf
    touch /root/.build_gpu/.stamp/BUILD_MEMORY_INJECTOR
fi

rm -f /root/.build_gpu/update_memory_injector
exit 0
