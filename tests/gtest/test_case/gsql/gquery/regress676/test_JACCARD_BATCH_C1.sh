echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query jaccard_batch("JACCARD_STUDENT","JACCARD_LOVES","REVERSE_JACCARD_LOVES",20,True,"","",1)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
