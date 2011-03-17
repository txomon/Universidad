	LIST	P=16F887; Para el compilador
	INCLUDE	"P16F887.INC"; Para las EQU del micro
;*****************************************************************************************************************************************
;***************************************** LAS EQUIVALENCIAS Y LAS VARIABLES *************************************************************
;*****************************************************************************************************************************************
;******** DIRECCIONES DE LAS TABLAS ********;
POSACOMPD	EQU	H'800';Tabla de conversión de posición en el teclado a compraración
NUMAKEYRD	EQU	H'810';Tabla de conversión de numero de tecla a bit del registro


;********
;******** VARIABLES EN LA RSI *********;

;**** variables para guardar los parametros de entrada ****;
SAVEW	EQU	H'20'; workspace
SAVEST	EQU	H'21'; status
SAVEFSR	EQU	H'22'; fsr (indirect addressing)
SAVEPCL	EQU	H'23'; pclath
;**** varios ****;
BIT_CONT	EQU	H'2F'; Para llevar un contador
TEMP	EQU	H'2E';Para guardar cosas importantes
REG_TEMP	EQU	H'2D'; Para guardar el registro con el que trabajamos

;******** EL TECLADO ********;
;**** control de teclas *****
KEYHL	EQU	H'30'; KEY HARD LOWER
KEYHU	EQU	H'31'; Para tener guardadas cuales son las teclas presionadas comprobadas
KEYSL	EQU	H'32'; KEY SOFT LOWER
KEYSU	EQU	H'33'; Para tener guardadas cuales son las teclas presionadas a comprobar

KEYRCTL	EQU	H'34'; Voy a utilizarlo como un registro para pasar parametros a funciones
	;** bits de configuración de KEYRCTL **;
	KRP0	EQU	H'0';
	KRP1	EQU	H'1';
	KRP2	EQU	H'2';
	KEYL_U	EQU	H'3'; seleccionar lower/upper (0/1)
	KEYH_S	EQU	H'4'; seleccionar hard/soft (0/1)
	KEYS_C	EQU	H'5'; bit set/bit clear (0/1)


;**** equivalencias de puertos ****;
PORTPAD	EQU	PORTB
TRISPAD	EQU	TRISB
;********


;********






; Y aqui empezamos propiamente a programar
	ORG	H'003'
	GOTO	PROG; Para iniciar el programa

;******** RSI Y RETI *********;
	ORG	H'004';Especifico el comienzo de la RSI al lugar de una interrupción
RSI:
	BCF	INTCON,GIE; Como voy a hacer un sistema de RSI muy completo, no
	; necesito interrupciones
;Espacio de Trabajo
	MOVWF	SAVEW;Guardo el Espacio de Trabajo
;Status
	MOVF	STATUS,W;Pongo el status en el Espacio de trabajo
	MOVWF	SAVEST;Guardo el status en su espacio correspondiente
	CLRF	STATUS;Me coloco en el espacio de trabajo 0
;FSR
	MOVF	FSR,W;Muevo el valor del registro de direccionamiento al E.T.
	MOVWF	SAVEFSR;Guardo el registro de direccionamiento indirecto
;PCLATH
	MOVF	PCLATH,W;El PCLATH no es retroalimentado por el PC 
	MOVWF	SAVEPCL;por lo que se puede salvar ahora
	CLRF	PCLATH;Y lo borramos por que queremos estar en el banco 0 y
	; no queremos saltar a ningún banco de memoria

	;AQUI TODAS LAS INTERRUPCIONES POR ORDEN DE PRIORIDAD.
RETI:
	CLRF	STATUS;Por defecto en las rsi trabajare en el banco 0
	BTFSC	PIR1,TMR2IF; Miro si el timer ha sido llamado
		GOTO	TMR2INTER;
	BTFSC	INTCON,RBIF;
		GOTO	PADINTER;
	;AQUI ACABA LA TABLA DE RSI
	;devolvemos los valores a su sitio
;PCLATH
	MOVF	SAVEPCL,W;
	MOVWF	PCLATH;
;FSR
	MOVF	SAVEFSR,W;
	MOVWF	FSR;
;STATUS
	MOVF	SAVEST,W;
	MOVWF	STATUS;
;W
	MOVF	SAVEW,W;
	RETFIE;
;*******************************;	
;******** TABLAS DE RSI ********;
;*******************************;

