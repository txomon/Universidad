#ifndef _PROCESOS_H_

#define _PROCESOS_H_

int debug1(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int debug2(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));
int debug3(const char *format, ...)
    __attribute__ (( format(printf,1,2) ));

FILE* debug_file;

struct timespec tiempo_inicio;

#define DEBUG "DEBUG"

#endif
