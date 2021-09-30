#!/bin/bash

cwd=$(cd `dirname $0` && pwd)
# get gtest folder
gtest_dir=$cwd/../../../..

# start gsql server
gadmin start gsql

# create graph schema
cd $gtest_dir/test_case/gsql/gquery/regress3
gdev_path=$(gadmin config get System.AppRoot)/dev
gsql 'PUT ExprFunctions FROM "../../../../resources/common/ExprFunctions_gsql_regress3.hpp"'
gsql regress3_schema.gsql

# install query
all_queries=$(ls -a)
for query in ${all_queries}; do
  if [[ "$query" =~ query.gsql$ ]]; then
    echo "Define query: $query"
    gsql -g poc_graph $query
  else
    echo "Ignore file: $query"
  fi
done

gsql -g poc_graph 'INSTALL QUERY -batch ALL'
