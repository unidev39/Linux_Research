--Introduction
/*
For large SGA sizes, HugePages can give substantial benefits in virtual memory management. 
Without HugePages, the memory of the SGA is divided into 4K pages, which have to be managed by the Linux kernel. 
Using HugePages, the page size is increased to 2MB (configurable to 1G if supported by the hardware), 
thereby reducing the total number of pages to be managed by the kernel and therefore reducing the amount 
of memory required to hold the page table in memory. In addition to these changes, the memory associated 
with HugePages can not be swapped out, which forces the SGA to stay memory resident.
*/

--Step 1 - On Both Nodes - (To determine how much memory you are currently using to support the page table, run the following command at a time when the server is under normal/heavy load.)
[root@pdb1/pdb2 ~]# grep PageTables /proc/meminfo
/*
PageTables:       148100 kB
*/

--Step 2 - On Both Nodes - (Configuring HugePages)
--Run the following command to determine the current HugePage usage. The default HugePage size is 2MB on Oracle Linux 5.x and as you can see from the output below, by default no HugePages are defined.
[root@pdb1/pdb2 ~]# grep Huge /proc/meminfo
/*
AnonHugePages:         0 kB
HugePages_Total:       0
HugePages_Free:        0
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
*/

--Step 3 - On Node 1 - (Identify the HugePage Size)
--Depending on the size of your SGA, you may wish to increase the value of Hugepagesize to 1G
[root@pdb1 ~]# cd /root/Oracle_19C/

--Step 3.1 - On Node 1 - (Create bash file to identify the required size of HugePage)
[root@pdb1 Oracle_19C]# vi hugepages_setting.sh
/*
#!/bin/bash
#
# hugepages_settings.sh
#
# Linux bash script to compute values for the
# recommended HugePages/HugeTLB configuration
# on Oracle Linux
#
# Note: This script does calculation for all shared memory
# segments available when the script is run, no matter it
# is an Oracle RDBMS shared memory segment or not.
#
# This script is provided by Doc ID 401749.1 from My Oracle Support
# http://support.oracle.com

# Welcome text
echo "
This script is provided by Doc ID 401749.1 from My Oracle Support
(http://support.oracle.com) where it is intended to compute values for
the recommended HugePages/HugeTLB configuration for the current shared
memory segments on Oracle Linux. Before proceeding with the execution please note following:
 * For ASM instance, it needs to configure ASMM instead of AMM.
 * The 'pga_aggregate_target' is outside the SGA and
   you should accommodate this while calculating the overall size.
 * In case you changes the DB SGA size,
   as the new SGA will not fit in the previous HugePages configuration,
   it had better disable the whole HugePages,
   start the DB with new SGA size and run the script again.
And make sure that:
 * Oracle Database instance(s) are up and running
 * Oracle Database Automatic Memory Management (AMM) is not setup
   (See Doc ID 749851.1)
 * The shared memory segments can be listed by command:
     # ipcs -m


Press Enter to proceed..."

read

# Check for the kernel version
KERN=`uname -r | awk -F. '{ printf("%d.%d\n",$1,$2); }'`

# Find out the HugePage size
HPG_SZ=`grep Hugepagesize /proc/meminfo | awk '{print $2}'`
if [ -z "$HPG_SZ" ];then
    echo "The hugepages may not be supported in the system where the script is being executed."
    exit 1
fi

# Initialize the counter
NUM_PG=0

# Cumulative number of pages required to handle the running shared memory segments
for SEG_BYTES in `ipcs -m | cut -c44-300 | awk '{print $1}' | grep "[0-9][0-9]*"`
do
    MIN_PG=`echo "$SEG_BYTES/($HPG_SZ*1024)" | bc -q`
    if [ $MIN_PG -gt 0 ]; then
        NUM_PG=`echo "$NUM_PG+$MIN_PG+1" | bc -q`
    fi
done

RES_BYTES=`echo "$NUM_PG * $HPG_SZ * 1024" | bc -q`

# An SGA less than 100MB does not make sense
# Bail out if that is the case
if [ $RES_BYTES -lt 100000000 ]; then
    echo "***********"
    echo "** ERROR **"
    echo "***********"
    echo "Sorry! There are not enough total of shared memory segments allocated for
HugePages configuration. HugePages can only be used for shared memory segments
that you can list by command:

    # ipcs -m

of a size that can match an Oracle Database SGA. Please make sure that:
 * Oracle Database instance is up and running
 * Oracle Database Automatic Memory Management (AMM) is not configured"
    exit 1
fi

# Finish with results
    echo "Recommended setting: vm.nr_hugepages = $NUM_PG";

# End
*/

