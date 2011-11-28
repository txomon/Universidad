#include <stdio.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>

int copiar(char [], char []);



int copiar(char dir_destino[], char dir_origen[]){
    int x;
    FILE *f_destino,*f_origen;
    void *zona;
    long tam;
    int pagina;
    size_t volumen;

    if((dir_destino!=NULL&&strlen(dir_destino)==0)||
        (dir_origen!=NULL&&strlen(dir_origen)==0)){
        printf("Argument fault\n");
        return 2;
    }
    else
        printf("Arguments OK\n");
    f_destino=fopen(dir_destino,"wb");
    f_origen=fopen(dir_origen,"rb");

    fseek(f_origen,0L,SEEK_END);
    tam=ftell(f_origen);
    fseek(f_origen,0L,SEEK_SET);
    pagina=getpagesize();
    if((tam/pagina)<1)
        zona=calloc(sizeof(char),tam);
    else
        zona=calloc(sizeof(char),pagina);
    if(zona==NULL)
        printf("Error al cojer zona de memoria\n");
    printf("tam=%ld,pagina=%d,f_origen=%d,f_destino=%d\n"
        "ftell(f_origen)=%ld\n",tam,pagina,fileno(f_origen),
        fileno(f_destino),ftell(f_origen));

    volumen=fread(zona,sizeof(char),tam,f_origen);
    do{
        printf("He leido %d\n",(int)volumen);
        fwrite(zona,sizeof(char),volumen,f_destino);
        printf("He escrito %d\n",(int)volumen);
    }
    while(0!=(volumen=fread(zona,pagina,sizeof(char),f_origen)));

    free(zona); 
    free(f_destino);
    free(f_origen);

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
        printf("Ha salido la opcion %c\n",opt);
    }
    
    /* De ahí, empezamos la copia */
    if(args<2)
        return 1;
    copiar(argv[args-1],argv[args-2]);

    return 0;    
}
