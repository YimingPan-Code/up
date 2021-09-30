#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

# we need to test static global variables with runing  the same query multiple times
# here we run query avgac_test2 three times to see the result

# first round
gsql -g poc_graph 'RUN QUERY avgac_test2("c2")'

# second round
gsql -g poc_graph 'RUN QUERY avgac_test2("c3")'

# third round
# we will deallocate the static global variables this time
gsql -g poc_graph 'RUN QUERY avgac_test2("c3")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
