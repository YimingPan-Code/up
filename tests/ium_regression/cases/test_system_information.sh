#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestSysInformation"
# Test gamin ds
## good case
RunCaseCmd "$IUM_BIN/gadmin ds $GSQL_HOME"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "===Disk Space ==="
TEST_OUTPUT_MATCH "$GSQL_HOME Free : "
TEST_OUTPUT_MATCH "$GSQL_HOME Total: "
TEST_OUTPUT_MATCH "$GSQL_HOME Used : "
## bad case
RunCaseCmd "$IUM_BIN/gadmin ds ~/NonExistPath"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "===Disk Space ==="
TEST_OUTPUT_MATCH "Error: it doesn't exist"
TEST_OUTPUT_MATCH "(0, 0, 0)"

# Stop all
RunCaseCmd "$IUM_BIN/gadmin stop -y"
TEST_RC_EQUAL 0
## Good case
#### Test gadmin mem
RunCaseCmd "$IUM_BIN/gadmin mem restpp"
TEST_OUTPUT_MATCH "restpp: {}"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin mem gse"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gse: {}"
RunCaseCmd "$IUM_BIN/gadmin mem gpe"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gpe: {}"
#### Test gadmin cpu
RunCaseCmd "$IUM_BIN/gadmin cpu restpp"
TEST_OUTPUT_MATCH "restpp: {}"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin cpu gse"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gse: {}"
RunCaseCmd "$IUM_BIN/gadmin cpu gpe"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gpe: {}"
#### Test gadmin check
RunCaseCmd "$IUM_BIN/gadmin check"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "in-use"

# Start all
RunCaseCmd "$IUM_BIN/gadmin start"
TEST_RC_EQUAL 0
## Good case
#### Test gadmin mem
RunCaseCmd "$IUM_BIN/gadmin mem restpp"
TEST_OUTPUT_MATCH "restpp:"
TEST_OUTPUT_MATCH ":.*iB"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin mem gse"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gse:"
TEST_OUTPUT_MATCH ":.*iB"
RunCaseCmd "$IUM_BIN/gadmin mem gpe"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gpe:"
TEST_OUTPUT_MATCH ":.*iB"
#### Test gadmin cpu
RunCaseCmd "$IUM_BIN/gadmin cpu restpp"
TEST_OUTPUT_MATCH "restpp:"
TEST_OUTPUT_MATCH ": .*\."
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin cpu gse"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gse:"
TEST_OUTPUT_MATCH ": .*\."
RunCaseCmd "$IUM_BIN/gadmin cpu gpe"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "gpe:"
TEST_OUTPUT_MATCH ": .*\."
#### Test gadmin check
RunCaseCmd "$IUM_BIN/gadmin check"
TEST_RC_EQUAL 0
## Bad case
#### Test gadmin mem
RunCaseCmd "$IUM_BIN/gadmin mem non-exist-component"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "non-exist-component: {}"
#### Test gadmin cpu
RunCaseCmd "$IUM_BIN/gadmin cpu non-exist-component"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "non-exist-component: {}"
EndCase

exit ${EXIT_CODE}
