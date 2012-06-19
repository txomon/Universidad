;******** RSI para el PAD ********;

;**** Timer2 Interrupt RSI ****;
TMR2INTER:
	CLRF	BIT_CONT;
	; Comprobamos por columnas
	CALL	COMPCOLUM;comparamos las columnas
	BCF	PIR1,TMR2IF; Quitamos la interrupción del temporizador
	BCF	T2CON,TMR2ON; Deshabilitamos el temporizador
	BANKSEL	PIE1; BANCO 1
	BCF	PIE1&7F,TMR2IE; Quitamos el aviso de interrupción
	BANKSEL	TMR2IF; BANCO 0
	CLRF	PORTPAD; Ponemos el puerto del teclado a 0 para leer futuros cambios
	BCF	INTCON,RBIF; Limpiamos el bit de interrupción del teclado
	BSF	INTCON,RBIE; Habilitamos las interrupciones en el puerto del teclado
	GOTO	RETI; Volvemos a la RETI
		
;**** COMPCOLUM Comprueba las filas recurrentemente ****;
COMPCOLUM:
	PAGESELW	POSACOMP; La siguiente llamada va a ser a otra página
	MOVF	BIT_CONT,W; Muevo el contador a W
	ANDLW	H'0F'; Corto el contado a la parte interesante (la cuenta)
	CALL	POSACOMP&7FF;Conseguimos la comparación de la tecla para el contador dado
	PAGESEL	COMPPAD; Volvemos a la página 0
	CALL	COMPPAD;Comparamos si está pulsada
	MOVWF	PAD_TMP2;El resultado lo guardamos
	MOVF	BIT_CONT,W;Cargamos el num de bit en W
	MOVWF	KEYRCTL; Empezamos a configurar el registro de control de escrituras en los registros hard
	BTFSS	PAD_TMP2,0;Si el resultado es 0
		BSF	KEYRCTL,KRS_C;Añadimos que haga un clear, el set viene implicito en el 0
	CALL	KEYPADREGW; Llamamos a que escriba el registro
	
	INCF	BIT_CONT,F; Incrementamos el contador de todas todas
	MOVF	BIT_CONT,W;
	ANDLW	H'0F'; Si es 16, dará 00010000 y por lo tanto, 0
	BTFSS	STATUS,Z; Si es 1, entonces 
		GOTO	COMPCOLUM; volvemos a repetir el anterior bucle
	RETURN; En el caso en el que la parte baja sea 0000 volvemos
	


;**** KEYPADREGW (escritor del registro del pad) ****;
KEYPADREGW:
	MOVLW	KEYHL; Pongo la posición del 1er registro
	BTFSC	KEYRCTL,KRL_U; registro Up?
		ADDLW	H'1'; sumo uno al FSR (para que apunte a la parte alta)
	MOVWF	FSR; Escribo el FSR
	PAGESELW	NUMAKEYR;
	MOVF	KEYRCTL,W; Elijo cual quiero
	ANDLW	H'7'; Cortamos el numero a 3 bits
	CALL	NUMAKEYR&7FF; Nos dice el bit del registro que tiene que ser
	MOVWF	PAD_TMP; Guardo en temp
	PAGESEL	KEYPADSET; Volvemos a la página de ahora
	BTFSS	KEYRCTL,KRS_C; Si queremos poner a uno ese bit en el registro
		GOTO	KEYPADSET; vamos a KEYPADSET
	COMF	PAD_TMP,W; Complemento el valor de comparación 00001000 => 11110111
	ANDWF	INDF,F; y al hacer una and, se borre ese bit seguro
	RETURN;
KEYPADSET:	
	MOVF	PAD_TMP,W;
	IORWF	INDF,F;Escribo 1 en el registro	
	RETURN;

;**** COMPPAD (Comprobador de si una tecla está activada) ****;
COMPPAD:
	MOVWF	PAD_TMP;tenemos la comparación a realizar EJ:01111110
	MOVWF	PORTPAD;cargamos la comparación en el puerto EJ; 01011110
	COMF	PAD_TMP,F;Invertimos la comparación EJ:10000001
	COMF	PORTPAD,W;Invertimos la lectura EJ: 10100001;
	ANDWF	PAD_TMP,W;Comparamos EJ: 10000001 & 10100001 = 10000001
	ANDLW	PAD_ENT;Cortamos los 4 de arriba EJ: 10000000
	BTFSS	STATUS,Z;
		RETLW	H'01';Devolvemos true
	RETLW	H'00';Devolvemos false
	
;**** INICIATMP2(Programa el timer para que salte a lo máximo posible) ****;
INICIATMP2:;Hacemos que el temp2 tenga un ciclo de interrupción de 0'04 secs
	BANKSEL	PR2;BANCO1
	BSF	PIE1&7F,TMR2IE;Habilitamos las interrupciones
	MOVLW	H'FF';
	MOVWF	PR2&7F; Que salte en FF
	BANKSEL	T2CON;BANCO 0
	BCF	PIR1,TMR2IF;Borramos la interrupción
	MOVWF	T2CON;ponemos preescalador y postescalador a tope y encendemos el reloj
	CLRF	TMR2; borramos la cuenta en curso para que empiece ahora
	BCF	PIR1,TMR2IF; Quitamos interrupción del reloj, por si ha habido una anterior
	BCF     INTCON,RBIE; Deshabilitamos las interrupciones de teclado
      	BCF     INTCON,RBIF; Limpiamos la interrupción de teclado que nos ha traido aquí
	RETURN;
	
	
	;***** Para inicializar todo lo relacionado con el puerto del pad ****;
PADINIT:
	CLRF	PORTPAD;Ponemos a 0 todos los puertos para notar el cambio.
	BANKSEL	ANSELH; BANCO 3
	CLRF	ANSELH&7F;modo digital
	BANKSEL	WPUB; BANCO 1
	MOVLW	PAD_ENT
	MOVWF	WPUB&7F;
	BANKSEL	TRISPAD; BANCO 3
	MOVWF	TRISPAD&7F;Configuramos como 4 entradas y 4 salidas aprovechando el h'F0' de antes
	BCF	OPTION_REG&7F,NOT_RBPU;Activamos las resistencias de pull up
	BANKSEL	IOCB; BANCO 1
	MOVLW	H'FF';Para habilitar las interrupciones en cada pin
	MOVWF	IOCB&7F;Lo inicializo a 1 los que cambian, para notar esos cambios
	BANKSEL	INTCON;BANCO 0
	CLRF	KEYHL;Inicializo a 0 los registros de control de teclas
	CLRF	KEYHU;
	BSF	INTCON,RBIE;Habilito las interrupciones para todo el puerto B
	BSF	INTCON,PEIE;Habilito las interrupciones de dispositivos
	RETURN;