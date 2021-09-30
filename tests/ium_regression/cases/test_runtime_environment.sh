#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestRuntimeEnvironment"
RunCaseCmd "$IUM_BIN/gadmin stop gse -y"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin start gse -v"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "is listening, please check this port."
TEST_OUTPUT_NOT_MATCH "WARN: openfiles value.* on host .* maybe too small, you should at least set it to .*."
TEST_OUTPUT_NOT_MATCH "WARN: path(.*) on host %s has low free disk space(.*GB, we expect at least 5GB is free), please take care."
EndCase

exit ${EXIT_CODE}