--Step 3.2 - On Node 1 - (Make the file - hugepages_setting.sh executable)
[root@pdb1 ~]# cd /root/Oracle_19C/
[root@pdb1 Oracle_19C]# chmod u+x hugepages_setting.sh

--Step 3.3 - On Node 1 - (Run the file - hugepages_setting.sh)
--Make sure all the Oracle services are running as normal on the server, then run the script and make a note of the recommended "vm.nr_hugepages" value.
[root@pdb1 Oracle_19C]# ./hugepages_setting.sh
/*
This script is provided by Doc ID 401749.1 from My Oracle Support
(http://support.oracle.com) where it is intended to compute values for
the recommended HugePages/HugeTLB configuration for the current shared
memory segments on Oracle Linux. Before proceeding with the execution please note following:
 * For ASM instance, it needs to configure ASMM instead of AMM.
 * The 'pga_aggregate_target' is outside the SGA and
   you should accommodate this while calculating the overall size.
 * In case you changes the DB SGA size,
   as the new SGA will not fit in the previous HugePages configuration,
   it had better disable the whole HugePages,
   start the DB with new SGA size and run the script again.
And make sure that:
 * Oracle Database instance(s) are up and running
 * Oracle Database Automatic Memory Management (AMM) is not setup
   (See Doc ID 749851.1)
 * The shared memory segments can be listed by command:
     # ipcs -m


Press Enter to proceed...

Recommended setting: vm.nr_hugepages = 7174
*/

--Step 4 - On Both Nodes - (Configuring HugePages)
--Edit the "/etc/sysctl.conf" file as the "root" user, adding the following entry, adjusted based on your output from the script. 
--You should set the value greater than or equal to the value displayed by the script.
--You only need 1 or 2 spare pages.
[root@pdb1/pdb2 ~]# vi /etc/sysctl.conf
/*
vm.nr_hugepages=7176
*/

--Step 4.1 - On Both Nodes - (set it, get the ID of the dba group)
[root@pdb1/pdb2 ~]# fgrep dba /etc/group
/*
dba:x:54322:oracle,grid
backupdba:x:54324:oracle
dgdba:x:54325:oracle
kmdba:x:54326:oracle
racdba:x:54330:oracle
asmdba:x:506:grid,oracle
*/

--Step 4.2 - On Both Nodes - (Use the resulting group ID in the "/etc/sysctl.conf" file)
[root@pdb1/pdb2 ~]# vi /etc/sysctl.conf
/*
vm.hugetlb_shm_group=54322
*/

--Step 4.3 - On Both Nodes - (Verify the File)
[root@pdb1/pdb2 ~]# cat /etc/sysctl.conf | grep huge
/*
vm.nr_hugepages=7171
vm.hugetlb_shm_group=54322
*/

--Step 4.4 - On Both Nodes - (Run the following command as the "root" user)
[root@pdb1/pdb2 ~]# sysctl -p
/*
fs.file-max = 6815744
kernel.sem = 250 32000 100 128
kernel.shmmni = 4096
kernel.shmall = 1073741824
kernel.shmmax = 4398046511104
kernel.panic_on_oops = 1
net.core.rmem_default = 262144
net.core.rmem_max = 4194304
net.core.wmem_default = 262144
net.core.wmem_max = 1048576
net.ipv4.conf.all.rp_filter = 2
net.ipv4.conf.default.rp_filter = 2
fs.aio-max-nr = 1048576
net.ipv4.ip_local_port_range = 49152 65535
vm.nr_hugepages = 7176
vm.hugetlb_shm_group = 54322
*/

--Step 4.5 - On Node 1 - (See the HugePages have been created, but are currently not being used.)
[root@pdb1 ~]# grep Huge /proc/meminfo
/*
AnonHugePages:         0 kB
HugePages_Total:    7176
HugePages_Free:     7176
HugePages_Rsvd:        0
HugePages_Surp:        0
Hugepagesize:       2048 kB
*/

