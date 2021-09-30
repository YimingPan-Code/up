echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query msf(["MSF_C5"],["MSF_C5_HAS_EDGE"],"weight",False,"","",True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"