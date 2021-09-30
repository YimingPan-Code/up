#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

# first query
gsql -g poc_graph 'RUN QUERY sumac_test7_1("m3")'

# second query 
gsql -g poc_graph 'RUN QUERY sumac_test7_2("m3")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
