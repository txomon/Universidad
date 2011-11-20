#include "procesos.h"

int main()
{
    int idsem,x;
    union semun{
        int val;
        unsigned short *array;
        struct semid_ds *bufsem;
    } sem_arg;

    idsem=semget(LLAVE,(N_PARTES*3)+2,0666);
    while(1)
    {
        printf("El estado de los semaforos es:\n");
        semctl(idsem,0,GETALL,sem_arg.array);
        printf("semaphore\tvalue\t\n");
        for(x=0;x<N_PARTES;x++){
            printf("SHA%-6d\t%5u\n",x,sem_arg.array[x*3]);
            printf("SHA%-2dPROD\t%5u\n",x,sem_arg.array[x*3+SEM_PROD]);
            printf("SHA%-2dCONS\t%5u\n",x,sem_arg.array[x*3+SEM_CONS]);
        }
        
        printf("NSEM_PROD\t%5u\n",sem_arg.array[NSEM_PROD]);
        printf("NSEM_CONS\t%5u\n",sem_arg.array[NSEM_CONS]);
        sleep(1);
        system("sh clear");
    }
    return 0;
}
