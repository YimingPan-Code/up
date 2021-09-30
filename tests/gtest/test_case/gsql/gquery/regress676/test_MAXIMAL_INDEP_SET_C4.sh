echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query maximal_indep_set("MAXIMAL_INDEP_SET_C4","MAXIMAL_INDEP_SET_C4_HAS_EDGE",100,False,"", True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"