#include <stdio.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>

#define MI_RECUR   0x0001
#define MI_LISTA   0X0002
#define MI_TODOS   0X0004

#define SMI_RECUR (X) (X & MI_RECUR)
#define SMI_LISTA (X) (X & MI_LISTA)
#define SMI_TODOS (X) (X & MI_TODOS)

int mostrardir( char [],int);

int mostrardir(char dir_origen[],int flags)
{
    char existe=1,*ndiror;
    struct stat buf_or;
    struct dirent *dir_element;
    DIR *dde,*dor;

    stat(dir_origen,&buf_or);
    printf("Empezamos a leer el directorio %s\n", dir_origen);
    if(S_ISREG(buf_or->st_mode))
        dor=opendir(dir_origen);
        while(NULL!=(dir_element=readdir(dor))){
            if((strcmp(dir_element->d_name,".")==0)||
                (strcmp(dir_element->d_name,"..")==0)){
                dir_element=readdir(dor);
                if(NULL==dir_element)
                    break;
            }

            printf("%s",dir_element->d_name);
            ndiror=calloc(strlen(dir_element->d_name)+strlen(dir_origen)+2
                ,sizeof(char));
            strcpy(ndiror,dir_origen);
            strcat(ndiror,"/");
            strcat(ndiror,dir_element->d_name);
            mostrardir(ndiror);
            free(ndiror);
        }
    return 0;
}

int main(int args, char* argv[]){
    int flags=0;
    int x;
    char opt,recursivo;
    int *ficheros;

    printf("args=%d",args);
    for(x=0;x<args;x++)
        printf("El arg[%d] => \"%s\"\n",x,argv[x]);
    /* Cojemos los argumentos y los interpretamos */
    while(-1!=(opt=getopt(args,argv,"al"))){
        switch(opt){
        case 'a':
            flags|=MI_TODOS;
            break;
        case 'l':
            flags|=MI_LISTA;
            break;
        case 'r':
        case 'R':
            flags|=MI_RECUR;
            break;
        }
        printf("Ha salido la opcion %c\n",opt);
    }
    
    /* De ahí, empezamos la copia */
    if(args<2)
        return 1;
    if(strlen(argv[args-1])<1)
        return 1;
    mostrardir(argv[args-1],flags);

    return 0;    
}
