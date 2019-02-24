#!/bin/bash

if [ "$1" == "start" ]; then
    modprobe bridge

    /usr/bin/mgusb start

    /usr/sbin/brctl addbr br0
    /usr/sbin/brctl addif br0 usb0
    /usr/sbin/brctl addif br0 usb1
    /sbin/ifconfig usb0 up
    /sbin/ifconfig usb1 up
    /sbin/ifup br0

    # make sure leases file exists, busybox bails out otherwise
    killall -9 udhcpd
    touch /tmp/udhcpd.leases
    /usr/sbin/udhcpd -S /etc/udhcpd.br0.conf
else
    killall -9 udhcpd
    /sbin/ifdown br0
    /sbin/ifconfig usb0 down
    /sbin/ifconfig usb1 down
    /usr/sbin/brctl delif br0 usb0
    /usr/sbin/brctl delif br0 usb1
    /usr/sbin/brctl delbr br0

    /usr/bin/mgusb stop
fi
