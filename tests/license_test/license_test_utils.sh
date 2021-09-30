#This function updates the current string license to one that expires in a given number of days
#It can also update the current string license to a given string license.
function update_string_lic(){
  if [[ $# < 1 || $# >2 || !($1 =~ ^-?[0-9]+$ ) && $1 != "-l" ]]; then
    echo update_string_lic num_days_from_today
    echo update_string_lic -l license_to_apply
    return 10
  fi
  if [[ $1 = "-l" ]]; then
    if [[ $# < 2 ]]; then
      echo "Error: the option \"-l\" requires a license number"
      return 20
    fi
    gadmin set-license-key $2 > /dev/null
    if [[ $? = 0 ]]; then
      gadmin config-apply > /dev/null
      expr_date=`echo $2 | tail -c 11`
    fi
    echo $expr_date
  else
    license=`gadmin --dump-config | grep license | cut -d " " -f 2`
    expr_date=$(date "+%s" -d "+$1 days")
    lic_head=`echo $license | head -c 64`
    new_lic=`echo $lic_head$expr_date`
    echo $new_lic >> /dev/null
    gadmin set-license-key $new_lic > /dev/null
    gadmin config-apply > /dev/null
    echo $expr_date
  fi
}

#This function updates the current file license to a file license in a .tgz package
function update_file_lic(){
  if [[ $# != 1 || $1 = "-h" || !($1 =~ \.tgz$) && $1 != "-au" ]]; then
    echo update_file_lic license_file_ending_in_.tgz
    echo update_file_lic -au \(automatically update the file license using the gsql_dev_lic_update script\)
  fi
  if [[ $1 = "-au" ]]; then
    bash gsql_dev_lic_update > /dev/null 2>&1
    adv_lic_expr_date_epoch=`head -n 1 ~/tigergraph/.license/lic_endpoint | head -c 10`
    echo $adv_lic_expr_date_epoch
  else
    tar xzvf $1 > /dev/null
    cat seed_m1 > ~/tigergraph/.license/1/a8471537d4f7f154993224be7fe58063
    rm -rf ~/tigergraph/.license/0/*
    echo 1 > ~/tigergraph/.license/using_dir
    gadmin stop gse -y > /dev/null || true
    gadmin start gse > /dev/null || true
    adv_lic_expr_date=`cat ~/tigergraph/logs/GSE_1_1/log.INFO | grep -m 1 license | rev | cut -d " " -f "1 2 3 4 5" | rev`
    adv_lic_expr_date_epoch=`date "+%s" -d "$adv_lic_expr_date"`
    adv_lic_seed=`ls | grep "seed_m1."`
    echo $adv_lic_expr_date_epoch"000" > ~/tigergraph/.license/lic_endpoint
    cat $adv_lic_seed >> ~/tigergraph/.license/lic_endpoint
    echo $adv_lic_expr_date_epoch
    rm -rf seed_m1*
  fi
  gadmin start > /dev/null || true
  gadmin config-apply > /dev/null || true
}

#returns the difference between two days
datediff() {
  d1=$1
  d2=$2
  echo $(( (d1 - d2) / 86400 ))
}

#checks to make sure that the give error/warning message is displayed during "gadmin status lic"
function check_message(){
  if [[ $# < 1 || $# >3 || $1 = -h ]]; then
    echo "check_message message_to_check message_to_display_if_check_fails [-n] [-h]"
    echo "-h: displays this message."
    echo "-n: check that message_to_check does not exist during \"gadmin status lic\"."
    echo "    (If not specified function will check if massage_to_check exists during \"gadmin status lic\")"
    return 1
  fi
  
  #return 1 
  message_to_check=$1
  message_to_display=$2
  lic_status=`gadmin status lic` || true
  echo -e "Output from command \"gadmin status lic\":\n"
  echo -e "$lic_status\n" 
  output=`gadmin status lic | egrep -i "$message_to_check"` || true
  
  if [[ $3 = "-n" ]]; then
    echo baseline:
    echo output: $output  
    if [[ -n $output ]]; then
      echo $message_to_display
      return 30
    else
      echo "Check passed!"
      return 0
    fi
  else
    echo baseline: $message_to_check
    echo output: $output  
    if [[ -z $output ]]; then
      echo $message_to_display
      return 30
    else
      echo "Check passed!"
      return 0
    fi 
  fi
}


#checks the results from a test case to make sure it is correct
function check_result(){
  trap '[ "$?" -eq 0 ] || echo "License Test Failed."' RETURN
  start_msg=''
  str_lic_exp_date=''
  file_lic_exp_date=''
  help=$(echo "check_result [-h] [-m start_message] [-s string_license_expiration_date] [-f file_license_expiration_date] [-au]"
         echo "  -h -- show this message"
         echo "  -m -- specify message to display at the beginning of the check." 
         echo "        (If NOT specified, no message will be displayed)"
         echo "  -s -- specify string license expiration date in epoch time"
         echo "        (If NOT spicified, will automatically get the expration date)"
         echo "  -f -- specify file license expiration date in epoch time"
         echo "        (If NOT spicified, will automatically get the expration date)"
        )
  #Read arguments
  while [[ $# -gt 0 ]]; do
    if [[ $1 = "-h" ]]; then
      echo "$help"
      return 0
    elif [[ $1 = "-m" ]]; then
      start_msg=$2
      shift 2
    elif [[ $1 = "-s" ]]; then
      str_lic_exp_date=$2
      shift 2
    elif [[ $1 = "-f" ]]; then
      file_lic_exp_date=$2
      shift 2
    else
      echo "Invalid option $1. Please see usage below:"
      echo "$help"
      return 40
    fi
  done

  #Get string license expiration data automatically if needed
  if [[ -z $str_lic_exp_date ]]; then
    license=`gadmin --dump-config | grep license`
    str_lic_exp_date=${license: -10}
  fi

  #Get string license expiration data automatically if needed
  if [[ -e ~/tigergraph/.license/lic_endpoint && -z $file_lic_exp_date ]]; then
    first_line=`head -n 1 ~/tigergraph/.license/lic_endpoint`
    file_lic_exp_date=${first_line::-3}
  fi 
  
  #Print message to display at the beginning of test case (if specified)
  if [[ -n $start_msg ]]; then
    echo $start_msg
  fi
  :
  #Print out today's date and the expiration dates of string and file licenses if they are integers. 
  today_date=`date "+%s"`
  if [[ $str_lic_exp_date =~ ^-?[0-9]+$ ]]; then
    echo String license expration date: `date -d @$str_lic_exp_date`
  fi
  echo File license expration date: `date -d @$file_lic_exp_date`
  echo -e "Today's date: `date -d @$today_date`\n"

  #Set the license to check to the license with the longer expration date
  license_to_check=''  
  expr_date_to_check=''
  if [[ $str_lic_exp_date -gt $file_lic_exp_date ]]; then
    license_to_check="String"
    expr_date_to_check=$str_lic_exp_date
  else
    license_to_check="File"
    expr_date_to_check=$file_lic_exp_date
  fi

  if [[ !($str_lic_exp_date =~ ^-?[0-9]+$) && $file_lic_exp_date -le $today_date ]]; then
    echo "64 byte string license..."
    echo "Checking if command \"gadmin status lic\" returned error message in format \"Expiration Date: [hidden]\n For more information, please contact support@tigergraph.com\""
    
    #Initialize baseline and error message for first line of output for case when string license is 64 bytes and file license is invalid.
    baseline="Expiration Date: \[hidden\]"
    err_message="Error: expected error message in the format \"Expiration Date: [hidden]\" to be displayed when both string license contains 64 bytes."
 
    #Check if output from gadmin status lic is correct
    check_message "$baseline" "$err_message"
    
    #Initialize baseline and error message for second line of output for case when string license is 64 bytes and file license is invalid.
    baseline="For more information, please contact: support@tigergraph.com"
    err_message="Error: expected error message in the format \"For more information, please contact: support@tigergraph.com\" to be displayed when both string license contains 64 bytes."
   
    #Check if output from gadmin status lic is correct
    check_message "$baseline" "$err_message"
 
  elif [[ $today_date -gt $str_lic_exp_date && $today_date -gt $file_lic_exp_date ]]; then
    echo "Both string license and file license are expired..."
    echo "Checking if command \"gadmin status lic\" returned error message in format \"[Error] License was expired at \$expdate\"..."
    
    #Initialize baseline for error message when no license is valid
    baseline="\[Error\] License was expired at [0-9-]*[ 0-9\:]*"
    err_message="Error: expected error message in the format \"[Error] License was expired at \$expdate\" to be displayed when both string and file licenses are expired."
 
    #Check if output from gadmin status lic is correct
    check_message "$baseline" "$err_message"
         
  elif [[ `datediff $expr_date_to_check $today_date` -lt 30 ]]; then
    echo "$license_to_check license expires in less than 30 days. Checking if a warning message is returned when executing command \"gadmin status lic\"..."
      
    #Initialize baseline for warning massage when license expires in less than 30 days
    baseline="\[Warning\] License will expire in [0-9]+ days*"
    err_message="Error: expected warning message in the format \"[Warning] License will expire in \$days_til_expire\" day(s) to be displayed when $license_to_check license expires in less than 30 days."
    
    #check if output gadmin status lic is correct
    check_message "$baseline" "$err_message"

  else
    echo "$license_to_check license expires in 30 days or more. Making sure no warning message is return when executing command \"gadmin status lic\"..."

    #Initialize baseline to warning message that should NOT be displayed when license expires in more than 30 days
    baseline="\[Warning\] License will expire in [0-9]+ days*"
    err_message="Error: expected no warning message to be displayed when $license_to_check license expires in 30 days or more."
    
    #check if output gadmin status lic is correct
    check_message "$baseline" "$err_message" -n
  fi
}



#The function runs a test case with a specified number of days 
function run_test_case(){
  start_msg=''
  str_lic_valid_days=''
  file_lic_file_name=''
  str_lic_exp_date=''
  file_lic_exp_date=''
  auto_gen_file_lic=false
  help=$(echo "run_test_case [-h] [-m start_message] [-s string_license_valid_days] [-f file_license_file_name] [-au]"
         echo "  -h -- show this message"
         echo "  -m -- specify message to display at the beginning of the test case." 
         echo "        (If NOT specified, no message will be displayed)"
         echo "  -s -- specify number of days from the current date the generated string license should be valid for"
         echo "        if an integer is given, or the string license to use if a non interger is specified." 
         echo "        (If NOT specified, string license will NOT be updated.)"
         echo "  -f -- specify the name of the file (ending in .tgz) containing the file license."
         echo "        (If NOT specified, file license will NOT be updated.)"
         echo "  -au -- specify that the file license should be automatically updated."
         echo "        Note: if both -au and -f are specified, only -au will be honored."
        )

  #Read arguments
  while [[ $# -gt 0 ]]; do
    if [[ $1 = "-h" ]]; then
      echo "$help"
      return 0
    elif [[ $1 = "-m" ]]; then
      start_msg=$2
      shift 2
    elif [[ $1 = "-s" ]]; then
      str_lic_valid_days=$2
      shift 2
    elif [[ $1 = "-f" ]]; then
      file_lic_file_name=$2
      shift 2
    elif [[ $1 = "-au" ]]; then
      auto_gen_file_lic=true
      shift 1
    else
      echo "Invalid option $1. Please see usage below:"
      echo "$help"
      return 40
    fi
  done 
  
  #Print message to display at the beginning of test case (if specified)
  if [[ -n $start_msg ]]; then
    echo $start_msg
  fi
  
  #Update string license
  if [[ -n $str_lic_valid_days ]]; then
    if [[ !($str_lic_valid_days =~ ^-?[0-9]+$) ]]; then
      echo "Updating string license to $str_lic_valid_days..."
      str_lic_exp_date=`update_string_lic -l $str_lic_valid_days` 
    else
      if [[ $str_lic_valid_days -le 0 ]]; then
        echo "Updating string license to expired license..."
      else
        echo "Updating string license to license that expires in $str_lic_valid_days days..."
      fi
      str_lic_exp_date=`update_string_lic $((str_lic_valid_days + 1))`
    fi
  fi

  #Update file license
  #Check if auto update option is enabled
  if [[ $auto_gen_file_lic = true ]]; then
      echo "Automatically updating file license"
      file_lic_exp_date=`update_file_lic -au`
  fi

  #If not, will update file license manually (if sepecified) 
  if [[ $auto_gen_file_lic = false && -n $file_lic_file_name ]]; then
    if [[ !($file_lic_file_name =~ \.tgz$) || !(-e $file_lic_file_name) ]]; then
      echo "Invalid file license \"$file_lic_file_name\". Either file does NOT end with .tgz or file does NOT exist."
      return 50
    fi
    echo "Updating file license to license contained in $file_lic_file_name..."
    file_lic_exp_date=`update_file_lic $file_lic_file_name` 
  fi

  #Check result to make sure it is correct.
  check_result -m "Checking result of test case..." -s "$str_lic_exp_date" -f "$file_lic_exp_date"
  return_code=$?
  if [[ $return_code -eq 0 ]]; then
    echo -e "Test case passed.\n"
    return 0
  else
    return $return_code
  fi

}