--Step 5 - On Both Nodes - (Configure HugePages)
--Add the following entries into the "/etc/security/limits.conf" script, where the setting is at least the size of the HugePages allocation in KB (HugePages * Hugepagesize). 
--In this case the value is 7176*2048=626688.
[root@pdb1/pdb2 ~]# vi /etc/security/limits.conf
/*
* soft memlock 14696448
* hard memlock 14696448
*/

--Step 6 - On Node 1 - (Check the MEMORY_TARGET parameters are not set for the database and SGA_TARGET and PGA_AGGREGATE_TARGET parameters are being used instead.)
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun May 26 11:23:32 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0

SQL> show parameter target

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
archive_lag_target                   integer     0
db_big_table_cache_percent_target    string      0
db_flashback_retention_target        integer     1440
fast_start_io_target                 integer     0
fast_start_mttr_target               integer     0
memory_max_target                    big integer 0
memory_target                        big integer 0
parallel_servers_target              integer     160
pga_aggregate_target                 big integer 3G
sga_target                           big integer 12G
target_pdbs                          integer     28


SQL> show parameter sga

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
allow_group_access_to_sga            boolean     FALSE
lock_sga                             boolean     FALSE
pre_page_sga                         boolean     FALSE
sga_max_size                         big integer 14G
sga_min_size                         big integer 0
sga_target                           big integer 12G
unified_audit_sga_queue_size         integer     1048576

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0
*/

--Step 6 - On Node 1 - (Restart the server and restart the database services as required.)
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

--Step 6.1 - On Node 1 - (Stop the database Instances)
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb

--Step 6.2 - On Node 1 - (Start the database Instances)
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

