#!/bin/bash

# Named pipe for communication with mgurdy main program
# open read/write so open doesn't block if mgurdy is not
# running yet
exec 3<>/tmp/mgurdy

CURR_CONFIG_FILE=/sys/devices/platform/soc@01c00000/1c13000.usb/musb-hdrc.1.auto/gadget/configuration
PREV_CONFIG_FILE=/tmp/udc_configuration

if [ -f $PREV_CONFIG_FILE ]; then
   PREV=$(cat $PREV_CONFIG_FILE)
else
   PREV="-1"
fi

for i in 1 2 3 4 5; do
   CONFIG=$(cat $CURR_CONFIG_FILE)
   if [ "$CONFIG" == "$PREV" ]; then
        sleep 1
   else
        echo $CONFIG > $PREV_CONFIG_FILE
        echo "CHANGE internal udc $CONFIG" >> /tmp/mgurdy
        break
   fi
done
