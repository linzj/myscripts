#!/bin/bash

function ctrl_c() {
    do_exit
}

function do_exit() {
    echo 'exiting'
    iptables -t nat -D OUTPUT 1
    exit 0
}

iptables -t nat -A OUTPUT -d 100.84.12.31/24 -j DNAT --to-destination 8.8.8.8
#iptables -t nat -A OUTPUT -d 192.168.1.1 -j DNAT --to-destination 8.8.8.8
#iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-port 80
iptables -L -t nat
trap ctrl_c INT

read
do_exit
#iptables -t nat -D OUTPUT 1

