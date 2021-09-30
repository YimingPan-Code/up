#! /bin/bash

if [ $# -ne 3 ]
then
    echo "Usage: open_ssh_tunnel.sh <hosts_file> <user> <password>"
    exit -1
fi

for line in `cat $1`
do
  expect -f $(dirname $0)/open-ssh-tunnel.exp $line $2 $3
done
