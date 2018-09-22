#!/bin/bash

# This scripts sets the priorities and cpu affinities of all relevant 
# threads and processes

source /usr/bin/mgprio_helper.sh

function set_priorities() {
    # wheel driver (mlx90363) uses these two, so we want them to be
    # services at top priority
    prio 1 99 "spi0"              "proc"
    prio 1 99 "spi1"              "proc"
    prio 1 80 "sun4i-spi"         "irq"

    # keyboard driver next
    prio 1 85 "1c25000.mgurdy_keys" "irq"

    # make sure timer interrupts are serviced before all "normal" irqs
    prio - 52 "ktimersoftd/0"     "proc"
    prio - 52 "ktimersoftd/1"     "proc"

    # Fix disk access and usb controller to fist CPU, as fluidsynth
    # and MidiGurdy UI and modelling runs on second CPU
    prio 1 50 "mmcqd/0"           "proc"
    prio 1 50 "sunxi-mmc"         "irq"
    prio 1 50 "musb-hdrc.1.auto"  "irq"

    # I2C controller can wait a little
    prio - 49 "mv64xxx_i2c" "irq"
}

set_priorities
