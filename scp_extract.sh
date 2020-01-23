#!/bin/sh

##############################################################################################
# Eightsquare Pvt. Ltd its affiliates. All rights reserved. 
# File          : scp_extract.sh
# Purpose       : To transfer files from specified directory one Linux server to Linux another
# Usage         : ./scp_extract.sh &
# Created By    : Devesh Kumar Shrivastav
# Created Date  : Jan 21, 2020
# Purpose       : POC on UNIX Transfer & remove the files
# Revision      : 1.0
#############################################################################################

########################BOF This is part of the scp_extract##################################

#Source Server Path
source_path=$1

#Source Server File Name
source_filename=$2

#Destination Server User Name
dest_user=$3

#Destination Server IP
dest_ip=$4

#Destination Server Path
dest_path=$5

#Destination Server User Password
dest_password=$6

execute=`expect -c "
                    set timeout 1
                    spawn scp -r ${source_path}/${source_filename} ${dest_user}@${dest_ip}:${dest_path}/
                    expect yes/no { send yes\r ; exp_continue }
                    expect password: { send ${dest_password}\r }
                    expect 100%
                    sleep 1
                    exit
                   "`

# List of all 5 days old files 
source_filename=`echo ${source_filename} |  sed 's/_.*//'`
find ${source_path} -name "${source_filename}*.txt" -type f -mtime +5 -exec rm -f {} \;
########################BOF This is part of the scp_extract#########################
