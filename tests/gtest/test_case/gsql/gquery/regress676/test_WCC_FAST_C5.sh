echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query wcc_fast(["WCC_FAST_C5"],["WCC_FAST_C5_HAS_EDGE"],26,False,"","",True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"