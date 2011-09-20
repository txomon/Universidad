/*
 * usuario/init.c
 *
 *  Minikernel. Versión 1.0
 *
 *  Fernando Pérez Costoya
 *
 */

/* Programa inicial que arranca el S.O. Sólo se ejecutarán los programas
   que se incluyan aquí, que, evidentemente, pueden ejecutar otros
   programas...
*/

#include "servicios.h"

int main(){

	printf("init: comienza\n");

	if (crear_proceso("simplon")<0)
                printf("Error creando simplon\n");

	/* Este programa causa una excepción */
	if (crear_proceso("excep_arit")<0)
		printf("Error creando excep_arit\n");

	/* Este programa crea otro proceso que ejecuta simplon a
	   una excepción */
	if (crear_proceso("excep_mem")<0)
		printf("Error creando excep_mem\n");
	
	/* No existe: debe fallar */
	if (crear_proceso("noexiste")<0)
		printf("Error creando noexiste\n");

	printf("init: termina\n");
	return 0; 
}
