#! /bin/bash

BASEDIR=$(dirname "$0")

# clean up
rm -rf $BASEDIR/jepsen
# download jepsen and integrate with tigergraph jepsen kit
wget https://github.com/jepsen-io/jepsen/archive/master.zip
unzip master.zip && rm -f master.zip && mv jepsen-master jepsen
rm -rf $BASEDIR/jepsen/docker && cp -r $BASEDIR/jepsen-docker $BASEDIR/jepsen/docker
cp -r $BASEDIR/jepsen-tigergraph $BASEDIR/jepsen/tigergraph
cd $BASEDIR/jepsen/docker
bash ./up.sh
