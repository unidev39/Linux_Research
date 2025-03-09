https://www.tecmint.com/extend-and-reduce-lvms-in-linux/

--How to Extend LVM’s (Logical Volume Management) in Linux
--Logical Volume Extending

--Step 1
--Manually extend disk from VM mechine

--Step 1.1 (Verify)
root@uni-db-n1:~# fdisk -ll | grep -E "\-data|\-backup|\-log"
/*
Disk /dev/mapper/uni--vg02--backup-uni--lv--backup: 49.96 GiB, 53645148160 bytes, 104775680 sectors
Disk /dev/mapper/uni--vg02--data-uni--lv--data: 49.96 GiB, 53645148160 bytes, 104775680 sectors
Disk /dev/mapper/uni--vg02--log-uni--lv--log: 49.96 GiB, 53645148160 bytes, 104775680 sectors
*/

--Step 1.2 (Verify)
root@uni-db-n1:~# lsblk
/*
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                                     8:0    0   130G  0 disk
├─sda1                                  8:1    0     1G  0 part /boot/efi
├─sda2                                  8:2    0     1G  0 part /boot
└─sda3                                  8:3    0 127.9G  0 part
  ├─uni--vg01-uni--lv--root           252:2    0    48G  0 lvm  /
  ├─uni--vg01-uni--lv--home           252:3    0    10G  0 lvm  /home
  ├─uni--vg01-uni--lv--srv            252:4    0    10G  0 lvm  /srv
  ├─uni--vg01-uni--lv--usr            252:5    0    10G  0 lvm  /usr
  ├─uni--vg01-uni--lv--var            252:6    0    10G  0 lvm  /var
  ├─uni--vg01-uni--lv--var--lib       252:7    0    10G  0 lvm  /var/lib
  ├─uni--vg01-uni--lv--tmp            252:8    0    10G  0 lvm  /tmp
  └─uni--vg01-uni--lv--swap           252:9    0  19.9G  0 lvm  [SWAP]
sdb                                     8:16   0    50G  0 disk
└─sdb1                                  8:17   0    50G  0 part
  └─uni--vg02--data-uni--lv--data     252:1    0    50G  0 lvm  /data
sdc                                     8:32   0    50G  0 disk
└─sdc1                                  8:33   0    50G  0 part
  └─uni--vg02--backup-uni--lv--backup 252:0    0    50G  0 lvm  /backup
sdd                                     8:48   0    50G  0 disk
└─sdd1                                  8:49   0    50G  0 part
  └─uni--vg02--log-uni--lv--log       252:10   0    50G  0 lvm  /log
sr0                                    11:0    1  1024M  0 rom
*/

--Step 2 (Identify the disk name to load in your OS)
root@uni-db-n1:~# echo 1 > /sys/class/block/sdb/device/rescan
root@uni-db-n1:~# echo 1 > /sys/class/block/sdc/device/rescan
root@uni-db-n1:~# echo 1 > /sys/class/block/sdd/device/rescan

--Step 2.1 (Verify)
root@uni-db-n1:~# lsblk
/*
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                                     8:0    0   130G  0 disk
├─sda1                                  8:1    0     1G  0 part /boot/efi
├─sda2                                  8:2    0     1G  0 part /boot
└─sda3                                  8:3    0 127.9G  0 part
  ├─uni--vg01-uni--lv--root           252:2    0    48G  0 lvm  /
  ├─uni--vg01-uni--lv--home           252:3    0    10G  0 lvm  /home
  ├─uni--vg01-uni--lv--srv            252:4    0    10G  0 lvm  /srv
  ├─uni--vg01-uni--lv--usr            252:5    0    10G  0 lvm  /usr
  ├─uni--vg01-uni--lv--var            252:6    0    10G  0 lvm  /var
  ├─uni--vg01-uni--lv--var--lib       252:7    0    10G  0 lvm  /var/lib
  ├─uni--vg01-uni--lv--tmp            252:8    0    10G  0 lvm  /tmp
  └─uni--vg01-uni--lv--swap           252:9    0  19.9G  0 lvm  [SWAP]
sdb                                     8:16   0   100G  0 disk
└─sdb1                                  8:17   0    50G  0 part
  └─uni--vg02--data-uni--lv--data     252:1    0    50G  0 lvm  /data
sdc                                     8:32   0   100G  0 disk
└─sdc1                                  8:33   0    50G  0 part
  └─uni--vg02--backup-uni--lv--backup 252:0    0    50G  0 lvm  /backup
sdd                                     8:48   0   100G  0 disk
└─sdd1                                  8:49   0    50G  0 part
  └─uni--vg02--log-uni--lv--log       252:10   0    50G  0 lvm  /log
sr0                                    11:0    1  1024M  0 rom
*/


