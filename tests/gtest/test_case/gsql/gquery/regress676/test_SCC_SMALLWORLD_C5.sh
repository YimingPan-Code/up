echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 

gsql -g GSQL_Algo_Test 'run query SCC_SmallWorld("SCC_C5","SCC_C5_HAS_EDGE","reverse_SCC_C5_HAS_EDGE",100000,True)'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
