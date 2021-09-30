echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query tg_influence_maximization_greedy("INFLUENCE_MAXIMIZATION_C2","INFLUENCE_MAXIMIZATION_C2_HAS_EDGE","weight",3,TRUE,"")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
