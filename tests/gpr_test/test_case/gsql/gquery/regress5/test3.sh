#!/bin/bash

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g poc_graph 'RUN QUERY AndOrAccum_test3(False, True)'
gsql -g poc_graph 'RUN QUERY AndOrAccum_test3(True, False)'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
