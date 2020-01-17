Step 1:
We need to make sure that we have the necessary sources gcc, cpp, make and their dependencies:
[root@rac_sdb ~]# yum install gcc make
/*
Loaded plugins: aliases, changelog, kabi, presto, refresh-packagekit, security, tmprepo, ulninfo, verify, versionlock
Loading support for kernel ABI
Setting up Install Process
Package gcc-4.4.7-23.0.1.el6.x86_64 already installed and latest version
Package 1:make-3.81-23.el6.x86_64 already installed and latest version
Nothing to do
*/

Step 2:
Then after, We can download file "inotify-tools-3.14.tar.gz" from Github here
https://github.com/unidev39/Linux_Research/blob/master/inotify-tools-3.14.tar.gz

Step 3:
Copy the tar file to our loaction
[root@rac_sdb ~]# mkdir -p /home/grid/inotify
[root@rac_sdb ~]# cp -r /mnt/hgfs/inotify-tools-3.14.tar.gz /home/grid/inotify/

Step 4:
Untar the file
[root@rac_sdb ~]# cd /home/grid/inotify
[root@rac_sdb inotify]# tar -xvzf inotify-tools-3.14.tar.gz
/*
inotify-tools-3.14/
inotify-tools-3.14/AUTHORS
inotify-tools-3.14/src/
inotify-tools-3.14/src/Makefile.am
inotify-tools-3.14/src/inotifywatch.c
inotify-tools-3.14/src/Makefile.in
inotify-tools-3.14/src/common.c
inotify-tools-3.14/src/common.h
inotify-tools-3.14/src/inotifywait.c
inotify-tools-3.14/config.guess
inotify-tools-3.14/README
inotify-tools-3.14/Makefile.am
inotify-tools-3.14/configure.ac
inotify-tools-3.14/config.h.in
inotify-tools-3.14/ChangeLog
inotify-tools-3.14/man/
inotify-tools-3.14/man/Makefile.am
inotify-tools-3.14/man/Makefile.in
inotify-tools-3.14/man/inotifywait.1
inotify-tools-3.14/man/inotifywatch.1
inotify-tools-3.14/config.sub
inotify-tools-3.14/Makefile.in
inotify-tools-3.14/aclocal.m4
inotify-tools-3.14/configure
inotify-tools-3.14/COPYING
inotify-tools-3.14/install-sh
inotify-tools-3.14/missing
inotify-tools-3.14/NEWS
inotify-tools-3.14/libinotifytools/
inotify-tools-3.14/libinotifytools/src/
inotify-tools-3.14/libinotifytools/src/inotifytools_p.h
inotify-tools-3.14/libinotifytools/src/Makefile.am
inotify-tools-3.14/libinotifytools/src/redblack.h
inotify-tools-3.14/libinotifytools/src/redblack.c
inotify-tools-3.14/libinotifytools/src/inotifytools.c
inotify-tools-3.14/libinotifytools/src/Makefile.in
inotify-tools-3.14/libinotifytools/src/Doxyfile
inotify-tools-3.14/libinotifytools/src/example.c
inotify-tools-3.14/libinotifytools/src/inotifytools/
inotify-tools-3.14/libinotifytools/src/inotifytools/Makefile.am
inotify-tools-3.14/libinotifytools/src/inotifytools/inotify.h.in
inotify-tools-3.14/libinotifytools/src/inotifytools/inotifytools.h
inotify-tools-3.14/libinotifytools/src/inotifytools/Makefile.in
inotify-tools-3.14/libinotifytools/src/inotifytools/inotify-nosys.h
inotify-tools-3.14/libinotifytools/src/test.c
inotify-tools-3.14/libinotifytools/Makefile.am
inotify-tools-3.14/libinotifytools/Makefile.in
inotify-tools-3.14/INSTALL
inotify-tools-3.14/ltmain.sh
inotify-tools-3.14/depcomp
*/
[root@rac_sdb inotify]# ls -ltr
/*
drwxrwxrwx 5 1000 1000   4096 Mar 14  2010 inotify-tools-3.14
-rwxr-xr-x 1 root root 358772 Jan 17 12:03 inotify-tools-3.14.tar.gz
*/

