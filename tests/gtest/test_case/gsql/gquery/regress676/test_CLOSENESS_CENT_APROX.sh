echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query closeness_cent_aprox(["CLOSENESS_CENT_C1"],["CLOSENESS_CENT_C1_HAS_EDGE"],"CLOSENESS_CENT_C1_HAS_EDGE",100,100,10,0.1,True,"",0,0,1000,TRUE)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
