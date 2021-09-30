#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestConfigUpdate"

RunCaseCmd "$IUM_BIN/gadmin start dict"
TEST_RC_EQUAL 0

RunCaseCmd "$IUM_BIN/gadmin __sync-config-to-dict"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "Local config modification sync to dictionary successfully!"

# mkdir, touch file
mkdir tmpA
cd tmpA
touch a b
date > a
date > b
cd ..

RunCaseCmd "$IUM_BIN/gadmin __pushtodict tmpA"
TEST_RC_EQUAL 0

mkdir tmpB
RunCaseCmd "$IUM_BIN/gadmin __pullfromdict tmpB"
TEST_RC_EQUAL 0

RunCaseCmd "ls tmpB"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "a"
TEST_OUTPUT_MATCH "b"
RunCaseCmd "diff tmpA/a tmpB/a"
TEST_RC_EQUAL 0

rm -rf tmpA
rm -rf tmpB
# lack good case
EndCase

exit ${EXIT_CODE}
