%ifndef SYSLIB_ASM
%define SYSLIB_ASM
%include "nsyslib-basic.mac"
%include "proc-local-vars.mac"

%define NullPtr 0x0000000000000000
%define FH_STDIN  0
%define FH_STDOUT 1
%define FH_STDERR 2

; SString exampe:
;
; msg_text: db "I am a string!",0
; msg_text_len equ $ - msg_text - 1
; mesg:
; isstruct SString
; 	at SString.size, dd 0		;0=read-only
;	at SString.used, dd msg_text_len 
;	at SString.data, dq msg_text
; iend

;These are my Smart Strings, because c strings are dumb. Memory efficent?
;sure, but it invited a lot of issues when we were only looking for the
;terminating zero

isstruc SString
	.size: resd 1	;Size of the allocated string block (mem size)
			;if this is 0, it is read only.
	.used: resd 1	;actual used size of the string block (true size)
	.data: resq 1	;pointer to string data, which could be
			;[allocated block+8] or a pointer to a satic
			;c-string.
endstruc
; yea, nasm acutall maes SString_size for us... this is just a reminder
; of that fact.
SString_size equ SString_size 

;exit - expects exit code in eax
extern exit
; these exit with 0 or 1, respectively
extern exit0
extern exit1

extern write
extern read
extern cstrlen
extern cstrlen_fast

%endif
