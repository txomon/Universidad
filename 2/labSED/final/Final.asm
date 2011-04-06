;
; Comienzo con la proyección del ejercicio de practica final de Sistemas Digitales. El objetivo ahora, va a ser conseguir hacer un movil que mande y
; reciba SMS. Una vez acabado eso, se pensará en la ampliación del proyecto a más. Para conseguirlo, se dispone de un modem GSM maestro100 que tiene
; todo lo necesario para poder enviar y recibir mensajes.
;
; De momento me centraré en conseguir el menú. Según vaya progresando en la teoría y en el planteamiento del proyecto, iré ampliando esta documentación
;
;
;
;
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
BIT_CONT	EQU	H'24'; Para llevar un contador
TEMP	EQU	H'25';Para guardar cosas importantes
REG_TEMP	EQU	H'26'; Para guardar el registro con el que trabajamos
TEMP2	EQU	H'27';
	;** Control de origen de llamada **;
	P_S_H	EQU	7;

;******** EL TECLADO ********;
;**** control de teclas *****
KEYHL	EQU	H'28'; KEY HARD LOWER
KEYHU	EQU	H'29'; Para tener guardadas cuales son las teclas presionadas comprobadas
KEYSL	EQU	H'2A'; KEY SOFT LOWER
KEYSU	EQU	H'2B'; Para tener guardadas cuales son las teclas presionadas a comprobar
KEYRCTL	EQU	H'2C'; Voy a utilizarlo como un registro para pasar parametros a funciones

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

;******** EL LCD ********;
TMP1	EQU	H'2D'
TMP2	EQU	H'2E'

;******** CONTROL DEL PROGRAMA ********;
MAQUINA_EST	EQU	H'2F'

	;** ESTADOS DE LA MÁQUINA **;
	POR	EQU	H'00';
	STANDBY	EQU	H'01';
	UNLOCK	EQU	H'02';
	MENU12_1 EQU	H'03';
	MARCA	EQU	H'04';
	MENSAJES_1 EQU	H'05';
	MENSAJES_2 EQU	H'06';
	LEER_SMS EQU	H'07';
	ESCRIBIR_SMS EQU H'08';


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
	CLRF	PCLATH;
	BTFSC	PIR1,TMR2IF; el timer2 está para comprobar si era un rebote (Soft-> Hard)
		GOTO	TMR2INTER;
	BTFSC	INTCON,RBIF; esto está para pasar las pulsaciones al registro Soft (primera vez)
		GOTO	PADINTER;
	BANKSEL	P_LED;
	MOVF	KEYHL,W;
	ADDWF	KEYHU,W;
	BTFSS	STATUS,Z;se enciende el led si está el registro Hard activado y si no, se apaga
		BCF	P_LED,B_LED;
	BTFSC	STATUS,Z;
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
	MOVLW	H'80';
	MOVWF	BIT_CONT;
	MOVF	KEYSL,W;
	XORWF	KEYHL,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
	
	MOVLW	H'84';
	MOVWF	BIT_CONT;
	MOVF	KEYSL,W;
	XORWF	KEYHL,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
		
	MOVLW	H'88';
	MOVWF	BIT_CONT;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
		
	MOVLW	H'8C';
	MOVWF	BIT_CONT;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
	
	BCF	PIR1,TMR2IF;Quitamos la interrupción
	BCF	T2CON,TMR2ON;Deshabilitamos el temporizador
	BANKSEL	PIE1;banco1
	BCF	PIE1&7F,TMR2IE;Quitamos el aviso de interrupción
	BANKSEL	TMR2IF;banco0
	CLRF	PORTPAD;
	BCF	INTCON,RBIF;
	BSF	INTCON,RBIE;
	GOTO	RETI;

