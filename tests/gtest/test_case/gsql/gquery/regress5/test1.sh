#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY AndOrAccum_test1()'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"

