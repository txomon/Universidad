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
	BSF	SER_CTL,IS_SND;
	MOVLW	'A';
	MOVWF	TXREG;
	MOVLW	'T';
	MOVWF	TXREG;
	BANKSEL	PIE1;
	BSF	PIE1&7F,TXIE;
	BANKSEL STATUS;
	RETURN;

;****** SERIAL_SEND *******;
;;
; manda el caracter que se le pasa como argumento
; @param W - El caracter a enviar
;;
SERIAL_SEND:
	MOVWF	TXREG;
	RETURN;
	
;****** SERIAL_RECEIVE ******;
;;
; recibe un caracter y llama a una función para que lo guarde
; @return W - caracter recibido
;;
SERIAL_RECEIVE:
	MOVF	RCREG,W;
	RETURN;

;****** SEND_NEXT *********;
; input = SER_CTL <= phase ( at, option, data)
;         OPT_CTL <= which option in tables
; no output	

SEND_NEXT:
	BTFSS	PIR1,TXIF; Si no nos ha llamado esta, tenemos que salir de aquí y continuar
		GOTO	SEND_NEXT_RETI; porque sino, se hace un bucle.
	BTFSC	SER_CTL,IS_CMD;
		GOTO	SEND_CMD;
	BTFSC	SER_CTL,IS_DAT;
		GOTO	SEND_DAT;
	BTFSC	SER_CTL,IS_EEP;
		GOTO	SEND_EEP;
	CLRF	RCV_CONT
	CLRF	SND_CONT
	BCF	SER_CTL,IS_SND;
	BANKSEL	PIE1; BANCO 1
	BCF	PIE1&7F,TXIE;
	GOTO	RETI;Por haber acabado la transmision
	
	;**** SEND_CMD ****;
	SEND_CMD:
		PAGESELW MODEM_TABLE; Vamos a conseguir el siguiente caracter a enviar, cambiamos de página (esta en la 1)
		MOVF	SND_CONT,W; Ponemos el número de caracter en W
		CALL	MODEM_TABLE&7FF; Conseguimos el caracter
		ANDLW	H'FF'; Hay que hacer esto para que mire si W es 0
		BTFSC	STATUS,Z; El comando ha acabado de enviarse si W=0
			BCF	SER_CTL,IS_CMD; Si ya hemos de acabado de enviarlo, deshabilitamos mandar comandos
		INCF	SND_CONT,F;Aumentamos el contador para la siguiente
		PAGESEL SEND_NEXT; Volvemos a la página 0
		BTFSC	SER_CTL,IS_CMD; Si seguimos enviando comandos,
			CALL	SERIAL_SEND; mandar el caracter
		BTFSS	SER_CTL,IS_CMD; Si hemos acabado de enviar comandos
			CLRF	SND_CONT; limpiar el contador para el siguiente proceso
		GOTO	RETI; Volver a la RETI
		
	SEND_DAT:
		MOVF	SND_CONT,W; Cojemos el contador y lo ponemos en W
		ADDLW	SERIAL_SEND_DATA&H'FF'; Le añadimos la dirección a partir de la que tenemos los datos para enviar
		BSF	STATUS,IRP; preparamos el IRP de direccionamiento indirecto para leer en los bancos 2:3
		MOVWF	FSR; ponemos la dirección indirecta bits <7:0> en el FSR
		MOVF	INDF,W; Guardamos lo que ponga en la dirección indirecta en W
		BTFSC	STATUS,Z; Si el caracter conseguido es 0
			BCF	SER_CTL,IS_DAT; hemos acabado de enviar datos de la RAM
		INCF	SND_CONT,F; Aumentamos el contador de datos
		BTFSC	SER_CTL,IS_DAT; Si seguimos enviando datos de la ram
			CALL	SERIAL_SEND; mandamos el caracter que acabamos de conseguir
		BTFSS	SER_CTL,IS_DAT; Si hemos acabado
			CLRF	SND_CONT; reseteamos el contador
		GOTO	RETI; y volvemos a la RETI
		
	SEND_EEP:
		BSF	EE_CTL,ORI_EXT;	
		MOVF	SND_CONT,W; Copiamos el valor del contador a W
		CALL	EEPROM_READ; Conseguimos de la EEPROM el valor de esa posición
		ANDLW	H'FF';
		BTFSC	STATUS,Z; Si es cero
			BCF	SER_CTL,IS_EEP; hemos acabado de enviar datos de la EEPROM
		BTFSC	SER_CTL,IS_EEP; Si seguimos mandando datos de la eeprom, entonces 
			CALL	SERIAL_SEND; mandamos el caracter
		INCF	SND_CONT,F; Aumentamos el contador
		BTFSS	SER_CTL,IS_EEP; Si hemos acabado
			CLRF	SND_CONT; reseteamos el contador para la siguiente fase
		GOTO RETI; y volvemos a la RETI
		
;******** RECEIVE_NEXT **********;
RECEIVE_NEXT:
	MOVF	RCV_CONT,W;
	ADDLW	SERIAL_RECEIVE_DATA&H'FF';La posicion esta especificada como 11F en serial.inc
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