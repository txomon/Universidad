#include <stdio.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>

int copiar(char [], char []);
int copiardir(char [], char []);


int copiar(char dir_destino[], char dir_origen[]){
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

    volumen=fread(zona,sizeof(char),pagina,f_origen);
    do{
        printf("He leido %d\n",(int)volumen);
        fwrite(zona,sizeof(char),volumen,f_destino);
        printf("He escrito %d\n",(int)volumen);
    }
    while(0!=(volumen=fread(zona,pagina,sizeof(char),f_origen)));

    printf("Para acabar, libero la memoria");
    free(zona); 
    fclose(f_destino);
    fclose(f_origen);
    printf("He acabado de copiar las cosas\n");
    return 0;

}

int copiardir(char dir_destino[],char dir_origen[])
{
    char existe=1,*ndiror,*ndirde;
    struct stat buf_or,buf_de;
    struct dirent *dir_element;
    DIR *dde,*dor;

    stat(dir_origen,&buf_or);
    if((-1==stat(dir_destino,&buf_de))&&(errno==ENOENT))
        existe=0;
    printf("Empezamos a copiar el directorio %s a %s\n",
        dir_origen,dir_destino); 
    if(S_ISDIR(buf_or.st_mode))
    {
        printf("%s es un directorio",dir_origen);
        if(!existe){ //Si no existe
            mkdir(dir_destino, S_IRUSR|S_IWUSR|S_IXUSR|
                S_IRGRP|S_IWGRP|S_IXGRP|S_IROTH|S_IWOTH|S_IXOTH);
            printf("El directorio %s ahora existe\n",dir_destino);
        }else 
            if(!S_ISDIR(buf_de.st_mode)){ // Si existe pero no directorio
                unlink(dir_destino);
                mkdir(dir_destino, S_IRUSR|S_IWUSR|S_IXUSR|
                    S_IRGRP|S_IWGRP|S_IXGRP|S_IROTH|S_IWOTH|S_IXOTH);
            }
        //Aqui ya tenemos el objetivo creado, ahora, como es un subdir,
        // copiamos los archivos también
        dor=opendir(dir_origen);
        while(NULL!=(dir_element=readdir(dor))){
            if((strcmp(dir_element->d_name,".")==0)||
                (strcmp(dir_element->d_name,"..")==0)){
                dir_element=readdir(dor);
                if(NULL==dir_element)
                    break;
            }

            ndiror=calloc(strlen(dir_element->d_name)+strlen(dir_origen)+2
                ,sizeof(char));
            ndirde=calloc(strlen(dir_element->d_name)+strlen(dir_destino)+2
                ,sizeof(char));

            strcpy(ndirde,dir_destino);
            strcat(ndirde,"/");
            strcat(ndirde,dir_element->d_name);
            strcpy(ndiror,dir_origen);
            strcat(ndiror,"/");
            strcat(ndiror,dir_element->d_name);
            copiardir(ndirde,ndiror);
            free(ndiror);
            free(ndirde);
        }        
    }
    else
        copiar(dir_destino,dir_origen);
    
    return 0;
}

int main(int args, char* argv[]){
    int x;
    char opt,recursivo;
    int *ficheros;

    printf("args=%d",args);
    for(x=0;x<args;x++)
        printf("El arg[%d] => \"%s\"\n",x,argv[x]);
    /* Cojemos los argumentos y los interpretamos */
    while(-1!=(opt=getopt(args,argv,"R"))){
        switch(opt){
        case 'R':
            recursivo=1;
            break;
        }
        printf("Ha salido la opcion %c\n",opt);
    }
    
    /* De ahí, empezamos la copia */
    if(args<2)
        return 1;
    if(strlen(argv[args-1])<1)
        return 1;
    if(strlen(argv[args-2])<1)
        return 1;
    if(recursivo)
        copiardir(argv[args-1],argv[args-2]);
    else
        copiar(argv[args-1],argv[args-2]);

    return 0;    
}
