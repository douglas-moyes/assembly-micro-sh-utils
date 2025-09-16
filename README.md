# assembly-micro-sh-utils
Why? Am I crazy? Maybe... or maybe just because it's crazy fun.

This is a collection of Unix utilities written in Assembly language --
they have no library dependencies, no runtime overheads, and are super
small for that reason. The goal is to make something much more tiny than
the tinybox project. Why? Because it's fun, and it's a challenge.

The goal of this is to optimize the code for size. As a side effect,
these utilities will likely run considerably faster than their 
C/C++ counterparts. 

At some point I'd like to write a bourne-compatible shell... but for
that project, I'll likely want to write my own language to simplify 
development.

Normally one would write to be compatible with the C/C++ libraries. However,
since I'm writing these to avoid linking to the standard libraries, I
only need to concern myself with being compatible with the kernel. That
means I can pick some of my own data types. 

C pointers and strings have one glaring flaw that my custom data types
one have: They are just a pointer to a memory location. Mine will be a
little different:

For strings and most data:

[32-bit] allocated memory block size (only needed for non-constant values)
[32-bit] used memory in that block 
[64-bit] pointer to memory location

I may also use a large data block size that uses 64-bits. To pick between
different data types, I can use different calling labels to the same
function, but just have different entry points

```
Big_String_Func:
	; stuff to handle pointers with 64-bit sizes
	jmp base_Func

Func:
	; stuff to handle pointers with 32-bit sizes
	; no jmp needed here.
base_Func:
	;base code shared by both
	;possibly add some conditionals if the strings need to be
	;modified.

```
Yeah, you can't do that in C :) 


If I need to be compatible with C, I just send the 64-bit address, then
recompute the used memory size.

Managing these data types is why I'd want to add a simple middle-level
programming language for anything more complex than simple utilities.
Also I'll be able to re-use the same code for other CPUs,or even OS. 
Making the small utilities in pure assembly at first is also my way of
becoming familiar with the system architecture.

