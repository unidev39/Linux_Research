#!/bin/bash
set -e

##############################################################################################
# Credit Information Bureau Nepal Limited its affiliates. All rights reserved.
# File          : call_extract.sh
# Purpose       : To Call Remote Script with Variable Data in Linux
# Usage         : ./call_extract.sh &
# Created By    : Devesh Kumar Shrivastav
# Created Date  : Feb 21, 2021
# Purpose       : POC on UNIX Transfer & remove the files
# Revision      : 1.0
##############################################################################################
########################BOF This is part of the call_extract##################################

# Export the oracle environment
export ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1
export ORACLE_SID=orcl
export PATH=$PATH:$ORACLE_HOME/bin

#Fiscal Year
fiscal_year=$1

#Office Branch
office_branch=$2

#Office Institution
office_institution=$3

#Branch User
branch_user=$4

#From Date (AD)
from_date=$5

#To Date (AD)
to_date=$6

#Destination Server User Name
dest_user=$7
input_string=${dest_user}
dest_user=$(echo ${input_string}| cut -d'|' -f 1)

#Destination Server IP
dest_ip=$8

#Destination Server User Password
dest_password=$9

#Destination Server Path
dest_path=$(echo ${input_string}| cut -d'|' -f 5)

#Database Credentials
db_directory_name=$(echo ${input_string}| cut -d'|' -f 2)
db_username=$(echo ${input_string}| cut -d'|' -f 3)
db_password=$(echo ${input_string}| cut -d'|' -f 4)

#Destination Script
export call_script="send_extract.sh"

execute=`expect -c "
                    set timeout 5
                    eval spawn ssh ${dest_user}@${dest_ip} ${dest_path}/${call_script} ${fiscal_year} ${office_branch} ${office_institution} ${branch_user} ${from_date} ${to_date} ${db_directory_name} ${db_username} ${db_password}
                    expect yes/no { send yes\r ; exp_continue }
                    expect $assword: { send ${dest_password}\r }
                    expect 100%
                    sleep 5
                    exit
                   "`

exit
#############################################################################################
########################BOF This is part of the call_extract#################################