;****** SERIAL.ASM ******;
; Funciones para la comunicación por serie


;****** SERIAL_INIT para inicializar la comunicación serial ******;
SERIAL_INIT:
	BANKSEL BAUDCTL;
	MOVLW	B'00001000'; 16bit timer
	MOVWF	BAUDCTL&7F;
	BANKSEL	TXSTA;
	MOVLW	B'00100100';Habilitado, asincrono y alta velocidad
	MOVWF	TXSTA&7f;
	MOVLW	D'95'
	MOVWF	SPBRG&7F;
	CLRF	SPBRGH&7F;
	BANKSEL	RCSTA
	MOVLW	B'10010000';Habilitado, Habilitado receptor
	MOVWF	RCSTA
	RETURN;
	
;****** SERIAL_SEND *******;
SERIAL_SEND:
	