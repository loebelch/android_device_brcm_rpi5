#!/vendor/bin/sh
# Ausgabe nach dmesg - als init-Service ist stdout/stderr sonst /dev/null (14.3)
exec 1>/dev/kmsg 2>&1

# PFLICHT: die PATH eines init-Service enthaelt /system/bin nicht zuverlaessig,
# und ip/tc liegen genau dort. Ohne das: "ip: inaccessible or not found".
PATH=/system/bin:/vendor/bin
export PATH

IFACE=eth0
VID=2

# 8021q wird von init geladen (insmod-Builtin in der init.avtp.rc) - ein
# Service mit "capabilities"-Zeile hat kein CAP_SYS_MODULE und bekaeme EPERM.
if [ ! -d /proc/net/vlan ]; then
    echo "tsn-setup: 8021q nicht geladen - VLAN wird uebersprungen"
else
    # idempotent: bei erneutem Lauf sonst "File exists"
    if [ ! -d /sys/class/net/${IFACE}.${VID} ]; then
        ip link add link $IFACE name ${IFACE}.$VID type vlan id $VID \
            egress-qos-map 0:0 3:3 2:2
    fi
    ip link set ${IFACE}.$VID up
fi

# Anzahl HW-TX-Queues: entscheidet ueber die Qdisc-Struktur (13.4)
echo "tsn-setup: TX-Queues =" $(ls -d /sys/class/net/$IFACE/queues/tx-* | wc -l)
