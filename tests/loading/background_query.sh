#! /bin/bash
qps=4
output="./background_query.output"
rm -f $output
touch $output
while [ 1 ]; do
    random=$(($RANDOM % 3))
    pid=""
    if [ $random -eq 0 ]; then
	curl -X POST 'http://localhost:9000/builtins' -d '{"function":"randomids","count":500,"vtype":1}' >> $output 2>&1&
        pid=$!
    elif [ $random -eq 1 ]; then
	curl -X POST 'http://localhost:9000/builtins' -d '{"function":"randomids","count":1000,"vtype":1}' >> $output 2>&1&
        pid=$!
    else
	curl -X POST 'http://localhost:9000/builtins' -d '{"function":"randomids","count":3000,"vtype":0}' >> $output 2>&1&
        pid=$!
    fi
    usleep $((1000000/$qps))
    disown $pid
    kill -9 $pid > /dev/null 2>&1
done
