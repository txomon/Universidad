#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <unistd.h>
#include <stdio.h>
#include <netinet/in.h>
#include <errno.h>

int main (int args, char *argv[]){
    int sockfd,msgsock;
    socklen_t length;
    struct sockaddr_in addr_servidor;
    char data,error=0;
    FILE *log;


    sockfd=socket(AF_INET,SOCK_STREAM,0);
    if(0>sockfd){
        perror("Error creando el socket");
        exit(1);
    }
    printf("Socket creado\n");

    addr_servidor.sin_family=AF_INET;
    addr_servidor.sin_port=htons(5284);
    addr_servidor.sin_addr.s_addr=INADDR_ANY;
    if(bind(sockfd,(struct sockaddr *) &addr_servidor, 
        sizeof(addr_servidor))){
        perror("Inicializando el socket");
        exit(1);
    }
    printf("Inicializado el socket\n");

    length=sizeof(addr_servidor);
    if(getsockname(sockfd,(struct sockaddr *) &addr_servidor,&length)){
        perror("getsockname()");
    }
    printf("El servidor se ha puesto en el puerto %d\n", 
        ntohs(addr_servidor.sin_port));

    if(listen(sockfd,5)==-1){
        perror("Escuchando el socket");
        exit(1);
    }
    printf("Escuchando en el socket\n");

    msgsock=accept(sockfd,0,0);
    if(msgsock==-1)
        perror("accept");
    printf("Aceptada conexión\n");
    /* Aqui viene la parte en la que hacemos algo */

    log=fopen("log.txt","w");    

    do{
        if(-1==read(msgsock,&data,1)){
            perror("Error en el read");
            error=1;
        }
        if(data!=-1){
            write(1,&data,1);
            fprintf(log,"La letra es: %d\n",(int)data);
        }
        else{
            if(errno==EINTR){
                fprintf(log,"He recibido la llamada EINTR");
                break;
            }
        }
    }while(error!=1);
    printf("Cerrada conexión por caracter %d\n",(int)data);
    fclose(log);

    return 0;
}
