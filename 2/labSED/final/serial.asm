;****** SERIAL.ASM ******;
; Funciones para la comunicación por serie


;****** SERIAL_INIT para inicializar la comunicación serial ******;
SERIAL_INIT:
	BANKSEL BAUDCTL;BANCO* 3
	MOVLW	B'00001000';Usemos el contador de 16 bits
	MOVWF	BAUDCTL&7F;
	
	BANKSEL	TXSTA;BANCO1
	MOVLW	D'8'; He estado leyendo, y para escrituras en la eeprom, 9600 da justo, pero solo se puede hablar con el modem a 115k
	MOVWF	SPBRG&7F; 8 para 115200
	CLRF	SPBRGH&7F; 103 para 9600

	MOVLW	B'00100100';Habilitado, asincrono y alta velocidad
	MOVWF	TXSTA&7f;
	
	BSF	PIE1&7F,RCIE;Habilito las interrupciones de recepcion
	BCF	PIE1&7F,TXIE; y las de transmisión no
	
	BANKSEL	RCSTA
	MOVLW	B'10010000';Habilitado, Habilitado receptor
	MOVWF	RCSTA
	
	CLRF	SER_CTL;
	CLRF	SND_CONT;
	CLRF	RCV_CONT;
	RETURN;

;****** SEND_AT ******;
; send AT and start trasmission
SEND_AT:
	BANKSEL	SER_CTL;
	BSF	SER_CTL,IS_SND;
	BANKSEL	TXREG;
	MOVLW	'A';
	MOVWF	TXREG;
	MOVLW	'T';
	MOVWF	TXREG;
	BANKSEL	PIE1
	BSF	PIE1&7F,TXIE;
	RETURN;
;****** SERIAL_SEND *******;
;;
; manda el caracter que se le pasa como argumento
; @param W - El caracter a enviar
;;
SERIAL_SEND:
	BANKSEL	TXREG;BANCO1
	MOVWF	TXREG;
	RETURN;
	
;****** SERIAL_RECEIVE ******;
;;
; recibe un caracter y llama a una función para que lo guarde
; @return W - caracter recibido
;;
SERIAL_RECEIVE:
	BANKSEL RCREG;
	MOVF	RCREG,W;
	RETURN;

;****** SEND_NEXT *********;
; input = SER_CTL <= phase ( at, option, data)
;         OPT_CTL <= which option in tables
; no output	

SEND_NEXT:
	BANKSEL	PIE1
	BTFSS	PIE1&7F,TXIF;
		GOTO	RETI;
	BTFSS	TXSTA&7F,TRMT;
		GOTO	RETI;
	BANKSEL	SER_CTL;
	BTFSC	SER_CTL,IS_CMD;
		GOTO	SEND_CMD;
	BTFSC	SER_CTL,IS_DAT;
		GOTO	SEND_DAT;
	BTFSC	SER_CTL,IS_EEP;
		GOTO	SEND_EEP;
	CLRF	RCV_CONT
	CLRF	SND_CONT
	BANKSEL	PIE1;
	BCF	PIE1&7F,TXIE;
	GOTO	RETI;Por haber acabado la transmision
	SEND_NEXT_END:
	CALL	SERIAL_SEND;
	PAGESEL	RETI;
	GOTO	RETI;
	
	;**** SEND_CMD ****;
	SEND_CMD:
		PAGESELW MODEM_TABLE;
		MOVF	SND_CONT,W;
		CALL	MODEM_TABLE&7FF;
		INCF	SND_CONT,F;
		ANDLW	H'FF';
		BTFSC	STATUS,Z;
			BCF	SER_CTL,IS_CMD;
		PAGESEL SERIAL_SEND;
		BTFSC	STATUS,Z;
			GOTO	SEND_NEXT;
		GOTO	SEND_NEXT_END;
		
		
	SEND_DAT:
		MOVF	SND_CONT,W;
		ADDLW	H'10';
		BSF	STATUS,IRP;
		MOVWF	FSR;
		MOVF	INDF,W;
		INCF	SND_CONT,F;
		ANDLW	H'FF';
		BTFSC	STATUS,Z;
			CALL	SEND_DAT_END;
		GOTO	SEND_NEXT_END;
		
		;**** SEND_DAT_END ****;
		SEND_DAT_END:
			BANKSEL	SER_CTL;
			BCF	SER_CTL,IS_DAT;
			CLRF	SND_CONT;
			MOVLW	D'10'
		
	SEND_EEP:
		BANKSEL	SND_CONT;
		MOVF	SND_CONT,W;
		BANKSEL EEADR;
		MOVWF	EEADR&7F;
		PAGESEL EEPROM_READ;
		CALL	EEPROM_READ;
		INCF	SND_CONT,F;
		ANDLW	H'FF';
		PAGESEL SEND_EEP_END
		BTFSC	STATUS,Z;
			CALL	SEND_EEP_END;
		GOTO	SEND_NEXT_END;
		
		;**** SEND_EEP_END ****;
		; prepares EEP end
		SEND_EEP_END:
			BANKSEL	SND_CONT
			CLRF	SND_CONT;
			BCF	SER_CTL,IS_EEP;
			MOVLW	H'1A';
			RETURN;
		
		
;******** RECEIVE_NEXT **********;
RECEIVE_NEXT:
	MOVF	RCV_CONT,W;
	ADDLW	H'1F';La posicion esta especificada como 11F en serial.inc
	MOVWF	FSR;
	BSF	STATUS,IRP;
	CALL	SERIAL_RECEIVE
	MOVWF	INDF;
	MOVLW	H'0D';
	XORWF	INDF,W;
	BTFSC	STATUS,Z;
		BSF	SER_CTL,IS_RCV
	INCF	RCV_CONT,F;
	GOTO	RETI;