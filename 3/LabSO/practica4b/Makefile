CC = gcc

CFLAGS = -Wall -g -Werror=format 

LIBRARIES = -lrt

OBJECTS1 = procesos.o

EXECS = procesos

all: $(EXECS)


procesos: $(OBJECTS1)
	$(CC) $(OBJECTS1) -o $@ $(LIBRARIES)
        
clean:
	rm -f *.o
	rm -f $(EXECS)