[root@rac_sdb inotify]# cd inotify-tools-3.14
[root@rac_sdb inotify-tools-3.14]# ls -ltr
/*
drwxrwxrwx 2 1000 1000   4096 Mar 12  2010 src
-rw-r--r-- 1 1000 1000    246 Mar 12  2010 README
-rw-r--r-- 1 1000 1000     48 Mar 12  2010 NEWS
-rwxr-xr-x 1 1000 1000  11419 Mar 12  2010 missing
drwxrwxrwx 2 1000 1000   4096 Mar 12  2010 man
-rw-r--r-- 1 1000 1000  22603 Mar 12  2010 Makefile.in
-rw-r--r-- 1 1000 1000    245 Mar 12  2010 Makefile.am
-rwxr-xr-x 1 1000 1000 243452 Mar 12  2010 ltmain.sh
drwxrwxrwx 3 1000 1000   4096 Mar 12  2010 libinotifytools
-rwxr-xr-x 1 1000 1000  13663 Mar 12  2010 install-sh
-rw-r--r-- 1 1000 1000   9498 Mar 12  2010 INSTALL
-rwxr-xr-x 1 1000 1000  18615 Mar 12  2010 depcomp
-rw-r--r-- 1 1000 1000  17999 Mar 12  2010 COPYING
-rw-r--r-- 1 1000 1000   1810 Mar 12  2010 configure.ac
-rwxr-xr-x 1 1000 1000 386339 Mar 12  2010 configure
-rwxr-xr-x 1 1000 1000  33952 Mar 12  2010 config.sub
-rw-r--r-- 1 1000 1000   2195 Mar 12  2010 config.h.in
-rwxr-xr-x 1 1000 1000  46260 Mar 12  2010 config.guess
-rw-r--r-- 1 1000 1000      0 Mar 12  2010 ChangeLog
-rw-r--r-- 1 1000 1000     39 Mar 12  2010 AUTHORS
-rw-r--r-- 1 1000 1000 316757 Mar 12  2010 aclocal.m4
*/

