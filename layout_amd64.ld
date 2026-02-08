/* layout_amd64.ld -- for x86_64/amd64 */
ENTRY(_start)

PHDRS {
    code_seg PT_LOAD FLAGS(5); /* R+X */
    data_seg PT_LOAD FLAGS(6); /* R+W */
}

SECTIONS {
    /* Base Address */
    . = 0x400000;

    /* CODE SEGMENT, and read-only data */
    .text : {
        KEEP(*(.text.start_header)) /*custom entry point*/
        *(.text)
        *(.text.*)
        *(.rodata)
        *(.rodata.*)
    } :code_seg

    _code_file_end = .;

    /* DATA SEGMENT (16MB Gap) for read/write data */
    . = 0x1400000;

    /* LMA: Pack immediately after code in the file */
    .data : AT(_code_file_end) {
        *(.data)
        *(.data.*)
    } :data_seg

    .bss (NOLOAD) : {
        *(.bss)
    }

    /DISCARD/ : { 
    	*(.note.*) 
	*(.comment) 
	*(.eh_frame) 
	*(.interp)
	*(.dynamic)
	*(.dynsym)
	*(.dynstr)
    }
}
