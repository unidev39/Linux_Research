--To Clear RAM Memory Cache, Buffer and Swap Space on Linux
--Step 1 (Check the Swap Usage)
[root@pdb1/pdb2 ~]# free -m
/*
              total        used        free      shared  buff/cache   available
Mem:          19713        3819        2333       10834       13560        4707
Swap:         15359           2       15357
*/

--Step 2 (Clearing PageCache)
--To clear the PageCache only, you can use the following command, which will specifically clear the PageCache, helping to free up memory resources.
[root@pdb1/pdb2 ~]# sync; echo 1 > /proc/sys/vm/drop_caches

--Step 3 (Clearing Dentries and Inodes)
--To clear the dentries and inodes only, you can use the following command, which will sync the filesystem and clear both dentries and inodes, 
--improving system performance by releasing cached directory and inode information.
[root@pdb1/pdb2 ~]# sync; echo 2 > /proc/sys/vm/drop_caches


--Step 4 (Clearing PageCache, Dentries, and Inodes)
--To clear the pagecache, dentries, and inodes, you can use the following command, which will sync the filesystem and clear the pagecache, 
--dentries, and inodes, helping to free up memory and improve system performance.
[root@pdb1/pdb2 ~]# sync; echo 3 > /proc/sys/vm/drop_caches 

--Step 5 (Check the Swap Usage)
[root@pdb1/pdb2 ~]# free -m
/*
              total        used        free      shared  buff/cache   available
Mem:          19713        3770       10843        4289        5099       11306
Swap:         15359           2       15357
*/

--Step 7 (Turn Off Swap)
[root@pdb1/pdb2 ~]# swapoff -a

--Step 8 (Check the Swap Usage)-(Wait for the Data to Move On RAM for 1-2min)
[root@pdb1/pdb2 ~]# free -m
/*
              total        used        free      shared  buff/cache   available
Mem:          19713        3763       10812        4291        5137       11311
Swap:             0           0           0
*/

--Step 9 (Turn On Swap)
[root@pdb1/pdb2 ~]# swapon -a

--Step 10 (Check the Swap Usage)
[root@pdb1/pdb2 ~]# free -m
/*
              total        used        free      shared  buff/cache   available
Mem:          19713        3760       10781        4291        5172       11314
Swap:         15359           0       15359
*/

--Step 11 (Optional: Adjust Swappiness)
--If you want to adjust how often your system uses swap, you can change the swappiness value.
--A lower value will decrease the use of swap, while a higher value increases it. The default value is usually 60. 
--You can check the current swappiness value with:
[root@pdb1/pdb2 ~]# cat /proc/sys/vm/swappiness
/*
30
*/

--Step 11.1 (Optional: Adjust Swappiness)
[root@pdb1/pdb2 ~]# sysctl vm.swappiness=20
/*
vm.swappiness = 20
*/

--Step 11.2 (Optional: Adjust Swappiness)
[root@pdb1/pdb2 ~]# cat /proc/sys/vm/swappiness
/*
20
*/