#!/bin/bash

BUILDROOT_VERSION=2018.02.5
BUILDROOT_URL=https://buildroot.org/downloads/buildroot-$BUILDROOT_VERSION.tar.gz

if [ ! -d $1 ]; then
    echo "Please specify a path to the directory where you checked out the mg-build repository"
    exit 1;
fi

if [ "$2" == "" ]; then
    echo "Please specify a path to the new build directory as second argument"
    exit 1;
fi

EXTERNAL_DIR=`realpath $1`
BASE_DIR=`realpath $2`

BUILDROOT_DIR=$BASE_DIR/buildroot
OUTPUT_DIR=$BASE_DIR/output

if [ -e $BASE_DIR ]; then
    echo "Build dir exists already, exiting."
    exit 1;
fi

if ! mkdir -p $BASE_DIR > /dev/null; then
    echo "Unable to create build directory"
    exit 1;
fi

if ! mkdir $BUILDROOT_DIR > /dev/null; then
    echo "Unable to create buildroot directory"
    exit 1;
fi

if ! wget $BUILDROOT_URL -q --progress=bar:force:noscroll --show-progress -O - | tar zxf - --strip-components=1 -C $BUILDROOT_DIR; then
    echo "Unable to download and extract buildroot"
    exit 1;
fi

if ! mkdir $OUTPUT_DIR > /dev/null; then
    echo "Unable to create output directory"
    exit 1;
fi

cd $BUILDROOT_DIR
if ! make BR2_EXTERNAL=$EXTERNAL_DIR O=$OUTPUT_DIR a20_olimex_som_mgurdy_defconfig > /dev/null; then
    echo "Unable to configure build environment"
    exit 1;
fi

echo "MidiGurdy build environment set up successfully."
echo "To start a build, change to the output directory and call make:"
echo
echo "   cd $OUTPUT_DIR"
echo "   make"
echo
echo "Then get a coffee... or ten, this will take a while! :-)"