;******	Comprobar el keypad ******;
PADINTER:
	CLRF	BIT_CONT;
	; Comprobamos por columnas
	CLRF	PORTPAD;
	BTFSS	PORTPAD,7;miramos si la columna 1 se ha activado
		CALL	COMPCOLUM;comparamos la columna 1 (de 0 a 3)
	MOVLW	H'4';
	MOVWF	BIT_CONT
	
	CLRF	PORTPAD;
	BTFSS	PORTPAD,6;columna 2
		CALL	COMPCOLUM;columna2 (de 4 a 7)
	MOVLW	H'8';
	MOVWF	BIT_CONT;

	CLRF	PORTPAD;	
	BTFSS	PORTPAD,5;columna 3
		CALL	COMPCOLUM;columna3 (de 8 a 11)
	MOVLW	H'C';
	MOVWF	BIT_CONT

	CLRF	PORTPAD;	
	BTFSS	PORTPAD,4;columna 4
		CALL	COMPCOLUM;columna4 (de 12 a 15)
	
	MOVF	KEYSL,W; Comprobamos si hemos escrito algo en total,
	XORWF	KEYHL,W; para saber si hay diferencias entre el H y el S
	MOVWF	TEMP;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	IORWF	TEMP,W;
	BTFSS	STATUS,Z;Si hay algo en el Soft, programar temporizacion
		CALL	INICIATMP2;
	BANKSEL	PORTPAD;
	CLRF	PORTPAD;
	MOVF	KEYSL,W;
	XORWF	KEYHL,W;
	MOVWF	TEMP;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	IORWF	TEMP,W;
	BTFSS	STATUS,Z;Si hay algo, deshabilitar interrupciones
		BCF	INTCON,RBIE;
	BCF	INTCON,RBIF
	GOTO	RETI;
		
;**** COMPCOLUM Comprueba las filas recurrentemente ****;
COMPCOLUM:
	PAGESELW	POSACOMP
	MOVF	BIT_CONT,W;
	ANDLW	H'0F';
	CALL	POSACOMP&7FF;Conseguimos la comparación para la tecla
	PAGESEL	COMPPAD;
	CALL	COMPPAD;Comparamos si está pulsada
	MOVWF	TEMP2;El resultado lo guardamos
	CLRF	KEYRCTL;
	MOVF	BIT_CONT,W;Cargamos el num de bit en W
	IORLW	B'00010000';Añadimos que escriba en el soft
	BTFSS	TEMP2,0;Si el resultado es 0
		IORLW	B'00100000';Añadimos que haga un clear
	BTFSC	BIT_CONT,P_S_H;
		IORLW	B'00100000';Si el resultado es de S a H
	MOVWF	KEYRCTL;
	CALL	KEYPADREGW;
	
	BTFSC	BIT_CONT,P_S_H;		
		GOTO	CALLFROMTMP2;
	GOTO	CALLFROMCOMPPAD;
CALLFROMTMP2:
	MOVF	BIT_CONT,W;
	BTFSS	TEMP2,0;
		IORLW	B'00100000';
	MOVWF	KEYRCTL;
	CALL	KEYPADREGW;	
CALLFROMCOMPPAD:
	CLRF	PORTPAD;
	INCF	BIT_CONT,F;
	MOVF	BIT_CONT,W;
	ANDLW	H'03';Compruebo si hemos llegado al XX00(cambio de columna)
	BTFSC	STATUS,Z;
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
	MOVF	INDF,W;Comparo el valor del registro
	ANDWF	TEMP,W;con el valor de la comparación
	BTFSS	STATUS,Z;si esta en 1, salto
		GOTO	EN1;esta en 1
	MOVF	TEMP,W;esta en 0
	BTFSS	KEYRCTL,KRS_C;
		IORWF	INDF,F;Escribo uno en el registro
	RETURN;
EN1:	
	MOVF	TEMP,W;
	BTFSC	KEYRCTL,KRS_C;Si dice que hay que borrarlo
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
	PAGESEL PADINIT;
	CALL	PADINIT;
	PAGESEL LEDINIT;
	CALL	LEDINIT;
	PAGESEL LCDINIT;
	CALL	LCDINIT;
	PAGESEL SERIAL_INIT
	CALL	SERIAL_INIT
	CLRF	MAQUINA_EST;
	BSF	INTCON,GIE;
