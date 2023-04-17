#!/bin/bash

ct-ng-env $(cat ./.ct-ng-version) ~/.ct-ng-$(cat ./.ct-ng-version)
source ~/.ct-ng-$(cat ./.ct-ng-version)/activate

mkdir -p output/downloads
export CT_PREFIX=${PWD}/output

TAG=2023.04.01
MTIME="2023-04-01 00:00Z"

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
    hub release create -m "v${TAG}" \
           -a output/avr.tar.gz \
           -a output/avr.tar.gz.sha256 \
           -a output/aarch64-rpi3-linux-gnu.tar.gz \
           -a output/aarch64-rpi3-linux-gnu.tar.gz.sha256 \
           -a output/arm-cortex_a8-linux-gnueabihf.tar.gz \
           -a output/arm-cortex_a8-linux-gnueabihf.tar.gz.sha256 \
           -a output/armv6-rpi-linux-gnueabihf.tar.gz \
           -a output/armv6-rpi-linux-gnueabihf.tar.gz.sha256 \
           "v${TAG}"
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
