#!/bin/bash

remove_action () {
  umount ${1}
}

# At bootup, "mdev -s" is called.  It does not pass any environmental
# variables other than MDEV.  If no ACTION variable is passed, exit
# the script.
if [ ! -b ${MDEV} ] ; then exit 0 ; fi

mountdir="/tmp/mnt"

# Flag for whether or not we have a partition.  0=no, 1=yes, default no
partition=0

# Check for various conditions during an "add" operation
if [ "X${ACTION}" == "Xadd" ] ; then
   # Flag for mounting if it's a regular partition
   if [ "X${DEVTYPE}" == "Xpartition" ] ; then
      partition=1 ;
#
# Further checks if DEVTYPE is disk; looking for weird setup where the
# entire USB key is formatted as one partition, without the standard
# partition table.
   elif [ "X${DEVTYPE}" == "Xdisk" ] ; then
    # If it's "disk", check for string "FAT" in first 512 bytes of device.
    # Flag as a partition if the string is found.
      if dd if=${MDEV} bs=512 count=1 2>/dev/null | grep "FAT" 1>/dev/null ; then
         partition=1
      fi
   fi
fi

# check for various conditions during a "remove" operation
if [ "X${ACTION}" == "Xremove" ] ; then
   # Check for a disk or regular partition
   if [ "X${DEVTYPE}" == "Xpartition" ] || [ "X${DEVTYPE}" == "Xdisk" ] ; then

      # Flag for unmounting if device exists in /proc/mounts mounted somewhere
      # under the ${mountdir} directory.
      if grep "^/dev/${MDEV} ${mountdir}/" /proc/mounts 1>/dev/null ; then
         partition=1
      fi
   fi
fi

# If not flagged as a partition, bail out.
if [ ${partition} -ne 1 ] ; then exit 0 ; fi

# The "add" action.
if [ "X${ACTION}" == "Xadd" ] ; then

   # Create the mountpoint
   mkdir -p ${mountdir}/${MDEV}

   # Mount the partition
   mount /dev/${MDEV} ${mountdir}/${MDEV}

   # Attempt to find the latest version of the update files on the drive, and start the upgrade if found
   # sed - remove leading path from filename
   # sort - reverb sort by version numbers (three fields, offset first field by length of "midigurdy-" string)
   # head - return only the first result
   LATEST_VERSION=$(
        find ${mountdir}/${MDEV} -maxdepth 1 -name "midigurdy-*.swu" 2> /dev/null \
        | sed -r -e 's/.*-([0-9]+\.[0-9]+\.[0-9A-Za-z-]+).swu/\1/' \
        | sed -r -e 's/-([a-zA-Z]+)([0-9]*)/.\1.\2/' \
        | sed -r -e 's/([0-9]+\.[0-9]+\.[0-9]+)$/\1.zz.9999/' \
        | sort -t . -k1,1nr -k2,2nr -k3,3nr -k4,4r -k5,5nr \
        | sed -r -e 's/\.zz\.9999//' \
        | sed -r -e 's/\.([a-zA-Z]+)\.([0-9]*)/-\1\2/' \
        | head -1)
   if [ "${LATEST_VERSION}" ]; then
       UPDATE_FILE="midigurdy-${LATEST_VERSION}.swu"
       mgupdate.sh ${mountdir}/${MDEV}/${UPDATE_FILE} /dev/${MDEV} "${LATEST_VERSION}" &
   fi

# The "remove" action.
elif [ "X${ACTION}" == "Xremove" ] ; then
   # Get info from /proc/mounts, and call remove_action to unmount the
   # device and remove the associated directory
   procmounts=`grep "^/dev/${MDEV} ${mountdir}/${MDEV}" /proc/mounts`
   echo $procmounts >> /tmp/mdev.log
   umount ${procmounts}
fi
