; True-false test to check differtn resulting binary sizes

%ifdef USE_MACROS
	%include "exit-macro.inc"
%else
	extern exit
	extern exit_1
%endif

global _start ;The linker uses this to determine where execution starts

section .text
_start:
	;lets see what we were called as..
	;Stack values:
	;	[rsp] =argc
	;	[rsp+8]=argv[0] [rsp+(8*(x+1))=argv[x]
	mov rsi,[rsp+8]
	xor eax,eax ; zero rax
	mov al,[rsi]
	cmp al, 't'
	mov al,0
	je .true
;This would have been more efficent
;	inc eax
;true:
;	EXIT (macro, or even the fuction call)
;but then we can't test dead code elimiation
%ifdef USE_MACROS
	EXIT_1
%else
	call exit_1
%endif
.true:
%ifdef USE_MACROS
	EXIT
%else
	call exit
%endif

;Tthis won't be executed, but we're adding more calls
;to better show the size difference between these.

%ifdef USE_MACROS
	EXIT
	EXIT_1
	EXIT
	EXIT
	EXIT
%else
	call exit
	call exit_1
	call exit
	call exit
	call exit
%endif
