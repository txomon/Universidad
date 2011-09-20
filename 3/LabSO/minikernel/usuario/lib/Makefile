#
# usuario/lib/Makefile
#	Makefile de la biblioteca
#

INCLUDEDIR=../include
INCLUDEDIR2=../../minikernel/include

CC=gcc
CFLAGS=-Wall -m32 -g -I$(INCLUDEDIR) -I$(INCLUDEDIR2)

all: libserv.a

serv.o: $(INCLUDEDIR)/servicios.h $(INCLUDEDIR2)/llamsis.h

libserv.a: serv.o misc.o
	ar -r $@ serv.o misc.o

clean:
	rm -f serv.o libserv.a
