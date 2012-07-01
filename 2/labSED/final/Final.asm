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
C_LED	EQU	1;
D_LED	EQU	2;
P_LED	EQU	PORTA;Puerto



; Includes despues de las propias del programa	
	ORG H'800'
	
	INCLUDE "lcd.inc"
	INCLUDE	"pad.inc"
	INCLUDE "eeprom.inc"
	INCLUDE "estados.inc"
	INCLUDE	"serial.inc";Tiene que ir al final por la reserva de memoria RAM
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
	BCF	P_LED,C_LED; 
	CLRF	PCLATH;
	BTFSC	PIR1,RCIF;
		GOTO	RECEIVE_NEXT;
	BTFSC	SER_CTL,IS_SND; En vez de mirar si está vacio el txreg, tenemos que mirar si ha podido ser él el que ha
		GOTO	SEND_NEXT; causado la interrupción.
	SEND_NEXT_RETI:
	BTFSC	PIR1,TMR2IF; el timer2 está para leer cuales son las teclas que hay pulsadas tras el rebote 
		GOTO	TMR2INTER;
	BTFSC	INTCON,RBIF; esto está para programar la lectura después
		CALL	INICIATMP2; 
	BANKSEL	P_LED;
	MOVF	KEYHL,W;
	IORWF	KEYHU,W;
	BTFSS	STATUS,Z;se enciende el led si está el registro Hard activado y si no, se apaga
		BCF	P_LED,B_LED;
	BTFSC	STATUS,Z;
		BSF	P_LED,B_LED;
	
	BTFSS	PIR2,EEIF;
		BSF	PORTA,D_LED;
	BTFSC	PIR2,EEIF;
		BCF	PORTA,D_LED;

	BSF	P_LED,C_LED;

	;AQUI ACABA LA RSI
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
	include	"serial.asm"
	include "eeprom.asm"
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
	PAGESEL SERIAL_INIT;
	CALL	SERIAL_INIT;
	PAGESEL	EEPROM_INIT;
	CLRF	MAQUINA_EST;
	CLRF	EST_CTL
	CLRF	LCD_CTL
	CLRF	LCD_CONT
	BSF	INTCON,GIE; 
BUCLEOCIOSO:

	include "maquina_de_estados.asm"
	PAGESEL BUCLEOCIOSO;
	GOTO	BUCLEOCIOSO;	
	

;****** LEDINIT para inicializar el led ******;
LEDINIT:
	BANKSEL	ANSEL;
	CLRF	ANSEL&7F;
	BANKSEL	TRISA;me coloco para modificar el trisa
	BCF	P_LED,B_LED;Digo que va a ser de output
	BCF	P_LED,C_LED;
	BCF	P_LED,D_LED;
	BANKSEL	P_LED;me coloco en el porta
	BSF	P_LED,B_LED;Apago el led
	BSF	P_LED,C_LED;
	BSF	P_LED,D_LED;
	RETURN;
	

	
	INCLUDE "estados.asm"	
	INCLUDE	"lcd.asm"
	END;	 