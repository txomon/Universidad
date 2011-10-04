#include "servicios.h"

int main(){
	printf("Este proceso tiene el valor %d", obtener_id_pr());
	dormir(9);
	printf("Este proceso tiene el valor %d", obtener_id_pr());
    return 0;
}
