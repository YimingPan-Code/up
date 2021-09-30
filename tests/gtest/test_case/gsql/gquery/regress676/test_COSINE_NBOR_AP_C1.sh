echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query cosine_nbor_ap(["Person"],["Likes"],["Reverse_Likes"],"weight",20,20,True,"","")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"