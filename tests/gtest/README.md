# gtest structure & usage
For the detail, please check wiki page:
[Gtest Framework Design Page](https://tigergraph.atlassian.net/wiki/spaces/GS/pages/64684162/Parallel+Regression+Test+Framework+Design+Doc+done+by+Zixuan)

## Tree Structures
```
gtest                                // project folder
|-- base_line                        // the baseline of test output, will be compared with runtime output
|-- config                           // the configuration file
|-- diff                             // generated at runtime, will be empty if no diff
|   |-- gsql                         //
|       |-- regress1                 //
|           |-- test1.diff           //
|-- drivers                          // each test class has its own driver 
|   |-- gsql.sh                      // driver for gsql test class
|-- gtest.sh                         // script to run the gtest framework
|-- lib -> ../../../../lib/gle/regress/lib    // gtest framework library
|-- output                           // runtime output of test, same structure as diff
|-- README.md                        // instruction file
|-- resources                        // repo of all data sets, and others
|-- run_all.sh                       // the entry for MIT to run all tests
|-- test_case                        // run test case, and generate runtime output
|   |-- gsql                         // test case class: gsql
|       |-- gquery                   // test case subclass: gquery
|           |-- regress1             //
|               |-- test1            //
|-- setup                            // setup all regress env, same structure as test_case
|-- utils                            // utility functions or others
```


## Example to Show the Usage
The entry to run all tests is: run_all.sh

Here we use k_step_neighbor as an example to show the detail how to run gtest.
```bash
# step 1, setup environment
bash path/to/gtest/setup/gsql/gquery/regress1/setup.sh

# step 2, run gsql/gquery regression 1
./gtest.sh gsql.sh gquery 1
```
The above code has been added in run_all.sh
