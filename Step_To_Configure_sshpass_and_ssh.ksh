To install sshpass on linux
[root@localhost ~]#yum install sshpass
[root@localhost ~]#sshpass -p "P@ssw0rd" ssh Administrator@192.168.159.136
[root@localhost ~]#sshpass -p "P@ssw0rd" ssh Administrator@192.168.159.139

------------------------------------------------------------------------------------------------------------------------------
To build sshpass on Windows (Cygwin):

$ curl -LO http://downloads.sourceforge.net/sshpass/sshpass-1.06.tar.gz
$ md5sum sshpass-1.06.tar.gz
f59695e3b9761fb51be7d795819421f9

Build and install to /usr/local/bin:

Administrator@WIN-NCT2H96T0RC ~
$ tar xvf sshpass-1.06.tar.gz
Administrator@WIN-NCT2H96T0RC ~
$ cd sshpass-1.06
Administrator@WIN-NCT2H96T0RC /sshpass-1.06
$ ./configure
Administrator@WIN-NCT2H96T0RC /sshpass-1.06
$ make
Administrator@WIN-NCT2H96T0RC /sshpass-1.06
$ sudo make install
or
Administrator@WIN-NCT2H96T0RC /sshpass-1.06
$ make install
Administrator@WIN-NCT2H96T0RC /sshpass-1.06
$ ./sshpass.exe -p root ssh root@192.168.159.130

Which installs two files
 1.the executable /usr/local/bin/sshpass
 2.man page /usr/local/share/man/man1/sshpass.1

Your Cygwin install needs to have the required tools: curl to download, tar to extract, and autoconf, make and gcc to build. 
I'll assume reader familiarity with installing packages on Cygwin.'

Cygwin Setup Tips: install package => openssh,ssh,openssl,vim,rcync,make,autoconf,curl,gcc...
------------------------------------------------------------------------------------------------------------------------------
To install crotab in cygwin :https://www.davidjnice.com/cygwin_cron_service.html
To schedule jobs under crontab :http://ehealth-aussie.blogspot.com/2013/06/setup-cygwin-cron-service-on-windows.html
------------------------------------------------------------------------------------------------------------------------------
Administrator@WIN-SCQ0AST90GT ~
$ sshpass -p root scp /Cygwin-Terminal.ico root@192.168.159.130:/POC/Windows_inotify_2/
------------------------------------------------------------------------------------------------------------------------------
[root@localhost ~]# sshpass -p "P@ssw0rd" ssh Administrator@192.168.159.136  "C:/\Windows/\system32/\cmd.exe"

----------------------------------------------------------------
Steps to configure linux server for password less ssh connection
----------------------------------------------------------------
Step 1: Login to the database server from which the perl/shell script is to be run.

Step 2: $ ssh-keygen -t rsa 
The output to Step 2 is (Enter blanks if asked to enter user input):
Generating public/private rsa key pair.
Enter file in which to save the key (/home/oracle/.ssh/id_rsa):  (Press Enter)
(If Overwrite (y/n)? is asked answer as 'n' )
Created directory '/home/oracle/.ssh'.
Enter passphrase (empty for no passphrase): (Press Enter)
Enter same passphrase again:  (Press Enter)
Your identification has been saved in /home/oracle/.ssh/id_rsa.
Your public key has been saved in /home/oracle/.ssh/id_rsa.pub.
The key fingerprint is:
08:8a:ef:dc:a9:18:d5:e1:a0:cf:23:6b:64:98:e3:2d oracle@sitaram

Step 3: $ cat .ssh/id_rsa.pub | ssh WinUser@WinIP 'cat>> .ssh/authorized_keys'
E.g. : $ cat .ssh/id_rsa.pub | ssh Administrator@192.168.159.136 'cat>> .ssh/authorized_keys'
o/p: 
The authenticity of host '192.168.159.136 (192.168.159.136)' can't be established.
RSA key fingerprint is 83:d4:60:6a:99:db:cc:54:83:1c:1f:e4:86:f1:20:ca.
Are you sure you want to continue connecting (yes/no)? yes  <-Answer as yes
Warning: Permanently added '192.168.159.136' (RSA) to the list of known hosts.
Administrator@192.168.159.136's password:       <-Enter Windows user password

Step 4: $ ssh WinUser@WInIP (Test for passwordless ssh connection)
E.g. :  $ ssh Administrator@192.168.159.136

----------------------------------------------------------------
Steps to configure linux server for password less ssh connection
----------------------------------------------------------------
Step 5: Login to the database server from which the perl/shell script is to be run.

Step 6: $ ssh-keygen -t rsa 
The output to Step 2 is (Enter blanks if asked to enter user input):
Generating public/private rsa key pair.
Enter file in which to save the key (/home/oracle/.ssh/id_rsa):  (Press Enter)
(If Overwrite (y/n)? is asked answer as 'n' )
Created directory '/home/oracle/.ssh'.
Enter passphrase (empty for no passphrase): (Press Enter)
Enter same passphrase again:  (Press Enter)
Your identification has been saved in /home/oracle/.ssh/id_rsa.
Your public key has been saved in /home/oracle/.ssh/id_rsa.pub.
The key fingerprint is:
08:8a:ef:dc:a9:18:d5:e1:a0:cf:23:6b:64:98:e3:2d oracle@sitaram

Step 7: $ cat .ssh/id_rsa.pub | ssh WinUser@WinIP 'cat>> .ssh/authorized_keys'
E.g. : $ cat .ssh/id_rsa.pub | ssh Administrator@192.168.159.139 'cat>> .ssh/authorized_keys'
o/p: 
The authenticity of host '192.168.159.139 (192.168.159.139)' can't be established.
RSA key fingerprint is 83:d4:60:6a:99:db:cc:54:83:1c:1f:e4:86:f1:20:ca.
Are you sure you want to continue connecting (yes/no)? yes  <-Answer as yes
Warning: Permanently added '192.168.159.139' (RSA) to the list of known hosts.
Administrator@192.168.159.139's password:       <-Enter Windows user password

Step 8: $ ssh WinUser@WInIP (Test for passwordless ssh connection)
E.g. :  $ ssh Administrator@192.168.159.139



