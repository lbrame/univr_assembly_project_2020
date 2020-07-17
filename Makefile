GCC = gcc -m32
FLAGS = -g -Wpedantic

all:
	$(GCC) $(FLAGS) -c -o parking.o parking.c
	$(GCC) $(FLAGS) -c -o core_asm.o core_asm.s
	$(GCC) $(FLAGS) -c -o init.o init.s
	$(GCC) $(FLAGS) -c -o strcmp_asm.o strcmp_asm.s
	$(GCC) $(FLAGS) -c -o atoi_asm.o atoi_asm.s
	$(GCC) $(FLAGS) -c -o strcat_asm.o strcat_asm.s
	$(GCC) $(FLAGS) -c -o itoa_asm.o itoa_asm.s
	$(GCC) $(FLAGS) -c -o nltoz.o nltoz.s
	$(GCC) $(FLAGS) -o parking parking.o core_asm.o init.o strcmp_asm.o atoi_asm.o strcat_asm.o itoa_asm.o nltoz.o

run:
	$(GCC) $(FLAGS) -c parking.o parking.c
	$(GCC) $(FLAGS) -c -o core_asm.o core_asm.s
	$(GCC) $(FLAGS) -c -o init.o init.s
	$(GCC) $(FLAGS) -c -o strcmp_asm.o strcmp_asm.s
	$(GCC) $(FLAGS) -c -o atoi_asm.o atoi_asm.s
	$(GCC) $(FLAGS) -c -o strcat_asm.o strcat_asm.s
	$(GCC) $(FLAGS) -c -o itoa_asm.o itoa_asm.s
	$(GCC) $(FLAGS) -c -o nltoz.o nltoz.s
	$(GCC) $(FLAGS) -o parking parking.o core_asm.o init.o strcmp_asm.o atoi_asm.o strcat_asm.o itoa_asm.o nltoz.o
	./parking testin.txt testout.txt

clean:
	rm parking parking.o core_asm.o init.o strcmp_asm.o atoi_asm.o strcat_asm.o itoa_asm.o nltoz.o itoa_asm.o testout.txt
