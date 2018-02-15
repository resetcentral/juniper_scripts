echo "delete security nat destination"
echo "delete security nat proxy-arp"

iface="ge-0/0/1"
base="set security nat destination"
echo "$base rule-set dnat from interface $iface"

for combo in $(cat dnat); do
  name=$(echo $combo | awk -F: '{print $1}')
  ext=$(echo $combo | awk -F: '{print $2}')
  extport=$(echo $combo | awk -F: '{print $3}')
  int=$(echo $combo | awk -F: '{print $4}')

  echo "$base pool $name address $int"
  echo "$base rule-set dnat rule $name match destination-address $ext"
  echo "$base rule-set dnat rule $name then destination-nat pool $name"
  if [ "$extport" != "any" ]; then
    echo "$base rule-set dnat rule $name match destination-port $extport"
  fi
  echo "set security nat proxy-arp interface $iface address $ext"
done

