echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query pageRank("PAGERANK_C3","PAGERANK_C3_HAS_EDGE",26,0.001,25,0.85,"","",True,False)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"