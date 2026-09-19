#!/vendor/bin/sh
IFACE=eth0
VID=2

# VLAN mit SR-Class-A-Priorität (PCP 3)
ip link add link $IFACE name ${IFACE}.$VID type vlan id $VID \
    egress-qos-map 0:0 3:3 2:2
ip link set ${IFACE}.$VID up

# Anzahl HW-TX-Queues prüfen — mqprio/CBS brauchen mehrere Queues
ls /sys/class/net/$IFACE/queues/
