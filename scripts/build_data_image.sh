#!/bin/bash

MG=/home/marcus/mg
IMAGES=$MG/output-olimex-som/images

cd $IMAGES
cp data-sw-description sw-description
VERSION=`grep "version = " sw-description | awk -F '"' '{print $2}'`
NAME="data"

tar -zcf datafs.tar.gz -C $MG/external/datafs .

FILES="sw-description datafs.tar.gz data_cleanup.sh"

for i in $FILES; do
        echo $i; done | cpio -ov -H crc > ${NAME}-${VERSION}.swu
