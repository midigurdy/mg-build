#!/bin/bash

# Set the I2C IRQ and kernel thread cpu affinity. Executed 
# at system start. Needed to prevent a stuck I2C bus on poweroff,
# when CPU1 is already shut down and the I2C subsystem waits for a
# completion on that CPU.

source /usr/bin/mgprio_helper.sh

function set_priorities() {
    prio 1 50 "mv64xxx_i2c" "irq"
}

set_priorities
