#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY listac_test6("m3")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
