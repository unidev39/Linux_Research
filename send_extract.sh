#!/bin/bash
set -e

######################################################################################################
# Credit Information Bureau Nepal Limited its affiliates. All rights reserved.
# File          : send_extract.sh
# Purpose       : To Extract then transfer files from specified directory to Remote directory in Linux
# Usage         : ./send_extract.sh &
# Created By    : Devesh Kumar Shrivastav
# Created Date  : Feb 21, 2021
# Purpose       : POC on UNIX Extract then Transfer the files
# Revision      : 1.0
######################################################################################################
########################BOF This is part of the send_extract##########################################

# Creating Temporary File
export tmp_file="/home/oracle/extracts/script/processing.txt"

# Condition to Extract and then Transfer
if [[ ! -f "$tmp_file" ]]; then
#Fiscal Year
fiscal_year=$1

#Office Branch
office_branch=$2

#Office Institution
office_institution=$3

#Branch User
branch_user=$4

#From Date (AD)
from_date=$5

#To Date (AD)
to_date=$6

# Database Credentials
db_directory_name=$7
db_username=$8
db_password=$9

#Source File Name
export source_filename="IVC_${from_date}_${to_date}.txt"

rm -rf ${tmp_file}
echo "Processing Start ....." > ${tmp_file}
chown -R oracle:oinstall ${tmp_file}
chmod -R 777 ${tmp_file}

# Export the oracle environment
export ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1
export ORACLE_SID=nplprod1
export PATH=$PATH:$ORACLE_HOME/bin

$ORACLE_HOME/bin/sqlplus ${db_username}/${db_password}  <<EOF
SET SERVEROUTPUT ON;
BEGIN
    Dbms_Output.Put_Line('Query Execution Start Time:=> '||systimestamp);
    DECLARE
         l_inhandler        utl_file.file_type;
         l_outhandle        VARCHAR2(32767);
         TYPE cursor_cr     IS REF cursor;
         l_cursor_cr        cursor_cr;
         l_sql              VARCHAR2(32767);
         l_composit_columns VARCHAR2(500);
         l_count            NUMBER := 0;
    BEGIN
        l_inhandler := utl_file.fopen('${db_directory_name}','${source_filename}','W');

        l_outhandle := 'FISCAL_YR|CIR_NUMBER|SUBJECT_NAME|REQUEST_ID|PRODUCT_ID|PRODUCT_TYPE_ID|NO_OF_PRODUCT|CHARGE_AMOUNT|USER_TYPE|USER_CODE|BANK_CODE|BRANCH_CODE|ACTIVITY_DATE_BS|ACTIVITY_DATE_AD';
        utl_file.put_line(l_inhandler,l_outhandle);

        l_sql := 'SELECT
                       a.fiscal_yr||''|''||a.cir_number||''|''||a.subject_name||''|''||a.request_id||''|''||a.product_id||''|''||a.product_type_id||''|''||a.no_of_product||''|''||a.charge_amount||''|''||a.user_type||''|''||a.user_code||''|''||a.bank_code||''|''||a.branch_code||''|''||a.activity_date_bs||''|''||a.activity_date_ad composit_columns
                  FROM (
                        SELECT
                             b.fiscal_yr,
                             b.cir_number,
                             UPPER(b.subject_name) subject_name,
                             b.request_id,
                             b.product_id,
                             b.product_type_id,
                             b.no_of_product,
                             b.charge_amount,
                             b.user_type,
                             b.user_code,
                             b.bank_code,
                             b.branch_code,
                             b.activity_date_bs,
                             b.activity_date_ad
                        FROM
                             ${db_username}.invoice_data b
                      ) a';
          OPEN l_cursor_cr FOR l_sql;
            LOOP
               FETCH l_cursor_cr INTO l_composit_columns;
               EXIT WHEN l_cursor_cr%NOTFOUND;
                  BEGIN
                      utl_file.put_line(l_inhandler,l_composit_columns);
                  END;
            END LOOP;
            CLOSE l_cursor_cr;
            utl_file.fclose(l_inhandler);
            EXECUTE IMMEDIATE 'SELECT COUNT(*) FROM ${db_username}.invoice_data' INTO l_count;
            EXECUTE IMMEDIATE 'INSERT INTO ${db_username}.inv_log VALUES(${db_username}.sq_sn_inv_log.NEXTVAL,''${fiscal_year}'',''${from_date}'',''${to_date}'',''${source_filename}'','||l_count||',''SUCCEEDED'',NULL)';
            COMMIT;
    EXCEPTION WHEN NO_DATA_FOUND THEN
        utl_file.fclose(l_inhandler);
        EXECUTE IMMEDIATE 'INSERT INTO ${db_username}.inv_log VALUES(${db_username}.sq_sn_inv_log.NEXTVAL,''${fiscal_year}'',''${from_date}'',''${to_date}'',''${source_filename}'','||l_count||',''FAILED'',SQLERRM)';
        COMMIT;
    END;
    Dbms_Output.Put_Line('Query Execution End Time:=> '||systimestamp);
END;
/
exit;

EOF

exit

else

eval rm -rf ${tmp_file}

# Export the oracle environment
export ORACLE_HOME=/opt/app/oracle/product/11.2.0.3/db_1
export ORACLE_SID=nplprod1
export PATH=$PATH:$ORACLE_HOME/bin

#Source File Name
source_filenames=$1

#Source Server Path
source_path=$2

#Destination Server User Name
dest_user=$3

#Destination Server IP
dest_ip=$4

#Destination Server Path
dest_path=$5

#Destination Server User Password
dest_password=$6

#Source File Row Count
filerowcount=$7

# Database Credentials
db_directory_name=$8
input_string=${db_directory_name}
db_directory_name=$(echo ${input_string}| cut -d'|' -f 1)
db_username=$(echo ${input_string}| cut -d'|' -f 2)
db_password=$9

execute=`expect -c "
                    set timeout 10
                    eval spawn scp -r ${source_path}/${source_filenames} ${dest_user}@${dest_ip}:${dest_path}/
                    expect yes/no { send yes\r ; exp_continue }
                    expect $assword: { send ${dest_password}\r }
                    expect 100%
                    sleep 10
                    exit
                   "`

export call_script="dump_extract.sh"
export dest_path1=${dest_path}/script

execute=`expect -c "
                    set timeout 2
                    eval spawn ssh ${dest_user}@${dest_ip} ${dest_path1}/${call_script} ${source_filenames} ${filerowcount} ${db_directory_name} ${db_username} ${db_password}
                    expect yes/no { send yes\r ; exp_continue }
                    expect $assword: { send ${dest_password}\r }
                    expect 100%
                    sleep 2
                    exit
                   "`

exit
fi

exit
# List of all 5 days old files
#source_filenames=`echo ${source_filenames} |  sed 's/_.*//'`
#find ${source_path} -name "${source_filenames}*.txt" -type f -mtime +5 -exec rm -f {} \;

#######################################################################################################
########################BOF This is part of the send_extract###########################################