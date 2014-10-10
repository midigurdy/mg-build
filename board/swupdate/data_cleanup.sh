#!/bin/sh

function do_preinst() {
    for i in `ls -1 /data/`; do
        if [ "$i" != "lost+found" ] && [ "$i" != "upgrade.log" ]; then
            rm -rf /data/$i
        fi
    done
}

case "$1" in
    preinst)
        do_preinst
        ;;

    postinst)
        ;;

    *)
        exit 1
        ;;
esac
