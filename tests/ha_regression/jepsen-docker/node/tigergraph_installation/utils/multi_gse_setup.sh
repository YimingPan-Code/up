#! /bin/bash

# modify tigergraph configuration
cp -f /home/graphsql/.gsql/gsql.cfg.commited /home/graphsql/.gsql/gsql.cfg.modified 
sed -i 's/cluster.nodes:.*/cluster.nodes: m1:172.16.238.8,m2:172.16.238.9,m3:172.16.238.10/g;s/gse.servers:.*/gse.servers: m1,m2,m3/g;s/gse.replicas:.*/gse.replicas: 3/g' /home/graphsql/.gsql/gsql.cfg.modified
rm -f /home/graphsql/tigergraph/pkg_pool/*.tar.gz 

# open ssh tunnel
/home/graphsql/installation/utils/open-ssh-tunnel.sh /home/graphsql/installation/conf/hosts.cfg graphsql graphsql 
ssh m2 /home/graphsql/installation/utils/open-ssh-tunnel.sh /home/graphsql/installation/conf/hosts.cfg graphsql graphsql 
ssh m3 /home/graphsql/installation/utils/open-ssh-tunnel.sh /home/graphsql/installation/conf/hosts.cfg graphsql graphsql 

# install target package
source /home/graphsql/.bashrc
if [ -f /home/graphsql/product/tigergraph.bin ]; then
  /home/graphsql/product/tigergraph.bin -fy
else
  curl --fail -O ftp://192.168.11.10/product/hourly/build_centos6_tigergraph.bin 
  chmod 777 ./build_centos6_tigergraph.bin
  ./build_centos6_tigergraph.bin -fy
  rm -f ./build_centos6_tigergraph.bin
fi
gadmin stop -fy
gadmin config-apply
echo "rmr /tigergraph/dict/objects/__services/RLS-GSE/_expelled_nodes" | ~/tigergraph/zk/bin/zkCli.sh -server 127.0.0.1:19999
