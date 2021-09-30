#!/bin/bash
. case_common/global_vars.sh
. utility/logging.sh
. utility/get_license.sh
# run all cases here and check errors

EXIT_CODE=0
MODE="SINGLE"
REFRESH_PKG=false
TEST_IUM_VERSION='4.4'

function UpdateExitCode() {
    ret=$1
    if [ ${ret} -ne 0 ]; then
        EXIT_CODE=${ret}
        # Exit when first error happens
        exit ${EXIT_CODE}
    fi
}

function ShowHelp() {
    echo "usage: $0 [-b <branch>] [-m <SINGLE|MULTI>] [-r]" >&2
    echo "  -h : show usage"
    echo "  -m : run in SINGLE or MULTI mode, SINGLE mode means run locally, MULTI means run in cluster, default=SINGLE"
    echo "  -r : refresh the tigergraph.bin and pkg.tar.gz, first time run must with this option"
    echo "  -b : the ium branch to test"
    exit 1
}

while getopts ":m:hrb:" opt; do
    case "$opt" in
    h)  ShowHelp
        ;;
    m)  MODE=$OPTARG
        [ ${MODE} = "SINGLE" -o ${MODE} = "MULTI" ] || ShowHelp
        ;;
    r)  REFRESH_PKG=true
        ;;
    b)  TEST_IUM_VERSION=$OPTARG
        ;;
    :)  echo "Option -$OPTARG requires an argument." >&2
        ShowHelp
        ;;
    \?) echo "Invalid option: -$OPTARG" >&2
        ShowHelp
        ;;
    esac
done

export EXIT_CODE
export TEST_IUM_VERSION

echo "Running mode: $MODE"
echo "License: $TIGERGRAPH_LICENSE"

if [ ${REFRESH_PKG} = true ]; then
    cd ${DEV_PACKAGE_DIR}
    pwd
    wget -N ftp://192.168.11.10/product/${TEST_PRODUCT_VERSION}-centos652.x86_64.bin
    wget -N ftp://192.168.11.10/product/${TEST_PRODUCT_VERSION}.tar.gz
    chmod +x ${TEST_PRODUCT_VERSION}-centos652.x86_64.bin
    rm -f tigergraph.bin
    ln -s ${TEST_PRODUCT_VERSION}-centos652.x86_64.bin tigergraph.bin
fi

cd ${WORKDIR}

InitialConfig=""
if [ "$MODE" = "SINGLE" ]
then
  InitialConfig="./config_sample/SingleNode.cfg"
else
  InitialConfig="./config_sample/MultiNode.cfg"
fi
echo ${InitialConfig}

# change the variable $USER name to system user
tmpFile="${InitialConfig}.tmp"
cp ${InitialConfig} ${tmpFile}
sed -i "s#home/tigergraph/#home/`whoami`/#g" ${tmpFile}
./cases/test_initialize_ium_and_config.sh ${tmpFile}
UpdateExitCode $?

# This test should in run first, because license update in this file
./cases/test_installation.sh
UpdateExitCode $?

rm -f ${tmpFile}
cd ${WORKDIR}
pwd

./cases/test_configure.sh
UpdateExitCode $?

./cases/test_config_update.sh
UpdateExitCode $?

./cases/test_gsql_status.sh
UpdateExitCode $?

./cases/test_internal_use.sh
UpdateExitCode $?

./cases/test_output.sh
UpdateExitCode $?

./cases/test_package_commands.sh
UpdateExitCode $?

./cases/test_runtime_environment.sh
UpdateExitCode $?

./cases/test_service_control.sh
UpdateExitCode $?

./cases/test_system_information.sh
UpdateExitCode $?

exit ${EXIT_CODE}
