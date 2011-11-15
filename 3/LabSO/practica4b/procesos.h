#ifndef _PROCESOS_H_

#define _PROCESOS_H_

int debug1(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int debug2(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int debug3(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int hijo(char*,int,FILE*);

FILE* debug_file;
FILE* input_file;

struct timespec tiempo_inicio;

#define DEBUG "DEBUG"

#define LLAVE (key_t)0x22652343341L
#define SHMTAM 120*sizeof(char)

#endif
