echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query pageRank("PAGERANK_C1","PAGERANK_C1_HAS_EDGE",26,0.001,25,0.85,"","",True,False)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"