Step 5:
To Generate the Makefile by running ./configure:
[root@rac_sdb inotify-tools-3.14]# ./configure
/*
checking for a BSD-compatible install... /usr/bin/install -c
checking whether build environment is sane... yes
checking for a thread-safe mkdir -p... /bin/mkdir -p
checking for gawk... gawk
checking whether make sets $(MAKE)... yes
checking whether make sets $(MAKE)... (cached) yes
checking for gcc... gcc
checking for C compiler default output file name... a.out
checking whether the C compiler works... yes
checking whether we are cross compiling... no
checking for suffix of executables... 
checking for suffix of object files... o
checking whether we are using the GNU C compiler... yes
checking whether gcc accepts -g... yes
checking for gcc option to accept ISO C89... none needed
checking for style of include used by make... GNU
checking dependency style of gcc... gcc3
checking build system type... x86_64-unknown-linux-gnu
checking host system type... x86_64-unknown-linux-gnu
checking for a sed that does not truncate output... /bin/sed
checking for grep that handles long lines and -e... /bin/grep
checking for egrep... /bin/grep -E
checking for fgrep... /bin/grep -F
checking for ld used by gcc... /usr/bin/ld
checking if the linker (/usr/bin/ld) is GNU ld... yes
checking for BSD- or MS-compatible name lister (nm)... /usr/bin/nm -B
checking the name lister (/usr/bin/nm -B) interface... BSD nm
checking whether ln -s works... yes
checking the maximum length of command line arguments... 1966080
checking whether the shell understands some XSI constructs... yes
checking whether the shell understands "+="... yes
checking for /usr/bin/ld option to reload object files... -r
checking for objdump... objdump
checking how to recognize dependent libraries... pass_all
checking for ar... ar
checking for strip... strip
checking for ranlib... ranlib
checking command to parse /usr/bin/nm -B output from gcc object... ok
checking how to run the C preprocessor... gcc -E
checking for ANSI C header files... yes
checking for sys/types.h... yes
checking for sys/stat.h... yes
checking for stdlib.h... yes
checking for string.h... yes
checking for memory.h... yes
checking for strings.h... yes
checking for inttypes.h... yes
checking for stdint.h... yes
checking for unistd.h... yes
checking for dlfcn.h... yes
checking for objdir... .libs
checking if gcc supports -fno-rtti -fno-exceptions... no
checking for gcc option to produce PIC... -fPIC -DPIC
checking if gcc PIC flag -fPIC -DPIC works... yes
checking if gcc static flag -static works... no
checking if gcc supports -c -o file.o... yes
checking if gcc supports -c -o file.o... (cached) yes
checking whether the gcc linker (/usr/bin/ld -m elf_x86_64) supports shared libraries... yes
checking whether -lc should be explicitly linked in... no
checking dynamic linker characteristics... GNU/Linux ld.so
checking how to hardcode library paths into programs... immediate
checking whether stripping libraries is possible... yes
checking if libtool supports shared libraries... yes
checking whether to build shared libraries... yes
checking whether to build static libraries... yes
checking for doxygen... /usr/bin/doxygen
checking sys/inotify.h usability... yes
checking sys/inotify.h presence... yes
checking for sys/inotify.h... yes
checking mcheck.h usability... yes
checking mcheck.h presence... yes
checking for mcheck.h... yes
checking whether sys/inotify.h actually works... yup
checking for an ANSI C-conforming const... yes
checking for inline... inline
configure: creating ./config.status
config.status: creating Makefile
config.status: creating src/Makefile
config.status: creating man/Makefile
config.status: creating libinotifytools/Makefile
config.status: creating libinotifytools/src/Makefile
config.status: creating libinotifytools/src/inotifytools/Makefile
config.status: creating config.h
config.status: creating libinotifytools/src/inotifytools/inotify.h
config.status: executing depfiles commands
config.status: executing libtool commands
*/

