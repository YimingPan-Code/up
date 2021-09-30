#! /bin/bash

set -e
txtbld=$(tput bold)             # Bold
bldred=${txtbld}$(tput setaf 1) # red
bldgre=${txtbld}$(tput setaf 2) # green
bldblu=${txtbld}$(tput setaf 4) # blue
txtrst=$(tput sgr0)             # Reset

workdir="./"
log() {
   echo ${bldred}"$*"${txtrst}
}

cmd_help=false
cmd_generate_data=false
concurrency=0

usage() {
    echo "${bldred}Usage: $0 -h -g"
    echo "  -h                 show command list"
    echo "  -g                 generate loading data first"
    echo "  -q   concurrency   degree of background query concurrency, default is 0 (no background queries)"
    echo "${txtrst}"
}

# Following two functions are used to control background querying
arr=()
start_background_query() {
    for ((i=0;i<$concurrency;i++)); do
        bash $workdir"background_query.sh" &
        arr[i]=$!
    done
}

stop_background_query() {
  for i in ${arr[@]}; do
      disown $i || :
      kill -9 $i > /dev/null 2>&1 || :
  done
}

# Verificate the loading result
verification() {
  python verification.py $1
  if [ $? -ne 0 ]; then
    exit 1
  fi
}

# Start loading test
loading_test() {
    set -e
    sudo sh -c "sudo swapoff -a; sync; echo 3 > /proc/sys/vm/drop_caches"
    gsql "clear graph store -HARD" 
    start_background_query
    gsql "run job load$1"
    stop_background_query
    # if $2 is true, do the verification
    if $2; then
        verification $1
    fi
    set +e
}

while getopts ":hgq:" opt; do
    case $opt in
        h)
            cmd_help=true
            ;;
        g)
            cmd_generate_data=true
            ;;
        q)
            concurrency=$OPTARG
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            usage
            exit 1
            ;;
    esac
done

if $cmd_help; then
    usage
    exit 0
fi

# Generate data
if $cmd_generate_data; then
    log "Generating edge distribution ..."
    python ./edge_generator.py 2>&1
fi

log "Resetting environment ..."
gadmin restart gsql -fy > /dev/null 2>&1

# tet suite #0
# this test suit should not do the product edge verification
log "Testing graph without attributes ..."
gsql ./prepare_directed_edge_tag_to_product.gsql 2>&1
loading_test 1 false 
loading_test 2 false
loading_test 3 false
loading_test 4 false
loading_test 5 false
loading_test 6 false

# test suite #1
log "Testing graph without attributes ..."
gsql ./prepare.gsql 2>&1
loading_test 1 true 
loading_test 2 true
loading_test 3 true
loading_test 4 true
loading_test 5 true
loading_test 6 true

# test suite #2
log "Testing graph with attributes ..."
gsql ./prepare_with_attr.gsql 2>&1
loading_test 1 true 
loading_test 2 true
loading_test 3 true
loading_test 4 true
loading_test 5 true
loading_test 6 true
