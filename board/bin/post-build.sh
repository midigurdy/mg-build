#!/bin/sh

# Available environment vars:
#   BR2_CONFIG: the path to the Buildroot .config file
#   HOST_DIR, STAGING_DIR, TARGET_DIR: self explanatory
#   BUILD_DIR: the directory where packages are extracted and built
#   BINARIES_DIR: the place where all binary files (aka images) are stored
#   BASE_DIR: the base output directory
#   BR2_EXTERNAL_MG_PATH: absolute path to external directory
#
# Available arguments:
#   $1    same as TARGET_DIR
#   $2    BR2_EXTERNAL path (set via BR2_ROOTFS_POST_SCRIPT_ARGS)
#

MKIMAGE=$HOST_DIR/usr/bin/mkimage

# Compile u-boot boot script
$MKIMAGE -A arm -O linux -T script -C none -d $2/board/uboot/boot.cmd $1/boot/boot.scr

# Fix ssh host key permissions
find $1/etc/ssh -name "*key" -exec chmod 600 {} \;

VERSION=`cat $1/etc/mg-version`

# Write the current version to the splash image and convert it to mono (for /dev/fb0)
# and raw (for direkt i2c transfer) formats
convert $2/board/splash/base.bmp -fill black -font $2/board/splash/font.bdf -pointsize 7 -draw "text 30,28 'Version $VERSION'" $1/boot/splash.mono
$2/board/splash/ssd1307.py $1/boot/splash.mono $1/boot/splash.raw

# Write current version to swupdate description and copy to image dir
cat $2/board/swupdate/system-sw-description | sed "s/MIDIGURDY_VERSION/$VERSION/" > $BINARIES_DIR/system-sw-description
cat $2/board/swupdate/data-sw-description | sed "s/MIDIGURDY_VERSION/$VERSION/" > $BINARIES_DIR/config-sw-description
cp $2/board/swupdate/data_cleanup.sh $BINARIES_DIR/data_cleanup.sh
