#ifndef _PROCESOS_H_

#define _PROCESOS_H_

#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <sys/ipc.h>
#include <sys/sem.h>
#include <sys/shm.h>
#include <time.h>
#include <signal.h>
#include <errno.h>

int debug1(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int debug2(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int debug3(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int hijo(char*,int,FILE*);

FILE* debug_file;
FILE* archivo;

struct timespec tiempo_inicio;
char hayquesalir;

union semun{
    int val;
    struct semid_ds *buf;
    unsigned short *array;
    struct seminfo *__buf;
};

/*
 * Nombre de la variable de entorno que tiene que tener el valor del 
 * nivel de detalle de las trazas
 */
#define DEBUG "DEBUG"

/* Llave que se utilizara para identificar los ipcs de este programa*/
#define LLAVE (key_t)0x61733713L
/* Número de partes que el va a tener la memoria compartida */
#define N_PARTES 4
/* Números de semáforos de control para cada clase */
#define NSEM_PROD (N_PARTES*3)
#define NSEM_CONS ((N_PARTES*3)+1)
/*
 * Especificación del semaforo dentro de las partes que corresponde a cada
 * clase
 */
#define SEM_PROD 1
#define SEM_CONS 2
/* El tamaño de la memoria compartida se redondeará a este numero*/
#define PAGE_SIZE getpagesize()
#define TAM_PARTES PAGE_SIZE 
#define SHMTAM (N_PARTES*TAM_PARTES*sizeof(char))

// Definicion de operaciones en semaforo
#define SEM_WAIT -1
#define SEM_SIGNAL 1

/* Definicion de señales */
#define MYSIGNAL SIGRTMIN+4

#endif
