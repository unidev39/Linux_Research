#!/bin/ksh

##################################################################
# Copyright 2014 Verisk Health, ALL RIGHTS RESERVED
# File     : move_execute_job_test.ksh
# Purpose  : Create the trigger to run the script if the file is created in the directory
# Usage    : ./execute_job_test.ksh <<meg.prm>>
# Author   : Devesh Kumar Shrivastav
# Date     : Augst 31, 2017
# Revision : 1.0
# $Workfile:   slsiltsde.ksh  $
# $Revision: /main/1 $
# $Modtime :    $
###################################################################

################BOF This is part of the ra_profile#################

. $MMHOME/etc/ra.env
FILENAME="RWDT.txt"


file=`ls $FILENAME 2>null`;
echo "$file"

for findfile in $file
do
   if [ -f $FILENAME ]
   then 
      echo "Pass => $FILENAME"
   fi
done



####################################################################
#                       End of Script                              #
####################################################################