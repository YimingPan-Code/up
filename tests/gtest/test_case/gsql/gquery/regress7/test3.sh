#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

# we need to test static global variables with runing  the same query multiple times
# here we run query listac_test3 three times to see the result

# first round
gsql -g poc_graph 'RUN QUERY listac_test3("m3")'

# second round
gsql -g poc_graph 'RUN QUERY listac_test3("m3")'

# third round
# we will deallocate all static global variables this time
gsql -g poc_graph 'RUN QUERY listac_test3("m3")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
