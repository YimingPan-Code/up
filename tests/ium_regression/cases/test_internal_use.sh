#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestKill"
RunCaseCmd "$IUM_BIN/gadmin start"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is down"
RunCaseCmd "$IUM_BIN/gadmin killall -y"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is up"
EndCase

# this command will cause tg_infr_admind core, so now remove it
#PrepareCase "TestLogClean"
#RunCaseCmd "$IUM_BIN/gadmin stop -y"
#TEST_RC_EQUAL 0
#RunCaseCmd "$IUM_BIN/gadmin clean log"
#TEST_RC_EQUAL 0
#TEST_OUTPUT_MATCH "rm -rf .*\/logs\/.*; mkdir -p .*\/logs\/logs; mkdir -p .*\/logs\/coredump"
EndCase

exit ${EXIT_CODE}
