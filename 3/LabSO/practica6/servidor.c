#include <stdlib.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <stdio.h>
#include <netinet/in.h>

int main (int args, char *argv[]){
    int sockfd,x;
    struct sockaddr_in addr_mio,addr_cliente;
    sockfd=socket(AF_INET,SOCK_STREAM,0);
    if(0>sockfd){
        perror("Error creando el socket");
    }
    addr_mio.sin_family=AF_INET;
    addr_mio.sin_port=5284;
    addr_mio.sin_addr.s_addr=INADDR_ANY;
    if(bind(sockfd,(struct sockaddr *) &addr_mio, sizeof(addr_mio))){
        perror("Inicializando el socket");
        exit(1);
    }
    accept(sockfd,0,0);
    return 0;
}
