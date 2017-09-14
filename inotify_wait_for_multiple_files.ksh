#!/bin/bash

#########################################################################################
# Copyright (c) 2017 LIS Nepal its affiliates. All rights reserved. 
# File          : inotify_wait_for_multiple_files.ksh
# Purpose       : Create the trigger to run the script if the file is created under the specified directory
# Usage         : ./inotify_wait_for_multiple_files.ksh &
# Author        : Devesh Kumar Shrivastav
# Date          : September 4, 2017
# Modified Date : September 14, 2017
# Purpose       : POC on UNIX Triggering mechanism
# Revision      : 1.0
#########################################################################################

################BOF This is part of the inotify_wait_for_multiple_files#################

. $MMHOME/etc/ra.env

# Path for the file will be created - $filename
path=/home/oracle/RA14DB/mmhome/data

# File name that we looking for
filename_0="RDWT2.txt"
filename_1="RDWT3.txt"

# Path where the triggering script is located <<triggering_script>>
script_path=/home/oracle/RA14DB/mmhome/src
exec_script_0="./slsilsil.ksh"
exec_script_1="./invildsil.ksh"

# Function to hold the process for completely wright the file to calling by the depended script
file_write_status()
{
lsofresult=`lsof | grep $1 | wc -l`
while [ $lsofresult != 0 ]; do 
  sleep 5
  lsofresult=`lsof | grep $1 | wc -l`
done;
}

# UNIX Triggering mechanism when the movement of file under the directory
# File events - close_write,moved_to,create,modify,move

inotifywait -m "$path" -e close_write,moved_to |
while read path action file; do
    if [[ "$file" =~ "$filename_0"$ ]]; then

       # Provide the permission on file 
       chmod 0777 $path/$filename_0

       # Execute the relevant script
       cd $script_path

       # Dependency managed by using double am-percent(&&) and for execution of calling mechanism in parallel mode by using single am-percent(&)
       file_write_status $filename_0 && eval $exec_script_0 &

     elif [[ "$file" =~ "$filename_1"$ ]]; then

       # Provide the permission on file 
       chmod 0777 $path/$filename_1

       # Execute the relevant script
       cd $script_path

       # Dependency managed by using double am-percent(&&) and for execution of calling mechanism in parallel mode by using single am-percent(&)
       file_write_status $filename_1 && eval $exec_script_1 &
    fi
done

####################################################################
#                       End of Script                              #
####################################################################