
## 2017-08

Having another go at .NET core probably 2.0 now that it has been released. Tried previews with limited success on debian sid a few months ago.

[Debian 9 Stretch is now supported, so more hopeful for sid](https://github.com/dotnet/core/blob/master/release-notes/2.0/2.0-supported-os.md)


```bash
cd ~/tmp/hwapp
gdb --args  dotnet restore
```

```
[Thread 0x7fff54a0d700 (LWP 3244) exited]

Thread 15 "dotnet" received signal SIGSEGV, Segmentation fault.
[Switching to Thread 0x7fff5520e700 (LWP 3243)]
0x00007fffe0a8fddd in ?? () from /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0
(gdb)   Restore completed in 13.96 ms for /home/XXXXX/tmp/hwapp/hwapp.csproj.
(gdb) c
Thread 15 "dotnet" received signal SIGSEGV, Segmentation fault.
0x00007fffe0a8fddd in ?? () from /usr/lib/x86_64-linux-gnu/libcrypto.so.1.0.0
(gdb) c
Continuing.

```

```
.NET Command Line Tools (2.0.0)

Product Information:
 Version:            2.0.0
 Commit SHA-1 hash:  cdcd1928c9

Runtime Environment:
 OS Name:     debian
 OS Version:  
 OS Platform: Linux
 RID:         debian-x64
 Base Path:   /home/XXXXX/dotnet/sdk/2.0.0/

Microsoft .NET Core Shared Framework Host

  Version  : 2.0.0
  Build    : e8b8861ac7faf042c87a5c2f9f2d04c98b69f28d



Linux abcdefgh 4.11.0-2-amd64 #1 SMP Debian 4.11.11-1 (2017-07-22) x86_64 GNU/Linux
```

I try to follow the steps in the last comment of [this comment to an issue](https://github.com/dotnet/core-setup/issues/545#issuecomment-294358690)  but to no avail as of August 2017. Seems to cannot downgrade libcurl and the like.

```
find ~/dotnet/ -name '*.so' -type f -print | xargs ldd | grep 'not found'
	libcrypto.so.10 => not found
	libssl.so.10 => not found
	libcrypto.so.10 => not found
	libssl.so.10 => not found
	libcrypto.so.10 => not found
	libssl.so.10 => not found
```

Note that I envisaged to [recompile from source](https://github.com/dotnet/coreclr/blob/master/Documentation/building/linux-instructions.md)  but decided not to.

Since telemetry was mentioned a couple of times as the real offender, tried to turn it off ([ref](http://michaelcrump.net/part12-aspnetcore/)). Problem gone...

```bash
export DOTNET_CLI_TELEMETRY_OPTOUT=1
```


# hosting the VM

[netcore hosting](https://docs.microsoft.com/en-us/dotnet/core/tutorials/netcore-hosting)

and a top of a google search comes up with a blog from a guy I should get in touch with:
[hosting coreclr](http://yizhang82.me/hosting-coreclr)