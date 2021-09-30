#!/bin/bash
#
# This is the script to run all tests
# MIT system will call this script only
#

cwd=$(cd `dirname $0` && pwd)
source $cwd/utils/exit.code

help(){
  echo "bash `basename $0` [-h] [-c <class>] [-s <subclass>] [-r <regress>]"
  echo "  -h  --  show this message"
  echo "  -c  --  specify class name (if not specify, the default runs all classes)"
  echo "  -s  --  specify subclass name (if not specify, the default runs all subclasses)"
  echo "  -r  --  specify regress number (if not specified, the default run all regresses)"
  echo
  echo "Usage Example:"
  echo "[1] bash `basename $0` -c gsql -s gquery -r '1 2 3'"
  echo "e.g.1 will run regress1, 2, 3 under test_case/gsql/gquery folder"
  echo "[2] bash `basename $0` -s gquery -r '1,3'"
  echo "e.g.2 will run regress1, 3 under test_case/*/gquery folder"
  echo "[3] bash `basename $0` -c gsql"
  echo "e.g.3 will run all regresses under test_case/gsql/* folder"
  exit 0
}

if ! which gawk &>/dev/null; then
  echo "Please install tool: gawk, then retry"
  echo "Install by: [yum/apt-get] install gawk"
  exit $E_Miss_Tool
fi

while getopts ":hc:s:r:" opt; do
  case $opt in
    h|H)
      help
      ;;
    c|C)
      CLASS=$OPTARG
      ;;
    s|S)
      SUBCLASS=$OPTARG
      ;;
    r|R)
      REGRESS=$OPTARG
      ;;
    *)
      echo "${bldred}Invalid option, the correct usage is described below: $txtrst"
      help
      ;;
  esac
done
gadmin start gsql
gsql 'set json_api = "v2" '

CLASS=$(echo "$CLASS" | tr "," " ")
SUBCLASS=$(echo "$SUBCLASS" | tr "," " ")
REGRESS=$(echo "$REGRESS" | tr "," " ")
[ -z "$CLASS" ] && CLASS=ALL
[ -z "$SUBCLASS" ] && SUBCLASS=ALL
[ -z "$REGRESS" ] && REGRESS=ALL
echo "CLASS: $CLASS"
echo "SUBCLASS: $SUBCLASS"
echo "REGRESS: $REGRESS"

log_dir=~/gtest_blackbox
rm -rf $log_dir
mkdir -p $log_dir
echo "log_dir: $log_dir"

log_file=$log_dir/gtest_blackbox.log
echo "Log Created: $(date +"%m/%d/%Y")" > $log_file

# clean up old diff and output
cd $cwd
rm -rf diff
rm -rf output
rm -rf .working_dir

## setup and run all class regresses
failed=false
cd $cwd/test_case
all_class=$(ls -a)  # ("gsql")
for class in ${all_class}; do
  if [[ $class =~ ^\. ]]; then
    echo "Ignore hidden folder: $class"
    continue
  elif [ "$CLASS" != "ALL" ] && ! [[ "$CLASS" == *"$class"* ]]; then
    echo "Skip all test in class: $class"
    continue
  # since we need to run parser driver in single thread mode, we need to
  # change thread config.
  elif [ "$class" = "parser" ]; then
    config_file=$cwd/config
    thread=$(grep numThreads $config_file | awk -F'=' '{print $2}')
    echo "For class $class, change running thread to be: 1"
    sed -i 's/^numThreads=.*$/numThreads=1/g' $config_file
  fi

  cd $cwd/test_case/$class
  # add all subclass type into the array
  all_subclass=$(ls -a)  # ("gquery")
  # check if test_case folder is two level or three level
  # two level e.g.: test_case/rest/regress1
  # three level e.g.: test_case/gsql/gquery/regress1
  if [[ "$all_subclass" == *"regress1"* ]]; then
    test_level=2
  fi
  for subclass in ${all_subclass}; do
    if [[ $subclass =~ ^\. ]]; then
      echo "Ignore hidden folder: $subclass"
      continue
    elif [ "$SUBCLASS" != "ALL" ] && ! [[ "$SUBCLASS" == *"$subclass"* ]]; then
      echo "Skip test in subclass: $class/$subclass"
      continue
    fi
    # subclass is empty if test_level is two
    if [ "$test_level" = 2 ]; then
      subclass=''
    fi
    echo "Run all ${class}/${subclass} regression tests" | tee -a $log_file
    all_regress=$(ls -d ${cwd}/test_case/${class}/${subclass}/regress*)
    for file in ${all_regress}; do
      # strip text to get regress number
      num=${file##*regress}
      if [ "$REGRESS" != "ALL" ] && ! [[ "$REGRESS" == *"$num"* ]]; then
        echo "Skip $class/$subclass regress$num"
        continue
      fi
      # step 1, setup environment
      echo -e "\nsetup ${class}/${subclass} regress $num at $(date +'%F %T.%6N')" | tee -a $log_file
      bash $cwd/setup/${class}/${subclass}/regress$num/setup.sh
      [ "$?" != "0" ] && failed="true"
      # step 2, run regression tests
      echo -e "\nrun ${class}/${subclass} regress $num at $(date +'%F %T.%6N')" | tee -a $log_file
      # get class driver name
      cd $cwd/drivers
      class_driver=$(ls -f ${class}*)
      # run gtest with the class driver
      cd $cwd
      $cwd/gtest.sh ${class_driver} $subclass $num
      [ "$?" != "0" ] && failed="true"
    done
  done
  # since we run parser driver in single thread mode, we need to restore multiple thread
  # test mode after this run.
  if [ "$class" = "parser" ]; then
    sed -i "s/^numThreads=.*$/numThreads=$thread/g" $config_file
    echo "Finished class $class, change running thread back to be: $thread"
  fi
done
# return to previous working directory
cd -

if [ "$failed" = "true" ]; then
  echo "Black box test failed"
  exit $E_Test_Failed
fi
