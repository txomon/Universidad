;****** SERIAL.ASM ******;
; Funciones para la comunicación por serie


;****** SERIAL_INIT para inicializar la comunicación serial ******;
SERIAL_INIT:
	BANKSEL	TXSTA;
	MOVLW	B'00100100'
	MOVWF	TXSTA&7f;
	MOVLW	D'95'
	MOVWF	SPBRG&7F;
	CLRF	SPBRGH&7F;
	
	RETURN;