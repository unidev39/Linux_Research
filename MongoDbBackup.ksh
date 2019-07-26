#!/bin/sh

#########################################################################################
# Eightsquare Pvt. Ltd its affiliates. All rights reserved.
# File          : MongoDbBackup.ksh
# Purpose       : To take a backup files for MongoDB
# Usage         : ./MongoDbBackup.ksh
# Created By    : Devesh Kumar Shrivastav
# Created Date  : June 24, 2019
# Purpose       : UNIX Backup the files
# Revision      : 1.0
#########################################################################################

################BOF This is part of the MongoDbBackup#################

# To Create a FileName
today=`date +MongoDbFullBackUP_%d_%b_%Y`

# Path for the file will be created
backup_dir=/backup/MongoDB/BackUpMongoDB

# To Log the Start Time in Second
start=`date +%s`

# To Create a Date Specific Folder
mkdir -p ${backup_dir}/${today}/dump

# To Take a Backup
mongodump --host 127.0.0.1 --port 27017 -u admin -p P@55w0rd@Pr0D --authenticationDatabase admin --out ${backup_dir}/${today}/dump/ >> /backup/MongoDB/MongoDbBackup_Log/${today}.log 2>&1

# To Log End Time
end=`date +%s`

# To Calculate the Total Execution Time
runtime=$(python -c "print(${end} - ${start})")

# Email Configuration
cd ${backup_dir}
size_with_name="`du -sh "${today}"`"
set -- $size_with_name
size="`echo "$1"`"

subject="Backup Status of LiveChat"
body="Hello All,\n\n DB Full Backup has been completed successfully.
File Size       : "${size}"
File Name       : "${today}"
File Path       : "${backup_dir}"/
Completion Time : "${runtime}" Second \n\n Thank You, \n DBA Team"
from="noreply-chat@mtradeasia.com"
to="devesh@8squarei.com,suman@8squarei.com"
echo -e "Subject:${subject}\n${body}" | sendmail -f "${from}" -t "${to}"
################EOF This is part of the MongoDbBackup#################