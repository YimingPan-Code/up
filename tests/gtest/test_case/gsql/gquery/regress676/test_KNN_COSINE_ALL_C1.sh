echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query knn_cosine_all(["Person"],["Likes"],["Reverse_Likes"],"weight","known_label",26,True,"","")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"