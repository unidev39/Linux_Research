#!/bin/bash

#########################################################################################
# Copyright (c) 2017 LIS Nepal its affiliates. All rights reserved. 
# File     : inotify_wait.ksh
# Purpose  : Create the trigger to run the script if the file is created under the specified directory
# Usage    : ./inotify_wait.ksh &
# Author   : Devesh Kumar Shrivastav
# Date     : September 4, 2017
# Purpose  : POC on UNIX Triggering mechanism
# Revision : 1.0
#########################################################################################

################BOF This is part of the inotify_wait#################

. $MMHOME/etc/ra.env

# Path for the file will be created - $filename
path=/home/oracle/RA14DB/mmhome/data

# File name that we looking for
filename="RDWT2.txt"

# Path where the triggering script is located <<triggering_script>>
script_path=/home/oracle/RA14DB/mmhome/src
exec_script="./triggering_script.ksh"

# UNIX Triggering mechanism when the movement of file under the directory
# File events - close_write,moved_to,create,modify,move

inotifywait -m "$path" -e close_write,moved_to |
while read path action file; do
    if [[ "$file" =~ "$filename"$ ]]; then
       # Hold the process for completely wright the file to calling by the depended script
       sleep 5s

       # Provide the permission on file 
       chmod 0777 $path/$filename

       # Execute the relevant script
       cd $script_path
       eval $exec_script
    fi
done

####################################################################
#                       End of Script                              #
####################################################################