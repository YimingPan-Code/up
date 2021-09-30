#!/bin/bash

cwd=$(cd `dirname $0` && pwd)
# get gtest folder
gtest_dir=$cwd/../../../..

# start gsql server
gadmin start gsql

# create graph schema
cd $gtest_dir/test_case/gsql/gquery/regress1
gsql regress1_schema.gsql

# install query
all_queries=$(ls -a)
for query in ${all_queries}; do
  if [[ "$query" =~ query.gsql$ ]]; then
    echo "Define query: $query"
    gsql -g test_graph $query
  else
    echo "Ignore file: $query"
  fi
done

gsql -g test_graph 'INSTALL QUERY -batch ALL'