--Step 3 (Create a new partition Using Main Disk - /dev/sdb)
root@uni-db-n1:~# fdisk /dev/sdb
/*
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.


Command (m for help): p

Disk /dev/sdb: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x957a5faa

Device     Boot Start       End   Sectors Size Id Type
/dev/sdb1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (104857600-209715199, default 104857600):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (104857600-209715199, default 209715199):

Created a new partition 2 of type 'Linux' and of size 50 GiB.

Command (m for help): p
Disk /dev/sdb: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x957a5faa

Device     Boot     Start       End   Sectors Size Id Type
/dev/sdb1            2048 104857599 104855552  50G 8e Linux LVM
/dev/sdb2       104857600 209715199 104857600  50G 83 Linux

Command (m for help): t
Partition number (1,2, default 2): 2
Hex code or alias (type L to list all): 8E

Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/sdb: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x957a5faa

Device     Boot     Start       End   Sectors Size Id Type
/dev/sdb1            2048 104857599 104855552  50G 8e Linux LVM
/dev/sdb2       104857600 209715199 104857600  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Syncing disks.
*/

--Step 3.1 (Create a new partition Using Main Disk - /dev/sdc)
root@uni-db-n1:~# fdisk /dev/sdc
/*
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.


Command (m for help): p

Disk /dev/sdc: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x84b5f6f5

Device     Boot Start       End   Sectors Size Id Type
/dev/sdc1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (104857600-209715199, default 104857600):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (104857600-209715199, default 209715199):

Created a new partition 2 of type 'Linux' and of size 50 GiB.

Command (m for help): p
Disk /dev/sdc: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x84b5f6f5

Device     Boot     Start       End   Sectors Size Id Type
/dev/sdc1            2048 104857599 104855552  50G 8e Linux LVM
/dev/sdc2       104857600 209715199 104857600  50G 83 Linux

Command (m for help): t
Partition number (1,2, default 2): 2
Hex code or alias (type L to list all): 8E

Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/sdc: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0x84b5f6f5

Device     Boot     Start       End   Sectors Size Id Type
/dev/sdc1            2048 104857599 104855552  50G 8e Linux LVM
/dev/sdc2       104857600 209715199 104857600  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Syncing disks.
*/

--Step 3.2 (Create a new partition Using Main Disk - /dev/sdd)
root@uni-db-n1:~# fdisk /dev/sdd
/*
Welcome to fdisk (util-linux 2.39.3).
Changes will remain in memory only, until you decide to write them.
Be careful before using the write command.

This disk is currently in use - repartitioning is probably a bad idea.
It's recommended to umount all file systems, and swapoff all swap
partitions on this disk.


Command (m for help): p

Disk /dev/sdd: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe47c6c93

Device     Boot Start       End   Sectors Size Id Type
/dev/sdd1        2048 104857599 104855552  50G 8e Linux LVM

Command (m for help): n
Partition type
   p   primary (1 primary, 0 extended, 3 free)
   e   extended (container for logical partitions)
Select (default p): p
Partition number (2-4, default 2): 2
First sector (104857600-209715199, default 104857600):
Last sector, +/-sectors or +/-size{K,M,G,T,P} (104857600-209715199, default 209715199):

Created a new partition 2 of type 'Linux' and of size 50 GiB.

Command (m for help): p
Disk /dev/sdd: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe47c6c93

Device     Boot     Start       End   Sectors Size Id Type
/dev/sdd1            2048 104857599 104855552  50G 8e Linux LVM
/dev/sdd2       104857600 209715199 104857600  50G 83 Linux

Command (m for help): t
Partition number (1,2, default 2): 2
Hex code or alias (type L to list all): 8E

Changed type of partition 'Linux' to 'Linux LVM'.

Command (m for help): p
Disk /dev/sdd: 100 GiB, 107374182400 bytes, 209715200 sectors
Disk model: Virtual disk
Units: sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disklabel type: dos
Disk identifier: 0xe47c6c93

Device     Boot     Start       End   Sectors Size Id Type
/dev/sdd1            2048 104857599 104855552  50G 8e Linux LVM
/dev/sdd2       104857600 209715199 104857600  50G 8e Linux LVM

Command (m for help): w
The partition table has been altered.
Syncing disks.
*/

