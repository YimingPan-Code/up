# Test case list
regress1: test KSubGraph
regress2: test SumAccum
regress3: test MaxAccum & MinAccum
regress4: test AvgAccum
regress5: test AndAccum & OrAccum

# Instruction to Add More Regress
Each Regress has its own graph schema, test cases

## Steps to Add RegressX
1. Add RegressX folder:
```bash
cd path/to/bigtest/tests/gtest
mkdir test_case/gsql/gquery/regressX
mkdir setup/gsql/gquery/regressX
mkdir baseline/gsql/gquery/regressX
```
2. Add schema, query, test cases
```bash
cd test_case/gsql/gquery/regressX
touch regressX_schema.gsql           # create graph schema
touch test1_query.gsql               # create graph query
touch test1.sh                       # run query
```
3. Add Setup
```bash
cd setup/gsql/gquery/regressX
cp ../regress1/setup.sh .
sed -i "s/regress1/regressX/g" setup.sh     # substitute all regress1 with regressX
```
4. Add baseline
```bash
cd path/to/bigtest/tests/gtest
./run_all.sh                         # run this, it will generate baseline for you automatically
```
