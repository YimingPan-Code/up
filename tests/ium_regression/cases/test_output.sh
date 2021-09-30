#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestOutput"
RunCaseCmd "gadmin start"
TEST_RC_EQUAL 0
cp /home/`whoami`/.gsql/gsql.cfg /home/`whoami`/.gsql/gsql.cfg.modified
RunCaseCmd "gadmin"
TEST_OUTPUT_MATCH "Detect config change. Please run 'gadmin config-apply' to apply."

mv /home/`whoami`/.gsql/gsql.cfg.commited /home/`whoami`/.gsql/gsql.cfg.commited.tmp
mv /home/`whoami`/.gsql/gsql.cfg.modified /home/`whoami`/.gsql/gsql.cfg.modified.tmp
RunCaseCmd "gadmin"
TEST_OUTPUT_MATCH "Local config is not identified by IUM. Please use 'gadmin --config' to update."
mv /home/`whoami`/.gsql/gsql.cfg.commited.tmp /home/`whoami`/.gsql/gsql.cfg.commited
mv /home/`whoami`/.gsql/gsql.cfg.modified.tmp /home/`whoami`/.gsql/gsql.cfg.modified

RunCaseCmd "gadmin start"
rm -f /home/`whoami`/.gsql/gsql.cfg.modified
RunCaseCmd "gadmin __dumpiplist zk $CASE_LOG_DIR/zklist"
${REAL_PSSH} -ih $CASE_LOG_DIR/zklist "kill -15 \`ps aux | grep zookeeper | grep -v kafka | grep -v grep | awk -F' ' '{print \$2}'\`"
RunCaseCmd "gadmin"
TEST_OUTPUT_MATCH "WARNING: Dictionary init failed (300). Fall back to local configure."

RunCaseCmd "gadmin start"
RunCaseCmd "gadmin __dumpiplist dict $CASE_LOG_DIR/dictlist"
${REAL_PSSH} -ih $CASE_LOG_DIR/dictlist "killall tg_infr_dictd"
sleep 2
RunCaseCmd "gadmin"
TEST_OUTPUT_MATCH "WARNING: Dictionary init failed (200). Fall back to local configure."

EndCase

exit ${EXIT_CODE}
