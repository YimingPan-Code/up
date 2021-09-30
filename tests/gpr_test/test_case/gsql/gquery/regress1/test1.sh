#!/bin/bash
#
# find the k step neighbers for all vertices
#
tmpdir=/tmp/k_step_neighber
# print may to any cluster nodes
grun all "rm -rf $tmpdir; mkdir -p $tmpdir"

echo "[GTEST_BEGIN]"
echo "[GTEST_JSON_BEGIN]"
# this two methods are equivalent
#curl -s -X GET "http://localhost:9000/query/ip_batch?step=2&output=$tmpdir"
gsql  -g test_graph "RUN QUERY ip_batch(2, \"$tmpdir/output.txt\")"
echo "[GTEST_JSON_END]"

# for cluster, output.txt is in all nodes
# fetch from all nodes, it will be named as output.txt_m[1-n]
gfetch all $tmpdir/output.txt $tmpdir &>/dev/null

cat $tmpdir/output.txt* > $tmpdir/tmp.out
awk '!seen[$0]++' $tmpdir/tmp.out | awk -F',' '{split($2, a, " "); asort(a); printf("%s,", $1); \
for(i = 1; i <= length(a); i++) printf("%s ", a[i]); printf("\n");}' > $tmpdir/ip_all.txt

sort -t, -nk1 $tmpdir/ip_all.txt
echo "[GTEST_END]"

# clean up
grun all "rm -rf $tmpdir" &>/dev/null
