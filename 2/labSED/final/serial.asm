;****** SERIAL.ASM ******;
; Funciones para la comunicación por serie


;****** SERIAL_INIT para inicializar la comunicación serial ******;
SERIAL_INIT:
	BANKSEL BAUDCTL;BANCO 3
	MOVLW	B'00001000';Usemos el contador de 16 bits
	MOVWF	BAUDCTL;
	
	BANKSEL	TXSTA;BANCO1
	MOVLW	D'8'; He estado leyendo, y para escrituras en la eeprom, 9600 da justo, pero solo se puede hablar con el modem a 115k
	MOVWF	SPBRG&7F;
	CLRF	SPBRGH&7F;

	MOVLW	B'00100100';Habilitado, asincrono y alta velocidad
	MOVWF	TXSTA&7f;
	
	BSF	PIE1,RCIE;Habilito las interrupciones de recepcion
	BCF	PIE1,TXIE; y las de transmisión no
	
	BANKSEL	RCSTA
	MOVLW	B'10010000';Habilitado, Habilitado receptor
	MOVWF	RCSTA
	RETURN;


;****** SERIAL_SEND *******;
; input <- W = char
; no output
; manda el siguiente caracter en la lista
SERIAL_SEND:
	BANKSEL	TXREG;BANCO1
	MOVWF	TXREG;
	RETURN;
	
;****** SERIAL_RECEIVE ******;
; no input
; output = received char
; recibe un caracter y llama a una función para que lo guarde
SERIAL_RECEIVE:
	BANKSEL RCREG;
	MOVF	RCREG,W;
	RETURN;

;****** SEND_NEXT *********;
; input = SER_CTL <= phase ( at, option, data)
;         OPT_CTL <= which option in tables
; no output	

SEND_NEXT:
	BANKSEL	SER_CTL;
	BTFSC	SER_CTL,IS_AT;
		GOTO	SEND_T;
	BTFSC	SER_CTL,IS_MAS;
		GOTO	SEND_MAS;
	BTFSC	SER_CTL,IS_CMD;
		GOTO	SEND_CMD;
	BTFSC	SER_CTL,IS_DAT;
		GOTO	SEND_DAT;
	SEND_NEXT_END:
	CALL	SERIAL_SEND;
	PAGESEL	RETI;
	GOTO	RETI;
	
	;****  SEND_T  ****;
	SEND_T:
		BCF	SER_CTL,IS_AT;
		MOVLW	'T';
		GOTO	SEND_NEXT_END;
	
	;****  SEND_MAS  ****;
	SEND_MAS:
		BCF	SER_CTL,IS_MAS;
		BTFSS	SND_CONT,0;
			MOVLW	'+';
		BTFSC	SND_CONT,0;
			MOVLW	'C';
		GOTO	SEND_NEXT_END;
	
	;**** SEND_CMD ****;
	SEND_CMD:
		PAGESELW MODEM_TABLE;
		MOVWF	SND_CONT;
		CALL	MODEM_TABLE;
		ANDLW	H'FF';
		BTFSC	STATUS,Z;
			BCF	SER_CTL,IS_CMD;
		PAGESEL SERIAL_SEND;
		GOTO	SERIAL_NEXT_END;
	
	SEND_DAT:
		BTFSS	DAT_CTL,EEP_MEM;
			GOTO	SEND_DAT_EEP;
		BTFSC	DAT_CTL,EEP_MEM;
			GOTO	SEND_DAT_MEM;
		GOTO 	SERIAL_NEXT_END;
		
	SEND_DAT_EEP:
		MOVF	SND_CONT,W;
		BANKSEL EEADDR;
		MOVWF	EEADDR;
		PAGESEL EEPROM_READ_00;
		
		
		
		
		