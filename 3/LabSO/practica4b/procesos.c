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
#include <time.h>

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


int main(int args, char *argv[])
{
    int x,n_pro=1,n_con=1,opt,pid;
    char clase[]="MAIN",aux_char[2]={EOF,0};
    FILE *aux_f=NULL;
    
    clock_gettime(CLOCK_REALTIME,&tiempo_inicio);
    debug_file=tmpfile();
    printf("%s: Empieza el programa\n",clase);

    debug1("%s: Empieza el programa",clase);
    debug2("%s: clock_gettime()",clase);
    debug3("\t => %d,%d",(int)tiempo_inicio.tv_sec,
                        (int)tiempo_inicio.tv_nsec);
    debug2("%s: debug_file=stdout",clase);

    debug1("%s: Parseamos los argumentos",clase);
    debug2("%s: Hay %d argumento(s)",clase,args-1);
    for(x=0;x<=args-1;x++)
        debug3("\t => arg[%d]: %s",x,argv[x]);
    while ((opt=getopt(args,argv, "f:")) != -1){
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
            debug3("\t => n_pro=%d",atoi(optarg));
            n_pro=atoi(optarg);
            debug2("%s: Numero de productores cambiado",clase);
            break;
        default:
            debug2("%s: Encontrada opcion no contenida",clase);
            debug3("\t => opt=%c optarg=%s",opt,optarg);
            fprintf(stderr, "Uso: %s [-p num_productores] [-c num_co"
                "nsumidores]\n", argv[0]);
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
    debug1("%s: Empezamos a crear los consumidores",clase);
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
    printf("%s: Acaba el programa\n",clase);
    return 0;

}
