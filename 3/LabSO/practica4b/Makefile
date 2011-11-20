CC = gcc

CFLAGS = -Wall -g -Werror=format 

LIBRARIES = -lrt

CONS_OBJ = consumidor.o

PROD_OBJ = productor.o

EXECS = consumidor productor

all: $(EXECS)


productor: $(PROD_OBJ)
	$(CC) $(PROD_OBJ) -o $@ $(LIBRARIES)

consumidor: $(CONS_OBJ)
	$(CC) $(CONS_OBJ) -o $@ $(LIBRARIES)
        
clean:
	rm -f *.o
	rm -f $(EXECS)

