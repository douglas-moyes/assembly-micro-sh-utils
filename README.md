# Micro Utility Box

The intent of this project is to create a busybox-like clone in the
smallest size possible for ARM64 and x86_64 Linux systems.

Originally the plan was to write all the utilities in assembly code
for the smallest size possible... until I looked at ARM assembly,
and also decided I was going to use Zig anyway to write a shell.

So yes, writing it all in raw assembly code was crazy, even 
if it was going to be fun... for a little bit. Now, what will
be written in pure assembly is the library code that interfaces
with the kernel. This code is that is unique between architects
and the most useful to optimize.  

```
Zig also gives the ability to define strict data structures,
as they would appear in RAM:
<32-bit int> 	Size of allocated memory at this pointer (0 for read-only data,
		importnat for data in the read-execute code blocks
<32-bit int> 	size of the string, excluding the null terminator
<64-bit ptr>	Pointer to the null-termianted string
[bytes...]	Typically the string would follow here, unless this was being
		used to map a C-string.
```

In C, anytime a string is used, strlen or the alike, is called repeatedly
to determine the string length. Here, it is only done once. This will
speed up string operations.

Of course, I will be doing other magic to speed things up
and keep the code small.

