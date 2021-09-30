#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

# we need to test static global variables with runing  the same query multiple times
# here we run query sumac_test4 twice to see the result 
# first round
gsql -g poc_graph 'RUN QUERY sumac_test4()'
# second round
gsql -g poc_graph 'RUN QUERY sumac_test4()'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
