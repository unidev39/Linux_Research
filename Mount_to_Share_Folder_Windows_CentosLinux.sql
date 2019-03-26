-------------------------------------------------------------------------------------------------------------------------------
The mount.cifs file is provided by the samba-client package. This can be installed from the standard CentOS yum repository by 
running the following command:
[root@localhost ~]#yum install samba samba-client cifs-utils

Once installed, you can mount a Windows SMB share on your CentOS server by running the following command:
Syntax: mount.cifs //SERVER_ADDRESS/SHARE_NAME MOUNT_POINT -o user=USERNAME

SERVER_ADDRESS: Windows system’s IP address or hostname
SHARE_NAME: The name of the shared folder configured on the Windows system
USERNAME: Windows user that has access to this share
MOUNT_POINT: The local mount point on your CentOS server

[root@localhost ~]#mkdir -p /POC/Windows_inotify_1 /POC/Windows_inotify_2
[root@localhost ~]#chown -R mssql:oinstall /POC/Windows_inotify_1 /POC/Windows_inotify_2
[root@localhost ~]#chmod -R 777 /POC/Windows_inotify_1 /POC/Windows_inotify_2

[root@localhost ~]# mount.cifs //192.168.159.136/Windows_mount_point_1 /POC/Windows_inotify_1 -o user=Administrator
Password for Administrator@//192.168.159.136/Windows_mount_point_1:  ********

[root@localhost ~]# mount.cifs //192.168.159.139/Windows_mount_point_1 /POC/Windows_inotify_1 -o user=Administrator
Password for Administrator@//192.168.159.139/Windows_mount_point_1:  ********

or
[root@localhost ~]#mount -t cifs -o username=Administrator,password=P@ssw0rd //192.168.159.136/Windows_mount_point_1 /POC/Windows_inotify_1
[root@localhost ~]#mount -t cifs -o username=Administrator,password=P@ssw0rd //192.168.159.139/Windows_mount_point_2 /POC/Windows_inotify_2

-------------------------------------------------------------------------------------------------------------------------------
To permanently mount a cifs drive, open /etc/fstab add the following lines,

[root@localhost ~]# cat /etc/fstab
#Mount Point
//192.168.159.136/Windows_mount_point_1 /POC/Windows_inotify_1 cifs _netdev,x-systemd.after=network-online.target,username=Administrator,password=P@ssw0rd
//192.168.159.139/Windows_mount_point_2 /POC/Windows_inotify_2 cifs _netdev,x-systemd.after=network-online.target,username=Administrator,password=P@ssw0rd
[root@localhost ~]#
-------------------------------------------------------------------------------------------------------------------------------

[root@localhost POC]# df -h
Filesystem                               Size  Used Avail Use% Mounted on
/dev/mapper/centos-root                   18G  986M   17G   6% /
devtmpfs                                 479M     0  479M   0% /dev
tmpfs                                    489M     0  489M   0% /dev/shm
tmpfs                                    489M  6.7M  483M   2% /run
tmpfs                                    489M     0  489M   0% /sys/fs/cgroup
/dev/sda1                                497M  123M  375M  25% /boot
tmpfs                                     98M     0   98M   0% /run/user/0
//192.168.159.136/Windows_mount_point_1   50G  8.7G   42G  18% /POC/Windows_inotify_1
//192.168.159.139/Windows_mount_point_2   50G  8.6G   42G  18% /POC/Windows_inotify_2
[root@localhost POC]#
