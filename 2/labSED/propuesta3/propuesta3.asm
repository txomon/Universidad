;**** Javier Domingo (2do Ing. Tecn. Teleco. Espec. en Telemática) para labSED****;
	LIST	P=16F887; Para el compilador
	INCLUDE	"P16F887.INC"; Para las EQU del micro
	errorlevel -207;quito los warnings de labels
	
TMP1	EQU	H'20'
TMP2	EQU	H'21'
CONTADOR	EQU	H'30'
	
	ORG	H'003'
	GOTO	PROG;

PROG:
	CALL	LCDINIT;
	CLRF	CONTADOR;
LAZODEHOLAMUNDO:
	MOVF	CONTADOR,W;
	CALL	HOLAMUNDO;
	ANDLW	H'FF';
	BTFSC	STATUS,Z;
		GOTO	BUCLE;
	CALL	LCDDWR;
	MOVLW	H'1';
	ADDWF	CONTADOR,F;
	MOVF	CONTADOR,W;
	GOTO	LAZODEHOLAMUNDO;
BUCLE
	GOTO BUCLE;
	INCLUDE	<LCD.INC>
	
HOLAMUNDO:
	ADDWF	PCL,F;
	DT	"Hola Mundo!",0;
	
	END;