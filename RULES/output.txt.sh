#!/bin/sh
#
# VARIABLES:
example_ip='192.168.1.1'

cat << EndOfMessage
# RULES/output.txt
# ALL OUTPUT RULES
# /////////////////
# FOR ALL:
#
# Main
iptables -P OUTPUT ACCEPT
#
# /////////////////
# FOR OTHER:
#
# lo
# iptables -A OUTPUT -i lo -j ACCEPT
#
# /////////////////
EndOfMessage
