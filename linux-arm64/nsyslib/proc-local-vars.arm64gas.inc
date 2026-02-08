/*  proc-local-vars.arm64gas.inc - Tools for handeling local vars
proc_start 	
	call this macro first as it is used to keep track
	of the stack offset for each local var you define.
proc_var name,size
	defines a a local var "name" and updates the frame offfset counter
proc_endvars
	Allocates stack space and saves FP(x29)/LR(x30)
	This is what actually updates the stack pointer, making room
	for the local vars on the stack.
proc_end
	add this at the end, before returning.

since the var names are just static values, you can do this:

str x0,[x29,your_var_name+16] 

The assembler  will add the static value of your_var_name to the 16.

Don't touch x29 with these, unless you like createive bug effects

Note: ARM64 assebmly code is ugly as hell compared to x86_64 (amd64).
...but ARM64 would likely benifit more from a tiny 'nanobox" set of
Linux utilites...

*/

.ifndef PROC_LOCAL_VARS_MACROS
.set PROC_LOCAL_VARS_MACROS, 1

.macro proc_start
    // Start at 16 because bottom 16 bytes are reserved for FP/LR 
    .set    frame_offset, 16
.endm

.macro proc_var name, size
    /* Define symbol at current positive offset from x29 */
    .set    \name, frame_offset

    /* Advance the counter */
    .set    frame_offset, frame_offset + \size
.endm

// Commit Stack (Allocate & Save FP/LR) 
.macro proc_endvars
    // Align total size to 16 bytes (Hardware Requirement)
    .set    total_size, (frame_offset + 15) & ~15

    //Use one instruction if offset is in a 9-bit singed int range (-512 bytes)
    .if total_size <= 512
        stp     x29, x30, [sp, -total_size]!
    .else
        sub     sp, sp, total_size
        stp     x29, x30, [sp]
    .endif

    //Anchor Frame Pointer to the bottom 
    mov     x29, sp
.endm

//  End Scope and restore stack stack (sp) and frame (x29) pointers
.macro proc_end
    mov sp,x29 // restore sp in case it was altered earlier.
    // De-allocate and Restore FP/LR 
    ldp     x29, x30, [sp], total_size
.endm

.endif
