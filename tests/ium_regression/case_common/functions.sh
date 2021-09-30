#!/bin/bash

. utility/logging.sh

function PrepareCase() {
  export CASE_NAME=$1
  export CASE_START_TIME=`date +"%s"`
  export CASE_LOG_FILE=$CASE_LOG_DIR/$CASE_NAME
  InitLogger $CASE_LOG_FILE $DEBUG $INFO
  LogRaw "---------------------------$CASE_NAME----------------------------"
  LogRaw "CASE [$CASE_NAME] Started @$CASE_START_TIME"
}

function EndCase() {
  export CASE_END_TIME=`date +"%s"`
  SECONDS=$((CASE_END_TIME - CASE_START_TIME))
  LogRaw "CASE [$CASE_NAME] finished, time took: $SECONDS""s"
}

function RunCaseCmdBg() {
  export CASE_CMD=$1
  LogRaw "BgRunning \"$CASE_CMD\""
  $CASE_CMD 2>&1 &
  export CASE_CMD_RETVAL=$?
  export CASE_CMD_OUTPUT="BGCommand"
  LogDebug "\nBGCommand(\"$CASE_CMD\") Output:"
  LogDebug "$CASE_CMD_OUTPUT\n"

  TEST_CORE_EXIST
}

function RunCaseCmd() {
  export CASE_CMD=$1
  LogRaw "Running \"$CASE_CMD\""
  cmdOutput="$($CASE_CMD 2>&1)"
  export CASE_CMD_RETVAL=$?
  export CASE_CMD_OUTPUT="$cmdOutput"
  LogDebug "\nCommand(\"$CASE_CMD\") Output:"
  LogDebug "$CASE_CMD_OUTPUT\n"

  TEST_CORE_EXIST
}
# the following are conditions on test failing
testFailContinue=return
testFailExit=exit

# the following testxxx functions' first parameter controls
# the case behaviours (e.g. exit or continue) when CASE FAIL occurs
function testCoreExit() {
  testFailControl=$1
  output=`find $CORE_DIR/ -mmin -1 -name "core*"`
  rc=$?
  if [ ! -z "$output" ]
  then
    EXIT_CODE=1
    LogError "Check:""\"$CASE_CMD\""" coredump check (core: $output): FAIL" 
    $testFailControl ${EXIT_CODE}
  fi
  LogInfo "Check:""\"$CASE_CMD\""" coredump check (no coredump): PASS" 
  return $rc
}

# TODO(xiaolong) hack, glive doesn't work now, so don't check glive related things
function testOutputMatch() {
  testFailControl=$1
  pattern=$2
  (echo "$CASE_CMD_OUTPUT" | grep -vi "glive" | grep -e "$pattern") 2>&1 > /dev/null
  rc=$?
  if [ $rc -ne 0 ]
  then
    EXIT_CODE=1
    LogError "Check:""\"$CASE_CMD\""" Output check (matches \"$pattern\"): FAIL" 
    $testFailControl ${EXIT_CODE}
  fi
  LogInfo "Check:""\"$CASE_CMD\""" Output check (matches \"$pattern\"): PASS" 
  return $rc
}

function testOutputNotMatch() {
  testFailControl=$1
  pattern=$2
  (echo "$CASE_CMD_OUTPUT" | grep -vi "glive" | grep -e "$pattern") 2>&1 > /dev/null
  rc=$?
  if [ $rc -eq 0 ]
  then
    EXIT_CODE=1
    LogError "Check:""\"$CASE_CMD\""" Output check (not matches \"$pattern\"): FAIL" 
    $testFailControl ${EXIT_CODE}
  fi
  LogInfo "Check:""\"$CASE_CMD\""" Output check (not matches \"$pattern\"): PASS" 
  return $rc
}

# if we expect Rc equal 0, then rc is set to 0, we can't return a 0 retcode when test failed,
# also if we expect a non 0 retcode, the CASE_CMD_RETVAL is 0, we encounter the same problem,
# we can't use CASE_CMD_RETVAL as the retcode.
# other test fucntion also has this problem, fix it by return or exit var EXIT_CODE
function testRcEqual() {
  testFailControl=$1
  rc=$2

  if [ $CASE_CMD_RETVAL -ne $rc ]
  then
    EXIT_CODE=1
    LogError "Check:""\"$CASE_CMD\""" Retval Equal $rc check ($CASE_CMD_RETVAL ==  $rc): FAIL" 
    $testFailControl ${EXIT_CODE}
  fi
  LogInfo "Check:""\"$CASE_CMD\""" Retval Equal $rc check: PASS"
  return $rc
}

function testRcNotEqual() {
  testFailControl=$1
  rc=$2

  if [ $CASE_CMD_RETVAL -eq $rc ]
  then
    EXIT_CODE=1
    LogError "Check:""\"$CASE_CMD\""" Retval NotEqual $rc check ($CASE_CMD_RETVAL !=  $rc): FAIL" 
    $testFailControl ${EXIT_CODE}
  fi
  LogInfo "Check:""\"$CASE_CMD\""" Retval NotEqual $rc check: PASS"
  return $rc
}

# test cmd's output , when match not found, exit script
# $1 the expected retval
function TEST_CORE_EXIST_FATAL() {
  testCoreExit $testFailExit $1
}

# test cmd's output , when match not found, exit script
# $1 the expected retval
function TEST_CORE_EXIST() {
  testCoreExit $testFailExit $1
}

# test cmd's output , when match not found, exit script
# $1 the expected pattern
function TEST_OUTPUT_MATCH_FATAL() {
  testOutputMatch $testFailExit "$1"
}

# test cmd's output , when match not found, continue script
# $1 the expected pattern
function TEST_OUTPUT_MATCH() {
  testOutputMatch $testFailExit "$1"
}

# test cmd's output , when match not found, continue script
# $1 the unexpected pattern
function TEST_OUTPUT_NOT_MATCH() {
  testOutputNotMatch $testFailExit "$1"
}

# test cmd's retval, when unexpected rc found, exit script
# $1 the expected retval
function TEST_RC_EQUAL_FATAL() {
  testRcEqual $testFailExit $1
}

# test cmd's retval, when unexpected rc found, continue script
# $1 the expected retval
function TEST_RC_EQUAL() {
  testRcEqual $testFailExit $1
}

# test cmd's retval, when unexpected rc found, exit script
# $1 the unexpected retval
function TEST_RC_NOT_EQUAL() {
  testRcNotEqual $testFailExit $1
}

function remove_sym_link() {
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm -rf ~/.gium && mv ~/tigergraph/.gium/ ~/.gium || true"
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm -rf ~/.venv && mv ~/tigergraph/.venv/ ~/.venv || true"
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm ~/.gsql && mv ~/tigergraph/.gsql/ ~/.gsql || true"
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "rm ~/.syspre && mv ~/tigergraph/.syspre/ ~/.syspre || true" 
}

function restore_sym_link() {
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "mkdir -p ~/tigergraph"
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "mv ~/.gium ~/tigergraph/ && ln -s ~/tigergraph/.gium/ ~/.gium || true"
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "mv ~/.venv ~/tigergraph/ && ln -s ~/tigergraph/.venv/ ~/.venv || true"
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "mv ~/.gsql ~/tigergraph/ && ln -s ~/tigergraph/.gsql/ ~/.gsql || true"
  ${REAL_PSSH} -ih $CASE_LOG_DIR/alliplist "mv ~/.syspre ~/tigergraph/ && ln -s ~/tigergraph/.syspre/ ~/.syspre || true" 
}
