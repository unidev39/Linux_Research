#!/bin/ksh
############################################################
# Workfile      : partition_over_maxvalue.ksh
# Description   : To Split the Partition Over Max Value
# Created By    : Devesh Kumar Shrivastav
# Created On    : 12/12/2017
# Reviewed By   : Bhuwan Prasad Bhatt
# Reviewed On   : 14/12/2017
############################################################

################BOF This is part of the Split the Partition Over Max Value#################

. $MMHOME/split_partition_over_maxvalue/environment.ksh

# To Log the Operations of query
starttime=$(date +"%m_%d_%Y"_"%H_%M"_"%S")
log_file_name="$MMHOME/split_partition_over_maxvalue/log_file_$starttime.txt"

if [[ "$execution_mode" -ge 1 ]]; then
query=$($oracle_home/bin/sqlplus -s $db_name/$db_password@$server_ip:$oracle_port/$oracle_sid  << EOF
SET SERVEROUTPUT ON SIZE UNLIMITED;
spool $log_file_name
EXECUTE $db_name.pk_partition_over_maxvalue.sp_partition_over_maxvalue('$db_name','$table_name','$year');
spool off
exit
EOF)
elif [[ "$execution_mode" -le 0 ]]; then
query=$($oracle_home/bin/sqlplus -s $db_name/$db_password@$server_ip:$oracle_port/$oracle_sid  << EOF
SET SERVEROUTPUT ON SIZE UNLIMITED;
spool $log_file_name
EXECUTE $db_name.pk_partition_over_maxvalue.sp_partition_over_maxvalues('$db_name','$year');
spool off
exit
EOF)
fi

# To find the Database Errors
datebase_error_log=`grep -o "ERROR" $log_file_name|uniq|wc -c`

if [[ "$datebase_error_log" -ge 5 ]]; then
   echo " \n Error Occured While Database Units Execution! \n\n Now please provide the file to fix the issue to RA Team!!!!! \n\n File_Name: $log_file_name \n"
else
   echo " \n Execution completed successfully! \n\n Now please provide the file for verification to RA Team!!!!! \n\n File_Name: $log_file_name \n"
fi

####################################################################
#                       End of Script                              #
####################################################################
