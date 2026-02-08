%include "nsyslib-basic.inc"


section .bss
;Things in here don't take up any space until used, thanks to Linux
;"Demand Paging" so lets allow for a ton of args, and will only allocate
; a "page" worth of ram as it is needed. On x86_64 that's 4kbytes


;args_list is terminated by a line that has 0,0,NullPtr, but args_count also
;is given so the end ins known.
global args_list
	args_list:	resb SString_size *1048576 ; all the args passed 
global args_count
	args_count:	resq 1
global command_path
	command_path:	resb SString_size
global command_name	
	command_name:	resb SString_size

section .text.start_header


