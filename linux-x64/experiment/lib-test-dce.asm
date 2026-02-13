;This exit library should allow the linker to remove unused code
;NOTE: It actually would be more efficient to just use macros
;than function calls, but this is suitable for our test.

; needed to define these as external functions/labels


;this a multi-entry point function to save on code space
;rdi and rax get destroyed... and the process sooo..


%ifdef STATICLIB
	section .text 
	global exit_0	;exits with 0 (true in the shell)
	global exit_1	;exits with 1 (false in the shell)
	global exit	;exits with whatever is in eax
%else
	section .text.exit_0 ; the magic that allows dead code removal to work
	global exit_0	;exits with 0 (true in the shell)
%endif
exit_0:
	xor eax,eax 	; this also zeros rax when in 64-bit mode
	jmp exit	; 
	; -- lets add some more just for the DCE proof
	nop
	nop
	nop
	nop
	nop
	nop
	nop
	nop
exit_1:
%ifndef STATICLIB
	section .text.exit_1
	global exit_1	;exits with 1 (false in the shell)
%endif
	; Below is the smallest opt code wise, but we'd hit the stack
	; push 1 	;2-byes, but actually pushes 8 zero padded bytes on the stack
	; pop rax 	; one byte
	; this is 1 byte loner, but 
	xor eax,eax	; 2 bytes, nukes the higher 4-bytes on rax
	inc eax		; 2 bytes, no difference using mov al,1 or inc eax, so this is better.
	jmp exit
	 
%ifndef STATICLIB
	section .text.exit
	global exit	;exits with whatever is in eax
%endif

exit:
	mov edi,eax 	; this sets rdi=eax, nuking the higher 4-byes on rdi.
	xor eax,eax
	mov al,0x3c	; set rax=60 (eax is the lower 4 bytes of rax, and ax is the 
			; lower 16 bits of eax, and al is the lower 8 bits of ax)
	syscall
	hlt ; something went very wrong if we got here.

