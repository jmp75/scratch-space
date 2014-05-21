Mono on Windows
=============

Notes relating to Mono for the more Windows specific material.

# Building Mono on Win32/Cygwin

Credits for these instructions go to [Alex J Lennon](http://lists.ximian.com/pipermail/mono-devel-list/2014-May/041457.html) for the bulk of the material. 

##  Install Cygwin

Install or update Cygwin 
http://www.cygwin.com/
You'll find 32 and 64 bits installers. Alex documented using setup-x86.exe; I give the 64 bits version a try.

Follow instructions from [Compiling Mono on Windows](http://www.mono-project.com/Compiling_Mono_on_Windows) to install needed packages

- autoconf
- automake
- bison
- gcc-core
- gcc-g++
- mingw-gcc
- libtool,
- make
- python,

Nice to have:

- wget, 
- zip, 
- patch, 
- openssh, 
- vim (but notepad++ is just fine :-)

In addition to this you (probably) need the following as per [these instructions](http://www.codeproject.com/Articles/19575/Building-Mono-on-Windows-the-final-battle)

- gettext-devel
- intltool
- libiconv
- pkg-config

Other information 

http://georgik.sinusgear.com/2012/07/14/how-to-fix-incorrect-cygwin-permission-inwindows-7/
http://shana.worldofcoding.com/en/mono_cygwin_tutorial.html
[The little book of Calm](http://www.penguin.com.au/products/9780140260656/little-book-calm)

## Install working Mono binaries

Use the installation executable from go-mono.com, at time of writing [version 3.2.3](http://download.mono-project.com/archive/3.2.3/windows-installer/mono-3.2.3-gtksharp-2.12.11-win32-0.exe)

For me this gives a working Mono in C:\Program Files (x86)\Mono-3.2.3 on a Windows 8.1 / x64 host

# Grab new Mono sources

## From source tarball

### Download and Extract

Download the tarball you wish to use from
http://download.mono-project.com/sources/mono/

At the time of writing we are using 3.4.0:

```bash
cd ~/src/mono
wget http://download.mono-project.com/sources/mono/mono-3.4.0.tar.bz2
```

Do not extract the source tarball with native Window tools as this
appears to affect line endings, which will cause problems.

To extract within Cygwin first run the Cywgin environment (Cygwin
terminal on your start bar) and extract with,

```bash
tar xjvf mono-3.4.0.tar.bz2
```

This will give you a mono-3.4.0 directory

### Create baseline destination

Create a destination folder, where we are going to install the newly
built Mono, in this case F:\bin\Mono

Copy across files from your existing installation (e.g. Mono-3.2.3) to
the new 3.4.0 folder to give us a baseline

NOTE: It is important not to have spaces in the path as otherwise the
Mono build will fail, so we're putting this in the root of C: for this
example
           (From my reading it is also likely to be important not to
have Windows user names with spaces in them, so a heads-up there...)

### Autogen the build

```bash
cd /cygdrive/f/src/mono/mono-3.4.0
cd libgc
wget https://raw.githubusercontent.com/mono/mono/mono-3.4.0/libgc/autogen.sh
cd /cygdrive/f/src/mono/mono-3.4.0
./autogen.sh --prefix="F:\bin\Mono" --with-preview=yes > autogenlog.txt 2>&1 
```

I could not see an autogen.sh in the libgc directory. 

### A fix for cross-platform compilation only?

I tried the following, but I don't think this is really helping. However I do end up, with or without it, with mono*-wrapper with references to a non-existing /-libtool script at the root of the directory.  

If I follow the following instructions between the autogen.sh and ./configure:
```
sed -e "s|slash\}libtool|slash\}${HOST_SYS}-libtool|" -i acinclude.m4
sed -e "s|slash\}libtool|slash\}../${HOST_SYS}-libtool|" -i libgc/acinclude.m4
sed -e "s|slash\}libtool|slash\}../${HOST_SYS}-libtool|" -i eglib/acinclude.m4
sed -e "s|r/libtool|r/${HOST_SYS}-libtool|" -i runtime/mono-wrapper.in
sed -e "s|r/libtool|r/${HOST_SYS}-libtool|" -i runtime/monodis-wrapper.in
```
Then  at compilation time:
```
Converting corlib.dll.sources to ../../build/deps/build_corlib.dll.response ...
mkdir -p -- ../../class/lib/build/tmp/
MCS     [build] mscorlib.dll
/cygdrive/f/src/mono/mono-3.4.0/runtime/mono-wrapper: line 16: /cygdrive/f/src/m
ono/mono-3.4.0/-libtool: No such file or directory
/cygdrive/f/src/mono/mono-3.4.0/runtime/mono-wrapper: line 16: exec: /cygdrive/f
```

### Configure the build

```bash
./configure --host=i686-pc-mingw32 > configurelog.txt 2>&1
```

```
checking if dolt supports this host... no, falling back to libtool
./configure: line 17238: ./libtool: No such file or directory
```

The above is because there was a missing autogen.sh in libgc. Maybe. Who knows.

```
checking for iconv... no, consider installing GNU libiconv
```
Huh?? Not sure what is going on, not sure how much this matter. Just go on.


Note that this step completes fine at this stage, but I noticed that if I started from a clone of the repo done with [Sourcetree](http://www.sourcetreeapp.com), I first had issues with autoconf, then failed configuration of libgc and eglib (as reported by Mark in XXXX)

At the end of this process, with the defaults, you should see something like

```
        mcs source:    mcs

   Engine:
        GC:            sgen and bundled Boehm GC with typed GC and
parallel mark
        TLS:           pthread
        SIGALTSTACK:   no
        Engine:        Building and using the JIT
        oprofile:      no
        BigArrays:     no
        DTrace:        no
        LLVM Back End: no (dynamically loaded: no)

   Libraries:
        .NET 2.0/3.5:  yes
        .NET 4.0:      yes
        .NET 4.5:      yes
        MonoDroid:     no
        MonoTouch:     no
        Xamarin.Mac:   no
        JNI support:   no
        libgdiplus:    assumed to be installed
        zlib:          system zlib
```

### Building mono

```bash
which mcs
# /cygdrive/f/bin/Mono/bin/mcs
```

If you have not manually placed the autogen.sh file under libgc, you will quickly get:

```
make[3]: Entering directory `/cygdrive/f/src/mono/mono-3.4.0/libgc'
  CC     allchblk.lo
preserve_args+= --tag CC: not found
base_compile+= i686-pc-mingw32-gcc: not found
cygwin warning:
  MS-DOS style path detected: /cygdrive/f/cygwin64/usr/local/bin/base_compile+=
-DPACKAGE_NAME=\"libgc-mono\"
  Preferred POSIX equivalent is: /cygdrive/f/cygwin64/usr/local/bin/base_compile
+= -DPACKAGE_NAME=/"libgc-mono/"
  CYGWIN environment variable option "nodosfilewarning" turns off this warning.
  Consult the user's guide for more details about POSIX paths:
```

```
@"F:\bin\Mono\bin\mono.exe" %MONO_OPTIONS% "F:\bin\Mono\lib\mono\4.5\mcs.exe" -sdk:4 %* 
```

You can go ahead and try 'make' now but at the time of writing
(03/05/2014) there is a problematical interaction between the Cygwin
headers and the Mono build

This will lead to an error along the lines of,

```
/usr/i686-pc-mingw32/sys-root/mingw/include/ddk/ntapi.h:49:15: error:
conflicting types for 'PEXECUTION_STATE'
In file included from
/usr/i686-pc-mingw32/sys-root/mingw/include/windows.h:62:0,
                 from
/usr/i686-pc-mingw32/sys-root/mingw/include/winsock2.h:40,
                 from ../../mono/io-layer/io-layer.h:24,
                 from ../../mono/metadata/domain-internals.h:15,
                 from ../../mono/metadata/metadata-internals.h:8,
                 from ../../mono/metadata/class-internals.h:10,
                 from ../../mono/metadata/object-internals.h:8,
                 from process.c:16:
```

A workaround is to edit the Cygwin header file ntapi.h (e.g.
C:\cygwin\usr\i686-pc-mingw32\sys-root\mingw\include\ddk\ntapi.h) to
rename PEXECUTION_STATE to PEXECUTION_STATE_KLUDGE, say.

Then, we are finally ready to launch the compilation

```
time make > make_log.txt 2>&1
```

this will take some time

NOTE: There seems to be an intermittent issue linking against libiconv
(even when present) relating to shared libraries.

```
mono-counters.c: In function 'dump_counter':
mono-counters.c:113:8: warning: unknown conversion type character 'l' in format [-Wformat]
mono-counters.c:113:8: warning: too many arguments for format [-Wformat-extra-args]

sgen-gc.c: In function 'pin_objects_from_addresses':
sgen-gc.c:1283:6: warning: unknown conversion type character 'z' in format [-Wformat]

  CC     decode.o
decode.c: In function ‘tracked_creation’:
decode.c:1434:3: warning: unknown conversion type character ‘l’ in format [-Wformat]
decode.c:1434:3: warning: format ‘%f’ expects argument of type ‘double’, but argument 5 has type ‘uint64_t’ [-Wformat]
decode.c:1434:3: warning: too many arguments for format [-Wformat-extra-args]
```

A [thread on StackOverflow](http://stackoverflow.com/questions/10678124/mingw-gcc-unknown-conversion-type-character-h-snprintf) gives some background as to these issues in relation to gcc and mingw.

note the --without-libiconv-prefix configure, below; not sure whether this is as should be or not.
```
$ i686-pc-mingw32-gcc -v
Using built-in specs.
COLLECT_GCC=i686-pc-mingw32-gcc
COLLECT_LTO_WRAPPER=/usr/lib/gcc/i686-pc-mingw32/4.7.3/lto-wrapper.exe
Target: i686-pc-mingw32
Configured with: /usr/src/packages/mingw-gcc/32/mingw-gcc-4.7.3-1/src/gcc-4.7.3/
configure --srcdir=/usr/src/packages/mingw-gcc/32/mingw-gcc-4.7.3-1/src/gcc-4.7.
3 --prefix=/usr --exec-prefix=/usr --bindir=/usr/bin --sbindir=/usr/sbin --libex
ecdir=/usr/lib --datadir=/usr/share --localstatedir=/var --sysconfdir=/etc --dat
arootdir=/usr/share --docdir=/usr/share/doc/mingw-gcc -C --build=i686-pc-cygwin
--host=i686-pc-cygwin --target=i686-pc-mingw32 --without-libiconv-prefix --witho
ut-libintl-prefix --with-sysroot=/usr/i686-pc-mingw32/sys-root --with-build-sysr
oot=/usr/i686-pc-mingw32/sys-root --enable-languages=c,c++,ada,fortran,objc,obj-
c++ --disable-sjlj-exceptions --with-dwarf2 --enable-shared --enable-libgomp --d
isable-win32-registry --enable-libstdcxx-debug --disable-build-poststage1-with-c
xx --enable-version-specific-runtime-libs --disable-multilib --enable-decimal-fl
oat=bid --disable-werror --enable-lto
Thread model: win32
gcc version 4.7.3 (GCC)
```



If you see this try,

```
make clean
make
```

### Install mono

Mount your destination folder under Cygwin as /usr/local with

mount "F:\bin\Mono" /usr/local

NOTE: Do not have /usr/local mounted when performing the previous make
step or you will see the following build error:
            *** Warning: Trying to link with static lib archive
/usr/local/lib/libiconv.a.

As a check you can 'ls /usr/local' which should show the files that you
have in F:\bin\Mono

At the time of writing (04/05/2014) there is a missing file in the Mono
3.4.0 release tarball. This causes installation failure.

[post on stackoverflow](http://stackoverflow.com/questions/22844569/build-error-mono-3-4-0-centos)

To add the missing file create a new file in  mcs/tools/xbuild/targets/
called Microsoft.Portable.Common.targets

This should contain the following

```bash
echo "<Project xmlns=\"http://schemas.microsoft.com/developer/msbuild/2003\">
    <Import Project=\"..\Microsoft.Portable.Core.props\" />
    <Import Project=\"..\Microsoft.Portable.Core.targets\" />
</Project>" > mcs/tools/xbuild/targets/Microsoft.Portable.Common.targets
```

Then ensure that /usr/local is correctly mounted as per 3(b)(ii) and run

```bash
make install
```

(vii) Fix "missing" mono.exe

The installation removes the existing mono.exe from the
F:\bin\Mono\bin directory and does not seem to copy across a new version

Within the Cygwin environment there is a "mono.exe" which is a symbolic
link to mono-sgen.exe, which is rebuilt.

So, assuming that under Win32 the mono.exe is a stub executable (which
it seems to be as it is small) it should be reasonable to copy
across mono.exe from the older mono installation

e.g. Copy C:\Program Files (x86)\Mono-3.2.3\bin\mono.exe to
F:\bin\Mono\bin

(vii) Check installation

Open a Windows cmd box, cd to F:\bin\Mono and run

mono --version

This should show something like

Mono JIT compiler version 3.4.0 (tarball)
Copyright (C) 2002-2014 Novell, Inc, Xamarin Inc and Contributors.
www.mono-project.com
        TLS:           normal
        SIGSEGV:       normal
        Notification:  Thread + polling
        Architecture:  x86
        Disabled:      none
        Misc:          softdebug
        LLVM:          supported, not enabled.
        GC:            sgen

(viii) Enable Xamarin Studio to add the new Mono runtime

If you to to Xamarin Tools->Options and try to add the Mono-3.4.0 folder
it will fail to detect Mono.

This is because of the presence of an installed symlink file, bin\mono

So, for example, delete the file F:\bin\Mono\bin\mono and you will
then be able to add the runtime to Xamarin Studio

There is an archive of the binaries resulting from my build here,

http://www.dynamicdevices.co.uk/downloads/Mono-3.4.0.zip

NOTE: That Mono 3.x fails to build projects for me with recent Xamarin
Studio builds giving the error

Build failed. Could not find type 'System.Globalization.SortVersion'.

This appears to be addressed in this commit which is not present in 3.4.0

http://stackoverflow.com/questions/23448795/build-failed-could-not-find-type-system-globalization-sortversion

The workaround is to use an older version of Xamarin Studio as discussed
here

http://stackoverflow.com/questions/23448795/build-failed-could-not-find-type-system-globalization-sortversion

i.e. Download Xamarin Studio 4.2.3 from your account at Xamarin.com with
"view all versions"

NOTE: You may then get a build error about UNC paths

error : Error building target GetReferenceAssemblyPaths: UNC paths
should be of the form \\server\share.

This appears to relate to extra \\'s in configuration files as discussed
here

http://stackoverflow.com/questions/19933266/error-building-c-sharp-solution-using-xbuild-mono

The workaround is to go to project options and unback "Use MSBuild
engine" at which point you will be able to compile and debug applications

------------------------------------------------------------------------

(b) From Git repository
====================

(i) Checkout Mono using Git within Cygwin. Don't use Subversion as I
have seen build problems which I think are because sub-modules are not
checked out with Subversion.

e.g.

cd c:/
git clone git://github.com/mono/mono.git

NOTE: We are working with Git rev 
47db8f756f409cd56d207b550ead42a156ad5a01 at present

(This will take some time and checkout to a mono folder)

(ii)

>From here the steps are similar to those above. i.e. Follow the above
steps in (a) (ii) - (v) to create a baseline, autogen, configure and make

NOTE: Ensure /usr/local is not mounted for the build, as discussed above

NOTE: As in the build instructions for the Mono 3.4.0 source archive,
above, you will need to rename the Cygwin header variable definition
PEXECUTION_STATE in the file
C:\cygwin\usr\i686-pc-mingw32\sys-root\mingw\include\ddk\ntapi.h to
something else e.g. PEXECUTION_STATE_KLUDGE.

e.g. With baseline copy of older mono in F:\bin\Mono

./autogen.sh --prefix="F:\bin\Mono" --with-preview=yes
./configure --host=i686-pc-mingw32
make

(this will take some time)

mount "F:\bin\Mono" /usr/local
make install

Copy across mono.exe to bin folder from older installation
Delete mono file in bin folder

There's an archive of binaries for 3.4.10-master-47db8f7 here

# Building mono with MS VC++ VS2013

You should first build mono using the configure/make process. It seems to generate some header files that you'll otherwise be missing. 
F:\src\mono\mono-3.4.0\msvc\mono.sln

Libraries\libmono

```
Error	3891	error LNK2019: unresolved external symbol _mono_emit_native_types_intrinsics referenced in function _mini_emit_inst_for_ctor	F:\src\mono\mono-3.4.0\msvc\method-to-ir.obj	libmono
Error	3889	error LNK2019: unresolved external symbol _mini_native_type_replace_type referenced in function _mini_replace_type	F:\src\mono\mono-3.4.0\msvc\mini.obj	libmono
Error	3890	error LNK2001: unresolved external symbol _mini_native_type_replace_type	F:\src\mono\mono-3.4.0\msvc\mini-generic-sharing.obj	libmono
Error	3892	error LNK1120: 2 unresolved externals	F:\src\mono\mono-3.4.0\msvc\Win32\bin\mono-2.0.dll	libmono
```

```xml
    <ClInclude Include="..\mono\mini\mini-llvm.h" />
    <ClInclude Include="..\mono\mini\mini-llvm-cpp.h" />
    <ClCompile Include="..\mono\mini\mini-native-types.c" />
  </ItemGroup>
```

F:\src\mono\mono-3.4.0\msvc\Win32\bin

to

F:\bin\mono_built\Win32

lib
	mono-2.0.lib
	mono
		gac
		2.0
		3.5
		4.0
		4.5

F:\bin\Mono\lib\mono


# Generating the csproj/sln files