BUCLEOCIOSO:
	;Miramos en que estado estamos
	;Acabamos de empezar?
	PAGESELW	POR_;
	MOVF	MAQUINA_EST,W;
	XORLW	POR;
	BTFSC	STATUS,Z;
		CALL	POR_;
	;Estamos en reposo?
	PAGESELW	STANDBY_;
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	STANDBY;
	BTFSC	STATUS,Z;
		CALL	STANDBY_;
	;Estamos en el "escritorio"
	PAGESELW	UNLOCK_;
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	UNLOCK;
	BTFSC	STATUS,Z;
		CALL	UNLOCK_;
	;Estamos marcando un número?
	PAGESELW	MARCA_
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	MARCA;
	BTFSC	STATUS,Z;
		CALL	MARCA_;
	;Estamos en el menú principal?
	PAGESELW	MENU12_1_;
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	MENU12_1;
	BTFSC	STATUS,Z;
		CALL	MENU12_1_;
	;Estamos dentro del menú de mensajes, en el indice 1?
	PAGESELW	MENSAJES_1_;
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	MENSAJES_1;
	BTFSC	STATUS,Z;
		CALL	MENSAJES_1_;
	;Estamos dentro del menú de mensajes, en el indice 2?
	PAGESELW	MENSAJES_2_;
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	MENSAJES_2;
	BTFSC	STATUS,Z;
		CALL	MENSAJES_2_;
	;Estamos en el menu para leer sms?
	PAGESELW	LEER_SMS_;
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	LEER_SMS;
	BTFSC	STATUS,Z;
		CALL	LEER_SMS_;
	;Estamos escribiendo un sms?
	PAGESELW	ESCRIBIR_SMS_;
	CLRF	STATUS;
	MOVF	MAQUINA_EST,W;
	XORLW	ESCRIBIR_SMS;
	BTFSC	STATUS,Z;
		CALL	ESCRIBIR_SMS_;
	
	GOTO	BUCLEOCIOSO;	
	
	INCLUDE "LCD.INC"
;***** Para inicializar todo lo relacionado con el puerto del teclado ****;
PADINIT:
	BANKSEL PORTPAD;Banco0
	MOVLW	B'00000000';
	MOVWF	PORTPAD;Ponemos a 0 todos los puertos para notar el cambio.
	BANKSEL	ANSELH;Banco4
	CLRF	ANSELH&7F;modo digital
	BANKSEL	WPUB; Por si acaso...
	MOVLW	H'F0'
	MOVWF	WPUB&7F;
	BANKSEL	TRISPAD;Banco1
	MOVLW	B'11110000';Configuramos como 4 entradas y 4 salidas
	MOVWF	TRISPAD&7F;
	BCF	OPTION_REG&7F,NOT_RBPU;Activamos las resistencias de pull up
	BANKSEL	IOCB;Banco1
	MOVLW	H'FF';Para habilitar las interrupciones en cada pin
	MOVWF	IOCB&7F;Lo inicializo a 1 los que cambian, para notar esos cambios
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
	CLRF	ANSEL&7F;
	BANKSEL	TRISA;me coloco para modificar el trisa
	BCF	P_LED,B_LED;Digo que va a ser de output
	BANKSEL	P_LED;me coloco en el porta
	BSF	P_LED,B_LED;Apago el led
	RETURN;
	
;****** SERIAL_INIT para inicializar la comunicación serial ******;
SERIAL_INIT:
	
	RETURN;
	
;******** EJECUCIONES EN CADA ESTADO ********;
POR_:
	RETURN;
STANDBY_:
	RETURN
UNLOCK_:
	RETURN;
MENU12_1_:
	RETURN;
MARCA_:
	RETURN;
MENSAJES_1_:
	RETURN;
MENSAJES_2_:
	RETURN;
ESCRIBIR_SMS_:
	RETURN;
LEER_SMS_:
	RETURN;
	

;******** TABLAS *********;
;**** traduccion de num de caracter a bits de comparación ****;
	ORG	POSACOMPD;
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