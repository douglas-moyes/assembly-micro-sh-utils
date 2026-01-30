%ifndef SYSLIB_ASM
%define SYSLIB_ASM
%include "syslib-basic.mac"

%define FH_STDIN  0
%define FH_STDOUT 1
%define FH_STDERR 2


;exit - expects exit code in eax
extern exit
; these exit with 0 or 1, respeticvely
extern exit0
extern exit1


%endif
