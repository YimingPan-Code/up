#!/bin/bash

cwd=$(dirname $0)
grun all "rm -rf /tmp/sc_companies.csv"
gscp all $cwd/../../../../resources/data_set/gsql/sc_companies.csv /tmp

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY listac_test9("/tmp/sc_companies.csv")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
