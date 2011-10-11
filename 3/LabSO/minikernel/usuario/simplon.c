/*
 * usuario/simplon.c
 *
 *  Minikernel. Versión 1.0
 *
 *  Fernando Pérez Costoya
 *
 */

/*
 * Programa de usuario que simplemente imprime un valor entero
 */

#include "servicios.h"

#define TOT_ITER 2000 /* ponga las que considere oportuno */

int main(){
	int i;

    printf("simplon: empieza\n");
    printf("simplon tiene id %d\n",obtener_id_pr());
	for (i=0; i<TOT_ITER; i++)
		printf("[id %d] simplon: i %d\n",obtener_id_pr(), i);

    dormir(3);
	printf("simplon: termina\n");
	return 0;
}
