echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query tg_article_rank("PAGERANK_C12","PAGERANK_C12_HAS_EDGE",0.001,25,0.85,26,TRUE,"","")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
