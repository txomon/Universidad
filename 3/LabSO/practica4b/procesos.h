#ifndef _PROCESOS_H_

#define _PROCESOS_H_

int debug1(char* , ...);
int debug2(char* , ...);
int debug3(char* , ...);

FILE* debug_file;

struct timespec tiempo_inicio;

#define DEBUG "DEBUG"

#endif
