#!/bin/ksh
############################################################
# Workfile      : poc_environment.ksh
# Description   : Internet SOH comparison before and After the batch
# Created By    : Devesh Kumar Shrivastav
# Created On    : 2nd April 2018
# Reviewed By   : 
# Reviewed On   : 
############################################################

################BOF This is part of the poc_environment file to set-up required variables for Internet SOH#################

# To Fetch the Oracle Home
export oracle_home=/u01/app/oracle/product/11.2.0/db_1

# To Fetch the Schema Name
export db_name='DSHRIVASTAV'

# To Fetch the Schema Password
export db_password='oracle'

# To Fetch the Server IP
export server_ip='192.168.50.19'

# To Fetch the Oracle Database Open Port
export oracle_port='1521'

# To Fetch the Serial ID of Oracle Database
export oracle_sid='RA14DB'

# To Fetch the Execution Mode, Before snapshot(rms apps are down)=> 1 and After snapshot(Before rms apps are up and after the completion of RA_NIGHTLY Batches - INVILDSIL) => 2
export execution_mode=1