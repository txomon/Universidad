;******** RSI para el PAD ********;

;**** Timer2 Interrupt RSI ****;
TMR2INTER:
	MOVLW	H'80';
	MOVWF	BIT_CONT;
	MOVF	KEYSL,W;
	XORWF	KEYHL,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
	
	MOVLW	H'84';
	MOVWF	BIT_CONT;
	MOVF	KEYSL,W;
	XORWF	KEYHL,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
		
	MOVLW	H'88';
	MOVWF	BIT_CONT;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
		
	MOVLW	H'8C';
	MOVWF	BIT_CONT;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	BTFSS	STATUS,Z;
		CALL	COMPCOLUM;
	
	BCF	PIR1,TMR2IF;Quitamos la interrupción
	BCF	T2CON,TMR2ON;Deshabilitamos el temporizador
	BANKSEL	PIE1;banco1
	BCF	PIE1&7F,TMR2IE;Quitamos el aviso de interrupción
	BANKSEL	TMR2IF;banco0
	CLRF	PORTPAD;
	BCF	INTCON,RBIF;
	BSF	INTCON,RBIE;
	GOTO	RETI;

;******	Comprobar el keypad ******;
PADINTER:
	CLRF	BIT_CONT;
	; Comprobamos por columnas
	CLRF	PORTPAD;
	BTFSS	PORTPAD,7;miramos si la columna 1 se ha activado
		CALL	COMPCOLUM;comparamos la columna 1 (de 0 a 3)
	MOVLW	H'4';
	MOVWF	BIT_CONT
	
	CLRF	PORTPAD;
	BTFSS	PORTPAD,6;columna 2
		CALL	COMPCOLUM;columna2 (de 4 a 7)
	MOVLW	H'8';
	MOVWF	BIT_CONT;

	CLRF	PORTPAD;	
	BTFSS	PORTPAD,5;columna 3
		CALL	COMPCOLUM;columna3 (de 8 a 11)
	MOVLW	H'C';
	MOVWF	BIT_CONT

	CLRF	PORTPAD;	
	BTFSS	PORTPAD,4;columna 4
		CALL	COMPCOLUM;columna4 (de 12 a 15)
	
	MOVF	KEYSL,W; Comprobamos si hemos escrito algo en total,
	XORWF	KEYHL,W; para saber si hay diferencias entre el H y el S
	MOVWF	PAD_TMP;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	IORWF	PAD_TMP,W;
	BTFSS	STATUS,Z;Si hay algo en el Soft, programar temporizacion
		CALL	INICIATMP2;
	BANKSEL	PORTPAD;
	CLRF	PORTPAD;
	MOVF	KEYSL,W;
	XORWF	KEYHL,W;
	MOVWF	PAD_TMP;
	MOVF	KEYSU,W;
	XORWF	KEYHU,W;
	IORWF	PAD_TMP,W;
	BTFSS	STATUS,Z;Si hay algo, deshabilitar interrupciones
		BCF	INTCON,RBIE;
	BCF	INTCON,RBIF
	GOTO	RETI;
		
;**** COMPCOLUM Comprueba las filas recurrentemente ****;
COMPCOLUM:
	PAGESELW	POSACOMP
	MOVF	BIT_CONT,W;
	ANDLW	H'0F';
	CALL	POSACOMP&7FF;Conseguimos la comparación para la tecla
	PAGESEL	COMPPAD;
	CALL	COMPPAD;Comparamos si está pulsada
	MOVWF	PAD_TMP2;El resultado lo guardamos
	CLRF	KEYRCTL;
	MOVF	BIT_CONT,W;Cargamos el num de bit en W
	IORLW	B'00010000';Añadimos que escriba en el soft
	BTFSS	PAD_TMP2,0;Si el resultado es 0
		IORLW	B'00100000';Añadimos que haga un clear
	BTFSC	BIT_CONT,P_S_H;
		IORLW	B'00100000';Si el resultado es de S a H
	MOVWF	KEYRCTL;
	CALL	KEYPADREGW;
	
	BTFSC	BIT_CONT,P_S_H;		
		GOTO	CALLFROMTMP2;
	GOTO	CALLFROMCOMPPAD;
	CALLFROMTMP2:
		MOVF	BIT_CONT,W;
		BTFSS	PAD_TMP2,0;
			IORLW	B'00100000';
		MOVWF	KEYRCTL;
		CALL	KEYPADREGW;	
	CALLFROMCOMPPAD:
		CLRF	PORTPAD;
		INCF	BIT_CONT,F;
		MOVF	BIT_CONT,W;
		ANDLW	H'03';Compruebo si hemos llegado al XX00(cambio de columna)
		BTFSC	STATUS,Z;
			RETURN;
	GOTO	COMPCOLUM;
	


