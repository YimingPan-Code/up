#!/bin/bash

# This file is copied from file gium/admin/src/GSQL/scripts/gsql_dev_lic_update.
# For gsql_dev_lic_update only exists while internal_dev=y(means ./install -i).
PATH=$PATH:~/.gium/:/sbin:/usr/bin:/usr/local/bin

findNearestServer() {
  bestNet=
  bestRtt=1000
  for net in 11 22 33
  do
    rtt=$(ping -c1 -W1 -q 192.168.${net}.10 | grep avg | awk '{print $4}' | cut -d '/' -f2 | sed -e 's/\.[0-9]*//')
    if [[ "R$rtt" != "R"  && "$rtt" -lt $bestRtt ]]
    then
      bestNet=$net
      bestRtt=$rtt
    fi
  done

  if [ "B$bestNet" = "B" ]
  then
    echo "0.0.0.0"
  else
    echo "192.168.${bestNet}.10"
  fi
}

server=$(findNearestServer)
if [ $server = '0.0.0.0' ]
then
  echo "Check your network. Your computer cannot reach TigerGraph ftp servers."
  exit 2
fi

keyFile=/tmp/lic_$PID
url="ftp://${server}/lic/license.txt"
curl -s "$url" -o ${keyFile}

TIGERGRAPH_LICENSE=$(cat $keyFile)
export TIGERGRAPH_LICENSE
