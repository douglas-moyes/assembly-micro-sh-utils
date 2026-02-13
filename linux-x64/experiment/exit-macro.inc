; Exit macros
; Using these only saves space if exit functions are called less than 3 times.

; We'll use macros here to save on the 5 bytes needed to call these instructions

%macro EXIT 0
	mov edi, eax	;2 bytes. sets rdi to eax, zeroing high order bytes
	xor eax,eax	;2 bytes, zeroes rax (working on eax, nukes rax' high order bits)
	mov al, 0x3c	;2 bytes, 8-bit move into al->ax->eax->rax, only eNN->rNN will 
			; nuke high order bits.
	syscall		;2 bytes
	hlt		;1 byte. This will cause a general protection fault when called.
%endmacro

%macro	EXIT_0  0
	xor eax,eax	;2 bytes
	EXIT
%endmacro

%macro EXIT_1 0
	xor eax,eax	;2 bytes
	inc eax		;2 bytes
	EXIT
%endmacro
