echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query tg_eigenvector_cent(["BETWEENNESS_CENT_C9"],["BETWEENNESS_CENT_C9_HAS_EDGE"],20,0.001,26,TRUE,"","")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
