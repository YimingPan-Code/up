#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY minmaxac_test5("c1")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"

