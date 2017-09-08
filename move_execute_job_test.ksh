#!/bin/ksh

##################################################################
# File     : move_execute_job_test.ksh
# Purpose  : Create the trigger to run the script if the file is created in the directory
# Usage    : ./move_execute_job_test.ksh
# Author   : Devesh Kumar Shrivastav
# Date     : Augst 31, 2017
# Revision : 1.0
###################################################################

################BOF This is part of the ra_profile#################

. $MMHOME/etc/ra.env

# set the MEG Command
FILENAME="RDWT.txt"
EXECUTEJOB="execute_job_test.ksh"

# set the source directory.
SOURCE_DIRECTORY=/home/oracle/RA14DB/mmhome/source_test_file

# set the target directory.
TARGET_DIRECTORY=/home/oracle/RA14DB/mmhome/data

# verify the source directory is exist or not
if [ ! -d "$SOURCE_DIRECTORY" ] 
then
   echo "Source directory $SOURCE_DIRECTORY does not exist.
   SOURCE_DIRECTORY must point to valid file directory.
   Exiting...." 
exit
fi

# verify the target directory is exist or not
if [ ! -d "$TARGET_DIRECTORY" ]
then
   echo "Target directory $TARGET_DIRECTORY does not exist.
   TARGET_DIRECTORY must point to valid file directory.
   Exiting...."
exit
fi

if [ -f $TARGET_DIRECTORY/moverror.log ];
then
    rm -f $TARGET_DIRECTORY/moverror.log;
fi
EXECUTEJOBTEST="./$EXECUTEJOB"
# check existence of file
if [ ! -f "$SOURCE_DIRECTORY/$FILENAME" ]
then
   echo "Cannot find file $FILENAME in directory $SOURCE_DIRECTORY
   Exiting...."
   exit
else
   #Move the Source File to Target Directory
   mv $SOURCE_DIRECTORY/$FILENAME $TARGET_DIRECTORY/$FILENAME 2>>$TARGET_DIRECTORY/moverror.log;
   chmod 0777 $TARGET_DIRECTORY/$FILENAME
   echo "File have been successfully moved from Source $SOURCE_DIRECTORY/$FILENAME to Target $TARGET_DIRECTORY/$FILENAME"
   cd $TARGET_DIRECTORY

   file=`ls $FILENAME 2>null`;
   
   echo "$file"

   for findfile in $file
   do
      if [ -f $FILENAME ]
      then 
         echo "Pass => $FILENAME"
         eval $EXECUTEJOBTEST
      fi
   done
exit
fi

####################################################################
#                       End of Script                              #
####################################################################