;****** CONFIRMAR  TECLAS ******;
TMR2INTER:
	CLRF	BIT_CONT;
	MOVLW	KEYSL;
	MOVWF	REG_TEMP;
	TMR2PADBUCLE:
	;primero comprobaremos si está en la lista que comprobar
		PAGESEL	NUMAKEYR;Consultar tabla de numero a bit del registro
		MOVLW	H'07';seleccionamos que bits a utilizar de indice 3 LSB
		ANDWF	BIT_CONT,W;cargamos esos bits
		CALL	NUMAKEYR;llamamos a la tabla
		ANDWF	REG_TEMP,W;comparamos lo que nos devuelve con nuestro registro de control
		MOVWF	TEMP;Guardamos la comparación (0 falso) para después
		PAGESEL	TMR2PADBUCLEDES;actualizamos el pclath para seguir aqui y no irnos por ahí
		MOVF	TEMP,F;Recuperamos la comparación (cambiamos el status [Z])
		BTFSS	STATUS,Z;comprobamos si el que comprobamos esta vacio
			GOTO	TMR2PADBUCLEDES;si no está pasamos al siguiente
	;una vez verificado que está en la lista, comprobar su estado
		PAGESEL	POSACOMP;Consultar tabla de posición a comparación
		MOVF	BIT_CONT,W;Cargamos el índice de la tabla
		CALL	POSACOMP;Consultamos la tabla
		PAGESEL	COMPPAD;Nos preparamos para comprobar si está pulsado o no la tecla
		CALL	COMPPAD;llamamos a la función que lo hace
		ANDLW	H'01';Comprobamos si es falso
		BTFSC	STATUS,Z;
			GOTO	TMR2PADBORRARREG;Ha sido una pulsación inválida
		CLRF	KEYRCTL;Al ser valida, se pasa al registro HARD
		MOVF	BIT_CONT,W;
		MOVWF	KEYRCLT;
		CALL	KEYPADREGW;
	TMR2PADBORRARREG:
		MOVF	BIT_CONT,W;y se borra el registro SOFT
		IORLW	B'00110000'
		MOVWF	KEYRCTL;
		CALL	KEYPADREGW;
	TMR2PADBULCEDES:
		INCF	BIT_CONT;
		MOVF	KEYSL,W;
		BTFSS	BIT_CONT,4;
			MOVF	KEYSU,W;
		MOVWF	REG_TEMP	
		BTFSS	BIT_CONT,5;
			GOTO	TMR2INTERFIN
		GOTO	TMR2PADBUCLE;
	
	TMR2INTERFIN:
	BCF	PIR1,TMR2IF
	BCF	PIE1,TMR2IE
	GOTO	RETI;

PADINTER:
	




;********* COMPROBAR SI ESTÁ PULSADO O NO ********;
PADCOMPR:



PROG:
	BCF	INTCON,GIE;
	CALL	PADINIT;
	BSF	INTCON,GIE;
BUCLEOCIOSO:
	GOTO	BUCLEOCIOSO;	
	
	
PADINIT:
	BANKSEL	TRISPAD;Nos movemos al banco en el que esta la configuración del puerto del keypad
	MOVLW	B'11110000';Configuramos como 4 entradas y 4 salidas
	MOVWF	TRISPAD&7F;
	BCF	OPTION_REG&7F,NOT_RBPU;Activamos las resistencias de pull up
	BANKSEL PORTPAD;Nos ponemos en el banco del puerto del teclado
	MOVLW	B'00000000';
	MOVWF	PORTPAD;Ponemos a 0 todos los puertos para notar el cambio.
	CLRF	IOCB;Para habilitar las interrupciones en cada pin
	COMF	IOCB,F;Lo inicializo a 1 todo
	BSF	INTCON,RBIE;Habilito las interrupciones para todo el puerto B
	RETURN;


;******** TABLAS *********;
;**** traduccion de num de caracter a bits de comparación ****;
	ORG	POSACOMPD;
POSACOMP:
	ADDWF	PCL,F;
	RETLW	B'10110111';0
	RETLW	B'01111110';1
	RETLW	B'10111110';2
	RETLW	B'11011110';3
	RETLW	B'01111101';4
	RETLW	B'10111101';5
	RETLW	B'11011101';6
	RETLW	B'01111011';7
	RETLW	B'10111011';8
	RETLW	B'11011011';9
	RETLW	B'11101110';A
	RETLW	B'11101101';B
	RETLW	B'11101011';C
	RETLW	B'11100111';D
	RETLW	B'11010111';#
	RETLW	B'01110111';*

;**** traducción de num de caracter a bit en el registro ****;
	ORG	NUMAKEYRD;
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
	END;