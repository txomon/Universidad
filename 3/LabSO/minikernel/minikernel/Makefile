#
# minikernel/Makefile
#	Makefile del sistema 
#

INCLUDEDIR=include
CC=gcc
CFLAGS=-g -m32 -Wall -I$(INCLUDEDIR)

all: kernel

OBJS_KER=kernel.o HAL.o 
BIB_KER=-ldl

kernel.o: $(INCLUDEDIR)/kernel.h $(INCLUDEDIR)/HAL.h $(INCLUDEDIR)/const.h $(INCLUDEDIR)/llamsis.h

HAL.o: $(INCLUDEDIR)/HAL.h $(INCLUDEDIR)/const.h

kernel: $(OBJS_KER)
	@ln -sf HAL.o.`uname -r | cut -c '1-3'` HAL.o
	$(CC) -m32 -shared -o $@ $(OBJS_KER) $(BIB_KER)

clean:
	rm -f kernel.o kernel HAL.o
