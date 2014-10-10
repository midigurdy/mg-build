#!/bin/bash

lock() {
    exec 200>/tmp/.mgupdate.lock

    flock -n 200 \
        && return 0 \
        || return 1
}

function get_target() {
    if grep -q root=/dev/mmcblk0p1 /proc/cmdline; then
        echo "stable,alt"
    else
        echo "stable,main"
    fi
}

function led_progress() {
    for i in 1 2 3; do
        echo timer > /sys/class/leds/string${i}/trigger
        usleep 100000
    done
}

function led_clear() {
    for i in 1 2 3; do
        echo none > /sys/class/leds/string${i}/trigger
        echo 0 > /sys/class/leds/string${i}/brightness
    done
}

function led_alert() {
    echo heartbeat > /sys/class/leds/string1/trigger
}

function led_on() {
    echo 255 > /sys/class/leds/string$1/brightness
}

function read_key() {
    dd if=/dev/input/event2 | hexdump -n 16 -v -e '4/1 "%02x" " "' | awk '{print $3}'
}

function stop_mgurdy() {
    /etc/init.d/S00mgurdy stop
}

function start_mgurdy() {
    exec /etc/init.d/S00mgurdy start
}

function wait_for_device_removal() {
    while [ -e $1 ]; do
        sleep 1
    done
}

lock || exit 1

UPDATE_TARGET=$(get_target)
UPDATE_IMAGE=$1
USB_DEVICE=$2
UPDATE_VERSION=$3

# stop mgurdy main
/etc/init.d/S00mgurdy stop

mgmessage.py $"Upgrade ${UPDATE_VERSION}\nPress GREEN to start\nother key to cancel"
led_clear
led_on 1
PRESSED=$(read_key)
if [ "$PRESSED" != "01007300" ]; then
    mgmessage.py $'Cancelled'
    led_clear

    # close lock FD, otherwise mgurdy will inherit the FD and keep it open
    exec 200>&-

    start_mgurdy
    exit 1;
fi

led_clear
led_progress
mgmessage.py $'Upgrading System\nDo not switch off!'

if swupdate -v -e $UPDATE_TARGET -i $UPDATE_IMAGE &> /data/upgrade.log; then
    led_clear
    led_on 1; led_on 2; led_on 3
    mgmessage.py $'Upgrade successful!\nPress key to reboot'
    read_key > /dev/null
else
    led_clear
    led_alert
    mgmessage.py $'UPGRADE FAILED!\nPress key to reboot'
    read_key > /dev/null
fi

if [ "$USB_DEVICE" != "" ]; then
    if [ -e $USB_DEVICE ]; then
        mgmessage.py $'Please remove the\nUSB Stick'
        wait_for_device_removal $USB_DEVICE
    fi
fi

mgmessage.py $'Rebooting...'
led_clear
reboot
