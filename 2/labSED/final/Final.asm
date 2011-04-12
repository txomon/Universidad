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
;********
;******** VARIABLES EN LA RSI *********;

;**** variables para guardar los parametros de entrada ****;
	CBLOCK	H'20'
		SAVEW; workspace
		SAVEST; status
		SAVEFSR; fsr (indirect addressing)
		SAVEPCL; pclath
	ENDC
;**** varios ****;


;******** EL LED ********;
B_LED	EQU	0;Posicion en el puerto
P_LED	EQU	PORTA;Puerto


;******** CONTROL DEL PROGRAMA ********;
	CBLOCK
	MAQUINA_EST

		;** ESTADOS DE LA MÁQUINA **;
		POR
		STANDBY
		UNLOCK
		MENU12_1
		MARCA
		MENSAJES_1
		MENSAJES_2
		LEER_SMS
		ESCRIBIR_SMS
	ENDC
; Includes despues de las propias del programa	
	ORG H'800'
	
	INCLUDE "lcd.inc"
	INCLUDE	"pad.inc"

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

	include "pad.asm"
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
	
	INCLUDE	"lcd.asm"
	END;	 