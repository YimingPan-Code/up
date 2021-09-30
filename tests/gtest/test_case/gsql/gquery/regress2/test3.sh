#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY sumac_test3("m5")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
