#!/bin/sh

export DEVICE_ID=tokay
export MAGISK_PREINIT_DEVICE=sda10

bash -c '. rooted-ota.sh && createRootedOta'