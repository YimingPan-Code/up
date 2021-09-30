echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query knn_cosine_cv(["Person"],["Likes"],["Reverse_Likes"],"weight","known_label",0,26)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"