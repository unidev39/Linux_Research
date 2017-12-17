To Split the Partition Over Max Value
==========================================================
This document serves the following purpose:
1.To Split the Partition Over Max Value for Single Table
2.To Split the Partition Over Max Value for Multiple Tables

========================================================================================
Split the Partition Over Max Value using Shell Script(Single or Multiple Execution Mode)
========================================================================================
1. Place all the scripts in this folder in an OS location say '$MMHOME/split_partition_over_maxvalue/'

2. Create a oracle package named ra_data_mart.pk_partition_over_maxvalue in the server pointing towards the OS location of the placed scripts and give appropriate grants to the schema.
   E.g: GRANT CONNECT,RESOURCE TO ra_data_mart;
        GRANT ALL PRIVILEGES TO ra_data_mart;
        GRANT CREATE SESSION,CREATE ANY PROCEDURE,DROP ANY PROCEDURE,EXECUTE ANY PROCEDURE TO ra_data_mart;

3. Grant permission on <Destination folder location> and shell scripts (partition_over_maxvalue.ksh and environment.ksh). 
   Here <Destination folder location> is '$MMHOME/split_partition_over_maxvalue/'
   E.g: chmod  777 $MMHOME/split_partition_over_maxvalue/partition_over_maxvalue.ksh 
        chmod 777 $MMHOME/split_partition_over_maxvalue/environment.ksh

===========================================================
Manual To Split the Partition Over Max Value
===========================================================
While Splitting over Max Value, the execution will be done manually by calling partition_over_maxvalue.ksh depends on the environment.ksh configuration

1. Place all the scripts in the folder in an OS location say '$MMHOME/split_partition_over_maxvalue/'
2. Create the oracle package named pk_partition_over_maxvalue in ra_data_mart schema
3. Set all the dependency in environment.ksh to execute the script partition_over_maxvalue.ksh
   E.g: # To Fetch the Oracle Home
          oracle_home=/u01/app/oracle/product/11.2.0/db_1
        # To Fetch the Schema Name
          db_name='RADM'
        # To Fetch the Schema Password
          db_password='lisnepal'
        # To Fetch the Server IP
          server_ip='192.168.50.19'
        # To Fetch the Oracle Database Open Port
          oracle_port='1521'
        # To Fetch the Serial ID of Oracle Database
          oracle_sid='RA14DB'
        # To Fetch the year to Split the Partition Over Max Value
          year='2018'
        # To Fetch the Execution Mode, Single Table => 1 and Multiple Table => 0
          execution_mode=0
        # To Fetch the Table Name to Split the Partition Over Max Value
          table_name='W_RTL_INV_IT_LC_WK_A'


All the split scripts must be placed in the folder, and the log files will be dumped in the same folder (this folder is created)

Syntax  : ksh <ShellFileLocation>/partition_over_maxvalue.ksh
Example : ksh /home/oracle/RA14DB/mmhome/split_partition_over_maxvalue/partition_over_maxvalue.ksh