GCC = gcc -m32
FLAGS = -g -Wpedantic

all:
	$(GCC) $(FLAGS) -o parking parking.c

run:
	$(GCC) $(FLAGS) -o parking parking.c
	./parking testin.txt testout.txt

test:
	$(GCC) $(FLAGS) -o parking playground.c

testrun:
	$(GCC) $(FLAGS) -o parking playground.c
	./parking testin.txt testout.txt

clean:
	rm parking testout.txt