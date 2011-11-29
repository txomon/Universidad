CC=gcc

CFLAGS= -Wall -g

OBJSERVER = servidor.o

OBJCLIENT = cliente.o

EXECS = servidor cliente

all: $(EXECS)


servidor: $(OBJSERVER)
	$(CC) $(OBJSERVER) -o $@ 
        
cliente: $(OBJCLIENT)
	$(CC) $(OBJCLIENT) -o $@ 

clean:
	rm -f *.o
	rm -f $(EXECS)


