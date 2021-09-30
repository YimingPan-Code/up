#!/bin/bash

cwd=$(cd `dirname $0` && pwd)
# get gtest folder
gtest_dir=$cwd/../../../..

# start gsql server
gadmin start gsql

# create graph schema
cd $gtest_dir/test_case/parser/gquery/regress5
# setup schema
gsql regress5_schema.gsql
