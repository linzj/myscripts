#!/bin/bash
iptables -t nat -A OUTPUT -d 10.1.12.31/24 -j DNAT --to-destination 8.8.8.8
#iptables -t nat -A OUTPUT -p tcp --dport 443 -j REDIRECT --to-port 80
iptables -L -t nat
read
iptables -t nat -D OUTPUT 1
#iptables -t nat -D OUTPUT 1

