echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query pageRank_pers([("A","PAGERANK_C2")],"PAGERANK_C2_HAS_EDGE",26,0.001,25,0.85,"","",True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"