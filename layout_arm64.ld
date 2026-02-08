/* layout_arm64.ld - for arm64 CPUs */
ENTRY(_start)

PHDRS {
    code_seg PT_LOAD FLAGS(5); /* R+X */
    data_seg PT_LOAD FLAGS(6); /* R+W */
}

SECTIONS {
    /* Base Address */
    . = 0x400000;

    /* CODE SEGMENT, and read-only data*/
    .text : {
        *(.text.start_header)
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata.*)
    } :code_seg

    /* Align file end to 64KB (Maximum ARM64 Page Size) */

    _code_file_end = .;

    /* DATA SEGMENT (16MB Gap) */
    . = 0x1400000;

    .bss (NOLOAD) :{
	    *(.bss)
    }:data_seg

    /* LMA: Pack immediately after code in the file */
    .data : AT(_code_file_end) {
        *(.data)
        *(.data.*)
    } :data_seg

    /DISCARD/ : { 
 	*(.note.*) 
	*(.comment) 
	*(.eh_frame) 
	*(.interp)
	*(.dynamic)
	*(.dynsym)
	*(.dynstr)
	*(.ARM.attributes)
		
   }
}
