#!/bin/bash
. case_common/global_vars.sh
. case_common/functions.sh

#$IUM_BIN/gadmin dumpIpList $CASE_LOG_DIR/"iplist"
CONFIG_FILE=$1

# checkout product
#cd $DEV_CODE_DIR
#git checkout $TEST_PRODUCT_VERSION
#git pull --rebase origin $TEST_PRODUCT_VERSION
#cd $WORKDIR

# checkout ium
cd $IUM_CODE_DIR
git checkout $TEST_IUM_VERSION
git pull --rebase origin $TEST_IUM_VERSION
cd $WORKDIR


PrepareCase "TestInitializeConfig"
cat $CONFIG_FILE | grep "cluster.nodes:" | awk -F 'cluster.nodes: ' '{print $2}' | awk -F ',' '{print $1":"$2}' | awk -F ':' '{print $2"\n"$4}' > $CASE_LOG_DIR/alliplist
# protection, make all previous service stop
if [ -f "$IUM_BIN/gadmin" ]; then
    gadmin stop -y
    gadmin stop admin ts3 -fy
    sleep 5
fi

remove_sym_link
${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm -rf ~/tigergraph/"
${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm -rf ~/tigergraph_coredump/"
${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm -rf ~/.gium"
${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm -rf ~/.gsql"
${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm -rf ~/.gsql_fcgi/"
${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "mkdir -p /home/`whoami`/.gsql/"
${REAL_PSCP} -h $CASE_LOG_DIR/alliplist $CONFIG_FILE "/home/`whoami`/.gsql/gsql.cfg"
EndCase

PrepareCase "TestInstallIUM"
cd $IUM_CODE_DIR
echo `pwd`
RunCaseCmd "./install.sh"
TEST_RC_EQUAL 0
RunCaseCmd "restore_sym_link"
TEST_RC_EQUAL 0
EndCase

PrepareCase "TestLicenseInvalid"
# mock a invalid license
RunCaseCmd "$IUM_BIN/gadmin --set license.key invalidit"
TEST_RC_EQUAL 1
RunCaseCmd "$IUM_BIN/gadmin"
TEST_RC_NOT_EQUAL 0
EndCase

PrepareCase "TestSetLicenseKey"
RunCaseCmd "$IUM_BIN/gadmin --set license.key $TIGERGRAPH_LICENSE"
TEST_RC_EQUAL 0
RunCaseCmd "gadmin"
TEST_RC_NOT_EQUAL 0
TEST_OUTPUT_NOT_MATCH "License string is invalid"
EndCase

PrepareCase "TestBinaryInstallation"
cd $DEV_PACKAGE_DIR
RunCaseCmd "./tigergraph.bin -y"
TEST_RC_EQUAL 0
cd $WORKDIR
RunCaseCmd "$IUM_BIN/gadmin start dict"
RunCaseCmd "$IUM_BIN/gadmin config-apply"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin start all"
TEST_RC_EQUAL 0
RunCaseCmd "$IUM_BIN/gadmin status"
TEST_RC_EQUAL 0
TEST_OUTPUT_NOT_MATCH "process is.*down.*"
EndCase

# for tigergraph.bin will install ium, which may make ium not the branch that we are testing
# so reinstall ium
PrepareCase "TestInstallIUM"
cd $IUM_CODE_DIR
echo `pwd`
RunCaseCmd "remove_sym_link"
TEST_RC_EQUAL 0
RunCaseCmd "./install.sh"
TEST_RC_EQUAL 0
RunCaseCmd "restore_sym_link"
TEST_RC_EQUAL 0
EndCase

PrepareCase "TestGenerateYamlConfig"
cd $WORKDIR
# mock a config
#touch /home/`whoami`/.gsql/gsql_config_local_modification_flag
touch /home/`whoami`/.gsql/gsql_config_local_generation_flag
RunCaseCmd "$IUM_BIN/gadmin  __generate_yaml_config"
TEST_RC_EQUAL 0
EndCase

exit ${EXIT_CODE}
