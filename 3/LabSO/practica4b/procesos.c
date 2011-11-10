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

                    [%timestamp]-DBG%l %t-%i: Donde %timestamp es el 
                    microsegundo, %l es nivel de debug (si no, aparecerá
                    sin nada de lo anterior), %t es el tipo (p => productor,
                    c => consumidor)y el %i es el identificador de miembro. 
                Ej:
                    [00000.000123]-DBG1 p-1: Creo el primer string

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
#include <sys/types.h>
#include <time.h>

#include "procesos.h"



int debug1(char *string , ...)
{
    va_list argp;
    struct timespec tiempo_actual;

    if(getenv(DEBUG)&&(atoi(getenv(DEBUG))<1))
        return 0;
    
    clock_gettime(CLOCK_REALTIME,&tiempo_actual);
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG1 ",
            (int) (tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
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
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG2 ",
            (int) (tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
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
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG3 ",
             (int)(tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
             (int)((tiempo_actual.tv_nsec-tiempo_inicio.tv_nsec)/1000));
                                  
 
    va_start(argp,string);
    vfprintf(debug_file,string, argp);
    va_end(argp);

    fprintf(debug_file,"\n");
    return 0;
}


int main(int args, char *argv[])
{
    int x,n_pro=1,n_con=1,opt,pid;
    char clase[]="MAIN";
    
    clock_gettime(CLOCK_REALTIME,&tiempo_inicio);
    debug_file=stdout;
    printf("%s: Empieza el programa\n",clase);

    debug1("%s: Empieza el programa",clase);
    debug2("%s: clock_gettime()",clase);
    debug3("\t => %d,%d",(int)tiempo_inicio.tv_sec,
                        (int)tiempo_inicio.tv_nsec);
    debug2("%s: debug_file=stdout",clase);

    debug1("%s: Parseamos las opciones",clase);
    while ((opt=getopt(args,argv, "p:c:f:")) != -1){
        printf("1\n");
        debug2("%s: La opcion encontrada es %c",clase,opt);
        switch (opt){
        case 'f':
            debug2("%s: Encontrada opcion para cambiar el "
                                  "archivo de debug",clase);
            debug3("\t => debug_file = %s", optarg);
            debug_file=fopen(optarg,"w");
            debug2("%s: Archivo de debug cambiado",clase);
        case 'p':
            debug2("%s: Encontrada opcion para cambiar el "
                    "numero de productores",clase);
            debug3("\t => n_pro=%d",optarg);
            n_pro=atoi(optarg);
            debug2("%s: Numero de productores cambiado",clase);
            break;
        case 'c':
            debug2("%s: Encontrada opcion para cambiar el "
                    "numero de consumidores",clase);
            debug3("\t => n_con=%d",optarg);
            n_con=atoi(optarg);
            debug2("%s: Numero de consumidores cambiado",clase);
            break;
        default:
            debug2("%s: Encontrada opcion no contenida",clase);
            debug3("\t => opt=%c optarg=%s",opt,optarg);
            fprintf(stderr, "Uso: %s [-p num_productores] [-c num_co"
                "nsumidores]", argv[0]);
            debug2("%s: Fallo grave de opciones, salimos del"
                    " programa",clase);
            return -1;
        }
    }
    printf("2\n");
    debug1("%s: Acabamos de parsear las opciones");
    debug1("%s: Empezamos a crear los consumidores");
    for(x=0;x<n_con&&pid!=0;x++)
    {
        //pid=fork();
        if(pid==0)
        {
         //   consumidor();
            break;
        }
    }

    debug1("%s: Acaba el programa",clase);
    printf("%s: Acaba el programa",clase);
    return 0;

}