--Step 4 (Verify the Disks)
root@uni-db-n1:~# lsblk
/*
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                                     8:0    0   130G  0 disk
├─sda1                                  8:1    0     1G  0 part /boot/efi
├─sda2                                  8:2    0     1G  0 part /boot
└─sda3                                  8:3    0 127.9G  0 part
  ├─uni--vg01-uni--lv--root           252:2    0    48G  0 lvm  /
  ├─uni--vg01-uni--lv--home           252:3    0    10G  0 lvm  /home
  ├─uni--vg01-uni--lv--srv            252:4    0    10G  0 lvm  /srv
  ├─uni--vg01-uni--lv--usr            252:5    0    10G  0 lvm  /usr
  ├─uni--vg01-uni--lv--var            252:6    0    10G  0 lvm  /var
  ├─uni--vg01-uni--lv--var--lib       252:7    0    10G  0 lvm  /var/lib
  ├─uni--vg01-uni--lv--tmp            252:8    0    10G  0 lvm  /tmp
  └─uni--vg01-uni--lv--swap           252:9    0  19.9G  0 lvm  [SWAP]
sdb                                     8:16   0   100G  0 disk
├─sdb1                                  8:17   0    50G  0 part
│ └─uni--vg02--data-uni--lv--data     252:1    0    50G  0 lvm  /data
└─sdb2                                  8:18   0    50G  0 part
sdc                                     8:32   0   100G  0 disk
├─sdc1                                  8:33   0    50G  0 part
│ └─uni--vg02--backup-uni--lv--backup 252:0    0    50G  0 lvm  /backup
└─sdc2                                  8:34   0    50G  0 part
sdd                                     8:48   0   100G  0 disk
├─sdd1                                  8:49   0    50G  0 part
│ └─uni--vg02--log-uni--lv--log       252:10   0    50G  0 lvm  /log
└─sdd2                                  8:50   0    50G  0 part
sr0                                    11:0    1  1024M  0 rom
*/

--Step 5 (Verify the pvs)
root@uni-db-n1:~# pvs
/*
  PV         VG              Fmt  Attr PSize    PFree
  /dev/sda3  uni-vg01        lvm2 a--  <127.95g     0
  /dev/sdb1  uni-vg02-data   lvm2 a--    49.99g 32.00m
  /dev/sdc1  uni-vg02-backup lvm2 a--    49.99g 32.00m
  /dev/sdd1  uni-vg02-log    lvm2 a--    49.99g 32.00m
*/

--Step 6 (Create the pvs - /dev/sdb2)
root@uni-db-n1:~# pvcreate /dev/sdb2
/*
  Physical volume "/dev/sdb2" successfully created.
*/

--Step 6.1 (Create the pvs - /dev/sdc2)
root@uni-db-n1:~# pvcreate /dev/sdc2
/*
  Physical volume "/dev/sdc2" successfully created.
*/

--Step 6.2 (Create the pvs - /dev/sdd2)
root@uni-db-n1:~# pvcreate /dev/sdd2
/*
  Physical volume "/dev/sdd2" successfully created.
*/

