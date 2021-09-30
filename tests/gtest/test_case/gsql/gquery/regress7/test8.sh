#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY listac_test8("m7")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
