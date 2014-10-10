#!/bin/bash

STATE=$(head -n1 /sys/class/extcon/extcon0/state)

if [ "$STATE" == "USB=1" ]; then
    /usr/bin/mgusb start
    # bring up both interfaces, then check which one is actually
    # "connected", i.e. used by the host. Then take down the
    # unused one, so we don't end up with two interfaces on the same IP
    /sbin/ifup -v -f usb0
    /sbin/ifup -v -f usb1

    # FIXME: this should really be a loop, not a fixed delay...
    sleep 2  

    usb0=$(cat /sys/class/net/usb0/carrier)
    usb1=$(cat /sys/class/net/usb1/carrier)

    if [ "$usb1" == "1" ]; then
        echo "usb1 is up, bringing usb0 down..."
        /sbin/ifdown -f usb0
        dhcpconf=/etc/udhcpd.usb1.conf
    else
        if [ "$usb0" == "1" ]; then
            echo "usb0 is up, bringing usb1 down..."
            /sbin/ifdown -f usb1
	    dhcpconf=/etc/udhcpd.usb0.conf
        fi
    fi

    # make sure leases file exists, busybox bails out otherwise
    killall -9 udhcpd
    touch /tmp/udhcpd.leases
    /usr/sbin/udhcpd -S $dhcpconf
else
    killall -9 udhcpd
    /sbin/ifdown -f usb0
    /sbin/ifdown -f usb1
    /usr/bin/mgusb stop
fi
