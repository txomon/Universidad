;******** EQUIVALENCIAS ********;

	CBLOCK
BIT_CONT; Para llevar un contador
TEMP;Para guardar cosas importantes
TEMP2; Para guardar el registro con el que trabajamos
	;** Control de origen de llamada **;
	P_S_H;
;**** control de teclas *****
KEYHL; KEY HARD LOWER
KEYHU; Para tener guardadas cuales son las teclas presionadas comprobadas
KEYSL; KEY SOFT LOWER
KEYSU; Para tener guardadas cuales son las teclas presionadas a comprobar
KEYRCTL; Voy a utilizarlo como un registro para pasar parametros a funciones

	ENDC

;**** equivalencias de puertos ****;
PORTPAD	EQU	PORTB
TRISPAD	EQU	TRISB

	;** bits de configuración de KEYRCTL **;
	KRP0	EQU	0;
	KRP1	EQU	1;
	KRP2	EQU	2;
	KRL_U	EQU	3; seleccionar lower/upper (0/1)
	KRH_S	EQU	4; seleccionar hard/soft (0/1)
	KRS_C	EQU	5; bit set/bit clear (0/1)

;******** TABLAS PAD *********;
;**** traduccion de num de caracter a bits de comparación ****;
POSACOMP:
	ADDWF	PCL,F;
	RETLW	B'01111110';*
	RETLW	B'01111101';0
	RETLW	B'01111011';#
	RETLW	B'01110111';D
	RETLW	B'10111110';7
	RETLW	B'10111101';8
	RETLW	B'10111011';9
	RETLW	B'10110111';C
	RETLW	B'11011110';4
	RETLW	B'11011101';5
	RETLW	B'11011011';6
	RETLW	B'11010111';B
	RETLW	B'11101110';1
	RETLW	B'11101101';2
	RETLW	B'11101011';3
	RETLW	B'11100111';A
	
;**** traducción de num de caracter a bit en el registro ****;
NUMAKEYR:
	ADDWF	PCL,F;
	RETLW	H'01'
	RETLW	H'02'
	RETLW	H'04'
	RETLW	H'08'
	RETLW	H'10'
	RETLW	H'20'
	RETLW	H'40'
	RETLW	H'80'
	