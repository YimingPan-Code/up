set -e
#echo an error message before exiting
trap '[ "$?" -eq 0 ] || echo License test failed with exit code $?.' EXIT 

source license_test_utils.sh

#Get current string license and check if file license is used
curr_str_license=`gadmin --dump-config | grep license | cut -d " " -f 2`
delete_file_lic="true"
if [[ -d ~/tigergraph/.license ]]; then
  delete_file_lic="false"
fi

#Create advanced license file
echo "-------------------------Creating Advanced License File--------------------------"
echo "Creating advanced license file..."
bash gsql_dev_lic_update
echo

#Test case 1: Invalid file license. Invalid string license.
echo "-------------------------Test Case 1--------------------------"
run_test_case -m "Running test case 1: Invalid file license, invalid string license..." -s -2 -f "expired_license.tgz"
echo

#Test case 2: Invalid file license. String license valid for < 30 days. 
echo "-------------------------Test Case 2--------------------------"
run_test_case -m "Running test case 2: Invalid file license, string license valid for < 30 days..." -s 29 -f "expired_license.tgz"
echo

#Test case 3: Invalid file license. String license valid for >= 30 days.
echo "-------------------------Test Case 3--------------------------"
run_test_case -m "Running test case 3: Invalid file license, string license valid for >= 30 days..." -s 30 -f "expired_license.tgz" 
echo

#Test case 4: File license valid for < 30 days. Invalid string license.
echo "-------------------------Test Case 4--------------------------"
run_test_case -m "Running test case 4: File license valid for < 30 days, invalid string license..." -s -2 -au
echo

#Test case 5: File license valid for < 30 days. String license valid for < 30 days
#and shorter then file license.
echo "-------------------------Test Case 5--------------------------"
run_test_case -m "Running test case 5: File license valid for < 30 days, string license valid for < 30 days and is valid for shorter then file license..." -s 3 -au
echo

#Test case 6: File license valid for < 30 days. String license valid for < 30 days.
#and longer then file license
echo "-------------------------Test Case 6--------------------------"
run_test_case -m "Running test case 6: File license valid for < 30 days, string license valid for < 30 days and is valid for longer then file license..." -s 10 -au
echo

#Test case 7: File license valid for < 30 days. String license valid for >= 30 days.
echo "-------------------------Test Case 7--------------------------"
run_test_case -m "Running test case 7: File license valid for < 30 days, string license valid for >= 30 days..." -s 31 -au
echo

#Test case 8: File license valid for >= 30 days. Invalid string license. 
echo "-------------------------Test Case 8--------------------------"
run_test_case -m "Running test case 8: File license valid for >= 30 days, invalid string license..." -s -5 -f "license_expire_in_one_year.tgz"
echo

#Test case 9: File license valid for >= 30 days. String license valid for < 30 days
echo "-------------------------Test Case 9--------------------------"
run_test_case -m "Running test case 9: File license valid for >= 30 days, string license valid for < 30 days" -s 10 -f "license_expire_in_one_year.tgz"
echo

#Test case 10: File license valid for >= 30 days. String license valid for >= 30 days
echo "-------------------------Test Case 10--------------------------"
run_test_case -m "Running test case 10: File license valid for >= 30 days, string license valid for >= 30 days" -s 400 -f "license_expire_in_one_year.tgz"
echo

mv ~/tigergraph/.license . 

#Test case 11: 64 byte string license
echo "-------------------------Test Case 11--------------------------"
run_test_case -m "Running test case 11: 64 byte string license" -s 7ad2813ff7c4face13db37330e99b1cd46d23718acfad9663b9b4bbe69014ebb  #-f "expired_license.tgz"
echo

#Test case 12: >74 byte string license
echo "-------------------------Test Case 12--------------------------"
run_test_case -m "Running test case 12: >74 byte string license. Output should NOT change from previous test case." -s 7ad2813ff7c4face13db37330e99b1cd46d23718acfad9663b9b4bbe69014ebb15198012734 #-f "expired_license.tgz"
echo

mv ./.license ~/tigergraph

#Clean up environment after test
echo "-------------------------Cleaning Up--------------------------"
echo "Delete file license: $delete_file_lic"
echo "Restoring string license"
update_string_lic -l $curr_str_license
if [[ $delete_file_lic = "true" ]]; then
  echo "Removing ~/tigergraph/.license..."
  rm -rf ~/tigergraph/.license
else
  echo "Restoring file license..."
  bash gsql_dev_lic_update
fi
