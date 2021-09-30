echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query jaccard_nbor_ap("Student","LOVES","Reverse_LOVES",26,True,"","")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"