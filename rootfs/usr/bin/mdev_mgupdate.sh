#!/bin/bash

MOUNTDIR="/tmp/mnt"

if [ "${ACTION}" == "add" ] ; then

    if grep -q "^/dev/${MDEV} " /proc/mounts ; then
        # Already mounted
        exit 0
    fi

    DEVBASE=`expr substr $MDEV 1 3`

    # check for full-disk partition
    if [ "${DEVBASE}" == "${MDEV}" ] ; then
        if [ -d /sys/block/${DEVBASE}/${DEVBASE}*1 ] ; then
            # Partition detected, just quit
            exit 0
        fi
        if [ ! -f /sys/block/${DEVBASE}/size ] ; then
            # No size info at all
            exit 0
        fi
        if [ `cat /sys/block/${DEVBASE}/size` == 0 ] ; then
            # Empty device, bail out.

            # But call blkid beforehand, as Some GPT/EFI sticks seem to need to
            # be woken up before their partitions are registered by the system.
            blkid >> /dev/null
            exit 0
        fi
    fi

    # Create the mountpoint
    mkdir -p ${MOUNTDIR}/${MDEV}

    # Mount the partition
    mount -t auto /dev/${MDEV} ${MOUNTDIR}/${MDEV}

    # Attempt to find the latest version of the update files on the drive, and start the upgrade if found
    # sed - remove leading path from filename
    # sort - reverb sort by version numbers (three fields, offset first field by length of "midigurdy-" string)
    # head - return only the first result
    LATEST_VERSION=$(
    find ${MOUNTDIR}/${MDEV} -maxdepth 1 -name "midigurdy-*.swu" 2> /dev/null \
        | sed -r -e 's/.*-([0-9]+\.[0-9]+\.[0-9A-Za-z-]+).swu/\1/' \
        | sed -r -e 's/-([a-zA-Z]+)([0-9]*)/.\1.\2/' \
        | sed -r -e 's/([0-9]+\.[0-9]+\.[0-9]+)$/\1.zz.9999/' \
        | sort -t . -k1,1nr -k2,2nr -k3,3nr -k4,4r -k5,5nr \
        | sed -r -e 's/\.zz\.9999//' \
        | sed -r -e 's/\.([a-zA-Z]+)\.([0-9]*)/-\1\2/' \
        | head -1)
    if [ "${LATEST_VERSION}" ]; then
        UPDATE_FILE="midigurdy-${LATEST_VERSION}.swu"
        mgupdate.sh ${MOUNTDIR}/${MDEV}/${UPDATE_FILE} /dev/${MDEV} "${LATEST_VERSION}" &
    fi

elif [ "${ACTION}" == "remove" ] ; then

    MOUNTPOINT=`grep "^/dev/$MDEV\s" /proc/mounts | cut -d' ' -f 2`

    if [ ! -z "$MOUNTPOINT" ]
    then
        umount "$MOUNTPOINT"
        rmdir "$MOUNTPOINT"
    else
        umount /dev/$MDEV
    fi
fi