Step 6:
Now over the Makefile, we can start building from the inotify-tools source code and generate the executables and libs by executing make:
[root@rac_sdb inotify-tools-3.14]# make
/*
make  all-recursive
make[1]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
Making all in libinotifytools
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
Making all in src
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
Making all in inotifytools
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[5]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[5]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
(CDPATH="${ZSH_VERSION+.}:" && cd ../../.. && /bin/sh /home/grid/inotify/inotify-tools-3.14/missing --run autoheader)
aclocal.m4:16: warning: this file was generated for autoconf 2.64.
You have another version of autoconf.  It may work, but is not guaranteed to.
If you have problems, you may need to regenerate the build system entirely.
To do so, use the procedure documented by the package, typically `autoreconf'.
rm -f stamp-h2
touch inotify.h.in
cd ../../.. && /bin/sh ./config.status libinotifytools/src/inotifytools/inotify.h
config.status: creating libinotifytools/src/inotifytools/inotify.h
config.status: libinotifytools/src/inotifytools/inotify.h is unchanged
make  all-am
make[5]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[6]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[6]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[5]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[5]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[5]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
/bin/sh ../../libtool --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools    -std=c99 -g -O2 -MT inotifytools.lo -MD -MP -MF .deps/inotifytools.Tpo -c -o inotifytools.lo inotifytools.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools -std=c99 -g -O2 -MT inotifytools.lo -MD -MP -MF .deps/inotifytools.Tpo -c inotifytools.c  -fPIC -DPIC -o .libs/inotifytools.o
inotifytools.c: In function ‘event_compare’:
inotifytools.c:2029: warning: cast from pointer to integer of different size
inotifytools.c: In function ‘inotifytools_wd_sorted_by_event’:
inotifytools.c:2050: warning: cast to pointer from integer of different size
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools -std=c99 -g -O2 -MT inotifytools.lo -MD -MP -MF .deps/inotifytools.Tpo -c inotifytools.c -o inotifytools.o >/dev/null 2>&1
mv -f .deps/inotifytools.Tpo .deps/inotifytools.Plo
/bin/sh ../../libtool --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools    -std=c99 -g -O2 -MT redblack.lo -MD -MP -MF .deps/redblack.Tpo -c -o redblack.lo redblack.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools -std=c99 -g -O2 -MT redblack.lo -MD -MP -MF .deps/redblack.Tpo -c redblack.c  -fPIC -DPIC -o .libs/redblack.o
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools -std=c99 -g -O2 -MT redblack.lo -MD -MP -MF .deps/redblack.Tpo -c redblack.c -o redblack.o >/dev/null 2>&1
mv -f .deps/redblack.Tpo .deps/redblack.Plo
/bin/sh ../../libtool --tag=CC   --mode=link gcc -std=c99 -g -O2 -version-info 4:1:4  -o libinotifytools.la -rpath /usr/local/lib inotifytools.lo redblack.lo  
libtool: link: gcc -shared  .libs/inotifytools.o .libs/redblack.o      -Wl,-soname -Wl,libinotifytools.so.0 -o .libs/libinotifytools.so.0.4.1
libtool: link: (cd ".libs" && rm -f "libinotifytools.so.0" && ln -s "libinotifytools.so.0.4.1" "libinotifytools.so.0")
libtool: link: (cd ".libs" && rm -f "libinotifytools.so" && ln -s "libinotifytools.so.0.4.1" "libinotifytools.so")
libtool: link: ar cru .libs/libinotifytools.a  inotifytools.o redblack.o
libtool: link: ranlib .libs/libinotifytools.a
libtool: link: ( cd ".libs" && rm -f "libinotifytools.la" && ln -s "../libinotifytools.la" "libinotifytools.la" )
/usr/bin/doxygen
Warning: Tag `USE_WINDOWS_ENCODING' at line 64 of file Doxyfile has become obsolete.
To avoid this warning please update your configuration file using "doxygen -u"
Warning: Tag `DETAILS_AT_TOP' at line 156 of file Doxyfile has become obsolete.
To avoid this warning please update your configuration file using "doxygen -u"
Warning: Tag `MAX_DOT_GRAPH_WIDTH' at line 1196 of file Doxyfile has become obsolete.
To avoid this warning please update your configuration file using "doxygen -u"
Warning: Tag `MAX_DOT_GRAPH_HEIGHT' at line 1204 of file Doxyfile has become obsolete.
To avoid this warning please update your configuration file using "doxygen -u"
Notice: Output directory `doc' does not exist. I have created it for you.
Searching for include files...
Searching for example files...
Searching for files in directory /home/grid/inotify/inotify-tools-3.14/libinotifytools/src
Searching for images...
Searching for dot files...
Searching for files to exclude
Searching for files to process...
Reading and parsing tag files
Preprocessing /home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools/inotifytools.h...
Parsing file /home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools/inotifytools.h...
Preprocessing /home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools.c...
Parsing file /home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools.c...
Building group list...
Building directory list...
Building namespace list...
Building file list...
Building class list...
Associating documentation with classes...
Computing nesting relations for classes...
Building example list...
Searching for enumerations...
Searching for documented typedefs...
Searching for members imported via using declarations...
Searching for included using directives...
Searching for documented variables...
Building member list...
Searching for friends...
Searching for documented defines...
Computing class inheritance relations...
Computing class usage relations...
Flushing cached template relations that have become invalid...
Creating members for template instances...
Computing class relations...
Add enum values to enums...
Searching for member function documentation...
Building page list...
Search for main page...
Computing page relations...
Determining the scope of groups...
Sorting lists...
Freeing entry tree
Determining which enums are documented
Computing member relations...
Building full member lists recursively...
Adding members to member groups.
Computing member references...
Inheriting documentation...
Generating disk names...
Adding source references...
Adding xrefitems...
Counting data structures...
Resolving user defined references...
Finding anchors and sections in the documentation...
Combining using relations...
Adding members to index pages...
Generating style sheet...
Generating index page...
Generating page index...
Generating example documentation...
Generating file sources...
Generating code for file inotifytools.c...
Generating code for file inotifytools/inotifytools.h...
Generating file documentation...
Generating docs for file inotifytools/inotifytools.h...
Generating page documentation...
Generating docs for page todo...
Generating group documentation...
Generating group index...
Generating class documentation...
Generating annotated compound index...
Generating alphabetical compound index...
Generating hierarchical class index...
Generating member index...
Generating namespace index...
Generating namespace member index...
Generating graph info page...
Generating file index...
Generating example index...
Generating file member index...
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Nothing to be done for `all-am'.
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
Making all in src
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14/src'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
gcc -DHAVE_CONFIG_H -I. -I.. -I../libinotifytools/src/inotifytools    -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2 -MT inotifywait.o -MD -MP -MF .deps/inotifywait.Tpo -c -o inotifywait.o inotifywait.c
mv -f .deps/inotifywait.Tpo .deps/inotifywait.Po
gcc -DHAVE_CONFIG_H -I. -I.. -I../libinotifytools/src/inotifytools    -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2 -MT common.o -MD -MP -MF .deps/common.Tpo -c -o common.o common.c
mv -f .deps/common.Tpo .deps/common.Po
/bin/sh ../libtool --tag=CC   --mode=link gcc -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2   -o inotifywait inotifywait.o common.o ../libinotifytools/src/libinotifytools.la 
libtool: link: gcc -std=c99 -I../libinotifytools/src -g -O2 -o .libs/inotifywait inotifywait.o common.o  -L/home/grid/inotify/inotify-tools-3.14/libinotifytools/src ../libinotifytools/src/.libs/libinotifytools.so -Wl,-rpath -Wl,/usr/local/lib
gcc -DHAVE_CONFIG_H -I. -I.. -I../libinotifytools/src/inotifytools    -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2 -MT inotifywatch.o -MD -MP -MF .deps/inotifywatch.Tpo -c -o inotifywatch.o inotifywatch.c
mv -f .deps/inotifywatch.Tpo .deps/inotifywatch.Po
/bin/sh ../libtool --tag=CC   --mode=link gcc -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2   -o inotifywatch inotifywatch.o common.o ../libinotifytools/src/libinotifytools.la 
libtool: link: gcc -std=c99 -I../libinotifytools/src -g -O2 -o .libs/inotifywatch inotifywatch.o common.o  -L/home/grid/inotify/inotify-tools-3.14/libinotifytools/src ../libinotifytools/src/.libs/libinotifytools.so -Wl,-rpath -Wl,/usr/local/lib
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/src'
Making all in man
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14/man'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Nothing to be done for `all'.
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/man'
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
cd . && /bin/sh ./config.status config.h
config.status: creating config.h
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[1]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
*/