--Step 7 (Verify the pvs)
root@uni-db-n1:~# pvs
/*
  PV         VG              Fmt  Attr PSize    PFree
  /dev/sda3  uni-vg01        lvm2 a--  <127.95g     0
  /dev/sdb1  uni-vg02-data   lvm2 a--    49.99g 32.00m
  /dev/sdb2                  lvm2 ---    50.00g 50.00g
  /dev/sdc1  uni-vg02-backup lvm2 a--    49.99g 32.00m
  /dev/sdc2                  lvm2 ---    50.00g 50.00g
  /dev/sdd1  uni-vg02-log    lvm2 a--    49.99g 32.00m
  /dev/sdd2                  lvm2 ---    50.00g 50.00g
*/

--Step 8 (Verify the vgs)
root@uni-db-n1:~# vgs
/*
  VG              #PV #LV #SN Attr   VSize    VFree
  uni-vg01          1   8   0 wz--n- <127.95g     0
  uni-vg02-backup   1   1   0 wz--n-   49.99g 32.00m
  uni-vg02-data     1   1   0 wz--n-   49.99g 32.00m
  uni-vg02-log      1   1   0 wz--n-   49.99g 32.00m
*/

--Step 9 (Create the vgs - uni-vg02-data for /dev/sdb2)
root@uni-db-n1:~# vgextend uni-vg02-data /dev/sdb2
/*
  Volume group "uni-vg02-data" successfully extended
*/

--Step 9.1 (Create the vgs - uni-vg02-backup for /dev/sdc2)
root@uni-db-n1:~# vgextend uni-vg02-backup /dev/sdc2
/*
  Volume group "uni-vg02-backup" successfully extended
*/

--Step 9.2 (Create the vgs - uni-vg02-log for /dev/sdd2)
root@uni-db-n1:~# vgextend uni-vg02-log /dev/sdd2
/*
  Volume group "uni-vg02-log" successfully extended
*/

--Step 10 (Verify the pvs)
root@uni-db-n1:~# pvs
/*
  PV         VG              Fmt  Attr PSize    PFree
  /dev/sda3  uni-vg01        lvm2 a--  <127.95g     0
  /dev/sdb1  uni-vg02-data   lvm2 a--    49.99g 32.00m
  /dev/sdb2  uni-vg02-data   lvm2 a--    49.99g 49.99g
  /dev/sdc1  uni-vg02-backup lvm2 a--    49.99g 32.00m
  /dev/sdc2  uni-vg02-backup lvm2 a--    49.99g 49.99g
  /dev/sdd1  uni-vg02-log    lvm2 a--    49.99g 32.00m
  /dev/sdd2  uni-vg02-log    lvm2 a--    49.99g 49.99g
*/

--Step 11 (Verify the lvs)
root@uni-db-n1:~# lvs
/*
  LV             VG              Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  uni-lv-home    uni-vg01        -wi-ao----  10.00g
  uni-lv-root    uni-vg01        -wi-ao----  48.00g
  uni-lv-srv     uni-vg01        -wi-ao----  10.00g
  uni-lv-swap    uni-vg01        -wi-ao---- <19.95g
  uni-lv-tmp     uni-vg01        -wi-ao----  10.00g
  uni-lv-usr     uni-vg01        -wi-ao----  10.00g
  uni-lv-var     uni-vg01        -wi-ao----  10.00g
  uni-lv-var-lib uni-vg01        -wi-ao----  10.00g
  uni-lv-backup  uni-vg02-backup -wi-ao----  49.96g
  uni-lv-data    uni-vg02-data   -wi-ao----  49.96g
  uni-lv-log     uni-vg02-log    -wi-ao----  49.96g
*/

--Step 12 (Scan the pvs)
root@uni-db-n1:~# pvscan
/*
  PV /dev/sdd1   VG uni-vg02-log      lvm2 [49.99 GiB / 32.00 MiB free]
  PV /dev/sdd2   VG uni-vg02-log      lvm2 [49.99 GiB / 49.99 GiB free]
  PV /dev/sdc1   VG uni-vg02-backup   lvm2 [49.99 GiB / 32.00 MiB free]
  PV /dev/sdc2   VG uni-vg02-backup   lvm2 [49.99 GiB / 49.99 GiB free]
  PV /dev/sdb1   VG uni-vg02-data     lvm2 [49.99 GiB / 32.00 MiB free]
  PV /dev/sdb2   VG uni-vg02-data     lvm2 [49.99 GiB / 49.99 GiB free]
  PV /dev/sda3   VG uni-vg01          lvm2 [<127.95 GiB / 0    free]
  Total: 7 [<427.90 GiB] / in use: 7 [<427.90 GiB] / in no VG: 0 [0   ]
*/

