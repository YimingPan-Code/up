echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query pageRank_wt(["PAGERANK_WT_C8"],["PAGERANK_WT_C8_HAS_EDGE"],"weight",26,0.001,25,0.85,True,"","",False)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"