echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query scc(["SCC_C1"],["SCC_C1_HAS_EDGE"],["reverse_SCC_C1_HAS_EDGE"],26,26,500,5,False,"","", True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