--Step 13 (Verify the name of Disk used by data,backup and log)
root@uni-db-n1:~# lvdisplay | grep -E "\-data|\-backup|\-log"
/*
  LV Path                /dev/uni-vg02-log/uni-lv-log
  LV Name                uni-lv-log
  VG Name                uni-vg02-log
  LV Path                /dev/uni-vg02-backup/uni-lv-backup
  LV Name                uni-lv-backup
  VG Name                uni-vg02-backup
  LV Path                /dev/uni-vg02-data/uni-lv-data
  LV Name                uni-lv-data
  VG Name                uni-vg02-data
*/

--Step 14 (Verify the lvs - /dev/uni-vg02-data/uni-lv-data)
root@uni-db-n1:~# lvdisplay /dev/uni-vg02-data/uni-lv-data
/*
  --- Logical volume ---
  LV Path                /dev/uni-vg02-data/uni-lv-data
  LV Name                uni-lv-data
  VG Name                uni-vg02-data
  LV UUID                vSywbR-oVw8-SfMo-vJlV-l9i1-PRWU-2N1Puy
  LV Write Access        read/write
  LV Creation host, time uni-db-master01.kskl.org.np, 2025-01-10 20:04:03 +0545
  LV Status              available
  # open                 1
  LV Size                49.96 GiB
  Current LE             6395
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:1
*/

--Step 14.1 (Verify the lvs - /dev/uni-vg02-backup/uni-lv-backup)
root@uni-db-n1:~# lvdisplay /dev/uni-vg02-backup/uni-lv-backup
/*
  --- Logical volume ---
  LV Path                /dev/uni-vg02-backup/uni-lv-backup
  LV Name                uni-lv-backup
  VG Name                uni-vg02-backup
  LV UUID                9j9XjW-2so3-tLBe-rTYb-RQnB-7AXW-93AE74
  LV Write Access        read/write
  LV Creation host, time uni-db-master01.kskl.org.np, 2025-01-10 20:04:20 +0545
  LV Status              available
  # open                 1
  LV Size                49.96 GiB
  Current LE             6395
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:0
*/

--Step 14.2 (Verify the lvs - /dev/uni-vg02-log/uni-lv-log)
root@uni-db-n1:~# lvdisplay /dev/uni-vg02-log/uni-lv-log
/*
  --- Logical volume ---
  LV Path                /dev/uni-vg02-log/uni-lv-log
  LV Name                uni-lv-log
  VG Name                uni-vg02-log
  LV UUID                keePEs-2umI-aYXJ-Xstq-mHAl-P0TN-8tvXVX
  LV Write Access        read/write
  LV Creation host, time uni-db-master01.kskl.org.np, 2025-01-10 20:04:41 +0545
  LV Status              available
  # open                 1
  LV Size                49.96 GiB
  Current LE             6395
  Segments               1
  Allocation             inherit
  Read ahead sectors     auto
  - currently set to     256
  Block device           252:10
*/


--Step 15 (Verify the vgs - uni-vg02-data and Free PE / Size)
root@uni-db-n1:~# vgdisplay uni-vg02-data
/*
  --- Volume group ---
  VG Name               uni-vg02-data
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               99.98 GiB
  PE Size               8.00 MiB
  Total PE              12798
  Alloc PE / Size       6395 / 49.96 GiB
  Free  PE / Size       6403 / 50.02 GiB
  VG UUID               XKLNRo-XNcc-LUSW-cd6f-5Cnx-iUxW-Luamgl
*/

