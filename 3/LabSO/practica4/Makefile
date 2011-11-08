CC=gcc

CFLAGS= -Wall -g

LIBRARIES = -lpthread

OBJECTS1 = procsync.o

EXECS = procsync 

all: $(EXECS)


procsync: $(OBJECTS1)
	$(CC) $(OBJECTS1) -o $@ $(LIBRARIES)
        
clean:
	rm -f *.o
	rm -f $(EXECS)


