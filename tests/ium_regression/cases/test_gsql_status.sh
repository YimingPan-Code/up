#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestLog"
RunCaseCmd "$IUM_BIN/gadmin log"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "GPE : $GSQL_HOME\/logs\/gpe.*.out"
# TEST_OUTPUT_MATCH "GPE : $GSQL_HOME\/logs\/.*\/log.INFO"
TEST_OUTPUT_MATCH "GSE : $GSQL_HOME\/logs\/gse.*.out"
# TEST_OUTPUT_MATCH "GSE : $GSQL_HOME\/logs\/.*\/log.INFO"
TEST_OUTPUT_MATCH "RESTPP : $GSQL_HOME\/logs\/restpp.*.out"
# TEST_OUTPUT_MATCH "RESTPP : $GSQL_HOME\/logs\/.*\/log.INFO"
EndCase

exit ${EXIT_CODE}
