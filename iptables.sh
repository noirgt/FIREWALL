#!/bin/bash
#
# 0) VARIABLES:
num_input=$($(dirname $0)/RULES/input.txt.sh | egrep -v '^#|^$' | wc -l)
num_output=$($(dirname $0)/RULES/output.txt.sh | egrep -v '^#|^$' | wc -l)
num_forward=$($(dirname $0)/RULES/forward.txt.sh | egrep -v '^#|^$' | wc -l)
num_nat=$($(dirname $0)/RULES/nat.txt.sh | egrep -v '^#|^$' | wc -l)
#
# 1) CLEAR ALL RULES:
iptables -F
iptables -F -t nat
iptables -F -t mangle
iptables -X
iptables -t nat -X
iptables -t mangle -X
# 2) ADD LOGGING:
iptables -N LOGGING
iptables -A LOGGING -m limit --limit 2/min -j LOG --log-prefix "IPTables-Dropped: " --log-level 4
echo "/////////////////"
#
# 2) INPUT:
echo "INPUT"
for((i=1;i<=$num_input;i++))
	do
	INPUT=$($(dirname $0)/RULES/input.txt.sh | egrep -v '^#|^$' | sed -n $i\p)
	$INPUT
done
echo "/////////////////"
#
# 3) OUTPUT:
echo "OUTPUT"
for((o=1;o<=$num_output;o++))
        do
        OUTPUT=$($(dirname $0)/RULES/output.txt.sh | egrep -v '^#|^$' | sed -n $o\p)
	$OUTPUT
done
echo "/////////////////"
#
# 4) FORWARD:
echo "FORWARD"
for((f=1;f<=$num_forward;f++))
        do
        FORWARD=$($(dirname $0)/RULES/forward.txt.sh | egrep -v '^#|^$' | sed -n $f\p)
	$FORWARD
done
echo "/////////////////"
#
# 5) NAT:
echo "NAT"
for((n=1;n<=$num_nat;n++))
        do
        NAT=$($(dirname $0)/RULES/nat.txt.sh | egrep -v '^#|^$' | sed -n $n\p)
	$NAT
done
echo "/////////////////"
#
# 6) ESTABLISHED+RELATED:
iptables -A INPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -p all -m state --state ESTABLISHED,RELATED -j ACCEPT
#
# 7) UNRECOGNIZED PACKETS:
iptables -A INPUT -m state --state INVALID -j DROP
iptables -A FORWARD -m state --state INVALID -j DROP
#
# 8) ZERO PACKETS:
iptables -A INPUT -p tcp --tcp-flags ALL NONE -j DROP
#
# 9) LOGGING:
iptables -A INPUT -j LOGGING
iptables -A FORWARD -j LOGGING
#
# 10) SAVE RULES:
# CentOS
if [ $(cat /etc/os-release | grep -Iice "Centos") != 0 ]; then
	iptables-save > /etc/sysconfig/iptables
		fi
# Debian
if [ $(cat /etc/os-release | grep -Iice "Debian") != 0 ]; then
	iptables-save > /etc/iptables/rules.v4
                fi
