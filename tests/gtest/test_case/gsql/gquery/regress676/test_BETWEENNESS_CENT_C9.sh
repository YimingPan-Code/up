echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query betweenness_cent(["BETWEENNESS_CENT_C9"],["BETWEENNESS_CENT_C9_HAS_EDGE"],"BETWEENNESS_CENT_C9_HAS_EDGE",10,26,True,"","",False)' 
 
echo "[GTEST_JSON_END]"
