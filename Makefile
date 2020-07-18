GCC = gcc -m32
FLAGS = -g
SOURCES_C := $(wildcard *.c)
SOURCES_S := $(wildcard *.s)
OBJECTS := $(SOURCES_C:%.c=%.o) $(SOURCES_S:%.s=%.o) 

default: all

%.o: %.c
	$(GCC) $(FLAGS) -c -o "$@" "$<"

%.o: %.s
	$(GCC) $(FLAGS) -c -o "$@" "$<"

parking: $(OBJECTS)
	$(GCC) $(FLAGS) -o "$@" $^

all: parking

run: all
	./parking testin.txt testout.txt

clean: 
	rm parking $(OBJECTS) testout.txt

.PHONY: deafult all run clean