--Step 15.1 (Verify the vgs - uni-vg02-backup and Free PE / Size)
root@uni-db-n1:~# vgdisplay uni-vg02-backup
/*
  --- Volume group ---
  VG Name               uni-vg02-backup
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               99.98 GiB
  PE Size               8.00 MiB
  Total PE              12798
  Alloc PE / Size       6395 / 49.96 GiB
  Free  PE / Size       6403 / 50.02 GiB
  VG UUID               b5LL0T-IdmK-Yw2L-mSMI-qDu4-cZ59-ZMPQNY
*/

--Step 15.2 (Verify the vgs - uni-vg02-log and Free PE / Size)
root@uni-db-n1:~# vgdisplay uni-vg02-log
/*
  --- Volume group ---
  VG Name               uni-vg02-log
  System ID
  Format                lvm2
  Metadata Areas        2
  Metadata Sequence No  3
  VG Access             read/write
  VG Status             resizable
  MAX LV                0
  Cur LV                1
  Open LV               1
  Max PV                0
  Cur PV                2
  Act PV                2
  VG Size               99.98 GiB
  PE Size               8.00 MiB
  Total PE              12798
  Alloc PE / Size       6395 / 49.96 GiB
  Free  PE / Size       6403 / 50.02 GiB
  VG UUID               1g3HJP-N3kK-Jg89-WfzG-AWY6-1xk4-euOe3k
*/

--Step 16 (Extend the lvs - uni-lv-data using Free PE / Size - 6403 / 50.07 GiB)
root@uni-db-n1:~# lvextend -l +6403 /dev/uni-vg02-data/uni-lv-data
/*
  Size of logical volume uni-vg02-data/uni-lv-data changed from 49.96 GiB (6395 extents) to 99.98 GiB (12798 extents).
  Logical volume uni-vg02-data/uni-lv-data successfully resized.
*/

--Step 16.1 (Extend the lvs - uni-lv-backup using Free PE / Size - 6403 / 50.07 GiB)
root@uni-db-n1:~# lvextend -l +6403 /dev/uni-vg02-backup/uni-lv-backup
/*
  Size of logical volume uni-vg02-backup/uni-lv-backup changed from 49.96 GiB (6395 extents) to 99.98 GiB (12798 extents).
  Logical volume uni-vg02-backup/uni-lv-backup successfully resized.
*/

--Step 16.2 (Extend the lvs - uni-lv-log using Free PE / Size - 6403 / 50.07 GiB)
root@uni-db-n1:~# lvextend -l +6403 /dev/uni-vg02-log/uni-lv-log
/*
  Size of logical volume uni-vg02-log/uni-lv-log changed from 49.96 GiB (6395 extents) to 99.98 GiB (12798 extents).
  Logical volume uni-vg02-log/uni-lv-log successfully resized.
*/

--Step 17 (Idnetify the File System for data xfs,ext4,ext3,...)
root@uni-db-n1:~# df -Th | grep -E "data|backup|log"
/*
/dev/mapper/uni--vg02--log-uni--lv--log                   xfs        50G  2.3G   48G   5% /log
/dev/mapper/uni--vg02--data-uni--lv--data                 xfs        50G   12G   39G  23% /data
/dev/mapper/uni--vg02--backup-uni--lv--backup             xfs        50G  9.0G   41G  18% /backup
*/

--Step 18 (Grow the File System for data for xfs)
root@uni-db-n1:~# xfs_growfs /dev/uni-vg02-data/uni-lv-data
/*
meta-data=/dev/mapper/uni--vg02--data-uni--lv--data isize=512    agcount=4, agsize=3274240 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13096960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 13096960 to 26210304
*/

--Step 18.1 (Grow the File System for data for xfs)
root@uni-db-n1:~# xfs_growfs /dev/uni-vg02-backup/uni-lv-backup
/*
meta-data=/dev/mapper/uni--vg02--backup-uni--lv--backup isize=512    agcount=4, agsize=3274240 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13096960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 13096960 to 26210304
*/

