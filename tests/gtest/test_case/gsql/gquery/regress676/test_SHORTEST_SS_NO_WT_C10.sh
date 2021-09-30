echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query shortest_ss_no_wt(("A","SHORTEST_SS_NO_WT_C10"),["SHORTEST_SS_NO_WT_C10_HAS_EDGE"],26,False,"","",False, True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"