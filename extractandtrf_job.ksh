#!/bin/ksh

. $HOME/.ra.env
##################################################################################################
# Credit Information Bureau Nepal Limited its affiliates. All rights reserved.
# File          : extractandtrf_job.ksh
# Purpose       : Read the Information from File to Extract then Transfer the files on remote
# Usage         : ./extractandtrf_job.ksh
# Created By    : Devesh Kumar Shrivastav
# Created Date  : May 09, 2022
# Purpose       : POC on UNIX Extract then Transfer the files on remote server
# Revision      : 1.0

###################################################################################################
########################BOF This is part of the extractandtrf_job.ksh##############################

# Export the oracle environment
export ORACLE_HOME=/opt/app/oracle/product/11.2.0.3.0/db_1
export ORACLE_SID=racdb1
export PATH=$PATH:$ORACLE_HOME/bin

# Collect the Informatios From File
for f in $FILENAME
do
  g_1=`sed -n '1p' $f`
  g_2=`sed -n '2p' $f`
  g_3=`sed -n '3p' $f`
  g_4=`sed -n '4p' $f`
  g_5=`sed -n '5p' $f`
  g_6=`sed -n '6p' $f`
  g_7=`sed -n '7p' $f`
  g_8=`sed -n '8p' $f`
  g_9=`sed -n '9p' $f`
done

# Load the Informations for the relevant varibals
source_path=${g_1}
dest_user=${g_2}
dest_ip=${g_3}
dest_path=${g_4}
dest_password=${g_5}
db_username=${g_6}
db_password=${g_7}
db_directory_name=${g_8}
source_filenames=${g_9}"$(date +"%d_%m_%Y.txt")"


# To Genrate The Relevant Extract
$ORACLE_HOME/bin/sqlplus ${db_username}/${db_password}  <<EOF
SET SERVEROUTPUT ON;
DECLARE
    l_errmessage       VARCHAR2(4000);
BEGIN
    DECLARE
         l_inhandler        utl_file.file_type;
         l_outhandle        VARCHAR2(32767);
         TYPE cursor_cr     IS REF cursor;
         l_cursor_cr        cursor_cr;
         l_composit_columns VARCHAR2(500);
         l_sql              VARCHAR2(32767) := '';
    BEGIN
        l_inhandler := utl_file.fopen('${db_directory_name}','${source_filenames}','W');
        l_outhandle := 'SN_NO|CREATED_DATE|NAME|FATHER_NAME|F_TYPE';
        utl_file.put_line(l_inhandler,l_outhandle);

        l_sql := 'SELECT
                       a.sn_no||''|''||a.created_date||''|''||a.name||''|''||a.father_name||''|''||a.f_type composit_columns
                  FROM tbl_extractandtrf a
                  ORDER BY
                       a.sn_no';
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
    EXCEPTION WHEN NO_DATA_FOUND THEN
        utl_file.fclose(l_inhandler);
    END;

    INSERT INTO tbl_file_trf_log (process,error) VALUES ('The Relevant File Successfully Generated, Filename - ${source_filenames}',null);
    COMMIT;
    utl_mail.send (sender => 'unidev39@gmail.com', recipients => 'devesh@gmail.com', subject => 'Relevant File Extraction Status',message => 'The Relevant File Successfully Generated, Filename - ${source_filenames}');
EXCEPTION WHEN OTHERS THEN
    IF LENGTH(SQLCODE) > 0 THEN
       l_errmessage := SQLERRM; 
       INSERT INTO tbl_file_trf_log (process,error) VALUES ('The Relevant File Generation Failed, Filename - ${source_filenames}',''||l_errmessage||'');
       COMMIT;
       utl_mail.send (sender => 'unidev39@gmail.com', recipients => 'devesh@gmail.com', subject => 'Relevant File Extraction Status',message => 'The Black List File Generation Failed, with - '||SQLERRM);
       RETURN;
    END IF;
END;
/
exit;

EOF

# To transfer the file on remote server
execute=`expect -c "
                    set timeout 10
                    eval spawn scp -r ${source_path}/${source_filenames} ${dest_user}@${dest_ip}:${dest_path}/
                    expect yes/no { send yes\r ; exp_continue }
                    expect $assword: { send ${dest_password}\r }
                    expect 100%
                    sleep 10
                    exit
                   "`

# To find the error from Transfer log
error_log=`echo ${execute} | grep -i "100%" | wc -w`

if [[ ${error_log} -eq "0" ]]; then

$ORACLE_HOME/bin/sqlplus ${db_username}/${db_password}  <<EOF
SET SERVEROUTPUT ON;
BEGIN
    INSERT INTO tbl_file_trf_log (process,error) VALUES ('The Relevant File Transfer Failed, Filename - ${source_filenames}','issue at scp');
    COMMIT;
    utl_mail.send (sender => 'unidev39@gmail.com', recipients => 'devesh@gmail.com', subject => 'Relevant File Transfer Status',message => 'The Relevant File Transfer Failed, with - '||SQLERRM);
END;
/
exit;

EOF

else

$ORACLE_HOME/bin/sqlplus ${db_username}/${db_password}  <<EOF
SET SERVEROUTPUT ON;
BEGIN
    INSERT INTO tbl_file_trf_log (process,error) VALUES ('The Relevant File Successfully Transferred, Filename - ${source_filenames}',null);
    COMMIT;
    utl_mail.send (sender => 'unidev39@gmail.com', recipients => 'devesh@gmail.com', subject => 'Relevant File Transfer Status',message => 'The Relevant File Successfully Transferred, Filename -${source_filenames}');
END;
/
exit;

EOF

fi
exit
###################################################################################################
###################################################################################################
#$HOME
#/home/oracle
#$HOME/.ra.env
#FILENAME="$HOME/.CONTAIN.txt"
#$HOME/.CONTAIN.txt
#/home/oracle/relevant
#oracle
#192.168.1.1
#/home/oracle/relevant
#Or#c!EdB!!#39
#HR
#Or#c!EdB!!#39
#DIR_NAME
#Relevant_
###################################################################################################
########################EOF This is part of the extractandtrf_job.ksh##############################