Step 7:
Now issue the below commands to install make:
[root@rac_sdb inotify-tools-3.14]# make install
/*
Making install in libinotifytools
make[1]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
Making install in src
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
Making install in inotifytools
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[5]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[5]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[4]: Nothing to be done for `install-exec-am'.
make[4]: Nothing to be done for `install-data-am'.
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src/inotifytools'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
/bin/sh ../../libtool --tag=CC   --mode=compile gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools    -std=c99 -g -O2 -MT inotifytools.lo -MD -MP -MF .deps/inotifytools.Tpo -c -o inotifytools.lo inotifytools.c
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools -std=c99 -g -O2 -MT inotifytools.lo -MD -MP -MF .deps/inotifytools.Tpo -c inotifytools.c  -fPIC -DPIC -o .libs/inotifytools.o
inotifytools.c: In function ‘event_compare’:
inotifytools.c:2029: warning: cast from pointer to integer of different size
inotifytools.c: In function ‘inotifytools_wd_sorted_by_event’:
inotifytools.c:2050: warning: cast to pointer from integer of different size
libtool: compile:  gcc -DHAVE_CONFIG_H -I. -I../.. -I../../libinotifytools/src/inotifytools -std=c99 -g -O2 -MT inotifytools.lo -MD -MP -MF .deps/inotifytools.Tpo -c inotifytools.c -o inotifytools.o >/dev/null 2>&1
mv -f .deps/inotifytools.Tpo .deps/inotifytools.Plo
/bin/sh ../../libtool --tag=CC   --mode=link gcc -std=c99 -g -O2 -version-info 4:1:4  -o libinotifytools.la -rpath /usr/local/lib inotifytools.lo redblack.lo  
libtool: link: rm -fr  .libs/libinotifytools.a .libs/libinotifytools.la .libs/libinotifytools.lai .libs/libinotifytools.so .libs/libinotifytools.so.0 .libs/libinotifytools.so.0.4.1
libtool: link: gcc -shared  .libs/inotifytools.o .libs/redblack.o      -Wl,-soname -Wl,libinotifytools.so.0 -o .libs/libinotifytools.so.0.4.1
libtool: link: (cd ".libs" && rm -f "libinotifytools.so.0" && ln -s "libinotifytools.so.0.4.1" "libinotifytools.so.0")
libtool: link: (cd ".libs" && rm -f "libinotifytools.so" && ln -s "libinotifytools.so.0.4.1" "libinotifytools.so")
libtool: link: ar cru .libs/libinotifytools.a  inotifytools.o redblack.o
libtool: link: ranlib .libs/libinotifytools.a
libtool: link: ( cd ".libs" && rm -f "libinotifytools.la" && ln -s "../libinotifytools.la" "libinotifytools.la" )
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[5]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[5]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
test -z "/usr/local/lib" || /bin/mkdir -p "/usr/local/lib"
 /bin/sh ../../libtool   --mode=install /usr/bin/install -c   libinotifytools.la '/usr/local/lib'
libtool: install: /usr/bin/install -c .libs/libinotifytools.so.0.4.1 /usr/local/lib/libinotifytools.so.0.4.1
libtool: install: (cd /usr/local/lib && { ln -s -f libinotifytools.so.0.4.1 libinotifytools.so.0 || { rm -f libinotifytools.so.0 && ln -s libinotifytools.so.0.4.1 libinotifytools.so.0; }; })
libtool: install: (cd /usr/local/lib && { ln -s -f libinotifytools.so.0.4.1 libinotifytools.so || { rm -f libinotifytools.so && ln -s libinotifytools.so.0.4.1 libinotifytools.so; }; })
libtool: install: /usr/bin/install -c .libs/libinotifytools.lai /usr/local/lib/libinotifytools.la
libtool: install: /usr/bin/install -c .libs/libinotifytools.a /usr/local/lib/libinotifytools.a
libtool: install: chmod 644 /usr/local/lib/libinotifytools.a
libtool: install: ranlib /usr/local/lib/libinotifytools.a
libtool: finish: PATH="/usr/lib64/qt-3.3/bin:/usr/kerberos/sbin:/usr/kerberos/bin:/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin:/root/bin:/sbin" ldconfig -n /usr/local/lib
----------------------------------------------------------------------
Libraries have been installed in:
   /usr/local/lib

If you ever happen to want to link against installed libraries
in a given directory, LIBDIR, you must either use libtool, and
specify the full pathname of the library, or use the `-LLIBDIR'
flag during linking and do at least one of the following:
   - add LIBDIR to the `LD_LIBRARY_PATH' environment variable
     during execution
   - add LIBDIR to the `LD_RUN_PATH' environment variable
     during linking
   - use the `-Wl,-rpath -Wl,LIBDIR' linker flag
   - have your system administrator add LIBDIR to `/etc/ld.so.conf'

See any operating system documentation about shared libraries for
more information, such as the ld(1) and ld.so(8) manual pages.
----------------------------------------------------------------------
test -z "/usr/local/share/doc/inotify-tools" || /bin/mkdir -p "/usr/local/share/doc/inotify-tools"
 /usr/bin/install -c -m 644 doc/html/doxygen.css doc/html/doxygen.png doc/html/files.html doc/html/globals_func.html doc/html/globals.html doc/html/index.html doc/html/inotifytools_8c_source.html doc/html/inotifytools_8h.html doc/html/inotifytools_8h_source.html doc/html/pages.html doc/html/tab_b.gif doc/html/tab_l.gif doc/html/tab_r.gif doc/html/tabs.css doc/html/todo.html '/usr/local/share/doc/inotify-tools'
test -z "/usr/local/include" || /bin/mkdir -p "/usr/local/include"
/bin/mkdir -p '/usr/local/include/inotifytools'
 /usr/bin/install -c -m 644  inotifytools/inotifytools.h inotifytools/inotify-nosys.h inotifytools/inotify.h '/usr/local/include/inotifytools'
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools/src'
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[4]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[4]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Nothing to be done for `install-exec-am'.
make[3]: Nothing to be done for `install-data-am'.
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
make[1]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/libinotifytools'
Making install in src
make[1]: Entering directory `/home/grid/inotify/inotify-tools-3.14/src'
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
gcc -DHAVE_CONFIG_H -I. -I.. -I../libinotifytools/src/inotifytools    -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2 -MT inotifywait.o -MD -MP -MF .deps/inotifywait.Tpo -c -o inotifywait.o inotifywait.c
mv -f .deps/inotifywait.Tpo .deps/inotifywait.Po
gcc -DHAVE_CONFIG_H -I. -I.. -I../libinotifytools/src/inotifytools    -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2 -MT common.o -MD -MP -MF .deps/common.Tpo -c -o common.o common.c
mv -f .deps/common.Tpo .deps/common.Po
/bin/sh ../libtool --tag=CC   --mode=link gcc -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2   -o inotifywait inotifywait.o common.o ../libinotifytools/src/libinotifytools.la 
libtool: link: gcc -std=c99 -I../libinotifytools/src -g -O2 -o .libs/inotifywait inotifywait.o common.o  -L/home/grid/inotify/inotify-tools-3.14/libinotifytools/src ../libinotifytools/src/.libs/libinotifytools.so -Wl,-rpath -Wl,/usr/local/lib
gcc -DHAVE_CONFIG_H -I. -I.. -I../libinotifytools/src/inotifytools    -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2 -MT inotifywatch.o -MD -MP -MF .deps/inotifywatch.Tpo -c -o inotifywatch.o inotifywatch.c
mv -f .deps/inotifywatch.Tpo .deps/inotifywatch.Po
/bin/sh ../libtool --tag=CC   --mode=link gcc -std=c99 -I../libinotifytools/src -L../libinotifytools/src -g -O2   -o inotifywatch inotifywatch.o common.o ../libinotifytools/src/libinotifytools.la 
libtool: link: gcc -std=c99 -I../libinotifytools/src -g -O2 -o .libs/inotifywatch inotifywatch.o common.o  -L/home/grid/inotify/inotify-tools-3.14/libinotifytools/src ../libinotifytools/src/.libs/libinotifytools.so -Wl,-rpath -Wl,/usr/local/lib
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14/src'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
test -z "/usr/local/bin" || /bin/mkdir -p "/usr/local/bin"
  /bin/sh ../libtool   --mode=install /usr/bin/install -c inotifywait inotifywatch '/usr/local/bin'
libtool: install: /usr/bin/install -c .libs/inotifywait /usr/local/bin/inotifywait
libtool: install: /usr/bin/install -c .libs/inotifywatch /usr/local/bin/inotifywatch
make[2]: Nothing to be done for `install-data-am'.
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/src'
make[1]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/src'
Making install in man
make[1]: Entering directory `/home/grid/inotify/inotify-tools-3.14/man'
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14/man'
make[3]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[3]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Nothing to be done for `install-exec-am'.
test -z "/usr/local/share/man/man1" || /bin/mkdir -p "/usr/local/share/man/man1"
 /usr/bin/install -c -m 644 inotifywait.1 inotifywatch.1 '/usr/local/share/man/man1'
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/man'
make[1]: Leaving directory `/home/grid/inotify/inotify-tools-3.14/man'
make[1]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Entering directory `/home/grid/inotify/inotify-tools-3.14'
make[2]: Nothing to be done for `install-exec-am'.
make[2]: Nothing to be done for `install-data-am'.
make[2]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
make[1]: Leaving directory `/home/grid/inotify/inotify-tools-3.14'
*/

