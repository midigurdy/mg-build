#!/bin/bash

CFS=/sys/kernel/config
G=$CFS/usb_gadget/g1
UDC="musb-hdrc.1.auto"

mgusb_stop() {
    if [ ! -d ${G} ]; then
        echo "Gadget not configured"
        exit 1
    fi

    if [ "$(cat ${G}/UDC)" != "" ]; then
        echo "" > ${G}/UDC
    fi

    rm -rf ${G}/configs/c.1/midi.usb0
    rm -rf ${G}/configs/c.1/ecm.usb0

    rm -rf ${G}/configs/c.2/midi.usb0
    rm -rf ${G}/os_desc/c.2
    rm -rf ${G}/configs/c.2/rndis.usb0

    rmdir ${G}/functions/midi.usb0
    rmdir ${G}/functions/rndis.usb0
    rmdir ${G}/functions/ecm.usb0

    rmdir ${G}/configs/c.1/strings/0x409
    rmdir ${G}/configs/c.1

    rmdir ${G}/configs/c.2/strings/0x409
    rmdir ${G}/configs/c.2

    rmdir ${G}/strings/0x409
    rmdir ${G}
}

mgusb_start() {
    mount -t configfs none ${CFS}

    if [ ! -d ${CFS}/usb_gadget ]; then
        modprobe libcomposite
    fi

    if [ -d ${G} ]; then
        if [ "$(cat ${G}/UDC)" != "" ]; then
            echo "Gadget already configured"
            exit 1
        fi
    fi

    device="0x3002" # increment on breaking change
    ms_vendor_code="0xcd" # Microsoft
    ms_qw_sign="MSFT100" # also Microsoft (if you couldn't tell)
    ms_compat_id="RNDIS" # matches Windows RNDIS Drivers
    ms_subcompat_id="5162001" # matches Windows RNDIS 6.0 Driver
    usb_ver="0x0200" # USB 2.0

    mkdir ${G}
    echo "${usb_ver}" > ${G}/bcdUSB
    echo "0xEF" > ${G}/bDeviceClass
    echo "0x02" > ${G}/bDeviceSubClass
    echo "0x01" > ${G}/bDeviceProtocol
    echo "0x05e8" > ${G}/idVendor
    echo "0xa4a1" > ${G}/idProduct
    echo "${device}" > ${G}/bcdDevice
    mkdir ${G}/strings/0x409
    echo "00001" > ${G}/strings/0x409/serialnumber
    echo "Marcus Weseloh" > ${G}/strings/0x409/manufacturer
    echo "MidiGurdy" > ${G}/strings/0x409/product

    # RNDIS Ethernet Function
    mkdir ${G}/functions/rndis.usb0

    # On Windows 7 and later, the RNDIS 5.1 driver would be used by default,
    # but it does not work very well. The RNDIS 6.0 driver works better. In
    # order to get this driver to load automatically, we have to use a
    # Microsoft-specific extension of USB.

    echo "1" > ${G}/os_desc/use
    echo "${ms_vendor_code}" > ${G}/os_desc/b_vendor_code
    echo "${ms_qw_sign}" > ${G}/os_desc/qw_sign

    echo "36:bb:07:64:8b:90" > ${G}/functions/rndis.usb0/host_addr
    echo "0a:e8:92:78:32:05" > ${G}/functions/rndis.usb0/dev_addr
    echo "${ms_compat_id}" > ${G}/functions/rndis.usb0/os_desc/interface.rndis/compatible_id
    echo "${ms_subcompat_id}" > ${G}/functions/rndis.usb0/os_desc/interface.rndis/sub_compatible_id

    # CDC/ECM Ethernet Function
    mkdir ${G}/functions/ecm.usb0
    echo "36:bb:07:64:8b:91" > ${G}/functions/ecm.usb0/host_addr
    echo "0a:e8:92:78:32:06" > ${G}/functions/ecm.usb0/dev_addr

    # MIDI Function
    mkdir ${G}/functions/midi.usb0
    echo "midigurdy" > ${G}/functions/midi.usb0/id

    # CONFIG 1: CDC/ECM + MIDI
    mkdir ${G}/configs/c.1
    mkdir ${G}/configs/c.1/strings/0x409
    echo "Config 1" > ${G}/configs/c.1/strings/0x409/configuration
    echo 1 > ${G}/configs/c.1/MaxPower

    ln -s ${G}/functions/ecm.usb0 ${G}/configs/c.1
    ln -s ${G}/functions/midi.usb0 ${G}/configs/c.1

    # CONFIG 2: RNDIS + MIDI
    mkdir ${G}/configs/c.2
    mkdir ${G}/configs/c.2/strings/0x409
    echo "Config 2" > ${G}/configs/c.2/strings/0x409/configuration
    echo 1 > ${G}/configs/c.2/MaxPower

    ln -s ${G}/functions/rndis.usb0 ${G}/configs/c.2
    ln -s ${G}/configs/c.2 ${G}/os_desc
    ln -s ${G}/functions/midi.usb0 ${G}/configs/c.2

    # BIND
    echo musb-hdrc.1.auto > ${G}/UDC
}


case $@ in
    start)
        mgusb_start
        ;;
    stop)
        mgusb_stop
        ;;
    *)
        echo "Usage: mgusb start|stop"
        exit 1
        ;;
esac
