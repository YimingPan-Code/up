echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query mst(["MST_C10"],["MST_C10_HAS_EDGE"],"weight",False,"","", True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"