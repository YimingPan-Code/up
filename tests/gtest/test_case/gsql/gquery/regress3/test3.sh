#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY minmaxac_test3("c1", 0, 100)'
gsql -g poc_graph 'RUN QUERY minmaxac_test3("c2", 10, 90)'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
