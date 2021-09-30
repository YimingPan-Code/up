echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 

gsql -g GSQL_Algo_Test 'run query WCC_SmallWorld("WCC_FAST_C4","WCC_FAST_C4_HAS_EDGE",100000,True)'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
