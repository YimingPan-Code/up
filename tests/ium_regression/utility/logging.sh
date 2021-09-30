#! /bin/bash
. utility/color_string.sh

# LOG_LEVEL
DEBUG=0
RAW=1
INFO=1
ERROR=2
FATAL=3
LOG_LEVEL=(DEBUG INFO ERROR FATAL)

FILE_LOG_LEVEL=""
STDERR_LOG_LEVEL=""

SINK_FILE_NAME=""

# Init logger
# used to specific the log file name also the log levels 
# $1 the sink file
# $2 the log level showed in the sink file, passed in 0,1 or 2
#  represents INFO ERROR and FATAL
# $3 the log level showed in the terminal, passed in 0,1 or 2
#  represents INFO ERROR and FATAL
function InitLogger() {
  SINK_FILE_NAME=$1
  FILE_LOG_LEVEL=$2
  STDERR_LOG_LEVEL=$3

  rm -f $SINK_FILE_NAME
  touch $SINK_FILE_NAME
}

shouldAppend() {
  if [ $1 -le $2 ]
  then
    return 0
  fi
  return 1
}

# Logging function
# $1 the LOG_LEVEL of this log
# $2 the LOG_LEVEL threshold
# $3 the FILE_NAME you sink this log 
# $4 the raw log string
log() {
  shouldAppend $1 $2
  ret=$?
  if [ $ret -eq 0 ]
  then
    #echo -n -e $4 >> $3
    echo -e "$4" >> $3
  fi
}

logerr() {
  shouldAppend $1 $2
  ret=$?
  if [ $ret -eq 0 ]
  then
    echo -e "$3" >&2
  fi
}

LogDebug() {
  log $FILE_LOG_LEVEL $DEBUG $SINK_FILE_NAME "$1"
  logerr $STDERR_LOG_LEVEL $DEBUG "$1"
}

LogRaw() {
  log $FILE_LOG_LEVEL $RAW $SINK_FILE_NAME "$1"
  logerr $STDERR_LOG_LEVEL $RAW "$1"
}

LogInfo() {
  local _output
  GreenString _output "$1"
  log $FILE_LOG_LEVEL $INFO $SINK_FILE_NAME "$1"
  logerr $STDERR_LOG_LEVEL $INFO "$_output"
}

LogError() {
  local _output
  LightRedString _output "$1"
  log $FILE_LOG_LEVEL $ERROR $SINK_FILE_NAME "$1"
  logerr $STDERR_LOG_LEVEL $ERROR "$_output"
}

LogFatal() {
  local _output
  LightRedString _output "$1"
  log $FILE_LOG_LEVEL $FATAL $SINK_FILE_NAME "$1"
  logerr $STDERR_LOG_LEVEL $FATAL "$_output"
}


# example
#InitLogger  "/tmp/1" $INFO $INFO
#LogInfo "123"
#LogFatal "123"
