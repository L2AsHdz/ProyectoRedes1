#!/bin/bash

touch iptables.rules
echo"iptables -A INPUT -i enp3s0 -j ACCEPT" >> iptables.rules
echo"iptables -A OUTPUT -o enp3s0 -j ACCEPT" >> iptables.rules

echo "Generando rules para router A"
cp iptables.rules iptablesA.rules

sh genRulesClient.sh A a "iptablesA.rules"
sh genRulesClient.sh A b "iptablesA.rules"
sh genRulesClient.sh A c "iptablesA.rules"

echo ""
echo "Generando rules para router B"
cp iptables.rules iptablesB.rules

sh genRulesClient.sh B a "iptablesB.rules"
sh genRulesClient.sh B b "iptablesB.rules"
sh genRulesClient.sh B c "iptablesB.rules"

echo ""
echo "Generando rules para router C"
cp iptables.rules iptablesC.rules

sh genRulesClient.sh C a "iptablesC.rules"
sh genRulesClient.sh C b "iptablesC.rules"
sh genRulesClient.sh C c "iptablesC.rules"
sh genRulesClient.sh C d "iptablesC.rules"
sh genRulesClient.sh C e "iptablesC.rules"

echo ""
echo "Generando rules para router E"
cp iptables.rules iptablesE.rules

sh genRulesClient.sh E a "iptablesE.rules"
sh genRulesClient.sh E b "iptablesE.rules"
sh genRulesClient.sh E e "iptablesE.rules"
sh genRulesClient.sh E g "iptablesE.rules"

echo ""
echo "Generando rules para router D"
cp iptables.rules iptablesD.rules

sh genRulesClient.sh D a "iptablesD.rules"
sh genRulesClient.sh D b "iptablesD.rules"
sh genRulesClient.sh D g "iptablesD.rules"
sh genRulesClient.sh D f "iptablesD.rules"

rm iptables.rules
echo ""
echo "Achivos rules creados"
