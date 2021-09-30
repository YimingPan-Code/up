echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query estimate_diameter(["ESTIMATE_DIAMETER_C6"],["ESTIMATE_DIAMETER_C6_HAS_EDGE"],26,True,"",False)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"