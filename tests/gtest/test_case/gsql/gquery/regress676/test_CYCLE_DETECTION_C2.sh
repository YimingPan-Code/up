echo "[GTEST_BEGIN]" 
echo "[GTEST_JSON_BEGIN]" 
 
gsql -g GSQL_Algo_Test 'run query cycle_detection(["CYCLE_DETECTION_C2"],["CYCLE_DETECTION_C2_HAS_EDGE"],10,True,"")' 
 
echo "[GTEST_JSON_END]"
echo "[GTEST_END]"