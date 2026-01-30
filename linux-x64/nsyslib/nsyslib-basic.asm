; needed to define these as external functoins/labels
; For size reasons, I opted to use registers optimzied
; for assembly instructoins for fuction calls, rather
; than the C/C++ function calling convention.
;
; rsi		- stores the pointer of the string we're working with
; rdi		- the destinatoin string, if manipulating data
; rax		- used for return values, and the first number parameter.
; r8-r12	- used for other parameters
;
; all other modifed registers are saved, except rdi, rax, r11-r12

;------------
;exit
;	terminates the process with eax exit code
;exit0
;	terminates the process with 0 exit code (shell true)
;exit1
;this a multi-entry point function to save on code space
;rdi and rax get destroyed... and the process sooo..
;
;DCE note: These are tighly coupled and small enough that
;optimizing them for DCE actualy could make larger code with
;the longer jmp opcodes 



section .text.exists ; the magic that allows dead code removal to work

global exit	;exits with eax 
global exit0	;exits with 0 (true in the shell)
global exit1	;exits with 1 (false in the shell)
exit0:
	xor eax,eax 	; this also zeros rax when in 64-bit mode
	jmp exit	; this is 2 bytes, but could be 5 bytes if DCE was allowed to run free
exit1:
	xor eax,eax	; 2 bytes, nukes the higher 4-bytes on rax
	inc eax		; 2 bytes, no differnece using mov al,1 or inc eax, so ths is better.

exit:
	mov edi,eax 	; this sets rdi=eax, nuking the higher 4-byes on rdi.
	xor eax,eax
	mov al,0x3c	; set rax=60 (eax is the lower 4 bytes of rax, and ax is the 
			; lower 16 bits of eax, and al is the lower 8 bits of ax)
	syscall
	hlt ; something went very wrong if we got here.
;----------- End exit functions

.section .text.write
; write
;	rsi, the data to write
;	rax, lenght of data to write
;	r8, the file handle 
; using rax as the file handle would be more effiecnet...
; except our strlen functions return the lenght in rax.
; Returns RAX:
; 	-9 EBADF bad file descriptor
;	-14 EFAULT rsi is invalid (segfault)
;	-28 ENOSPC no space left on device
global write
write:
	push rdx	;
	mov rdx,rax
	mov rdi,r8	; set hte file handle
	xor eax,eax 	; zero rax
	mov al,1	; set write

	push rcx	; syscall always destroys rcx
	syscall
	pop rcx

	pop rdx
	ret

.section .text.read
; read
;	rsi, location to put data into
;	rax, lenght of data to read
;	r8, file handle
; Returns:
;	rax postive number of bytes read (or 0 for none)
; 	rax negative means there was an error.
global read
read:
	push rdx	; 1 byte
	mov rdx,rax	; 3 bytes
	mov rdi,r8	; 3 bytes, set hte file handle
	xor eax,eax 	; 2 bytes, zero rax
	;mov al,0	; 0 is the opt code for write rax is already zero.

	push rcx	; 1 bytew syscall always destroys rcx
	syscall		; 2 bytes
	pop rcx		; 1 byte

	pop rdx		;1 byte
	ret



.section .text.cstrlen
; cstrlen expects the string pointer in rsi
; This is for c-style zero terminated strings. My string format
; will save the string lenght.
; returns the string length in rax
; 15 opcode bytes, 
; ~ 2-3 ticks per byte on ryzen CPUs using macro-fuse microcode
global cstrlen
cstrlen:
	xor eax,eax		; 2 bytes, zeros rax without the 3 byes needed for rax op code
.cstrlen_loop:
	cmp [rsi+rax],0		; 5 bytes
	je .strllen_loop_break	; 2 bytes
	inc rax			; 3 bytes
	jmp .strlen_loop	; 2 bytes
.cstrllen_loop_break:
	ret			; 1 byte
	
.section .test.cstrlen_fast
; cstrlen_fast is a bit larger opcode wise, but is fastest
; on stings 64 bytes or latger.
; 24 byes. 
; 25 ticks to start up, processes 32 bytes every tick.
; works best on strings 15 byes or longer.
; A 1024 byte string would be ~40x faster than the slower
; and smaller strlent funciotn above.

global cstrlen_fast
cstrlen_fast
	push rcx	; 1 byte
	mov rdi,rsi	; 3 bytes
	xor eax,eax	; 2 bytes, zero al zero ticks uses "Zeroing Idioms"
	or rcx,-1 	; 4 bytes, set rcx to all 1's 
	cld		; 1 byte
	repne scasb	; 2 bytes, keep looping until it finds the byte in al.
			; this uses microcode that taks 15-20 ticks to 
			; start up, so best on longer strings.
	;calculate size
	not rcx		;3 bytes flip the bits on rcx (make it positive)
	dec rcx		;3 bytes adjust negative 0xffff being positive 0xffff -1
	mov rax,rcx	;3 bytes
	pop rcx		;1 byte
	ret		;1 byte









