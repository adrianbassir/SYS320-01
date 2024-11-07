#!/bin/bash

# List all the ips in the given network prefix
# /24 only

# Usage: bash IPList.bash 10.0.17
[ $# -ne 1 ] && echo "Usage: $0  <Prefix>" && exit 1

prefix=$1

for i in {1..254}
do
	echo "$prefix.$i"
done
