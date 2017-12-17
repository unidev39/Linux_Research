#!/bin/ksh
############################################################
# Workfile      : environment.ksh
# Description   : To Split the Partition Over Max Value
# Created By    : Devesh Kumar Shrivastav
# Created On    : 12/12/2017
# Reviewed By   : Bhuwan Prasad Bhatt
# Reviewed On   : 14/12/2017
############################################################

################BOF This is part of the environment file to set-up required variables for Oracle Partition table#################

# To Fetch the Oracle Home
export oracle_home=/u01/app/oracle/product/11.2.0/db_1

# To Fetch the Schema Name
export db_name='RADM'

# To Fetch the Schema Password
export db_password='lisnepal'

# To Fetch the Server IP
export server_ip='192.168.50.19'

# To Fetch the Oracle Database Open Port
export oracle_port='1521'

# To Fetch the Serial ID of Oracle Database
export oracle_sid='RA14DB'

# To Fetch the year to Split the Partition Over Max Value
export year='2018'

# To Fetch the Execution Mode, Single Table => 1 and Multiple Table => 0
export execution_mode=0
 
# To Fetch the Table Name to Split the Partition Over Max Value
export table_name='W_RTL_SLS_SC_LC_WK_A'