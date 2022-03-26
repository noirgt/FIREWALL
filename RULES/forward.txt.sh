#!/bin/sh
#
# VARIABLES:
WEST_PROD='10.121.0.0/24,172.121.110.84'
WEST_TEST='10.121.3.0/24'
WEST_SERVICE='10.121.5.0/24'
WEST_LINK='192.168.121.0/24'

EAST_PROD='10.122.0.0/24'
EAST_TEST='10.122.3.0/24'
EAST_SERVICE='10.122.5.0/24'
EAST_LINK='192.168.122.0/24'

EAST_MGMT='192.168.147.0/25'

cat << EndOfMessage
# RULES/forward.txt
# ALL FORWARD RULES
# /////////////////
# FOR ALL:
#
# Main
iptables -P FORWARD DROP
#
# Path MTU Discovery
iptables -A FORWARD -p tcp -m tcp --tcp-flags SYN,RST SYN -j TCPMSS --clamp-mss-to-pmtu
#
# Wireguard's clients
iptables -A FORWARD -s 192.168.245.0/21 -j ACCEPT
#
# /////////////////
# FOR OTHER:
#
# For EastProd
iptables -A FORWARD -s $EAST_PROD -d $WEST_PROD,$WEST_TEST,$WEST_SERVICE -j ACCEPT
#
# For EastTest
iptables -A FORWARD -s $EAST_TEST -d $WEST_TEST,$WEST_SERVICE -j ACCEPT
#
# For EastService
iptables -A FORWARD -s $EAST_SERVICE -d $WEST_TEST,$WEST_SERVICE -j ACCEPT
#
# For EastMGMT
iptables -A FORWARD -s $EAST_MGMT -d $EAST_LINK,$WEST_LINK -j ACCEPT
#
# /////////////////
EndOfMessage
