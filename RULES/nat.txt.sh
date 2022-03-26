#!/bin/sh
#
# VARIABLES:
INTERNET_ACCEPT='192.168.0.0/16, 10.254.33.0/26'
NAT_TO_WEST='10.100.0.0/16'
FINANCE_NETWORK='10.48.0.0/24,10.35.25.0/24'

cat << EndOfMessage
# RULES/nat.txt
# ALL NAT RULES
# /////////////////
# MASQUERADE:
#
# Clients to Internet NAT
iptables -t nat -A POSTROUTING -s $INTERNET_ACCEPT -o ens224 -j MASQUERADE
#
# /////////////////
# FOR ALL:
#
# Source NAT to West VDC
iptables -t nat -A POSTROUTING -d $NAT_TO_WEST -j SNAT --to-source 10.210.41.55
#
# /////////////////
# FOR OTHER:
#
# NAT for Finance Network to VPN Server
iptables -t nat -A PREROUTING -s $FINANCE_NETWORK -p tcp --dport 3434 -d 10.35.35.25 -j DNAT --to-destination 10.99.35.24:2525
#
# /////////////////
EndOfMessage