--Step 18.2 (Grow the File System for data for xfs)
root@uni-db-n1:~# xfs_growfs /dev/uni-vg02-log/uni-lv-log
/*
meta-data=/dev/mapper/uni--vg02--log-uni--lv--log isize=512    agcount=4, agsize=3274240 blks
         =                       sectsz=512   attr=2, projid32bit=1
         =                       crc=1        finobt=1, sparse=1, rmapbt=1
         =                       reflink=1    bigtime=1 inobtcount=1 nrext64=0
data     =                       bsize=4096   blocks=13096960, imaxpct=25
         =                       sunit=0      swidth=0 blks
naming   =version 2              bsize=4096   ascii-ci=0, ftype=1
log      =internal log           bsize=4096   blocks=16384, version=2
         =                       sectsz=512   sunit=0 blks, lazy-count=1
realtime =none                   extsz=4096   blocks=0, rtextents=0
data blocks changed from 13096960 to 26210304
*/

--Step 19 (Verify the required size)
root@uni-db-n1:~# fdisk -ll | grep -E "\-data|\-backup|\-log"
/*
Disk /dev/mapper/uni--vg02--backup-uni--lv--backup: 99.98 GiB, 107357405184 bytes, 209682432 sectors
Disk /dev/mapper/uni--vg02--data-uni--lv--data: 99.98 GiB, 107357405184 bytes, 209682432 sectors
Disk /dev/mapper/uni--vg02--log-uni--lv--log: 99.98 GiB, 107357405184 bytes, 209682432 sectors
*/

--Step 20 (Verify the required size)
root@uni-db-n1:~# lsblk
/*
NAME                                  MAJ:MIN RM   SIZE RO TYPE MOUNTPOINTS
sda                                     8:0    0   130G  0 disk
├─sda1                                  8:1    0     1G  0 part /boot/efi
├─sda2                                  8:2    0     1G  0 part /boot
└─sda3                                  8:3    0 127.9G  0 part
  ├─uni--vg01-uni--lv--root           252:2    0    48G  0 lvm  /
  ├─uni--vg01-uni--lv--home           252:3    0    10G  0 lvm  /home
  ├─uni--vg01-uni--lv--srv            252:4    0    10G  0 lvm  /srv
  ├─uni--vg01-uni--lv--usr            252:5    0    10G  0 lvm  /usr
  ├─uni--vg01-uni--lv--var            252:6    0    10G  0 lvm  /var
  ├─uni--vg01-uni--lv--var--lib       252:7    0    10G  0 lvm  /var/lib
  ├─uni--vg01-uni--lv--tmp            252:8    0    10G  0 lvm  /tmp
  └─uni--vg01-uni--lv--swap           252:9    0  19.9G  0 lvm  [SWAP]
sdb                                     8:16   0   100G  0 disk
├─sdb1                                  8:17   0    50G  0 part
│ └─uni--vg02--data-uni--lv--data     252:1    0   100G  0 lvm  /data
└─sdb2                                  8:18   0    50G  0 part
  └─uni--vg02--data-uni--lv--data     252:1    0   100G  0 lvm  /data
sdc                                     8:32   0   100G  0 disk
├─sdc1                                  8:33   0    50G  0 part
│ └─uni--vg02--backup-uni--lv--backup 252:0    0   100G  0 lvm  /backup
└─sdc2                                  8:34   0    50G  0 part
  └─uni--vg02--backup-uni--lv--backup 252:0    0   100G  0 lvm  /backup
sdd                                     8:48   0   100G  0 disk
├─sdd1                                  8:49   0    50G  0 part
│ └─uni--vg02--log-uni--lv--log       252:10   0   100G  0 lvm  /log
└─sdd2                                  8:50   0    50G  0 part
  └─uni--vg02--log-uni--lv--log       252:10   0   100G  0 lvm  /log
sr0                                    11:0    1  1024M  0 rom
*/

