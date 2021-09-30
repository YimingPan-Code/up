echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query cosine_batch("COSINEBATCH_PERSON","COSINEBATCH_LIKES","weight",20,True,"","",1)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
