echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query closeness_cent(["CLOSENESS_CENT_C9"],["CLOSENESS_CENT_C9_HAS_EDGE"],"REVERSE_CLOSENESS_CENT_C9_HAS_EDGE",10,26,True,True,"","",False)' 
 
echo "[GTEST_JSON_END]"
