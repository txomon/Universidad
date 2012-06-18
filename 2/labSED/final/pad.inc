;******** EQUIVALENCIAS ********;

	CBLOCK
BIT_CONT; Para llevar un contador
PAD_TMP;Para guardar cosas importantes
PAD_TMP2; Para guardar el registro con el que trabajamos

;**** control de teclas *****
KEYHL; KEY HARD LOWER
KEYHU; Para tener guardadas cuales son las teclas presionadas comprobadas
KEYRCTL; Voy a utilizarlo como un registro para pasar parametros a funciones

	ENDC
	
	;** Control de origen de llamada **;
	P_S_H EQU 7;
;**** equivalencias de puertos ****;
PAD_ENT	EQU	H'F0'; Esta macro lleva el valor de cuales son los bits de entrada (a 1) y los de salida
PORTPAD	EQU	PORTB
TRISPAD	EQU	TRISB

	;** bits de configuración de KEYRCTL **;
	KRP0	EQU	0; Estos tres bits krp<0:2> sirven para marcar la posición
	KRP1	EQU	1; dentro del keypad, en verdad es <0:3> pero como está dividido en
	KRP2	EQU	2; dos registros, el krp<3> sirve también para distinguir en el registro en el que se guarda.
	KRL_U	EQU	3; seleccionar lower/upper (0/1), vamos, que ademas de seleccionar el registro, distingue entre las teclas
			; *0#D789C de 456B123A, selecciónando cuales son low (*-C) y cuales Up (4-A)
	KRS_C	EQU	4; bit set/clear (0/1), vamos, la operación que se supone que hay que hacer en el registro de la tecla
			; krp<0:2>, dado por krl_u, y si es en el registro Hard o Soft, dado por KRH_S. La operación a hacer es poner a 0 o a 1

;******** TABLAS PAD *********;
;**** traduccion de num de caracter a bits de comparación ****;
POSACOMP:
	ADDWF	PCL,F;
	RETLW	B'01111110';*
	RETLW	B'01111101';0
	RETLW	B'01111011';#
	RETLW	B'01110111';D - ROJO
	RETLW	B'10111110';7
	RETLW	B'10111101';8
	RETLW	B'10111011';9
	RETLW	B'10110111';C - ABAJO
	RETLW	B'11011110';4
	RETLW	B'11011101';5
	RETLW	B'11011011';6
	RETLW	B'11010111';B - ARRIBA
	RETLW	B'11101110';1
	RETLW	B'11101101';2
	RETLW	B'11101011';3
	RETLW	B'11100111';A - VERDE
	
;**** traducción de num de caracter a bit en el registro ****;
NUMAKEYR:
	ADDWF	PCL,F
	RETLW	H'01'
	RETLW	H'02'
	RETLW	H'04'
	RETLW	H'08'
	RETLW	H'10'
	RETLW	H'20'
	RETLW	H'40'
	RETLW	H'80'