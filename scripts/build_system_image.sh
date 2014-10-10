#!/bin/bash

MG=/home/marcus/mg
IMAGES=$MG/output-olimex-som/images

cd $IMAGES
cp system-sw-description sw-description
VERSION=`grep "version = " sw-description | awk -F '"' '{print $2}'`
NAME="midigurdy"

gzip -c rootfs.ext2 > rootfs.ext2.gz

FILES="sw-description rootfs.ext2.gz"

for i in $FILES; do
        echo $i; done | cpio -ov -H crc > ${NAME}-${VERSION}.swu
