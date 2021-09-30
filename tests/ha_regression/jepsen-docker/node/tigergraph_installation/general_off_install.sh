#!/bin/bash

set -x

cd `dirname $0`
BASE_DIR=$(pwd)

source $BASE_DIR/utils/exit_code
source $BASE_DIR/utils/pretty_print
source $BASE_DIR/utils/os_utils
source $BASE_DIR/utils/install_by_os

source_url=$1
pkg_name=$2
skip_download=$3
skip_install=$4

echo "Welcome to offline_install testing framework!"
if [ "E$skip_install" = "Eyes" ]; then
  echo "===========Skip install platform============="
else
  if [ "E$skip_download" = "Eyes" ]; then
    echo "Skip download offline tarball"
  else
    echo "Download package from: $source_url/$pkg_name"
    rm -f $pkg_name
    curl --fail -O $source_url/$pkg_name
    check_fail $? $E_DOWNLOAD "Download $source_url/$pkg_name failed"
  fi
  
  rm -rf offline-package
  echo "Uncompressing pacakge ..."
  tar -xzf $pkg_name
  check_fail $? $E_DECOMPRESSFAIL "Decompress pacakge failed"
  
  cd offline-package
  curl -L ftp://192.168.11.10/lic/license.txt -o license_key.txt
  
  rm -rf LICENSE.txt
  
  sed -i "s:which \$tool > /dev/null 2>&1:which \$tool:g" helpers/sysutils
  export PATH=$PATH:/usr/local/sbin:/usr/sbin:/sbin
  prog "--------------Stage I: install platform------------------"
  prog "Checking operation system (OS) version ..."
  OSG=$(get_os)                              # e.g. RHEL 6.5, UBUNTU 14.04
  OS=$(echo $OSG | cut -d' ' -f1)            # e.g. RHEL, UBUNTU
  version=$(echo $OSG | cut -d' ' -f2)       # e.g. 6.5, 14.04
  OSV="$OS$(echo $version | cut -d'.' -f1)"  # e.g. RHEL6, UBUNTU14
  install_platform "$OSG"
  echo
fi

su - graphsql
