#!/bin/bash

ct-ng-env $(cat ./.ct-ng-version) ~/.ct-ng-$(cat ./.ct-ng-version)
source ~/.ct-ng-$(cat ./.ct-ng-version)/activate

mkdir -p output/downloads
export CT_PREFIX=${PWD}/output

TAG=2024.11.01
MTIME="2024-11-01 00:00Z"

function _build() {
    CONFIG=$1
    DEFCONFIG="${CONFIG}_defconfig" ct-ng defconfig
    ct-ng -j$(nproc) build

    tar -c \
        --sort=name \
        --mtime="${MTIME}" \
        --owner=0 \
        --group=0 \
        --numeric-owner \
        -C output/${CONFIG} . \
        | gzip -n > output/${CONFIG}.tar.gz

    sha256sum output/${CONFIG}.tar.gz > output/${CONFIG}.tar.gz.sha256
}

function _release() {
    gh release create "v${TAG}" \
        output/avr.tar.gz \
        output/avr.tar.gz.sha256 \
        output/aarch64-rpi3-linux-gnu.tar.gz \
        output/aarch64-rpi3-linux-gnu.tar.gz.sha256 \
        output/arm-cortex_a8-linux-gnueabihf.tar.gz \
        output/arm-cortex_a8-linux-gnueabihf.tar.gz.sha256 \
        output/armv6-rpi-linux-gnueabihf.tar.gz \
        output/armv6-rpi-linux-gnueabihf.tar.gz.sha256
}

function help() {
    ct-ng version
}

if [ $# -eq 0 ]; then
    _build avr
    _build aarch64-rpi3-linux-gnu
    _build arm-cortex_a8-linux-gnueabihf
    _build armv6-rpi-linux-gnueabihf
    _build x86_64-unknown-linux-gnu
else
    "$@"
fi
