echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query msf(["MSF_C1"],["MSF_C1_HAS_EDGE"],"weight",False,"","",True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"