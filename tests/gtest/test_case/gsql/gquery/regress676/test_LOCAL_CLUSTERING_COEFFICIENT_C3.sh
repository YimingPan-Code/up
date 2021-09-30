echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query Local_clustering_Coefficient(["LOCAL_CLUSTERING_COEFFICIENT_C3"],["LOCAL_CLUSTERING_COEFFICIENT_C3_HAS_EDGE"],100,TRUE,"","",FALSE)' 
 
echo "[GTEST_JSON_END]"
