#!/bin/bash

#########################################################################################
# Eightsquare Pvt. Ltd its affiliates. All rights reserved. 
# File          : remove_old_backup_files.ksh
# Purpose       : To remove the old backup files from specified directory
# Usage         : ./remove_old_backup_files.ksh &
# Created By    : Devesh Kumar Shrivastav
# Created Date  : April 15, 2019
# Reviewed By   : Suman Pantha
# Reviewed Date : April 15, 2019
# Purpose       : POC on UNIX remove the files
# Revision      : 1.0
#########################################################################################

################BOF This is part of the remove_old_backup_files#################
export PATH="/home/ftptest/BackUp":$PATH

# Path for the file will be created
path=/home/ftptest/BackUp

# To Enter source file path   
cd $path

# To Define The File Name
filename="m1remitprod_backup_"

# To Find and Remove all The relevant Files - on the Basis Of System Date and Time
for files in $(find -type f  -mtime +32 | grep $filename); 
do
    if [[ "$files" == *.bak ]]; then
       echo "$files" && rm -rf "$files";
    fi	   
done

# List of all 30 days old files - on the Basis of File Name 
listoffiles=`ls |grep $(date -d "-32 days" +"$filename%Y_%m_")`

# Single file name that holds the date formats - on the Basis of File Name  
filenamelike=`ls |grep $(date -d "-32 days" +"$filename%Y_%m_%d_")`
filenamelessthan=$(date -d "-32 days" +"$filename%Y_%m_%d_")

# Process to identify and remove the old files - on the Basis of File Name 
for file in $listoffiles; do
if [[ -f $file ]]; then
    if [[ "$file" == *.bak ]]; then
	   if [[ "$file" < "$filenamelessthan" || "$file" == "$filenamelike" ]]; then
		      echo "$file has been deleted"
	          rm -rf "$file"
	   fi
	fi
fi
done

####################################################################
#                       End of Script                              #
####################################################################
