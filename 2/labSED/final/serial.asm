;****** SERIAL.ASM ******;
; Funciones para la comunicación por serie


;****** SERIAL_INIT para inicializar la comunicación serial ******;
SERIAL_INIT:
	BANKSEL BAUDCTL;BANCO 3
	MOVLW	B'00001000';Usemos el contador de 16 bits
	MOVWF	BAUDCTL&7F;
	
	BANKSEL	TXSTA;BANCO1
	MOVLW	D'8'; He estado leyendo, y para escrituras en la eeprom, 9600 da justo, pero solo se puede hablar con el modem a 115k
	MOVWF	SPBRG&7F;
	CLRF	SPBRGH&7F;

	MOVLW	B'00100100';Habilitado, asincrono y alta velocidad
	MOVWF	TXSTA&7f;
	
	BSF	PIE1&7F,RCIE;Habilito las interrupciones de recepcion
	BCF	PIE1&7F,TXIE; y las de transmisión no
	
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
	BTFSC	SER_CTL,IS_CMD;
		GOTO	SEND_CMD;
	BTFSC	SER_CTL,IS_DAT;
		GOTO	SEND_DAT;
	BTFSC	SER_CTL,IS_EEP;
		GOTO	SEND_EEP;
	SEND_NEXT_END:
	CALL	SERIAL_SEND;
	PAGESEL	RETI;
	GOTO	RETI;
	
	;****  SEND_T  ****;
	SEND_T:
		BCF	SER_CTL,IS_AT;
		MOVLW	'T';
		GOTO	SEND_NEXT_END;
	
	;**** SEND_CMD ****;
	SEND_CMD:
		PAGESELW MODEM_TABLE;
		MOVWF	SND_CONT;
		CALL	MODEM_TABLE&7FF;
		ANDLW	H'FF';
		BTFSC	STATUS,Z;
			BCF	SER_CTL,IS_CMD;
		PAGESEL SERIAL_SEND;
		GOTO	SEND_NEXT_END;
	
	SEND_DAT:
		MOVF	SND_CONT,W;
		ADDLW	H'10';
		BSF	STATUS,IRP;
		MOVWF	FSR;	
		MOVF	INDF,W;
		ANDLW	H'FF';
		BTFSC	STATUS,Z;
			CALL	SEND_DAT_END;
		GOTO	SEND_NEXT_END;
		
		;**** SEND_DAT_END ****;
		SEND_DAT_END:
			BANKSEL	SER_CTL;
			BCF	SER_CTL,IS_DAT;
			CLRF	SER_CONT;
			MOVLW	D'10'
		
	SEND_EEP:
		BANKSEL	SND_CONT;
		MOVF	SND_CONT,W;
		BANKSEL EEADR;
		MOVWF	EEADR&7F;
		PAGESEL EEPROM_READ;
		CALL	EEPROM_READ;
		ANDLW	H'FF';
		BTFSC	STATUS,Z;
			CALL	SEND_EEP_END;
		PAGESEL	SEND_NEXT_END;
		GOTO	SEND_NEXT_END;
		
		;**** SEND_EEP_END ****;
		; prepares EEP end
		SEND_EEP_END:
			BANKSEL	SND_CONT
			CLRF	SND_CONT;
			BCF	SER_CTL,IS_EEP;
			MOVLW	H'1A';
			RETURN;
		
		
		