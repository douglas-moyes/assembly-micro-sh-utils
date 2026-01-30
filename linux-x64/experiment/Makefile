LD=ld
NASM=nasm
NASMFLAGS= -f elf64
# -s strip symbols
# -n disable page alignment
LDFLAGS= -s -n

all: true-dce true-nodce true-macro
clean:
	rm true-test.o lib-test-dce.o lib-test.o true-test-macro.o

release-clean: clean
	rm true-dce true-nodce true-macro

true-dce: true-test.o lib-test-dce.o
	$(LD) $(LDFLAGS) --gc-sections  -o true-dce true-test.o lib-test-dce.o

true-nodce:	true-test.o lib-test.o
	$(LD) $(LDFLAGS) -o true-nodce true-test.o lib-test.o

true-macro: true-test-macro.o
	$(LD) $(LDFLAGS) -o true-macro true-test-macro.o

true-test.o:  exit-macro.inc true-test.asm
	$(NASM) $(NASMFLAGS) -o true-test.o true-test.asm

true-test-macro.o:  exit-macro.inc true-test.o
	$(NASM) $(NASMFLAGS) -DUSE_MACROS -o true-test-macro.o true-test.asm


lib-test-dce.o: lib-test-dce.asm
	$(NASM) $(NASMFLAGS) -o lib-test-dce.o lib-test-dce.asm

lib-test.o: lib-test-dce.asm
	$(NASM) $(NASMFLAGS) -DSTATICLIB -o lib-test.o lib-test-dce.asm



