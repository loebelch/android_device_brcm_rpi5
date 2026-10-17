#!/vendor/bin/sh
IFACE=eth0
VID=2

# VLAN nur, wenn der Switch getaggte Frames erwartet - braucht 8021q.ko
modprobe -d /vendor/lib/modules 8021q 2>/dev/null

ip link add link $IFACE name ${IFACE}.$VID type vlan id $VID \
    egress-qos-map 0:0 3:3 2:2
ip link set ${IFACE}.$VID up

ls /sys/class/net/$IFACE/queues/      # mqprio/CBS brauchen mehrere Queues
