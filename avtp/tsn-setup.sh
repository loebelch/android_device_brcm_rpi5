#!/vendor/bin/sh
# als init-Service ist stdout/stderr sonst /dev/null
exec 1>/dev/kmsg 2>&1

IFACE=eth0
VID=2

modprobe -d /vendor/lib/modules 8021q

# idempotent: zweiter Lauf scheitert sonst mit "File exists"
if [ ! -d /sys/class/net/${IFACE}.${VID} ]; then
    ip link add link $IFACE name ${IFACE}.$VID type vlan id $VID \
        egress-qos-map 0:0 3:3 2:2
fi
ip link set ${IFACE}.$VID up

echo "tsn-setup: TX-Queues =" $(ls -d /sys/class/net/$IFACE/queues/tx-* | wc -l)
