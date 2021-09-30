#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PKG_POOL_PATH="$GSQL_HOME/pkg_pool"

PrepareCase "TestPackageCommands"
RunCaseCmd "$IUM_BIN/gadmin pkg-info"

TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "===$PKG_POOL_PATH==="
TEST_OUTPUT_MATCH "$TEST_PRODUCT_VERSION.tar.gz"

RunCaseCmd "$IUM_BIN/gadmin pkg-update"
TEST_RC_NOT_EQUAL 0
TEST_OUTPUT_MATCH "== Local source ($PKG_POOL_PATH) =="
TEST_OUTPUT_MATCH "Didn't find valid package or single binary under $PKG_POOL_PATH"
TEST_OUTPUT_MATCH "Didn't find any executable under $PKG_POOL_PATH"
# Lack gadmin pkg-update good case

PrepareCase "TestPkgRm"
RunCaseCmd "$IUM_BIN/gadmin pkg-rm $TEST_PRODUCT_VERSION.tar.gz -y"
TEST_RC_EQUAL 0

RunCaseCmd "$IUM_BIN/gadmin pkg-info"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "===$PKG_POOL_PATH==="
TEST_OUTPUT_NOT_MATCH "$TEST_PRODUCT_VERSION.tar.gz"

RunCaseCmd "cp $DEV_PACKAGE_DIR/$TEST_PRODUCT_VERSION.tar.gz /home/`whoami`/tigergraph/pkg_pool/"
TEST_RC_EQUAL 0

RunCaseCmd "$IUM_BIN/gadmin pkg-info"
TEST_RC_EQUAL 0
TEST_OUTPUT_MATCH "===$PKG_POOL_PATH==="
TEST_OUTPUT_MATCH "$TEST_PRODUCT_VERSION.tar.gz"
EndCase

PrepareCase "TestPkgReset"
RunCaseCmd "$IUM_BIN/gadmin reset -y"
TEST_RC_EQUAL 0
EndCase

exit ${EXIT_CODE}
