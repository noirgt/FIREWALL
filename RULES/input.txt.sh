#!/bin/sh
#
# VARIABLES:
ALL_ACCEPT='192.168.148.0/24,192.168.109.0/24,192.168.48.0/24,10.103.13.0/24,10.255.101.1/32'
ICMP_ACCEPT='95.153.191.5/32,95.153.191.209/32'
VPN_ACCEPT='95.153.191.5/32'
MONITORING='10.121.0.214'

cat << EndOfMessage
# RULES/input.txt
# ALL INPUT RULES
# /////////////////
# FOR ALL:
#
# Main
iptables -P INPUT DROP
#
# All accept
iptables -A INPUT -s $ALL_ACCEPT -j ACCEPT
#
# ICMP
iptables -A INPUT -s $ICMP_ACCEPT -p icmp --icmp-type echo-reply -j ACCEPT
iptables -A INPUT -s $ICMP_ACCEPT -p icmp --icmp-type destination-unreachable -j ACCEPT
iptables -A INPUT -s $ICMP_ACCEPT -p icmp --icmp-type time-exceeded -j ACCEPT
iptables -A INPUT -s $ICMP_ACCEPT -p icmp --icmp-type echo-request -j ACCEPT
#
# IPSec
iptables -A INPUT -s $VPN_ACCEPT -p udp -m multiport --dports 500,4500 -j ACCEPT
#
# GRE
iptables -A INPUT -s $VPN_ACCEPT -p gre -j ACCEPT
iptables -A INPUT -s $VPN_ACCEPT -p tcp --dport 1723 -j ACCEPT
#
# OSPF
iptables -A INPUT -i ens192 -p ospf -j ACCEPT
iptables -A INPUT -i gre_mts -p ospf -j ACCEPT
#
# /////////////////
# FOR OTHER:
#
# lo
iptables -A INPUT -i lo -j ACCEPT
#
# Node Exporter
iptables -A INPUT -s $MONITORING -p tcp --dport 9100 -j ACCEPT
#
# IPSec Exporter
iptables -A INPUT -s $MONITORING -p tcp --dport 9536 -j ACCEPT
#
# /////////////////
EndOfMessage