;**** KEYPADREGW (escritor del registro del pad) ****;
KEYPADREGW:
	MOVLW	KEYHL; Pongo la posición del 1er registro
	BTFSC	KEYRCTL,KRH_S;registro Soft?
		ADDLW	H'2';sumo dos al FSR (para que apunte al Soft)
	BTFSC	KEYRCTL,KRL_U;registro Up?
		ADDLW	H'1';sumo uno al FSR (para que apunte a la parte alta)
	MOVWF	FSR;Escribo el FSR
	PAGESELW	NUMAKEYR;
	MOVF	KEYRCTL,W;Elijo cual quiero
	ANDLW	H'7';Cortamos el numero a 3 bits
	CALL	NUMAKEYR&7FF;Nos dice el bit del registro que tiene que ser
	CLRF	PCLATH;Esta no la puedo hacer a con el pageselw
	MOVWF	PAD_TMP;Guardo en temp
	MOVF	INDF,W;Comparo el valor del registro
	ANDWF	PAD_TMP,W;con el valor de la comparación
	BTFSS	STATUS,Z;si esta en 1, salto
		GOTO	EN1;esta en 1
	MOVF	PAD_TMP,W;esta en 0
	BTFSS	KEYRCTL,KRS_C;
		IORWF	INDF,F;Escribo uno en el registro
	RETURN;
EN1:	
	MOVF	PAD_TMP,W;
	BTFSC	KEYRCTL,KRS_C;Si dice que hay que borrarlo
		XORWF	INDF,F;Escribo 0 en el registro	
	RETURN;

;**** COMPPAD (Comprobador de si una tecla está activada) ****;
COMPPAD:
	MOVWF	PAD_TMP;tenemos la comparación a realizar EJ:01111110
	MOVWF	PORTPAD;cargamos la comparación en el puerto EJ; 01011110
	COMF	PAD_TMP,F;Invertimos la comparación EJ:10000001
	COMF	PORTPAD,W;Invertimos la lectura EJ: 10100001;
	ANDWF	PAD_TMP,W;Comparamos EJ: 10000001 & 10100001 = 10000001
	ANDLW	H'F0';Cortamos los 4 de arriba EJ: 10000000
	BTFSS	STATUS,Z;
		RETLW	H'01';Devolvemos true
	RETLW	H'00';Devolvemos false
	
;**** INICIATMP2(Programa el timer para que salte a lo máximo posible) ****;
INICIATMP2:;Vaciamos los pre/post escaladores
	BANKSEL	PR2;banco1
	BSF	PIE1&7F,TMR2IE;Habilitamos las interrupciones
	MOVLW	H'01'
	MOVWF	PR2&7F;
	BANKSEL	T2CON
	BCF	PIR1,TMR2IF;Borramos la interrupción
	CLRF	T2CON;ponemos preescalador y postacalador 1:1
	BSF	T2CON,TMR2ON;encendemos el reloj
	CLRF	TMR2;borramos la cuenta en curso
T2ICL:	BTFSS	PIR1,TMR2IF;Cuando ponga la interrupción que salga
		GOTO	T2ICL;
	BCF	T2CON,TMR2ON;Apagamos el temporizador
	BCF	PIR1,TMR2IF;Quitamos la señal de interrupción
	BANKSEL	PR2
	MOVLW	H'FF';ponemos al maximo la comparación
	MOVWF	PR2&7F;
	BANKSEL	T2CON 
	MOVWF	T2CON;encendemos y ponemos al maximo los post/pre escaladores
	RETURN;
	
	
	;***** Para inicializar todo lo relacionado con el puerto del pad ****;
PADINIT:
	BANKSEL PORTPAD;Banco0
	MOVLW	B'00000000';
	MOVWF	PORTPAD;Ponemos a 0 todos los puertos para notar el cambio.
	BANKSEL	ANSELH;Banco4
	CLRF	ANSELH&7F;modo digital
	BANKSEL	WPUB; Por si acaso...
	MOVLW	H'F0'
	MOVWF	WPUB&7F;
	BANKSEL	TRISPAD;Banco1
	MOVLW	B'11110000';Configuramos como 4 entradas y 4 salidas
	MOVWF	TRISPAD&7F;
	BCF	OPTION_REG&7F,NOT_RBPU;Activamos las resistencias de pull up
	BANKSEL	IOCB;Banco1
	MOVLW	H'FF';Para habilitar las interrupciones en cada pin
	MOVWF	IOCB&7F;Lo inicializo a 1 los que cambian, para notar esos cambios
	BANKSEL	INTCON;Banco0
	CLRF	KEYSL;Inicializo a 0 los registros de control de teclas
	CLRF	KEYSU;
	CLRF	KEYHL;
	CLRF	KEYHU;
	BSF	INTCON,RBIE;Habilito las interrupciones para todo el puerto B
	BSF	INTCON,PEIE;Habilito las interrupciones de dispositivos
	RETURN;