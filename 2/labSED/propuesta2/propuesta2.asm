	LIST	P=16F887; Para el compilador
	INCLUDE	"P16F887.INC"; Para las EQU del micro
;*****************************************************************************************************************************************
;***************************************** LAS EQUIVALENCIAS Y LAS VARIABLES *************************************************************
;*****************************************************************************************************************************************
;******** DIRECCIONES DE LAS TABLAS ********;
POSACOMPD	EQU	H'800';


;******** VARIABLES PARA GUARDAR AL ENTRAR EN LA RSI *********;
SAVEW	EQU	H'20'
SAVEST	EQU	H'21'
SAVEFSR	EQU	H'22'
SAVEPCL	EQU	H'23'

;******** VARIABLES PARA EL TECLADO ********;

KEYHL	EQU	H'30'; KEY HARD LOW
KEYHH	EQU	H'31'; Para tener guardadas cuales son las teclas presionadas comprobadas
KEYCTRL	EQU	H'32'; Control del timer
KEYSL	EQU	H'33'; KEY SOFT LOW
KEYSH	EQU	H'34'; Para tener guardadas cuales son las teclas presionadas a comprobar
;******** BITS DENTRO DEL KEYCTRL ********;
KCONT_E	EQU	0; 



;******** EQUIVALENCIAS DE PUERTOS ****;
PORTPAD	EQU	PORTB
TRISPAD	EQU	TRISB



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
	CLRF	STATUS;
	BTFSC	PIR1,TMR2IF; Miro si el timer ha sido llamado
		GOTO	TMR2INTER;
	BTFSC	INTCON,RBIF;
		GOTO	PADINTER;
	;AQUI ACABA LA TABLA DE RSI

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
	BTFSS	KEYSL,H'0';
		GOTO	KEYSL1;
	PAGESELW	POSACOMP;
	MOVWF	H'0';
	CALL	POSACOMP;
	
	KEYSL1:
	BTFSS	KEYSL,H'1';
		GOTO	KEYSL2;
	PAGESELW	POSACOMP
	MOVWF	H'1';
	CALL	POSACOMP;
	
	KEYSL2:
	BTFSS	KEYSL,H'2';
		GOTO	KEYSL3;
	PAGESELW	POSACOMP;
	MOVWF	H'2';
	CALL	POSACOMP;
	
	KEYSL3:
	BTFSS	KEYSL,H'3';
		GOTO	KEYSL4;
	PAGESELW	POSACOMP;
	MOVLW	H'3';
	CALL	POSACOMP;
	
	KEYSL4:
	BTFSS	KEYSL,H'4';
		GOTO	KEYSL5;
	PAGESELW	POSACOMP;
	MOVLW	H'4';
	CALL	POSACOMP;
	
	KEYSL5:
	BTFSS	KEYSL,H'5';
		GOTO	KEYSL6;	
	PAGESELW	POSACOMP;
	MOVLW	H'5';
	CALL	POSACOMP;
	
	KEYSL6:
	BTFSS	KEYSL,H'6';
		GOTO	KEYSL7;
	PAGESELW	POSACOMP;
	MOVLW	H'6'
	CALL	POSACOMP;
	
	KEYSL7:
	BTFSS	KEYSL,H'7';
		GOTO	KEYSH0;
	PAGESELW	POSACOMP;
	MOVLW	H'7';
	CALL	POSACOMP;
	
	KEYSH0:
	BTFSS	KEYSH,H'0';
		GOTO	KEYSH1;
	PAGESELW	POSACOMP;
	MOVLW	H'8'
	CALL	POSACOMP;
	
	KEYSH1:
	BTFSS	KEYSH,H'1';
		GOTO	KEYSH2;
	PAGESELW	POSACOMP;
	MOVLW	H'9'
	CALL	POSACOMP;
	
	KEYSH2:
	BTFSS	KEYSH,H'2';
		GOTO	KEYSH3;
	PAGESELW	POSACOMP;
	MOVLW	H'A'
	CALL	POSACOMP;
	
	KEYSH3:
	BTFSS	KEYSH,H'3';
		GOTO	KEYSH4;
	PAGESELW	POSACOMP;
	MOVLW	H'B'
	CALL	POSACOMP;
	
	KEYSH4:
	BTFSS	KEYSH,H'4';
		GOTO	KEYSH5;
	PAGESELW	POSACOMP;
	MOVLW	H'C'
	CALL	POSACOMP;
	
	KEYSH5:
	BTFSS	KEYSH,H'5';
		GOTO	KEYSH6;
	PAGESELW	POSACOMP;
	MOVLW	H'D'
	CALL	POSACOMP;
	
	KEYSH6:
	BTFSS	KEYSH,H'6';
		GOTO	KEYSH7;
	PAGESELW	POSACOMP;
	MOVLW	H'E'	
	CALL	POSACOMP;
	
	KEYSH7:
	BTFSS	KEYSH,H'7';
		GOTO	TMR2INTERFIN;
	PAGESELW	POSACOMP;
	MOVLW	H'F'
	CALL	POSACOMP;
	
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
	BSF	INTCON,RBIE;Habilito las interrupciones para todo
	RETURN;


;******	TABLA DE TRADUCCIONES DE "CARACTER" A BITS DE MATRIZ*******;
	ORG POSACOMPD;
POSACOMP:
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

	END;