echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query tg_influence_maximization_CELF("INFLUENCE_MAXIMIZATION_C5","INFLUENCE_MAXIMIZATION_C5_HAS_EDGE","weight",3,TRUE,"")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"