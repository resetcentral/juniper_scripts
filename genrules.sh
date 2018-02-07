#!/bin/sh

echo "delete security zones security-zone trust address-book"
echo "delete security policies from-zone untrust to-zone trust"

base="set security zones security-zone trust address-book address"

for combo in $(cat addrs); do
  name="${combo%%:*}"
  ip="${combo#*:}"
  echo "$base" "$name" "$ip"
done

base="set security policies from-zone untrust to-zone trust policy"

for rule in $(cat rules); do
  name="${rule%%:*}"
  app="${rule#*:}"
  rulebase="$base $name-$app"
  echo "$rulebase" "match source-address any"
  echo "$rulebase" "match destination-address" "$name"
  echo "$rulebase" "match application" "$app"
  echo "$rulebase" "then permit"
done
