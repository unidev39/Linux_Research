https://www.howtoforge.com/samba-server-installation-and-configuration-on-centos-7

First I will explain the methodology to install Samba with an inotify_files share. To install the Samba software, run:

[root@localhost ~]#yum install samba samba-client samba-common

It will install the current Samba version from the CentOS software repository.

Now to configure samba, edit the file /etc/samba/smb.conf. Before making changes, I will make the backup of original 
file as  /etc/samba/smb.conf.bak

[root@localhost ~]#cp -pf /etc/samba/smb.conf /etc/samba/smb.conf.bak

Further, give the entries like this

[root@localhost ~]#vi /etc/samba/smb.conf

[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = centos
security = user
map to guest = bad user
dns proxy = no
#============================ Share Definitions ============================== 
[inotify_files]
path = /POC/inotify_files
browsable =yes
writable = yes
guest ok = yes
read only = no

[root@localhost ~]#systemctl enable smb.service
[root@localhost ~]#systemctl enable nmb.service
[root@localhost ~]#systemctl restart smb.service
[root@localhost ~]#systemctl restart nmb.service

[root@localhost ~]# firewall-cmd --permanent --zone=public --add-service=samba
sucess
[root@localhost ~]# firewall-cmd --reload
sucess
[root@localhost ~]# chcon -Rt samba_share_t /POC/inotify_files/

[root@localhost ~]# vi /etc/samba/smb.conf
# See smb.conf.example for a more detailed config file or
# read the smb.conf manpage.
# Run 'testparm' to verify the config is correct after
# you modified it.

[global]
workgroup = WORKGROUP
server string = Samba Server %v
netbios name = centos
security = user
map to guest = bad user
dns proxy = no
#============================ Share Definitions ==============================
[inotify_files]
path = /POC/inotify_files
browsable =yes
writable = yes
guest ok = yes
read only = no
create mode = 0777
directory mode = 0777

[root@localhost ~]#systemctl restart smb.service
[root@localhost ~]#systemctl restart nmb.service