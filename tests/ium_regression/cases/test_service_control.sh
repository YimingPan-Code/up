#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestStartStop"
RunCaseCmd "$IUM_BIN/gadmin start all"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin status"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is.*down.*"

RunCaseCmd "$IUM_BIN/gadmin restart -y"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin status"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is.*down.*"

RunCaseCmd "$IUM_BIN/gadmin stop all -y"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin status"
TEST_RC_EQUAL 0
#TEST_OUTPUT_NOT_MATCH "process is.*up.*"

RunCaseCmd "$IUM_BIN/gadmin start zk"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin status zk"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is.*down.*"

RunCaseCmd "$IUM_BIN/gadmin stop zk -y"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin status zk"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is.*up.*"
EndCase

PrepareCase "TestReset"
RunCaseCmd "$IUM_BIN/gadmin reset -yf"

TEST_RC_EQUAL 0
EndCase

exit ${EXIT_CODE}
