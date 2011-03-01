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
INTERR:
	MOVWF	SAVEW;
	MOVF	STATUS,W;
	CLRF	STATUS;
	MOVWF	SAVEST;
	MOVF	FSR,W;
	MOVWF	SAVEFSR;
	MOVF	PCLATH,W;
	MOVWF	SAVEPCL;
	CLRF	PCLATH;
	BTFSS	INTCON,T0IF;
	GOTO	RETINT;

	MOVLW	-d'10';
	MOVWF	TMR0;
	BCF	INTCON,T0IF;
	BTFSS	P_LED,b_LED;
	GOTO	INT2;
	BCF	P_LED,b_LED;
	GOTO	RETINT;
INT2:
	BSF 	P_LED,b_LED;
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
	CALL 	INITPA;
	CALL	INITTMR0;
	BSF	INTCON,GIE;

LAZOPPAL:
	GOTO	LAZOPPAL;
;************************************************************************************
;
INITPA:
	BSF	STATUS,RP0;
	BSF	STATUS,RP1;
	CLRF	ANSEL&7F;
	CLRF	ANSELH&7F;
	BCF	STATUS,RP1;
	CLRF	P_LED;
	BCF	STATUS,RP0;
	RETURN;
;************************************************************************************
;
INITTMR0:
	BSF	STATUS,RP0;
	MOVLW	B'00000110';
	MOVWF	OPTION_REG&7F;
	BCF	STATUS,RP0;
	BSF	P_LED,b_LED;
	BSF	INTCON,T0IE;
	RETURN;
	END;