#!/bin/bash

#########################################################################################
# File     : iwait.ksh
# Purpose  : Create the trigger to run the script if the file is created under the specified directory
# Usage    : ./iwait.ksh &
# Author   : Devesh Kumar Shrivastav
# Date     : September 4, 2017
# Purpose  : POC on UNIX Triggering mechanism
# Revision : 1.0
#########################################################################################

################BOF This is part of the iwait#################

. $MMHOME/etc/ra.env

# Path for the file will be created - $filename
path=/home/oracle/RA14DB/mmhome/data

# File name that we looking for
filename="RDWT2.txt"

# Path where the triggering script is located (triggering_script)
script_path=/home/oracle/RA14DB/mmhome/src
script_path=".$script_path/triggering_script.ksh"

# UNIX Triggering mechanism when the movement of file under the directory
#inotifywait -m "$path" -e close_write,create,modify,move,moved_to |

inotifywait -m "$path" -e close_write,moved_to |
while read path action file; do
    if [[ "$file" =~ "$filename"$ ]]; then
       # Provide the permission on file 
       chmod 0777 $path/$filename
       echo "This Test is Pass" >> "/home/oracle/RA14DB/mmhome/data/Pass.txt"
    fi
done

####################################################################
#                       End of Script                              #
####################################################################
