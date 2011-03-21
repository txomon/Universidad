	LIST	P=16F887; Para el compilador
	INCLUDE	"P16F887.INC"; Para las EQU del micro
	errorlevel -207;quito los warnings de labels
;*****************************************************************************************************************************************
;***************************************** LAS EQUIVALENCIAS Y LAS VARIABLES *************************************************************
;*****************************************************************************************************************************************
;******** DIRECCIONES DE LAS TABLAS ********;
POSACOMPD	EQU	H'800';Tabla de conversión de posición en el teclado a compraración
NUMAKEYRD	EQU	H'811';Tabla de conversión de numero de tecla a bit del registro


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
	KRP0	EQU	0;
	KRP1	EQU	1;
	KRP2	EQU	2;
	KRL_U	EQU	3; seleccionar lower/upper (0/1)
	KRH_S	EQU	4; seleccionar hard/soft (0/1)
	KRS_C	EQU	5; bit set/bit clear (0/1)


;**** equivalencias de puertos ****;
PORTPAD	EQU	PORTB
TRISPAD	EQU	TRISB

;******** EL LED ********;
B_LED	EQU	0;Posicion en el puerto
P_LED	EQU	PORTA;Puerto

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
	CLRW;Limpiamos el espacio de trabajo
RETI:
	CLRF	STATUS;Por defecto en las rsi trabajare en el banco 0
	BTFSC	PIR1,TMR2IF; el timer2 está para comprobar si era un rebote (Soft-> Hard)
		GOTO	TMR2INTER;
	ANDLW	H'FF';
	BTFSS	STATUS,Z;
		GOTO	RETITRAMPA;
	BTFSC	INTCON,RBIF; esto está para pasar las pulsaciones al registro Soft (primera vez)
		GOTO	PADINTER;
RETITRAMPA:
	BANKSEL	P_LED;
	BTFSC	KEYHL,0;se enciende el led si está el registro Hard activado y si no, se apaga
		BCF	P_LED,B_LED;
	BTFSS	KEYHL,0;
		BSF	P_LED,B_LED;

	;AQUI ACABA LA TABLA DE RSI
	;devolvemos los valores a su sitio
	BANKSEL	SAVEPCL;
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
		PAGESELW	NUMAKEYR;Consultar tabla de numero a bit del registro
		MOVLW	H'07';seleccionamos que bits a utilizar de indice 3 LSB
		ANDWF	BIT_CONT,W;cargamos esos bits
		CALL	NUMAKEYR&7FF;llamamos a la tabla
		ANDWF	REG_TEMP,W;comparamos lo que nos devuelve con nuestro registro de control
		MOVWF	TEMP;Guardamos la comparación (0 falso) para después
		PAGESEL	TMR2PADBUCLEDES;actualizamos el pclath para seguir aqui y no irnos por ahí
		MOVF	TEMP,F;Recuperamos la comparación (cambiamos el status [Z])
		BTFSS	STATUS,Z;comprobamos si el que comprobamos esta vacio
			GOTO	TMR2PADBUCLEDE0;si esta vacio, borramos el hard
		BTFSC	STATUS,Z;lo mismo
			GOTO	TMR2PADBUCLEDE1;si esta lleno, borramos el soft y ponemos el hard
		
	TMR2PADBUCLEDE1:
	;una vez verificado que está en la lista, comprobar su estado
		PAGESELW	POSACOMP;Consultar tabla de posición a comparación
		MOVF	BIT_CONT,W;Cargamos el índice de la tabla
		CALL	POSACOMP&7FF;Consultamos la tabla
		PAGESEL	COMPPAD;Nos preparamos para comprobar si está pulsado o no la tecla
		CALL	COMPPAD;llamamos a la función que lo hace
		ANDLW	H'01';Comprobamos si es falso
		BTFSC	STATUS,Z;
			GOTO	TMR2PADBORRARREG;Ha sido una pulsación inválida
		CLRF	KEYRCTL;Al ser valida, se pasa al registro HARD
		MOVF	BIT_CONT,W;
		MOVWF	KEYRCTL;
		CALL	KEYPADREGW;
	TMR2PADBORRARREG:
		MOVF	BIT_CONT,W;Se borra el registro SOFT
		IORLW	B'00110000'
		MOVWF	KEYRCTL;
		CALL	KEYPADREGW;
	TMR2PADBUCLEDE0:
		INCF	BIT_CONT,F;Se incrementa el contador de comprobación
		MOVF	KEYSL,W; Se carga el registro soft
		BTFSC	BIT_CONT,4; Si el contador es más de 8, 
			MOVF	KEYSU,W;entonces, Se carga la parte alta
		MOVWF	REG_TEMP; Se carga en el registro temporal	
		BTFSS	BIT_CONT,5; Si el contador ha pasado de 16
			GOTO	TMR2INTERFIN; entonces finalizamos la rsi
		GOTO	TMR2PADBUCLE;Volvemos a empezar
	
	TMR2INTERFIN:
	BCF	PIR1,TMR2IF;Quitamos la interrupción
	BCF	T2CON,TMR2ON;Deshabilitamos el temporizador
	BANKSEL	PIE1;banco1
	BCF	PIE1&7F,TMR2IE;Quitamos el aviso de interrupción
	BANKSEL	TMR2IF;banco0
	BSF	INTCON,RBIE;
	GOTO	RETI;

