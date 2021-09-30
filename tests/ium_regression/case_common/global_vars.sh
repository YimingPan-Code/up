#!/bin/bash
GSQL_HOME=/home/`whoami`/tigergraph
GSQL_BIN=$GSQL_HOME/bin
IUM_BIN=/home/`whoami`/.gium
TEST_PRODUCT_VERSION="poc4.4_base"
CORE_DIR=/home/`whoami`/tigergraph_coredump
TEST_DIR=/tmp/ium_test
CASE_LOG_DIR=$TEST_DIR/log
DEV_CODE_DIR=$TEST_DIR/code
DEV_PACKAGE_DIR=$TEST_DIR/pkg
IUM_CODE_DIR=$DEV_CODE_DIR
WORKDIR=`pwd`

LICENSE=`curl ftp://192.168.11.10/lic/license.txt`

CASE_GRAPH_CONFIG=$WORKDIR/config_sample/graph_config.yaml

REAL_PSSH="pssh -OStrictHostKeyChecking=no"
REAL_PSCP="pscp.pssh -OStrictHostKeyChecking=no"
if [ -f /etc/debian_version ]
then
    REAL_PSSH="parallel-ssh -OStrictHostKeyChecking=no"
    REAL_PSCP="parallel-scp -OStrictHostKeyChecking=no"
fi

# checkout ium
if [ ! -d $IUM_CODE_DIR/gium ]
then
  rm -f $IUM_CODE_DIR/gium
  mkdir -p $IUM_CODE_DIR
  cd $IUM_CODE_DIR
  TOKEN="5d823fd1a69ae41d72244b92d9890ba98d2bb863"
  BASE_BRANCH="4.4"
  git clone -b $BASE_BRANCH --quiet https://qa-tigergraph:$TOKEN@github.com/TigerGraph/gium.git --depth=1
  cd $WORKDIR
fi
IUM_CODE_DIR=$IUM_CODE_DIR/gium

# check package
if [ ! -d $DEV_PACKAGE_DIR ]
then
  mkdir -p $DEV_PACKAGE_DIR
fi

if [ ! -d $CASE_LOG_DIR ]
then
  rm -f $CASE_LOG_DIR
  mkdir -p $CASE_LOG_DIR
fi
