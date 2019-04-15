#!/bin/bash

#########################################################################################
# Eightsquare Pvt. Ltd its affiliates. All rights reserved. 
# File          : remove_old_backup_files.ksh
# Purpose       : To remove the old backup files from specified directory
# Usage         : ./remove_old_backup_files.ksh &
# Created By    : Devesh Kumar Shrivastav
# Created Date  : April 10, 2019
# Reviewed By   : Suman Pantha/Aman Maharjan
# Reviewed Date : April 11, 2019
# Purpose       : POC on UNIX remove the files
# Revision      : 1.0
#########################################################################################

################BOF This is part of the remove_old_backup_files#################

# Path for the file will be created
path=/home/ftptest/BackUp

# List of all 30 days old files 
listoffiles=`ls |grep $(date -d "-32 days" +"m1remitprod_backup_%Y_%m_")`

# To Enter source file path   
cd $path

# Single file name that holds the date formats  
filenamelike=`ls |grep $(date -d "-32 days" +"m1remitprod_backup_%Y_%m_%d_")`
filenamelessthan=$(date -d "-32 days" +"m1remitprod_backup_%Y_%m_%d_")

# Process to identify and remove the old files
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
