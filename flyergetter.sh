#!/bin/bash
wget https://www.sobeys.com/en/flyer/accessible
lines=$(egrep -n "^<th>Item</th>$" accessible)
echo $lines
total=$(wc -l accessible)
x=$((total-lines))
echo $total
cat accessible | head -n $total | tail -n $x > hi.html #<-- this lines doesn't work yet