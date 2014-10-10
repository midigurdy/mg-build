# Helper functions to set process and IRQ priorities.
# Used by mgprio.sh and i2cprio.sh

function get_irqs() {
    echo `grep $1 /proc/interrupts | awk -F: '{print \$1}'`
}

function get_irq_pids() {
    echo `ps | grep " \\[irq/$1-" | awk '{print $1}'`
}

# args: name prio cpu
function irq_prio() {
    local irqs=$(get_irqs $1)
    local irq
    for irq in $irqs; do
        local pids=$(get_irq_pids $irq)
        for pid in $pids; do
            chrt -f -p $2 $pid > /dev/null
            if [ "$3" != "-" ]; then
                local cpu=$3
                echo $3 > /proc/irq/$irq/smp_affinity
                taskset -p $3 $pid > /dev/null
            else
                local cpu="unchanged"
            fi
            echo "irq $1 (PID $pid) prio $2, cpu $cpu"
        done
    done
}

# args: name prio cpu
function proc_prio() {
    local pids=`pidof $1`
    local pid
    for pid in $pids; do
        chrt -f -p $2 $pid > /dev/null
        if [ "$3" != "-" ]; then
            local cpu=$3
            taskset -p $3 $pid > /dev/null
        else
            local cpu="unchanged"
        fi
        echo "proc $1 (PID $pid) prio $2, cpu $cpu"
    done
}

# arguments: cpu prio name (irq|proc)
function prio() {
    if [ "$4" == "irq" ]; then
        irq_prio $3 $2 $1
    else
        proc_prio $3 $2 $1
    fi
}
