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
	BANKSEL	SERIAL_CTL;
	CLRF	SERIAL_CTL
	RETURN;


;****** SERIAL_SEND *******;
; no input, no output
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
	