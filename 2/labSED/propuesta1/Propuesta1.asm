; Comienzo con la propuesta para la realización de un ejercicio
; que consiste en hacer parpadear un led ganando un 10% de ciclo
; de trabajo cada vez que parpadea, y cuando llega al 100%,
; volviendo a 0%
;
;	Ejemplo:
; Ciclo de 1s [0-10seg] : /\_________/\_________/\_________/\_________/\_________/\_________/\_________/\_________/\_________/\_________/\_________/\_________
;                                                _          __         ___        ____       _____      ______     _______    __________
;                   Led : ___________/\_________/ \________/  \_______/   \______/    \_____/     \____/      \___/       \__/          \__________/\_________
;
;
; Este debería ser al menos el funcionamiento, por lo que he 
; entendido. Por lo tanto, ahora hay que planificarlo.
; Se me ocurren varias maneras de hacerlo, dependiendo de los
; recursos que queramos gastar:
; 
; 1.- Haciendo que el temporizador salte cada 0'1 segundos
; 2.- Haciendo que el temporizador salte cada 1 segundo y
;	cada vez que haya que cambiar la luz del led
; 3.- Haciendo un bucle infinito que calculando el número de
;	bucles concatenados nos vaya dando un valor cada vez
;	mayor (o menor)
; 4.- Usando 2 temporizadores, de forma que el que está 
; 	preparado para hacer cuentas largas nos genere una
;	interrupción cada 1seg y el otro, cada vez que le toque
;	apagar el led
; 
;
; Visto que hay muchas opciones para codificar/implementar 
; la misma solución, voy a utilizar la que menos recursos 
; requiere y menor complicación tenga a la hora de implementarse.
;
; Debo admitir que me atrae la 4ta forma mucho, pero no lo
; considero viable en un sistema que necesite tener acceso a 
; algún temporizador.
;
; La siguiente opción que más me atrae, y que es bastante buena, 
; es la 2. El hecho de utilizar un solo temporizador, hace
; que sea bastante más viable y bastante atractiva. La razón por
; la que la desecho es que las operaciones aritméticas que tendría
; que hacer son algo más complicadas que la opción que voy a
; utilizar.
;
; Esta opción no me atrae nada, jamás la utilizaría por dos razones,
; la primera es que el sistema solo se puede dedicar a eso, y además
; sería un tostón peor que el anterior hacer los cálculos, y solo
; de pensarlo me da una pereza horrible. Bien pensado, si se
; necesitara un sistema (únicamente para eso) preciso, sería la 
; mejor opción. Escribir los bucles a mano, te permitiría tener un
; control absoluto de los tiempos, no tendrías que hacer calculos
; para la cuanto dura cada instrucción y te permitiría llevar el 
; cálculo de la forma más precisa posible. Esa es evidentemente, la
; opcion 3.
;
; Y la opción con la que me voy a quedar, es la opción 1. Me parece
; que es la mejor forma de hacerlo.
;
; 
;

	LIST	"P16F887"
	INCLUDE "P16F887.INC"