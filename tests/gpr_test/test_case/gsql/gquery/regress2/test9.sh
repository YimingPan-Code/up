#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

# first query
gsql -g poc_graph 'RUN QUERY sumac_test9_1()'

# second query
gsql -g poc_graph 'RUN QUERY sumac_test9_2("m3")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
