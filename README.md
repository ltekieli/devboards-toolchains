# devboards-toolchains
Collection of crosstool-ng toolchains for differents dev boards:
- aarch64-rpi3-linux-gnu_defconfig - **raspberry pi 3b+**
- arm-cortex_a8-linux-gnueabihf_defconfig - **beaglebone black**
- armv6-rpi-linux-gnueabihf_defconfig - **raspberry pi zero w**

## Prerequisites
- [ct-ng-env](https://github.com/ltekieli/ct-ng-env)

## Usage
Get the correct version of crosstool-ng:
```
$ ct-ng-env $(cat ./.ct-ng-version) ~/.ct-ng-current
$ source ~/.ct-ng-current/activate
```

Build a toolchain:
```
$ mkdir -p output/downloads
$ export CT_PREFIX=${PWD}/output
$ DEFCONFIG=aarch64-rpi3-linux-gnu_defconfig ct-ng defconfig
$ ct-ng build

$ tree -L 1 output/
output/
├── aarch64-rpi3-linux-gnu
└── downloads
```
