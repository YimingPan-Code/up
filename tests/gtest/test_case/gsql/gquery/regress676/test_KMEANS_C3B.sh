echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"

gsql -g GSQL_Algo_Test 'run query kMeans(5,10,1.0,"KMEANS_C3_PT","KMEANS_C3_PRODUCT_IS_PT",false,true,"")'

echo "[GTEST_JSON_END]"
echo "[GTEST_END]"
