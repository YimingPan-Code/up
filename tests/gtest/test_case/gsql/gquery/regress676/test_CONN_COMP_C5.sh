echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query conn_comp(["CONN_COMP_C5"],["CONN_COMP_C5_HAS_EDGE"],26,False,"","",True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"