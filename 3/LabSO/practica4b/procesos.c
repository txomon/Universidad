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
                    [00000.000123]-DBG1 p-1: Creo el primer format

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
#include <sys/ipc.h>
#include <sys/sem.h>
#include <time.h>
#include <signal.h>
#include "procesos.h"



int debug1( const char *format , ...)
{
    va_list argp;
    struct timespec tiempo_actual;

    if((NULL==getenv(DEBUG))||(atoi(getenv(DEBUG))<1))
        return 0;
    clock_gettime(CLOCK_REALTIME,&tiempo_actual);
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG1 ",
            (int) (tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
            (int)( (tiempo_actual.tv_nsec-tiempo_inicio.tv_nsec)/1000));

    va_start(argp,format);
    vfprintf(debug_file,format, argp);
    va_end(argp);

    fprintf(debug_file,"\n");
    return 0;
}
int debug2( const char *format , ...)
{
    va_list argp;
    struct timespec tiempo_actual;


    if((NULL==getenv(DEBUG))||(atoi(getenv(DEBUG))<2))
        return 0;

    clock_gettime(CLOCK_REALTIME,&tiempo_actual);
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG2 ",
            (int) (tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
            (int)((tiempo_actual.tv_nsec-tiempo_inicio.tv_nsec)/1000));

    va_start(argp,format);
    vfprintf(debug_file,format, argp);
    va_end(argp);

    fprintf(debug_file,"\n");
    return 0;
}
int debug3( const char *format , ...)
{
    va_list argp;
    struct timespec tiempo_actual;


    if((NULL==getenv(DEBUG))||(atoi(getenv(DEBUG))<3))
        return 0;
    
    clock_gettime(CLOCK_REALTIME,&tiempo_actual);
    fprintf(debug_file,"[%5.5d.%6.6d]-DBG3 ",
             (int)(tiempo_actual.tv_sec-tiempo_inicio.tv_sec),
             (int)((tiempo_actual.tv_nsec-tiempo_inicio.tv_nsec)/1000));
                                  
 
    va_start(argp,format);
    vfprintf(debug_file,format, argp);
    va_end(argp);

    fprintf(debug_file,"\n");
    return 0;
}

int hijo(char clase[5], int max_t, FILE *input_file )
{
    int id_shm,id_sem;
    union semun{
        int val;
        char *array;
        struct semid_ds *buff;
    } arg;

    debug1("%s: Hijo empieza su ejecucion",clase);
    debug3("\t => max_t=%d",max_t);

    printf("Hijo empieza\n");
    debug2("%s: Abro el semaforo");
    id_sem=semget(LLAVE,N_PARTES,IPC_CREAT|0666);
    
    return 0;
}

