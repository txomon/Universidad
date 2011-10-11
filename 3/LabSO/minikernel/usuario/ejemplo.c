#include "servicios.h"

int main(){
    printf("Empieza ejemplo\n");
	printf("Este proceso tiene el valor %d\n", obtener_id_pr());
	dormir(3);
	printf("Este proceso tiene el valor %d\n", obtener_id_pr());
    printf("Acaba ejemplo\n");
    return 0;
}