--Step 6.3 - On Node 1 - (Verify the database Instances)
[oracle@pdb1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

--Step 7 - On Node 1 - (Force Oracle to use HugePages (USE_LARGE_PAGES))
[oracle@pdb1 ~]$ sqlplus / as sysdba
/*
SQL*Plus: Release 19.0.0.0.0 - Production on Sun May 26 12:16:28 2024
Version 19.22.0.0.0

Copyright (c) 1982, 2023, Oracle.  All rights reserved.


Connected to:
Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0

SQL> show parameter use_large_pages

NAME                                 TYPE        VALUE
------------------------------------ ----------- ------------------------------
use_large_pages                      string      TRUE

SQL> ALTER SYSTEM SET use_large_pages=only SCOPE=SPFILE SID='*';

SQL> exit
Disconnected from Oracle Database 19c Enterprise Edition Release 19.0.0.0.0 - Production
Version 19.22.0.0.0
*/

--Step 7.1 - On Node 1 - (Restart the server and restart the database services as required.)
[oracle@pdb1 ~]$ srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

--Step 7.2 - On Node 1 - (Stop the database Instances)
[oracle@pdb1 ~]$ srvctl stop database -d pdbdb

--Step 7.3 - On Node 1 - (Start the database Instances)
[oracle@pdb1 ~]$ srvctl start database -d pdbdb

--Step 7.4 - On Node 1 - (Verify the database Instances)
[oracle@pdb1 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

--Step 8 - On Node 1 - (Restart the Cluster database Server)
[root@pdb1 ~]# cd /opt/app/19c/grid/bin/

--Step 8.1 - On Node 1 - (Stop the Cluster database)
[root@pdb1 bin]# ./crsctl stop cluster -all

--Step 8.2 - On Both Nodes - (Reboot the Cluster database Server)
[root@pdb1/pdb2 ~]# init 6

--Step 8.3 - On Node 1 - (Verify the Cluster database Server)
[root@pdb1 ~]# cd /opt/app/19c/grid/bin/

--Step 8.4 - On Node 1 - (Verify the Cluster database Server)
[root@pdb1 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.crf
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb1                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.storage
      1        ONLINE  ONLINE       pdb1                     STABLE
--------------------------------------------------------------------------------
*/

--Step 8.5 - On Node 2 - (Verify the Cluster database Server)
[root@pdb2 ~]# cd /opt/app/19c/grid/bin/

--Step 8.6 - On Node 2 - (Verify the Cluster database Server)
[root@pdb2 bin]# ./crsctl stat res -t -init
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.asm
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cluster_interconnect.haip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.crf
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.crsd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cssd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.cssdmonitor
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.ctssd
      1        ONLINE  ONLINE       pdb2                     OBSERVER,STABLE
ora.diskmon
      1        OFFLINE OFFLINE                               STABLE
ora.evmd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.gipcd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.gpnpd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.mdnsd
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.storage
      1        ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
*/

--Step 8.6 - On Both Nodes - (Verify the Cluster database Server)
[root@pdb1/pdb2 ~]# cd /opt/app/19c/grid/bin/
[root@pdb1/pdb2 bin]# ./crsctl stat res -t
/*
--------------------------------------------------------------------------------
Name           Target  State        Server                   State details
--------------------------------------------------------------------------------
Local Resources
--------------------------------------------------------------------------------
ora.LISTENER.lsnr
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.chad
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.net1.network
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
ora.ons
               ONLINE  ONLINE       pdb1                     STABLE
               ONLINE  ONLINE       pdb2                     STABLE
--------------------------------------------------------------------------------
Cluster Resources
--------------------------------------------------------------------------------
ora.ARC.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.ASMNET1LSNR_ASM.lsnr(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.DATA.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN1.lsnr
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.LISTENER_SCAN2.lsnr
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.OCR.dg(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.asm(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     Started,STABLE
      2        ONLINE  ONLINE       pdb2                     Started,STABLE
ora.asmnet1.asmnetwork(ora.asmgroup)
      1        ONLINE  ONLINE       pdb1                     STABLE
      2        ONLINE  ONLINE       pdb2                     STABLE
ora.cvu
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb1.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.pdb2.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.pdbdb.db
      1        ONLINE  ONLINE       pdb1                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
      2        ONLINE  ONLINE       pdb2                     Open,HOME=/opt/app/oracle/product/19c/db_1,STABLE
ora.qosmserver
      1        ONLINE  ONLINE       pdb1                     STABLE
ora.scan1.vip
      1        ONLINE  ONLINE       pdb2                     STABLE
ora.scan2.vip
      1        ONLINE  ONLINE       pdb1                     STABLE
--------------------------------------------------------------------------------
*/

--Step 9 - On Both Nodes - (Verify the Cluster grid listner)
[grid@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

--Step 9.1 - On Node 1 - (Verify the Cluster grid SCAN listner)
[grid@pdb1 ~]$ ps -ef | grep SCAN
/*
grid        7662       1  0 12:25 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN2 -no_crs_notify -inherit
grid       64731   63640  0 12:56 pts/1    00:00:00 grep --color=auto SCAN
*/

--Step 9.2 - On Node 1 - (Verify the Cluster grid SCAN listner)
[grid@pdb1 ~]$ lsnrctl status LISTENER_SCAN2
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2024 12:57:04

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN2)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN2
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                26-MAY-2024 12:25:23
Uptime                    0 days 0 hr. 31 min. 40 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener_scan2/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN2)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.26)(PORT=1521)))
Services Summary...
Service "18528463b26d763ce063150610acac23" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

--Step 9.3 - On Node 1 - (Verify the Cluster grid Local listner)
[grid@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2024 12:57:33

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                26-MAY-2024 12:25:22
Uptime                    0 days 0 hr. 32 min. 10 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "18528463b26d763ce063150610acac23" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

--Step 9.4 - On Node 2 - (Verify the Cluster grid SCAN listner)
[grid@pdb2 ~]$ ps -ef | grep SCAN
/*
grid       12157       1  0 12:26 ?        00:00:00 /opt/app/19c/grid/bin/tnslsnr LISTENER_SCAN1 -no_crs_notify -inherit
grid       64037   62268  0 12:57 pts/0    00:00:00 grep --color=auto SCAN
*/

--Step 9.5 - On Node 2 - (Verify the Cluster grid SCAN listner)
[grid@pdb2 ~]$ lsnrctl status LISTENER_SCAN1
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2024 12:58:17

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER_SCAN1)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER_SCAN1
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                26-MAY-2024 12:26:27
Uptime                    0 days 0 hr. 31 min. 50 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener_scan1/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER_SCAN1)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.25)(PORT=1521)))
Services Summary...
Service "18528463b26d763ce063150610acac23" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 2 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

