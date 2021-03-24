#!/bin/bash
set -e

######################################################################################################
# Credit Information Bureau Nepal Limited its affiliates. All rights reserved.
# File          : dump_extract.sh
# Purpose       : To import the Remote file With Parameters in Linux
# Usage         : ./dump_extract.sh &
# Created By    : Devesh Kumar Shrivastav
# Created Date  : Feb 21, 2021
# Purpose       : POC on UNIX Extract then Transfer the files
# Revision      : 1.0
######################################################################################################
########################BOF This is part of the dump_extract##########################################

# Export the oracle environment
export ORACLE_HOME=/u01/app/oracle/product/10.2.0/db_1
export ORACLE_SID=orcl
export PATH=$PATH:$ORACLE_HOME/bin

#Source File Name
source_filenames=$1

#Source File Row Count
filerowcount=$2

# Database Credentials
db_directory_name=$3
db_username=$4
db_password=$5

$ORACLE_HOME/bin/sqlplus ${db_username}/${db_password}  <<EOF
SET SERVEROUTPUT ON;
DECLARE
    l_timestamp    TIMESTAMP;
BEGIN
    pkg_inv.sp_dump_extract('${source_filenames}',${filerowcount},'${db_directory_name}');
EXCEPTION WHEN OTHERS THEN
    l_timestamp := SYSTIMESTAMP;
    EXECUTE IMMEDIATE 'INSERT INTO ${db_username}.inv_event_error VALUES (0,''${db_username}.pkg_inv.sp_dump_extract'','''||l_timestamp||''','''||SQLERRM||''')';
    COMMIT;
END;
/
exit;

EOF

exit
#############################################################################################
########################BOF This is part of the dump_extract#################################
