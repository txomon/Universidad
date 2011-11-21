CC = gcc

CFLAGS = -Wall -g -Werror=format 

LIBRARIES = -lrt

CONS_OBJ = consumidor.o

PROD_OBJ = productor.o

CONT_OBJ = controlador.o

TEST_OBJ = testcase.o

EXECS = testcase controlador consumidor productor

all: $(EXECS)


productor: $(PROD_OBJ)
	$(CC) $(PROD_OBJ) -o $@ $(LIBRARIES)

consumidor: $(CONS_OBJ)
	$(CC) $(CONS_OBJ) -o $@ $(LIBRARIES)

controlador: $(CONT_OBJ)
	$(CC) $(CONT_OBJ) -o $@ $(LIBRARIES)

testcase: $(TEST_OBJ)
	$(CC) $(TEST_OBJ) -o $@ $(LIBRARIES)

clean:
	rm -f *.log
	rm -f *.o
	rm -f $(EXECS)