Step 8:
Verify the inotify files Location and command:
[root@rac_sdb inotify-tools-3.14]# ls -ltr /usr/local/bin/inotify*
/*
-rwxr-xr-x 1 root root 44295 Jan 17 12:13 /usr/local/bin/inotifywait
-rwxr-xr-x 1 root root 41385 Jan 17 12:13 /usr/local/bin/inotifywatch
*/

[root@rac_sdb inotify-tools-3.14]# inotifywait -help
/*
inotifywait 3.14
Wait for a particular event on a file or set of files.
Usage: inotifywait [ options ] file1 [ file2 ] [ file3 ] [ ... ]
Options:
    -h|--help         Show this help text.
    @<file>           Exclude the specified file from being watched.
    --exclude <pattern>
                      Exclude all events on files matching the
                      extended regular expression <pattern>.
    --excludei <pattern>
                      Like --exclude but case insensitive.
    -m|--monitor      Keep listening for events forever.  Without
                      this option, inotifywait will exit after one
                      event is received.
    -d|--daemon       Same as --monitor, except run in the background
                      logging events to a file specified by --outfile.
                      Implies --syslog.
    -r|--recursive    Watch directories recursively.
    --fromfile <file>
                      Read files to watch from <file> or `-' for stdin.
    -o|--outfile <file>
                      Print events to <file> rather than stdout.
    -s|--syslog       Send errors to syslog rather than stderr.
    -q|--quiet        Print less (only print events).
    -qq               Print nothing (not even events).
    --format <fmt>    Print using a specified printf-like format
                      string; read the man page for more details.
    --timefmt <fmt>    strftime-compatible format string for use with
                      %T in --format string.
    -c|--csv          Print events in CSV format.
    -t|--timeout <seconds>
                      When listening for a single event, time out after
                      waiting for an event for <seconds> seconds.
                      If <seconds> is 0, inotifywait will never time out.
    -e|--event <event1> [ -e|--event <event2> ... ]
        Listen for specific event(s).  If omitted, all events are 
        listened for.

Exit status:
    0  -  An event you asked to watch for was received.
    1  -  An event you did not ask to watch for was received
          (usually delete_self or unmount), or some error occurred.
    2  -  The --timeout option was given and no events occurred
          in the specified interval of time.

Events:
    access         file or directory contents were read
    modify         file or directory contents were written
    attrib         file or directory attributes changed
    close_write    file or directory closed, after being opened in
                   writeable mode
    close_nowrite  file or directory closed, after being opened in
                   read-only mode
    close          file or directory closed, regardless of read/write mode
    open           file or directory opened
    moved_to       file or directory moved to watched directory
    moved_from     file or directory moved from watched directory
    move           file or directory moved to or from watched directory
    create         file or directory created within watched directory
    delete         file or directory deleted within watched directory
    delete_self    file or directory was deleted
    unmount        file system containing file or directory unmounted
*/