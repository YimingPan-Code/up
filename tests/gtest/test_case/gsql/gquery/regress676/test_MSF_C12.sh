echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query msf(["MSF_C12"],["MSF_C12_HAS_EDGE"],"weight",False,"","",True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"