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




static void manejador (int sig, siginfo_t *si, void *unused)
{
    debug2("%d: Recibida llamada al manejador,"
        " pongo a 1 hayquesalir",getpid());
    hayquesalir=1;
}



int hijo(char clase[5], int max_t, FILE *file )
{
    int x,returnvalue;
    /* Variables de programa */
    int id_shm,id_sem;
    char *sh_mem;
    union semun sem_arg;
    struct sembuf *sem_ops=calloc(2,sizeof(struct sembuf));
    
    sem_ops[0].sem_flg=0;
    sem_ops[1].sem_flg=0;

    debug1("%s: Hijo empieza su ejecucion",clase);
    debug3("%s: max_t=%d",clase,max_t);

    printf("%s: Hijo empieza\n",clase);
    debug2("%s: Abro el semaforo",clase);
    id_sem=semget(LLAVE,(N_PARTES*3)+2,0666);
    debug3("%s: id_sem=%d",clase,id_sem);
    if(semctl(id_sem,0,GETALL,sem_arg.array))
    {
        switch(errno){
        case EACCES:
            debug3("%s: Error EACCES",clase);
            break;
        case EFAULT:
            debug3("%s: Error EFAULT",clase);
            break;
        case EIDRM:
            debug3("%s: Error EIDRM",clase);
            break;
        case EINVAL:
            debug3("%s: Error EINVAL",clase);
            break;
        case EPERM:
            debug3("%s: Error EPERM",clase);
            break;
        case ERANGE:
            debug3("%s: Error ERANGE",clase);
            break;
        }
    }
    debug2("%s: Abro la memoria compartida",clase);
    id_shm=shmget(LLAVE,SHMTAM,0666);
    shmat(id_shm,0,0);
    while (!hayquesalir){
        debug2("%s: Intento conseguir una posicion dentro del sem"
            "aforo de mi clase",clase);
        debug3("%s=> %d tiene sem_value=%d",clase, NSEM_CONS,
            semctl(id_sem,NSEM_PROD,GETVAL));
        sem_ops[0].sem_num=NSEM_PROD;
        sem_ops[0].sem_op=SEM_WAIT;
        sem_ops[0].sem_flg=0;
        semop(id_sem,sem_ops,1);

        printf("0: %d",semctl(id_sem,0,GETALL,sem_arg.array));

        debug3("%s: Antes de entrar, hayquesalir=%d",clase,hayquesalir);
        for(x=0;(x<N_PARTES);x++)
            debug3("%s: SHA%1d=%3u SHA%1dPROD=%3u SHA%1dCONS=%3u",
                clase,x,sem_arg.array[x*3],x,sem_arg.array[x*3+SEM_PROD],
                x,sem_arg.array[x*3+SEM_CONS]);

        
        for(x=0;(x<N_PARTES)&&(!hayquesalir);x++){
            printf("%s: SHA%d=%u SHA%dPROD=%u\n",clase,
                x,sem_arg.array[x*3],x,sem_arg.array[x*3+SEM_PROD]);
            debug2("%s: Busco un hueco en el semaforo %d",clase,x);
            if(1==sem_arg.array[x*3]&&1==sem_arg.array[x*3+SEM_PROD])
            {
                debug2("%s: He encontrado un hueco en la zona %d de la "
                    "memoria compartida. Me quedare hasta que pueda hacer"
                    " mi trabajo", clase, x);

                sem_ops[0].sem_num=x*3;
                sem_ops[1].sem_num=x*3+SEM_PROD;
                sem_ops[1].sem_op=SEM_WAIT;
                returnvalue=semop(id_sem,sem_ops,2);
                if(returnvalue==-1&&EINTR==errno){
                    debug2("%s: Se me ha mandado acabar mientras estaba "
                        "en la cola de espera de %d",clase,x);
                    sem_ops[0].sem_op=SEM_SIGNAL;
                    sem_ops[1].sem_op=SEM_SIGNAL;
                    sem_ops[1].sem_num=NSEM_PROD;
                    exit(EXIT_SUCCESS);
                }
                debug2("%s: He conseguido el acceso a la zona %d",clase,x);


                //Aqui hago lo que sea


                debug2("%s: He acabado mis cosas en la zona %d, ahora toc"
                    "a salir",clase,x);
                sem_ops[0].sem_op=SEM_SIGNAL;
                sem_ops[1].sem_num=x+SEM_CONS;//Le abro el camino al prod
                sem_ops[1].sem_op=SEM_SIGNAL;
                semop(id_sem,sem_ops,2);
                debug3("%s: He mandado SEM_SIGNAL al otro y he liberado e"
                    "l acceso a esta zona",clase);
                x=N_PARTES;
            }
        }
        debug2("%s: Como ya he hecho mi trabajo, dejo que otro acceda"
            ,clase);
        sem_ops[0].sem_op=SEM_SIGNAL;
        sem_ops[0].sem_num=NSEM_PROD;
        semop(id_sem,sem_ops,1);
        sleep(1);
    }    
    exit(EXIT_SUCCESS);
}

