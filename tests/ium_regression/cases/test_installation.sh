#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

PrepareCase "TestDevCodeCompile"
cd $WORKDIR
RunCaseCmd "rm -rf /home/`whoami`/tigergraph/pkg_pool/"
TEST_RC_EQUAL 0
RunCaseCmd "mkdir -p /home/`whoami`/tigergraph/pkg_pool/"
TEST_RC_EQUAL 0
RunCaseCmd "cp $DEV_PACKAGE_DIR/$TEST_PRODUCT_VERSION.tar.gz /home/`whoami`/tigergraph/pkg_pool/"
TEST_RC_EQUAL 0
EndCase

PrepareCase "TestPkgInstallation"
RunCaseCmd "$IUM_BIN/gadmin pkg-install -y RESET"
TEST_RC_EQUAL_FATAL 0
RunCaseCmd "$IUM_BIN/gadmin start all"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin status"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is.*down.*"
EndCase

exit ${EXIT_CODE}
