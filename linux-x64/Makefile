ARC=elf64
LD=gold
#LD=ld

files 	:= echo.asm true.asm
objs 	:= $(files:.asm=.o)
progs 	:= $(files:.asm=)

all: $(progs)

$(objs): %.o : %.asm
	nasm -f $(ARC) -o $@ $<

$(progs): % : %.o
	$(LD) -o $@ %<
