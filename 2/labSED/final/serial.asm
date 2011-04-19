;****** SERIAL.ASM ******;
; Funciones para la comunicación por serie


;****** SERIAL_INIT para inicializar la comunicación serial ******;
SERIAL_INIT:
	BANKSEL BAUDCTL;BANCO 3
	CLRF	BAUDCTL&7F;
	
	BANKSEL	TXSTA;BANCO1
	MOVLW	D'25'; He estado leyendo, y para escrituras en la eeprom, 9600 da justo
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
; no input, no output
; manda el siguiente caracter en la lista
SERIAL_SEND:
	BANKSEL	TXREG;BANCO1
	BTFSS	TXREG,TRMT;compruebo si se ha enviado
		GOTO	RETI;
	PAGESEL	READUP;
	CALL	READUP;
	BANKSEL TX_MAX;
	XORWF	TX_MAX,W;
	BANKSEL PIE1;
	BTFSS	STATUS,Z;
		BCF	PIE1,TXIE;
	BTFSS	STATUS,Z;
		BCF	SERIAL_CTL,ISSENDING;
	PAGESEL RETI;
	GOTO	RETI;
	
;****** SERIAL_RECEIVE ******;
; no input,no output
; recibe un caracter y llama a una función para que lo guarde
SERIAL_RECEIVE:
	BANKSEL RCSTA;
	BTFSS	RCSTA,FERR;Buscamos problemas en la transmision
		CALL DESHECHAR;
	PAGESEL	WRITEDOWN;
	MOVF	RCREG,W;
	CALL	WRITEDOWN;
	GOTO	RETI;
	
;****** DESHECHAR **********;
; no input no output
; quita un caracter erróneo
DESHECHAR:
	MOVF	RCREG,W;
	RETURN;

;****** SERIAL_SEND_ENQUEUE ********;
; input = caracter a encolar
; output = error (1)

SERIAL_SEND_ENQUEUE:
	PAGESEL	WRITEUP;
	CALL	WRITEUP;
	BANKSEL	SERIAL_CTL;
	BSF	SERIAL_CTL,ISSENDING;
	RETURN;

;****** SERIAL_RECEIVE_GET ******;
; input = nothing
; output = char

SERIAL_RECEIVE_GET:
	PAGESEL	READDOWN;
	CALL	READDOWN;
	RETURN;
