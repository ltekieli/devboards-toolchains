#!/bin/bash

ct-ng-env $(cat ./.ct-ng-version) ~/.ct-ng-$(cat ./.ct-ng-version)
source ~/.ct-ng-$(cat ./.ct-ng-version)/activate

mkdir -p output/downloads
export CT_PREFIX=${PWD}/output

function _build() {
    CONFIG=$1
    DEFCONFIG="${CONFIG}_defconfig" ct-ng defconfig
    ct-ng -j$(nproc) build
    
    tar -c \
        --sort=name \
        --mtime="2021-12-01" \
        --owner=0 \
        --group=0 \
        --numeric-owner \
        -C output/${CONFIG} . \
        | gzip -n > output/${CONFIG}.tar.gz

    sha256sum output/${CONFIG}.tar.gz > output/${CONFIG}.tar.gz.sha256
}

_build aarch64-rpi3-linux-gnu
_build arm-cortex_a8-linux-gnueabihf
_build armv6-rpi-linux-gnueabihf