;******	Comprobar el keypad ******;
PADINTER:
	CLRF	BIT_CONT;
	; Comprobamos por columnas
	BTFSS	PORTPAD,7;miramos si la columna 1 se ha activado
		CALL	COMPCOLUM;comparamos la columna 1 (de 0 a 3)
	MOVLW	H'F0'
	BTFSC	PORTPAD,7;
		ANDWF	KEYSL,F;
	MOVLW	H'4';
	MOVF	BIT_CONT,F
	BTFSS	PORTPAD,6;columna 2
		CALL	COMPCOLUM;columna2 (de 4 a 7)
	MOVLW	H'0F'
	BTFSC	PORTPAD,6;
		ANDWF	KEYSL,F;
	MOVLW	H'8';
	MOVF	BIT_CONT,F;
	BTFSS	PORTPAD,5;columna 3
		CALL	COMPCOLUM;columna3 (de 8 a 11)
	MOVLW	H'F0'
	BTFSC	PORTPAD,5;
		ANDWF	KEYSU,F;
	MOVLW	H'B';
	MOVF	BIT_CONT,F
	BTFSS	PORTPAD,4;columna 4
		CALL	COMPCOLUM;columna4 (de 12 a 15)
	MOVLW	H'0F'
	BTFSC	PORTPAD,7;
		ANDWF	KEYSU,F;
	MOVF	KEYSL,W;
	ANDWF	KEYHL,W;
	ADDWF	KEYSU,W;
	ADDWF	KEYHU,W;
	BTFSS	STATUS,Z;Si hay algo en el Soft, programar temporizacion
		CALL	INICIATMP2;
	CLRF	PORTPAD;
	BCF	INTCON,RBIE;
	GOTO	RETI;
		
;**** COMPCOLUM Comprueba las filas recurrentemente ****;
COMPCOLUM:
	PAGESELW	POSACOMP
	MOVF	BIT_CONT,W;
	CALL	POSACOMP&7FF;Conseguimos la comparación para la tecla
	PAGESEL	COMPPAD;
	CALL	COMPPAD;Comparamos si está pulsada
	MOVWF	TEMP;El resultado lo guardamos
	CLRF	KEYRCTL;
	MOVF	BIT_CONT,W;Cargamos el num de bit en W
	IORLW	B'00010000';Añadimos que escriba en el soft
	BTFSS	TEMP,0;
		IORLW	B'00100000';Añadimos que haga un clear
	MOVWF	KEYRCTL;
	CALL	KEYPADREGW;
	INCF	BIT_CONT,F;
	MOVF	BIT_CONT,W;
	CLRF	TEMP;
	BTFSS	BIT_CONT,0;Compruebo si hemos llegado al XX00(cambio de columna)
		INCF	TEMP,F;
	BTFSS	BIT_CONT,1;
		INCF	TEMP,F;
	BTFSC	TEMP,1;
		RETURN;
	GOTO	COMPCOLUM;
	


;**** KEYPADREGW (escritor del registro del teclado) ****;
KEYPADREGW:
	MOVLW	KEYHL; Pongo la posición del 1er registro
	BTFSC	KEYRCTL,KRH_S;registro Soft?
		ADDLW	H'2';sumo dos al FSR (para que apunte al Soft)
	BTFSC	KEYRCTL,KRL_U;registro Up?
		ADDLW	H'1';sumo uno al FSR (para que apunte a la parte alta)
	MOVWF	FSR;Escribo el FSR
	PAGESELW	NUMAKEYR;
	MOVF	KEYRCTL,W;Elijo cual quiero
	ANDLW	H'7';Cortamos el numero a 3 bits
	CALL	NUMAKEYR&7FF;Nos dice el bit del registro que tiene que ser
	CLRF	PCLATH;Esta no la puedo hacer a con el pageselw
	MOVWF	TEMP;Guardo en temp
	MOVF	INDF,W;
	ANDWF	TEMP,W;
	BTFSS	STATUS,Z;
		GOTO	EN1;
	MOVF	TEMP,W;
	BTFSS	KEYRCTL,KRS_C;
		IORWF	INDF,F;Escribo uno en el registro
	RETURN;
