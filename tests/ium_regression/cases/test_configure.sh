#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

#$IUM_BIN/gadmin dumpIpList $CASE_LOG_DIR/"iplist"
PrepareCase "TestConfigApply"
RunCaseCmd "$IUM_BIN/gadmin start dict"
TEST_RC_EQUAL_FATAL 0
RunCaseCmd "$IUM_BIN/gadmin --set gse.log.level DEBUG"
RunCaseCmd "gadmin config-apply"
TEST_RC_EQUAL 0
RunCaseCmd "gadmin --dump-config"
TEST_OUTPUT_MATCH "gse.log.level.*DEBUG"
TEST_RC_EQUAL 0
# modification flag
RunCaseCmd "[ ! -f /home/`whoami`/.gsql/gsql.cfg.modified ]"
RunCaseCmd "[ -f /home/`whoami`/.gsql/gsql.cfg.commited ]"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin --set gse.log.level INFO"
# modification flag
RunCaseCmd "[ -f /home/`whoami`/.gsql/gsql.cfg.modified ]"
TEST_RC_EQUAL 0
RunCaseCmd "gadmin config-apply"
TEST_RC_EQUAL 0
RunCaseCmd "gadmin --dump-config"
TEST_OUTPUT_MATCH "gse.log.level.*INFO"
EndCase

PrepareCase "TestGSQLConfig"
RunCaseCmd "$IUM_BIN/gadmin update $CASE_LOG_DIR"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin update_graph_config $CASE_GRAPH_CONFIG"
TEST_RC_EQUAL 0
EndCase

exit ${EXIT_CODE}