int main(int args, char *argv[])
{
    /* Variables auxiliares */
    int x;
    /* Parseador de Argumentos */
    int opt, req=0;
    /* variables de debug */
    FILE *aux_f=NULL;
    char aux_char[2]={EOF,0};
    /* variables de programa */ 
    int n_pro=1,dormir=10,max_t;
    pid_t *pid;
    char clase[]="MAIN";
    
    clock_gettime(CLOCK_REALTIME,&tiempo_inicio);
    debug_file=tmpfile();
    input_file=stdin;
    printf("%s: Empieza el programa\n",clase);

    debug1("%s: Empieza el programa",clase);
    debug2("%s: clock_gettime()",clase);
    debug3("\t => %d,%d",(int)tiempo_inicio.tv_sec,
                        -(int)tiempo_inicio.tv_nsec);
    debug2("%s: debug_file=stdout",clase);
    debug2("%s: input_file=stdin",clase);
    pid=calloc(1,sizeof(pid_t));

    /*  Parseamos los argumentos */
    debug1("%s: Parseamos los argumentos",clase);
    debug2("%s: Hay %d argumento(s)",clase,args-1);
    for(x=0;x<=args-1;x++)
        debug3("\t => arg[%d]: %s",x,argv[x]);
    while ((opt=getopt(args,argv, "f:n:ir:s:m:")) != -1){
        debug2("%s: La opcion encontrada es %c",clase,opt);
        switch (opt){
        case 'f':
            debug2("%s: Encontrada opcion para cambiar el "
                                  "archivo de debug",clase);
            debug3("\t => debug_file = %s", optarg);
            aux_f=debug_file;
            debug_file=fopen(optarg,"w");
            aux_char[0]=EOF;
            fwrite(aux_char, sizeof(char),1,aux_f);
            fseek(aux_f,0,SEEK_SET);
            while( EOF != (aux_char[0]=(char)getc(aux_f)))
                fwrite(aux_char,sizeof(char),1,debug_file);
            fclose(aux_f);
            aux_f=stderr;
            debug2("%s: Archivo de debug cambiado",clase);
            break;
        case 'n':
            debug2("%s: Encontrada opcion para cambiar el "
                    "numero de hijos",clase);
            debug3("\t => n_pro=%d",x=atoi(optarg));
            pid=realloc(pid,x*sizeof(pid_t));
            debug2("%s: Reservado un tamaño de memoria %d*%d",
                        clase,(int)x,(int)sizeof(pid_t));
            req|=1;
            n_pro=atoi(optarg);
            debug2("%s: Numero de hijos cambiado",clase);
            break;
        case 'i':
            debug2("%s: Encontrada opcion para tener una e"
                    "ntrada interactiva",clase);
            debug3("\t => -i");
            req|=4;
            break;
        case 'r':
            -debug2("%s: Encontrada opcion para poner el fi"
                    "chero de entrada normal",clase);
            debug3("\t => %s",optarg);
            req|=2;
            input_file=fopen(optarg,"r");
            debug2("%s: Hemos abierto el fichero de entrada",clase);
            break;
        case 's':
            debug2("%s: Encontrada opcion para tiempo de ejecucion"
                    "del programa",clase);
            debug3("\t => %d a %d",dormir,atoi(optarg));
            dormir=atoi(optarg);
            break;
        
        case 'm':
            debug2("%s: Encontrada opcion para maximo de tiempo que "
                "tiene que esperar",clase);
            max_t=atoi(optarg);
            debug3("\t => max_t=%d",max_t);
            break;
        case ':':
            debug2("%s: En las opciones falta un operando",clase);
            debug3("\t => opt=%c",optopt);
            fprintf(stderr, "La opcion -%c requiere de un operando\n",
                    optopt);
        default:
            debug2("%s: Encontrada opcion no contenida",clase);
            debug3("\t => opt=%c optarg=%s",opt,optarg);
            fprintf(stderr, "Uso: %s [-n num_procesos -r fichero"
                " de entrada [-i]] [-f fichero de"
                " debug]\n", argv[0]);
            debug2("%s: Fallo grave de opciones, salimos del"
                    " programa",clase);
            return -1;
        }
    }
    debug1("%s: Acabamos de parsear las opciones",clase);
    debug2("%s: Comprobamos si hay un archivo al que escribir las trazas",clase);
    if(aux_f!=stderr){
        aux_f=debug_file;
        aux_char[0]=EOF;
        debug_file=stdout;
        fwrite(aux_char, sizeof(char),1,aux_f);
        fseek(aux_f,0,SEEK_SET);
        while( EOF != (aux_char[0]=(char)fgetc(aux_f)))
            fwrite(aux_char,sizeof(char),1,debug_file);
        fclose(aux_f);
        aux_f=stderr;
    }
    if( (req!=0) && (req==3 || req==7 || req==5) )
    {
        debug2("%s: No se han cumplido las especificaciones de argumentos",
            clase);
        debug3("\t => req=%d",req);
        return -1;
    }


    /* Empezamos con el verdadero programa */
    debug1("%s: Empezamos a crear los hijos",clase);
    for(x=0;x<n_pro&&pid!=0;x++)
    {
        printf("%s: Creo hijo %d\n",clase,x);
        pid[x]=fork();
        
        if(pid[x]==0)
        {
            printf("Hijo creado\n");
            if((req&4)&&(x==(n_pro-1)))
                hijo(clase,max_t,input_file);
            else
                hijo(clase,max_t, stdin);
            return 0;
        }
    }
   
    /* Despues de lanzar todos los procesos hijo, esperamos */
    sleep(dormir);

    /* Despues de esperar, matamos a todos los procesos hijo */
    for(x=0;x<n_pro;x++)
    {
        kill(pid[x],SIGKILL);
        debug2("%s: Mandada señal de muerte al proceso hijo %d",clase,x);
    }
    debug1("%s: Acaba el programa",clase);
    printf("%s: Acaba el programa\n",clase);
    return 0;

}
