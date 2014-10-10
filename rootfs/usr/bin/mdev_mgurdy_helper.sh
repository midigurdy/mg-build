#!/bin/bash

# Named pipe for communication with mgurdy main program
# open read/write so open doesn't block if mgurdy is not
# running yet
exec 3<>/tmp/mgurdy

if [ "$SUBSYSTEM" == "sound" ] && [[ "$DEVNAME" =~ ^snd/midi ]]; then
   if [[ "$DEVPATH" =~ /gadget/sound/ ]]; then
       TYPE=internal
   else
       TYPE=external
   fi
   echo "$ACTION $TYPE midi /dev/$DEVNAME" >> /tmp/mgurdy
fi