EN1:	
	MOVF	TEMP,W;
	BTFSC	KEYRCTL,KRS_C;
		XORWF	INDF,F;Escribo 0 en el registro	
	RETURN;

;**** COMPPAD (Comprobador de si una tecla está activada) ****;
COMPPAD:
	MOVWF	TEMP;tenemos la comparación a realizar EJ:01111110
	MOVWF	PORTPAD;cargamos la comparación en el puerto EJ; 01011110
	COMF	TEMP,F;Invertimos la comparación EJ:10000001
	COMF	PORTPAD,W;Invertimos la lectura EJ: 10100001;
	ANDWF	TEMP,W;Comparamos EJ: 10000001 & 10100001 = 10000001
	ANDLW	H'F0';Cortamos los 4 de arriba EJ: 10000000
	BTFSS	STATUS,Z;
		RETLW	H'01';Devolvemos true
	RETLW	H'00';Devolvemos false
;**** INICIATMP2(Programa el timer para que salte a lo máximo posible) ****;
INICIATMP2:;Vaciamos los pre/post escaladores
	BANKSEL	PR2;banco1
	BSF	PIE1&7F,TMR2IE;Habilitamos las interrupciones
	MOVLW	H'01'
	MOVWF	PR2&7F;
	BANKSEL	T2CON
	BCF	PIR1,TMR2IF;Borramos la interrupción
	CLRF	T2CON;ponemos preescalador y postacalador 1:1
	BSF	T2CON,TMR2ON;encendemos el reloj
	CLRF	TMR2;borramos la cuenta en curso
T2ICL:	BTFSS	PIR1,TMR2IF;Cuando ponga la interrupción que salga
		GOTO	T2ICL;
	BCF	T2CON,TMR2ON;Apagamos el temporizador
	BCF	PIR1,TMR2IF;Quitamos la señal de interrupción
	BANKSEL	PR2
	MOVLW	H'FF';ponemos al maximo la comparación
	MOVWF	PR2&7F;
	BANKSEL	T2CON 
	MOVWF	T2CON;encendemos y ponemos al maximo los post/pre escaladores
	RETURN;



;*******************************************************************;
;********** Programa principal ***********;
PROG:
	BCF	INTCON,GIE;
	CALL	PADINIT;
	CALL	LEDINIT;
	BSF	INTCON,GIE;
BUCLEOCIOSO:
	GOTO	BUCLEOCIOSO;	
	
	
PADINIT:
	BANKSEL	ANSELH;Banco4
	CLRF	ANSELH&7F;modo digital
	BANKSEL	TRISPAD;Banco1
	MOVLW	B'11110000';Configuramos como 4 entradas y 4 salidas
	MOVWF	TRISPAD&7F;
	BCF	OPTION_REG&7F,NOT_RBPU;Activamos las resistencias de pull up
	BANKSEL PORTPAD;Banco0
	MOVLW	B'00000000';
	MOVWF	PORTPAD;Ponemos a 0 todos los puertos para notar el cambio.
	BANKSEL	IOCB;Banco1
	CLRF	IOCB&7F;Para habilitar las interrupciones en cada pin
	COMF	IOCB&7F,F;Lo inicializo a 1 todo
	BANKSEL	INTCON;Banco0
	CLRF	KEYSL;Inicializo a 0 los registros de control de teclas
	CLRF	KEYSU;
	CLRF	KEYHL;
	CLRF	KEYHU;
	BSF	INTCON,RBIE;Habilito las interrupciones para todo el puerto B
	BSF	INTCON,PEIE;Habilito las interrupciones de dispositivos
	RETURN;

;****** LEDINIT para inicializar el led ******;
LEDINIT:
	BANKSEL	ANSEL;
	CLRF	ANSEL;
	BANKSEL	TRISA;me coloco para modificar el trisa
	BCF	P_LED,B_LED;Digo que va a ser de output
	BANKSEL	P_LED;me coloco en el porta
	BSF	P_LED,B_LED;Apago el led
	

;******** TABLAS *********;
;**** traduccion de num de caracter a bits de comparación ****;
	ORG	POSACOMPD;
POSACOMP:
	ADDWF	PCL,F;
	RETLW	B'01111110';1
	RETLW	B'01111101';4
	RETLW	B'01111011';7
	RETLW	B'01110111';*
	RETLW	B'10111110';2
	RETLW	B'10111101';5
	RETLW	B'10111011';8
	RETLW	B'10110111';0
	RETLW	B'11011110';3
	RETLW	B'11011101';6
	RETLW	B'11011011';9
	RETLW	B'11010111';#
	RETLW	B'11101110';A
	RETLW	B'11101101';B
	RETLW	B'11101011';C
	RETLW	B'11100111';D
	
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