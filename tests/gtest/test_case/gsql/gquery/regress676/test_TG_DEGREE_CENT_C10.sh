echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query tg_degree_cent(["BETWEENNESS_CENT_C10"],["BETWEENNESS_CENT_C10_HAS_EDGE"],["BETWEENNESS_CENT_C10_HAS_EDGE"],TRUE,FALSE,26,TRUE,"","")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
