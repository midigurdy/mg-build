#!/bin/bash

MG=/home/marcus/mgurdy
DEV=/dev/mmcblk0
IMAGES=$MG/build/output/images

dd if=/dev/zero of=$DEV bs=1M count=1

sfdisk $DEV < $MG/mg-build/board/sdcard.sfdisk

# stride = page size / fs block size (4096)
# stripe-width = erase block size / page size
#
# for Samsung EVO 32GB: 8k page size, 16MB erase block size => stride=2, stripe-width=2048
# for SanDisk Ultra 16GB: 8k page size, 2MB erase block size => stride=2, stripe-width=256
mkfs.ext4 -E stride=2,stripe-width=2048 -b 4096 -L MGDATA ${DEV}p3

# Copy u-boot image and environment
dd if=$IMAGES/u-boot-sunxi-with-spl.bin of=$DEV bs=1024 seek=8
dd if=$IMAGES/uboot-env.bin of=$DEV bs=1024 seek=544

# Copy system partition
dd if=$IMAGES/rootfs.ext2 of=${DEV}p1 bs=16M
sync
