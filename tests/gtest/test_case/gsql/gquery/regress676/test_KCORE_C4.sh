echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query kcore("KCORE_C4","KCORE_C4_HAS_EDGE",0,-1,True,"","",False,False)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"