#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>

int main (int args, char *argv[]){
    int sockfd,msgsock,x;
    struct sockaddr_in addr_servidor;
    char data;


    sockfd=socket(AF_INET,SOCK_STREAM,0);
    if(0>sockfd){
        perror("Error creando el socket");
        exit(1);
    }
    printf("Socket creado\n");

    addr_mio.sin_family=AF_INET;
    addr_mio.sin_port=htons(5284);
    if(addr_mio.sin_addr.s_addr=inet_addr(argv[args-1])==0){
        perror("inet_addr");
        exit(1);
    }

    connect
    x=sizeof(addr_mio);
    if(getsockname(sockfd,(struct sockaddr *) &addr_mio,&x)){
        perror("getsockname()");
    }
    printf("El cliente se ha puesto en el puerto %d\n", 
        ntohs(addr_mio.sin_port));

    printf("Escuchando en el socket\n");

    msgsock=accept(sockfd,0,0);
    if(msgsock==-1)
        perror("accept");
    printf("Aceptada conexión\n");
    /* Aqui viene la parte en la que hacemos algo */
    
    do{
        read(msgsock,&data,1);
        if(data!=-1)
            printf("%c",data);
            fflush(stdout);
    }while(data!=-1);


    return 0;
}
