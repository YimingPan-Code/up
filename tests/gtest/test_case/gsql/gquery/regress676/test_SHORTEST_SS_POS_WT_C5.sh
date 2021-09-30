echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query shortest_ss_pos_wt(("A","SHORTEST_SS_POS_WT_C5"),["SHORTEST_SS_POS_WT_C5_HAS_EDGE"],"weight",26,False,"","",False,True)' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"