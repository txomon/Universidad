#!/bin/sh


CC = gcc

CFLAGS = -g -Wall 

LIB = 

OBJECTS0 = micp.o

OBJECTS1 = mils.o

.SUFFIXES:

.SUFFIXES: .o .c


all: $(OBJECTS0) $(OBJECTS1) micp mils


.c.o:
	$(CC) -c $(CFLAGS) $*.c

micp: $(OBJECTS0)
	$(CC) $(CFLAGS) $(OBJECTS0)  $(LIB) -o $@

mils: $(OBJECT1)
	$(CC) $(CFLAGS) $(OBJECTS1)  $(LIB) -o $@


clean:
	rm -f $(OBJECTS0) $(OBJECTS1) micp mils
