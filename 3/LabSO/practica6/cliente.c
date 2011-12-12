#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <strings.h>
#include <unistd.h>
#include <netdb.h>


int main (int args, char *argv[]){
    int sockfd;
    socklen_t length;
    struct hostent *hp,*gethostbyname();
    struct sockaddr_in addr_servidor;
    char data;


    sockfd=socket(AF_INET,SOCK_STREAM,0);
    if(0>sockfd){
        perror("Error creando el socket");
        exit(1);
    }
    printf("Socket creado\n");

    addr_servidor.sin_family=AF_INET;
    addr_servidor.sin_port=htons(5284);
    hp = gethostbyname(argv[1]);
    if( hp==0){
        fprintf(stderr,"%s: nombre de host desconocido",argv[1]);
        exit(2);
    }
    bcopy(hp->h_addr,&addr_servidor.sin_addr,hp->h_length);


    if( connect(sockfd,(struct sockaddr *)&addr_servidor,
        sizeof(addr_servidor)) < 0){

        perror("connect()");
        exit(1);
    }
    printf("Conectado al servidorn\n");

    length=sizeof(addr_servidor);
    if(getsockname(sockfd,(struct sockaddr *) &addr_servidor,&length)){
        perror("getsockname()");
        exit(1);
    }
    printf("El cliente se ha puesto en el puerto %d\n", 
        ntohs(addr_servidor.sin_port));

    /* Aqui viene la parte en la que hacemos algo */
    
    do{
        read(0,&data,1);
        if(data!=-1)
            write(sockfd,&data,1);
    }while(data!=-1);


    return 0;
}
