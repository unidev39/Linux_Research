-- Steps to Enable the net or configure IP address 
-- Step 1
[root@localhost ~]# cat /etc/sysconfig/network-scripts/ifcfg-eno16777736
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eno16777736
UUID=96caa36f-4d94-462f-8d44-b10a3a55c649
DEVICE=eno16777736
ONBOOT=no
[root@localhost ~]#

-- Step 2
[root@localhost ~]# vi /etc/sysconfig/network-scripts/ifcfg-eno16777736
TYPE=Ethernet
BOOTPROTO=dhcp
DEFROUTE=yes
PEERDNS=yes
PEERROUTES=yes
IPV4_FAILURE_FATAL=no
IPV6INIT=yes
IPV6_AUTOCONF=yes
IPV6_DEFROUTE=yes
IPV6_PEERDNS=yes
IPV6_PEERROUTES=yes
IPV6_FAILURE_FATAL=no
NAME=eno16777736
UUID=96caa36f-4d94-462f-8d44-b10a3a55c649
DEVICE=eno16777736
ONBOOT=yes
[root@localhost ~]#

-- Step 3
[root@localhost ~]# reboot