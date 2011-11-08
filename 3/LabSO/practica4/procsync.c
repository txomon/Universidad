

#include <unistd.h>
#include <stdlib.h>
#include <stdio.h>
#include <pthread.h>

#define TRUE  1
#define FALSE 0

#define TIEMPO_EJECUCION  30
#define TIEMPO_PRODUCCION  1
#define TIEMPO_CONSUMO	   2

#define CONSUMIDORES 4
#define PRODUCTORES 3
#define MAX_LISTA  10

typedef struct {
    int lista[MAX_LISTA];
    int inicio_cola;
    int fin_cola;
} lista_circular;

static lista_circular almacen;
pthread_mutex_t mutex_cola;
pthread_cond_t condicion_vacio,condicion_lleno;

/**********************************************************************
** productor()
**********************************************************************/
void productor()
{
    int aux=0;

    while (TRUE) {
        /* producir un elemento*/
        /* la produccion requiere 'TIEMPO_PRODUCCION' segundos */
    	sleep(TIEMPO_PRODUCCION);
        aux = aux+1;
        printf ("Productor: el elemento %i ha sido producido\n",aux);

        pthread_mutex_lock(&mutex_cola);
        printf("Productor: bloqueo mutex_cola\n");
        /* si la cola esta llena, esperar */
        while ((almacen.inicio_cola+1) % MAX_LISTA == almacen.fin_cola){
            printf("Productor: la cola esta llena, me bloqueo\n");
            pthread_cond_wait(&condicion_lleno,&mutex_cola);
        }
        printf("Productor: inserto el elemento %d en la lista, "\
                "en la posicion %d\n", aux, almacen.inicio_cola);

        /* insertar un elemento en la lista circular */
        
        almacen.lista[almacen.inicio_cola] = aux;
        almacen.inicio_cola =(almacen.inicio_cola +1) % MAX_LISTA;
        
        printf("Ahora mismo la situacion es: inicio:%d fin:%d\n",
                                                        almacen.inicio_cola,
                                                        almacen.fin_cola);
        pthread_cond_signal(&condicion_vacio);
        pthread_mutex_unlock(&mutex_cola);               

    } 
}

/**********************************************************************
** consumidor ()
**********************************************************************/
void consumidor ()
{
    int aux;

    while (TRUE) {

        pthread_mutex_lock(&mutex_cola);
        
        printf("Consumidor: bloqueo mutex_cola\n");

        /* si la cola esta vacia, esperar */
        while (almacen.inicio_cola == almacen.fin_cola){
            printf("Consumidor: la cola esta vacia, me bloqueo\n");
            pthread_cond_wait(&condicion_vacio,&mutex_cola);
        }
        /* extraer un elemento de la lista circular */
        printf("Consumidor: cojo el elemento %d de la lista, "\
                "en la posicion %d\n", aux, almacen.fin_cola);
        aux = almacen.lista[almacen.fin_cola];
        almacen.fin_cola =(almacen.fin_cola +1) % MAX_LISTA;
        
        printf("Ahora mismo la situacion es: inicio:%d fin:%d\n",
                                                        almacen.inicio_cola,
                                                        almacen.fin_cola);
        
        pthread_cond_signal(&condicion_lleno);
        
        pthread_mutex_unlock(&mutex_cola);

        /* consumir un elemento */
        /* el consumo requiere 'TIEMPO_CONSUMO' segundos */
    	sleep(TIEMPO_CONSUMO);
        printf ("Consumidor: el elemento %i ha sido consumido\n",aux);
       
    } 
}

/**********************************************************************
** main ()
**********************************************************************/
int main ()
{
    int x;
    pthread_attr_t attr_productores[PRODUCTORES],attr_consumidores[CONSUMIDORES];
    pthread_t hilos_consumidores[CONSUMIDORES],
              hilos_productores[PRODUCTORES];

    /* inicializar las variables para threads */
    
    for (x=0;x<PRODUCTORES;x++){
        pthread_attr_init(&attr_productores[x]);
    }
    
    for (x=0;x<CONSUMIDORES;x++){
        pthread_attr_init(&attr_consumidores[x]);
    }
    /* Lock de la cola */
    pthread_mutex_init(&mutex_cola,NULL);
    pthread_cond_init(&condicion_vacio,NULL);
    pthread_cond_init(&condicion_lleno,NULL);

    /* iniciar la lista circular, al pricipio esta vacia */
    

    almacen.fin_cola = 0;
    almacen.inicio_cola = 0;
    
    for(x=0;x<CONSUMIDORES;x++){
        /* crear thread consumidor */
            printf ("Creando thread consumidor %d\n", x);
        /* < aqui se incluira el codigo para lanzar el thread consumidor > */
            pthread_create(&hilos_consumidores[x],&attr_consumidores[x],(void *)&consumidor,NULL);
    }
    
    for(x=0;x<PRODUCTORES;x++){
        /* crear thread productor */
        printf ("Creando thread productor %d\n",x);
        /* < aqui se incluira el codigo para lanzar el thread productor > */
        pthread_create(&hilos_productores[x],&attr_productores[x],(void *)&productor,NULL);
    }

    /* esperar un tiempo maximo de ejecucion */
    sleep (TIEMPO_EJECUCION);

    /* terminar el thread principal y con el sus hijos */
    printf ("Finalizando el programa\n");
    for(x=0;x<CONSUMIDORES;x++)
        pthread_cancel(hilos_consumidores[x]);
    for(x=0;x<PRODUCTORES;x++)
        pthread_cancel(hilos_productores[x]);
    exit(0);
}
