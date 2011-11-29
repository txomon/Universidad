#include <stdio.h>
#include <malloc.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <string.h>
#include <dirent.h>
#include <errno.h>
#include <time.h>

#define MI_RECUR   0x0001
#define MI_LISTA   0X0002
#define MI_TODOS   0X0004

#define SMI_RECUR(X) (X & MI_RECUR)
#define SMI_LISTA(X) (X & MI_LISTA)
#define SMI_TODOS(X) (X & MI_TODOS)

int mostrardir( char [],int);

int mostrardir(char dir_origen[],int flags)
{
    char *ndiror;
    struct stat buf_or,element;
    struct dirent *dir_element;
    DIR *dor;
    struct tm *fecha;

    stat(dir_origen,&buf_or);
    printf("Empezamos a leer el directorio %s\n", dir_origen);
    if(buf_or.st_mode&S_IFDIR){
        dor=opendir(dir_origen);
        while(NULL!=(dir_element=readdir(dor))){
            ndiror=calloc(strlen(dir_element->d_name)
                +strlen(dir_origen)+2,sizeof(char));
            strcpy(ndiror,dir_origen);
            if(ndiror[strlen(dir_origen)-1]!='/')
                strcat(ndiror,"/");
            strcat(ndiror,dir_element->d_name);
            stat(ndiror,&element);
            fecha=localtime(&(element.st_atime));       
            if((strcmp(dir_element->d_name,".")==0)||
                (strcmp(dir_element->d_name,"..")==0)){
                if(SMI_TODOS(flags)){
                    if(SMI_LISTA(flags))
                        printf("%c\t%d\t%d\t%d/%d/%d\t", 
                            (DT_DIR&dir_element->d_type)? 'D':
                            (DT_REG&dir_element->d_type)? 'R':
                            (DT_CHR&dir_element->d_type)? 'C':
                            (DT_BLK&dir_element->d_type)? 'B':
                            (DT_FIFO&dir_element->d_type)? 'F': '?',
                            (int)element.st_nlink,(int)element.st_size,
                            fecha->tm_mday,
                            fecha->tm_mon,fecha->tm_year%100);
                    printf("%s\n",dir_element->d_name);
                }
                goto bucle;
            }
            if(SMI_LISTA(flags))
                printf("%c\t%d\t%d\t%d/%d/%d\t", 
                    (DT_DIR&dir_element->d_type)? 'D':
                    (DT_REG&dir_element->d_type)? 'R':
                    (DT_CHR&dir_element->d_type)? 'C':
                    (DT_BLK&dir_element->d_type)? 'B':
                    (DT_FIFO&dir_element->d_type)? 'F': '?',
                    (int)element.st_nlink,(int)element.st_size,
                    fecha->tm_mday,fecha->tm_mon,fecha->tm_year%100);
                    
            printf("%s\n",dir_element->d_name);
            if(SMI_RECUR(flags)&&(dir_element->d_type&DT_DIR)){
                mostrardir(ndiror,flags);
            }
            bucle:
            free(ndiror);
        }
        free(dor);
    }
    return 0;
}

int main(int args, char* argv[]){
    int flags=0;
    int x;
    char opt;

    printf("args=%d\n",args);
    for(x=0;x<args;x++)
        printf("El arg[%d] => \"%s\"\n",x,argv[x]);
    /* Cojemos los argumentos y los interpretamos */
    while(-1!=(opt=getopt(args,argv,"alR"))){
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