--Step 21 (Verify the required size)
root@uni-db-n1:~# df -Th
/*
Filesystem                                                                                   Type      Size  Used Avail Use% Mounted on
tmpfs                                                                                        tmpfs     3.2G  1.5M  3.2G   1% /run
efivarfs                                                                                     efivarfs  256K   54K  198K  22% /sys/firmware/efi/efivars
/dev/mapper/uni--vg01-uni--lv--root                                                          xfs        48G  979M   47G   2% /
/dev/disk/by-id/dm-uuid-LVM-0m25Uf9hLfxXFptzs9MKLJtfiFpsrAy8rZUXLlzBNdVN4kdMFem6YAcQRCylJtU1 xfs        10G  2.9G  7.1G  29% /usr
tmpfs                                                                                        tmpfs      16G  1.2M   16G   1% /dev/shm
tmpfs                                                                                        tmpfs     5.0M     0  5.0M   0% /run/lock
/dev/mapper/uni--vg01-uni--lv--var                                                           xfs        10G  627M  9.4G   7% /var
/dev/sda2                                                                                    xfs       960M  237M  724M  25% /boot
/dev/mapper/uni--vg01-uni--lv--tmp                                                           xfs        10G  228M  9.8G   3% /tmp
/dev/mapper/uni--vg01-uni--lv--srv                                                           xfs        10G  228M  9.8G   3% /srv
/dev/mapper/uni--vg01-uni--lv--home                                                          xfs        10G  228M  9.8G   3% /home
/dev/sda1                                                                                    vfat      1.1G  6.2M  1.1G   1% /boot/efi
/dev/mapper/uni--vg02--log-uni--lv--log                                                      xfs       100G  3.2G   97G   4% /log
/dev/mapper/uni--vg02--data-uni--lv--data                                                    xfs       100G   13G   88G  13% /data
/dev/mapper/uni--vg02--backup-uni--lv--backup                                                xfs       100G   10G   91G  10% /backup
/dev/mapper/uni--vg01-uni--lv--var--lib                                                      xfs        10G  442M  9.6G   5% /var/lib
tmpfs                                                                                        tmpfs     3.2G   12K  3.2G   1% /run/user/1000
*/

--Step 22 (Verify the required size)
root@uni-db-n1:~# pvs
/*
  PV         VG              Fmt  Attr PSize    PFree
  /dev/sda3  uni-vg01        lvm2 a--  <127.95g    0
  /dev/sdb1  uni-vg02-data   lvm2 a--    49.99g    0
  /dev/sdb2  uni-vg02-data   lvm2 a--    49.99g    0
  /dev/sdc1  uni-vg02-backup lvm2 a--    49.99g    0
  /dev/sdc2  uni-vg02-backup lvm2 a--    49.99g    0
  /dev/sdd1  uni-vg02-log    lvm2 a--    49.99g    0
  /dev/sdd2  uni-vg02-log    lvm2 a--    49.99g    0
*/

--Step 23 (Verify the required size)
root@uni-db-n1:~# vgs
/*
  VG              #PV #LV #SN Attr   VSize    VFree
  uni-vg01          1   8   0 wz--n- <127.95g    0
  uni-vg02-backup   2   1   0 wz--n-   99.98g    0
  uni-vg02-data     2   1   0 wz--n-   99.98g    0
  uni-vg02-log      2   1   0 wz--n-   99.98g    0
*/

--Step 24 (Verify the required size)
root@uni-db-n1:~# lvs
/*
  LV             VG              Attr       LSize   Pool Origin Data%  Meta%  Move Log Cpy%Sync Convert
  uni-lv-home    uni-vg01        -wi-ao----  10.00g
  uni-lv-root    uni-vg01        -wi-ao----  48.00g
  uni-lv-srv     uni-vg01        -wi-ao----  10.00g
  uni-lv-swap    uni-vg01        -wi-ao---- <19.95g
  uni-lv-tmp     uni-vg01        -wi-ao----  10.00g
  uni-lv-usr     uni-vg01        -wi-ao----  10.00g
  uni-lv-var     uni-vg01        -wi-ao----  10.00g
  uni-lv-var-lib uni-vg01        -wi-ao----  10.00g
  uni-lv-backup  uni-vg02-backup -wi-ao----  99.98g
  uni-lv-data    uni-vg02-data   -wi-ao----  99.98g
  uni-lv-log     uni-vg02-log    -wi-ao----  99.98g
*/