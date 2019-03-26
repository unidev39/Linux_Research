#https://linuxize.com/post/how-to-setup-ftp-server-with-vsftpd-on-centos-7/#1-ftp-access
#sudo yum install vsftpd
#sudo systemctl start vsftpd
#sudo systemctl enable vsftpd
#sudo systemctl status vsftpd

#Step -1
[root@localhost ~]# yum install vsftpd ftp
#Step -2
[root@localhost ~]# vi /etc/vsftpd/vsftpd.conf
anonymous_enable=NO
local_enable=YES
write_enable=YES
local_umask=022
dirmessage_enable=YES
xferlog_enable=YES
connect_from_port_20=YES
xferlog_std_format=YES
ascii_upload_enable=YES
ascii_download_enable=YES
listen=NO
listen_ipv6=YES
pam_service_name=vsftpd
userlist_enable=YES
tcp_wrappers=YES

#Step -3
[root@localhost ~]# service vsftpd restart
#Step -4
[root@localhost ~]# chkconfig enable vstpd
#Step -5
[root@localhost ~]# systemctl enable vsftpd.service
#Step -6
[root@localhost ~]# systemctl status vsftpd
#Step -7
[root@localhost ~]# yum install firewalld
#Step -8
[root@localhost ~]# firwell-cmd --permanent --add-port=21/tcp
#Step -9
[root@localhost ~]# service firewalld start
#Step -10
[root@localhost ~]# systemctl start firewalld
#Step -11
[root@localhost ~]# firewall-cmd --permanent --add-port=21/tcp
#Step -12
[root@localhost ~]# firewall-cmd --permanent --add-service=ftp
#Step -13
[root@localhost vsftpd]# vi /etc/selinux/config

# This file controls the state of SELinux on the system.
# SELINUX= can take one of these three values:
#     enforcing - SELinux security policy is enforced.
#     permissive - SELinux prints warnings instead of enforcing.
#     disabled - No SELinux policy is loaded.
SELINUX=enforcing
# SELINUXTYPE= can take one of three two values:
#     targeted - Targeted processes are protected,
#     minimum - Modification of targeted policy. Only selected processes are protected.
#     mls - Multi Level Security protection.
SELINUXTYPE=targeted
#Step -14
[root@localhost vsftpd]# getenforce
#Step -15
[root@localhost ~]# reboot
#Step -16 
[root@localhost ~]# setsebool -P ftp_home_dir on
#Step -17
[root@localhost ~]# useradd ftptest
#Step -18
[root@localhost ~]# passwd ftptest
#Step -19
[root@localhost ~]# ftp 192.168.159.130
Connected to 192.168.159.130 (192.168.159.130).
220 (vsFTPd 3.0.2)
Name (192.168.159.130:root): ftptest
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp>
