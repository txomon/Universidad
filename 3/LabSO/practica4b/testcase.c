#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <stdlib.h>
#include <malloc.h>
int leer();

static FILE *fich;

int main()
{
    int x,y;
    fich=fopen("input.txt","r");
    /*/fich=fopen("input.txt","w");
    for(x=0;x<1000;x++){
        for(y=0;y<50;y++)
            fprintf(fich,"%d",x%10);
        fprintf(fich,"\b\n");
    }/*/
    fork();
    leer();/**/
    return 0;
}

int leer (){
    int x;
    char *array=(char*)calloc(sizeof(char),2);

    array[1]=0;
    for(x=0;x<5;x++){
        fread(array,1,sizeof(char),fich);
    //    printf("%d: INICIO\t%c\tFIN\n",getpid(),array);
    }
    return 0;

}