int main(int args, char *argv[])
{
    /* Variables auxiliares */
    int x,y;
    /* Parseador de Argumentos */
    int opt, req=0;
    /* variables de debug */
    FILE *aux_f=NULL;
    char aux_char[2]={EOF,0};
    /* variables de programa */ 
    ushort sem_array[(N_PARTES*3)+2];
    int n_pro=1,dormir=10,max_t;
    pid_t *pid;
    char clase[]="MAIN";
    int id_shm,id_sem;
    union semun sem_arg;

    /* Cosas de signal */
    hayquesalir=0;
    struct sigaction sa;
    sa.sa_flags=SA_SIGINFO;
    sigemptyset(&sa.sa_mask);
    sa.sa_sigaction=manejador;
     

    /*Empieza el programa */

    clock_gettime(CLOCK_REALTIME,&tiempo_inicio);
    debug_file=tmpfile();
    archivo=stdin;/*TODO*/
    printf("%s: Empieza el programa\n",clase);

    debug1("%s: Empieza el programa",clase);
    debug2("%s: clock_gettime()",clase);
    debug3("%s: %d,%d",clase,(int)tiempo_inicio.tv_sec,
                        -(int)tiempo_inicio.tv_nsec);
    debug2("%s: debug_file=stdout",clase);
    debug2("%s: archivo=",clase);/*TODO*/
    debug2("%s: sigaction(%d)=%d",clase,MYSIGNAL,
        sigaction(MYSIGNAL,&sa,NULL));
    pid=calloc(1,sizeof(pid_t));

    /*  Parseamos los argumentos */
    debug1("%s: Parseamos los argumentos",clase);
    debug2("%s: Hay %d argumento(s)",clase,args-1);
    for(x=0;x<=args-1;x++)
        debug3("%s: arg[%d]: %s",clase,x,argv[x]);
    while ((opt=getopt(args,argv, "D:h:if:s:m:")) != -1){
        debug2("%s: La opcion encontrada es %c",clase,opt);
        switch (opt){
        case 'D':
            debug2("%s: Encontrada opcion para cambiar el "
                                  "archivo de debug",clase);
            debug3("%s: debug_file = %s",clase,optarg);
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
        case 'h':
            debug2("%s: Encontrada opcion para cambiar el "
                    "numero de hijos",clase);
            debug3("%s: n_pro=%d",clase,x=atoi(optarg));
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
            debug3("%s: -%c",clase,opt);
            req|=4;
            break;
        case 'f':
            debug2("%s: Encontrada opcion para poner un fi"
                    "chero de entrada/salida fisico",clase);
            debug3("%s: %s",clase,optarg);
            req|=2;
            archivo=fopen(optarg,"r");
            debug2("%s: Abierto el fichero de entrada",clase);
            break;
        case 's':
            debug2("%s: Encontrada opcion para tiempo de ejecucion"
                    "del programa",clase);
            debug3("%s: %d a %d",clase,dormir,atoi(optarg));
            dormir=atoi(optarg);
            break;
        
        case 'm':
            debug2("%s: Encontrada opcion para maximo de tiempo que "
                "tiene que esperar",clase);
            max_t=atoi(optarg);
            debug3("%s: max_t=%d",clase,max_t);
            break;
        case ':':
            debug2("%s: En las opciones falta un operando",clase);
            debug3("%s: opt=%c",clase,optopt);
            fprintf(stderr, "La opcion -%c requiere de un operando\n",
                    optopt);
        default:
            debug2("%s: Encontrada opcion no contenida",clase);
            debug3("%s: opt=%c optarg=%s",clase,opt,optarg);
            fprintf(stderr, "Uso: %s [-h num_procesos_hijo -f fichero"
                " de entrada] [-i] [-m tiempo_de_ejec] [-d fichero de"
                " debug]\n", argv[0]);
            debug2("%s: Fallo grave de opciones, salimos del"
                    " programa",clase);
            return -1;
        }
    }
    debug1("%s: Acabamos de parsear las opciones",clase);
    debug2("%s: Comprobamos si hay un archivo al que escribir las trazas"
        ,clase);
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
        debug3("%s: req=%d",clase,req);
        return -1;
    }


    /* Empezamos con el verdadero programa */
    // Creamos los semaforos
    printf("%s: Intento crear el semaforo\n",clase);
    debug1("%s: Intento crear el semaforo",clase);
    if(-1!=(id_sem=semget(LLAVE,(N_PARTES*3)+2,IPC_CREAT|IPC_EXCL|0666))){
        debug1("%s: El semaforo no existe, lo creo",clase);
        printf("%s: El semaforo no existe, lo creo\n",clase);
        for(x=0;x<(N_PARTES);x++){
            sem_array[x*3]=1;
            sem_array[x*3+SEM_PROD]=1;
            sem_array[x*3+SEM_CONS]=0;
        }
        sem_array[NSEM_PROD]=N_PARTES;
        sem_array[NSEM_CONS]=N_PARTES;
        sem_arg.array=sem_array;
        semctl(id_sem,0,SETALL,sem_arg.array);
    }
    else{
        debug1("%s: Como el semaforo exisitia, duermo 1 segundo",clase);
        printf("%s: Como el semaforo exisitia, duermo 1 segundo\n",clase);
        sleep(1);
    }

    printf("%s: Intento crear la memoria compartida\n",clase);
    debug1("%s: Intento crear la memoria compartida",clase);
    // Creamos la memoria compartida
    if(-1!=(id_shm=shmget(LLAVE,SHMTAM,IPC_CREAT|IPC_EXCL|0666))){
        debug1("%s: La memoria compartida no existe, la creo",clase);
        printf("%s: La memoria compartida no existe, la creo",clase);
    }


    debug1("%s: Empezamos a crear los hijos",clase);
    for(x=0;x<n_pro&&pid!=0;x++)
    {
        debug1("%s: Creo hijo %d",clase,x);
        pid[x]=fork();
        
        if(pid[x]==0)
        {
            /*TODO problemas entre los dos tipos (stdin) */
            sprintf(clase,"PRO%1d",x+1);
            debug2("%s: He sido creado",clase);
            debug3("%s: CLASE=%s PID=%d",clase,clase,(int)getpid());
            if((req&4)&&(x==(n_pro-1)))
                hijo(clase,max_t,archivo);
            else
                hijo(clase,max_t, stdin);
            //Nunca llegarán hasta aqui, y si llegan:
            exit(EXIT_FAILURE);
        }
    }
   
    /* Despues de lanzar todos los procesos hijo, esperamos */
    sleep(dormir);

    /* Despues de esperar, matamos a todos los procesos hijo */
    for(x=0;x<n_pro;x++)
    {
        kill(pid[x],MYSIGNAL);
        debug2("%s: Mandada señal a tiempo real al proceso hijo %d",
            clase,x);
    }
    for(x=0;x<n_pro;x++){
        debug2("%s: Espero a que acabe un hijo, faltan %d",clase,n_pro-x);
        debug2("%s: Ha salido el hijo de PID %d",clase,wait(&y));
    }

    debug1("%s: Acaba el programa",clase);
    printf("%s: Acaba el programa\n",clase);
    exit(EXIT_SUCCESS);

}