--Step 9.6 - On Node 2 - (Verify the Cluster grid Local listner)
[grid@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2024 12:58:36

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (DESCRIPTION=(ADDRESS=(PROTOCOL=IPC)(KEY=LISTENER)))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                26-MAY-2024 12:25:47
Uptime                    0 days 0 hr. 32 min. 48 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "18528463b26d763ce063150610acac23" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

--Step 9.7 - On Both Nodes - (Verify the Cluster grid-ASM)
[grid@pdb1/pdb2 ~]$ asmcmd -p
/*
ASMCMD [+] > lsdg
State    Type    Rebal  Sector  Logical_Sector  Block       AU  Total_MB  Free_MB  Req_mir_free_MB  Usable_file_MB  Offline_disks  Voting_files  Name
MOUNTED  EXTERN  N         512             512   4096  1048576    409599   409256                0          409256              0             N  ARC/
MOUNTED  EXTERN  N         512             512   4096  1048576    204799   196654                0          196654              0             N  DATA/
MOUNTED  EXTERN  N         512             512   4096  4194304     20476    20108                0           20108              0             Y  OCR/
ASMCMD [+] > exit
*/

--Step 10 - On Both Nodes - (Verify the Cluster database listner)
[oracle@pdb1/pdb2 ~]$ srvctl status listener
/*
Listener LISTENER is enabled
Listener LISTENER is running on node(s): pdb2,pdb1
*/

--Step 10.1 - On Node 1 - (Verify the Cluster database Local listner)
[oracle@pdb1 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2024 12:54:20

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                26-MAY-2024 12:25:22
Uptime                    0 days 0 hr. 28 min. 57 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb1/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.21)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.23)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM1", status READY, has 1 handler(s) for this service...
Service "18528463b26d763ce063150610acac23" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb1", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

--Step 10.2 - On Node 2 - (Verify the Cluster database Local listner)
[oracle@pdb2 ~]$ lsnrctl status
/*
LSNRCTL for Linux: Version 19.0.0.0.0 - Production on 26-MAY-2024 12:54:41

Copyright (c) 1991, 2023, Oracle.  All rights reserved.

Connecting to (ADDRESS=(PROTOCOL=tcp)(HOST=)(PORT=1521))
STATUS of the LISTENER
------------------------
Alias                     LISTENER
Version                   TNSLSNR for Linux: Version 19.0.0.0.0 - Production
Start Date                26-MAY-2024 12:25:47
Uptime                    0 days 0 hr. 28 min. 53 sec
Trace Level               off
Security                  ON: Local OS Authentication
SNMP                      OFF
Listener Parameter File   /opt/app/19c/grid/network/admin/listener.ora
Listener Log File         /opt/app/oracle/diag/tnslsnr/pdb2/listener/alert/log.xml
Listening Endpoints Summary...
  (DESCRIPTION=(ADDRESS=(PROTOCOL=ipc)(KEY=LISTENER)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.22)(PORT=1521)))
  (DESCRIPTION=(ADDRESS=(PROTOCOL=tcp)(HOST=172.16.6.24)(PORT=1521)))
Services Summary...
Service "+ASM" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_ARC" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_DATA" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "+ASM_OCR" has 1 instance(s).
  Instance "+ASM2", status READY, has 1 handler(s) for this service...
Service "18528463b26d763ce063150610acac23" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "86b637b62fdf7a65e053f706e80a27ca" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "invpdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdb" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
Service "pdbdbXDB" has 1 instance(s).
  Instance "pdbdb2", status READY, has 1 handler(s) for this service...
The command completed successfully
*/

--Step 10.3 - On Node 2 - (Verify the Cluster database Instances)
[oracle@pdb1/pdb2 ~]$  srvctl status database -d pdbdb -v
/*
Instance pdbdb1 is running on node pdb1. Instance status: Open.
Instance pdbdb2 is running on node pdb2. Instance status: Open.
*/

--Step 11 - On Both Nodes - (Verify the HugePage)
[root@pdb1/pdb2 ~]# grep PageTables /proc/meminfo
/*
PageTables:       134116 kB
*/

--Step 12 - On Both Nodes - (Verify the HugePage)
[root@pdb1/pdb2 ~]# grep Huge /proc/meminfo
/*
AnonHugePages:         0 kB
ShmemHugePages:        0 kB
FileHugePages:         0 kB
HugePages_Total:    7176
HugePages_Free:     1030
HugePages_Rsvd:     1024
HugePages_Surp:        0
Hugepagesize:       2048 kB
Hugetlb:        14696448 kB
*/