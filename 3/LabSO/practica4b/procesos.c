/*
    Definiciones:
        - Solo habrá un ejecutable, en él, se harán tantos fork() como se
        especifiquen, a través de argumentos.

        - Se utilizará un array de dos dimensiones en la que la primera 
        dimensión será especificada a través de argumentos y la segunda 
        dimensión sea reservada dinamicamente. En todo momento se trabajará
        con referencias, los productores reservarán la memoria, les pasaran
        las referencias a los productores, y estos los imprimirán por
        pantalla.

        - Se utilizarán los siguientes recursos:
            1.  Una memoria compartida de direcciones entre las dos 
                secciones, productores y consumidores, para pasarse 
                mensajes.
                Se utilizara 1 semaforo para el acceso al array de 
                direcciones.

            2.  Una salida estándar para sacar los mensajes convertidos. 
                Se utilizará un semaforo para regular la salida por 
                pantalla. Se utilizará el siguiente formato para la 
                identificación del proceso que esta escribiendo:

                    [t-id]: Donde t es el tipo (p => productor, c => 
                    consumidor) y el id es el identificador de miembro. 
                Ej:
                    [p-1]: Creo el primer string

            3.  Se crearán funciones para las salidas, de tal manera que 
                se pueda controlar en un solo sitio el nivel de traceo 
                que se muestra.

           [4.  Se creará un fichero de debug para las trazas. También 
                estará regulado por un semaforo, y se utilizará el formato
                para las trazas como el de la salida estándar.]

*/
#include <stdlib.h>
#include <stdio.h>
#include <stdarg.h>
#include <unistd.h>
#include <time.h>

#include "procesos.h"



int debug1(char *string , ...)
{
    va_list argp;
    struct timespec tiempo_actual;

    if(getenv(DEBUG)&&(atoi(getenv(DEBUG))<1))
        return 0;
    
    clock_gettime(CLOCK_REALTIME,&tiempo_actual);
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG1 ",(int) (tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
                         (int)( (tiempo_actual.tv_nsec-tiempo_inicio.tv_nsec)/1000));

    va_start(argp,string);
    vfprintf(debug_file,string, argp);
    va_end(argp);

    fprintf(debug_file,"\n");
    return 0;
}
int debug2(char *string , ...)
{
    va_list argp;
    struct timespec tiempo_actual;


    if(getenv(DEBUG)&&(atoi(getenv(DEBUG))<1))
        return 0;

    clock_gettime(CLOCK_REALTIME,&tiempo_actual);
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG3 ",(int) (tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
                         (int)((tiempo_actual.tv_nsec-tiempo_inicio.tv_nsec)/1000));

    va_start(argp,string);
    vfprintf(debug_file,string, argp);
    va_end(argp);

    fprintf(debug_file,"\n");
    return 0;
}
int debug3(char *string , ...)
{
    va_list argp;
    struct timespec tiempo_actual;


    if(getenv(DEBUG)&&(atoi(getenv(DEBUG))<1))
        return 0;
    
    clock_gettime(CLOCK_REALTIME,&tiempo_actual);
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG3 ",(int)(tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
                          (int)((tiempo_actual.tv_nsec-tiempo_inicio.tv_nsec)/1000));
                                  
 
    va_start(argp,string);
    vfprintf(debug_file,string, argp);
    va_end(argp);

    fprintf(debug_file,"\n");
    return 0;
}


int main(int args, char *argv[])
{
    int x,n_pro=1,n_con=1,opt;
    
    clock_gettime(CLOCK_REALTIME,&tiempo_inicio);
    debug_file=stdout;
    debug1("MAIN: Empieza el programa");

    while ((opt=getopt(args,argv, "p:c:f:")) != -1){
        switch (opt){
            case 'f':
                debug_file=fopen(optarg,"w");
            case 'p':
                n_pro=atoi(optarg);
                break;
            case 'c':
                n_con=atoi(optarg);
                break;
            default:
                fprintf(stderr, "Uso: %s [-p num_productores] [-c num_co"
                    "nsumidores]", argv[0]);
                return -1;
            }
    }
    debug1("MAIN: Acaba el programa");
    return 0;

}
