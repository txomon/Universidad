#include <stdio.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>

int copiar(char [], char []);



int copiar(char dir_destino[], char dir_origen[]){
    int x;
    int *ficheros;
    void *zona;
    long tam;
    int pagina;
    size_t volumen;

    ficheros=(int)calloc(sizeof(int),2);
    ficheros[0]=open(dir_destino,O_WRONLY|O_TRUNC|O_CREAT,
        S_IRUSR|S_IWUSR|S_IRGRP|S_IWGRP);
    ficheros[1]=open(dir_origen,O_RDONLY);

    fseek(ficheros[1],0L,SEEK_END);
    tam=ftell(ficheros[1]);
    pagina=getpagesize();
    if(tam/pagina<1)
        zona=calloc(sizeof(char),tam);
    else
        zona=calloc(sizeof(char),pagina);
    printf("while(0!=\n");
    while(0!=(volumen=read(zona,pagina,sizeof(char),ficheros[1]))){
        printf("He leido, ahora escribo %d",(int)volumen);
        write(zona,volumen,sizeof(char),ficheros[0]);
    }

    free(zona); 
    for(x=0;x<2;x++)
        free(ficheros[x]);
    free(ficheros);

    return 0;

}

int main(int args, char* argv[]){
    int x;
    char opt;
    int *ficheros;
    for(x=0;x<args;x++)
        printf("El arg[%d] => \"%s\"\n",x,argv[x]);
    /* Cojemos los argumentos y los interpretamos */
    while(-1!=(opt=getopt(args,argv,""))){
        printf("Ha salido la opcion %c",opt);
    }
    
    /* De ahí, empezamos la copia */

    copiar(argv[args-1],argv[args-2]);

    return 0;    
}
