;ejemplo3.asm: LED intermitente en A0 (por interrupción);
;************************************************************************************
	LIST P=16F887
	INCLUDE "P16F887.INC"
;************************************************************************************;
SAVEPCL EQU	20;
SAVEFSR	EQU	21;
SAVEST	EQU	22;
SAVEW	EQU	23;
;**********************************
;
P_LED	EQU	PORTA;
b_LED	EQU	0;	
;************************************************************************************
;
	ORG	003;
	GOTO	PROGPPAL;
;************************************************************************************
;
	ORG	004;
INTERR:;Se guarda todo lo necesario para despues seguir correctamente
	MOVWF	SAVEW;
	MOVF	STATUS,W;
	CLRF	STATUS;
	MOVWF	SAVEST;
	MOVF	FSR,W;
	MOVWF	SAVEFSR;
	MOVF	PCLATH,W;
	MOVWF	SAVEPCL;
	CLRF	PCLATH;
	
	BTFSS	INTCON,T0IF;Hacemos un salto si el timer0 ha saltado
	GOTO	RETINT;

	MOVLW	d'10';
	MOVWF	TMR0;ponemos el timer 0 en el numero 10
	BCF	INTCON,T0IF;quitamos el bit de aviso a la interrupción
	BTFSS	P_LED,b_LED;Un ejemplo de if/else en ensamblador
	GOTO	INT2;
	BCF	P_LED,b_LED;Ponemos a 0 el led
	GOTO	RETINT;
INT2:
	BSF 	P_LED,b_LED;Ponemos a 1 el led
RETINT:
	MOVF	SAVEPCL,W;
	MOVWF	PCLATH;
	MOVF	SAVEFSR,W;
	MOVWF	FSR;
	MOVF	SAVEST,W;
	MOVWF	STATUS;
	SWAPF	SAVEW,F;
	SWAPF	SAVEW,W;
	RETFIE;
;************************************************************************************
;
PROGPPAL:
	CALL 	INITPA;Inicializamos el puerto
	CALL	INITTMR0;Inicializamos el contador
	BSF	INTCON,GIE;Activamos las interrupciones

LAZOPPAL:
	GOTO	LAZOPPAL;hacemos un bucle (por hacer algo)
;************************************************************************************
;
INITPA:
	BSF	STATUS,RP0;nos colocamos en el banco 1
	BSF	STATUS,RP1;nos colocamos en el banco 3
	CLRF	ANSEL&7F;borramos el ansel y el anselh
	CLRF	ANSELH&7F;para decir que es digital
	BCF	STATUS,RP1;nos movemos al banco 1
	CLRF	P_LED;ponemos a 0 todos los pines del puerto del led
	BCF	STATUS,RP0;vamos al banco 0
	RETURN;
;************************************************************************************
;
INITTMR0:
	BSF	STATUS,RP0;vamos al banco 1
	MOVLW	B'00000110';
	MOVWF	OPTION_REG&7F;ponemos el prescalador a 1:16
	BCF	STATUS,RP0;Me cambio al banco 0 otra vez
	BSF	P_LED,b_LED;enciendo el led
	BSF	INTCON,T0IE;habilitamos las interrupciones del timer 0
	RETURN;
	END;