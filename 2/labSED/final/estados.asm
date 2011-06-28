;******** EJECUCIONES EN CADA ESTADO ********;
;************ POR_ *************;
;;
; Power On Reset, inicializa el modem para que no haga echo
; y para que los resultados los devuelva en modo numérico
; @param MAQUINA_EST - Inicializa la variable para marcar que está en ese estado
; @param EST_CTL - Guarda el progreso en la máquina de estados
;;
POR_:
	MOVLW	POR; El estado de power on reset
	BANKSEL	MAQUINA_EST; siempre al principio de todos los estados
	MOVWF	MAQUINA_EST; pondremos el estado llamado ahí
	BTFSS	EST_CTL,0; 
		GOTO	POR_CTL_PER_CONFIG;
	BTFSS	EST_CTL,1;
		GOTO	POR_CTL_PER_ANALIZE;
	BTFSS	EST_CTL,2;
		GOTO	STANDBY_;
	RETURN;
	
		;******** POR_CTL_PER_CONFIG *******;
		;;
		; Se encarga de inicializar el periférico para que no haga echo, y tenga
		; respuestas numéricas.
		;;
		POR_CTL_PER_CONFIG:
			CLRF	RCV_CONT;
			CLRF	SER_CTL;
			BSF	SER_CTL,IS_CMD;
			MOVLW	MODEM_CMD_NUM_NO_ECHO&H'FF';
			MOVWF	SND_CONT;
			CALL	SEND_AT;
			BANKSEL	EST_CTL;
			BSF	EST_CTL,0;
			MOVLW	H'3F';
			MOVWF	TMP2;
			POR_WAIT:
				NOP			; 
				DECFSZ	TMP2,F		; Se decrementa contador básico
				GOTO	POR_WAIT	; hasta llegar a cero

			RETURN;
			
		;******** POR_CTL_PER_ANALIZE ********;
		;;
		; Esta funcion se encarga de comprobar que el comando ha recibido
		; la respuesta adecuada, y de todos modos, pone el valor recibido
		; en la pantalla abajo a la izquierda
		; @param RCV_CONT - Contador de caracteres recibidos
		; @return EST_CTL - Control del avance del estado
		;;
		POR_CTL_PER_ANALIZE:
			MOVF	RCV_CONT,W;
			BTFSC	STATUS,Z;
				RETURN;	
			MOVLW	H'1F'; La posición en la que voy a poner lo que se recibe.
			MOVWF	FSR;
			BSF	STATUS,IRP;

			MOVLW	cur_set|h'4F'; Mover el cursor a la última posicion de la segunda fila
			CALL	LCDIWR;
			MOVF	INDF,W;
			CALL	LCDDWR;Escribo la letra en pantalla

			MOVF	INDF,W; Comprobamos si el caracter es <CR>
			XORLW	H'0D'; el caracter <CR> es lo que NO tiene que tener devuelto
			BTFSC	STATUS,Z; Entrar si el caracter es <CR>
				BCF	EST_CTL,0;Si la posición no tenia el caracter 0, entonces ha ejecutado mal la instrucción

			MOVF	INDF,W; Comprobamos si el caracter es 0
			XORLW	'0';
			BTFSS	STATUS,Z;
				BSF	EST_CTL,1; Pasamos al anterior estado, ya que este no ha recibido todavia la respuesta esperada.
			RETURN
		
		
		
;************ STANDBY_ *************;
;;
; Estado de STANDBY, donde el procesador estará atento para
; que lo desbloqueen.
; @param KEYHU - Registro Hard de la parte de arriba del teclado
; @param KEYHL - Registro Hard de la parte de abajo del teclado
; @param EST_CTL - Registro de avance dentro del estado
;;
STANDBY_:
	BANKSEL	KEYHL;
	MOVF	MAQUINA_EST; Comprobamos si estamos aquí por primera vez
	XORLW	STANDBY;
	BTFSS	STATUS,Z; Si estamos por primera vez
		CLRF	EST_CTL;
	MOVLW	STANDBY;
	MOVWF	MAQUINA_EST;Decimos que estamos en STANDBY
	CALL	PUT_STANDBY;
	CALL	STANDBY_COMP_DESBLQ;
	BTFSS	EST_CTL,4;
		GOTO	UNLOCK_;
	SLEEP;
	RETURN
	;******	PUT_STANDBY ******;
	;;
	; Pone STANDBY en la pantalla, cambiando también el estado de la variable
	; @param LCD_CTL - Variable para controlar lo que tiene la pantalla en ese momento
	; @return LCD_CTL - Devuelve el estado que hay despues, lo cambia ahí mismo
	;;
	PUT_STANDBY:
		BANKSEL	LCD_CTL;
		MOVF	LCD_CTL,W;
		XORLW	LTR_STANDBY_;
		BTFSC	STATUS,Z;
			RETURN;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set|h'5'; Mover el cursor a la posicion 6
		CALL	LCDIWR;
		CLRF	LCD_CONT;
		PUT_STANDBY_LOOP:
			PAGESELW	LTR_STANDBY;
			MOVF	LCD_CONT,W;Ponemos el indice de la tabla
			CALL	LTR_STANDBY&7FF;
			ANDLW	H'FF';
			PAGESEL	PUT_STANDBY_LOOP_END;
			BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_STANDBY_LOOP_END;si hemos llegado, SALIMOS
			CALL	LCDDWR;Escribo la letra en pantalla
			INCF	LCD_CONT,F;Incremento el contador
			GOTO	PUT_STANDBY_LOOP;vuelvo a contar
		PUT_STANDBY_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_STANDBY_;Cambiamos lo que hay en pantalla a "STANDBY"
		MOVWF	LCD_CTL;
		RETURN;
	;****** STANDBY_COMP_DESBLQ ******;
	;;
	; Avance del desbloqueo pulsando *, *#, #, y soltando.
	; @param EST_CTL - El estado en el que va de desbloqueo
	;;
	STANDBY_COMP_DESBLQ:
		BANKSEL KEYHU;miramos que no haya  nada en las dos filas de arriba pulsado
		MOVF	KEYHU,W;
		BTFSS	STATUS,Z;
			CLRF	EST_CTL; Si lo hay, se vuelve a 0 (secuencia inválida)
		
		MOVF	KEYHL,W;miramos que abajo haya como mucho la * y la # pulsadas
		ANDLW	B'11111010';
		BTFSS	STATUS,Z;
			CLRF	EST_CTL; Si hay algo aparte, se vuelve a 0 el estado
			
		BTFSS	EST_CTL,0;Si hay un 0 en la posicion 0 se entra (lo mismo que para todas)
			GOTO	STANDBY_COMP_DESBLQ_EST0;
		BTFSS	EST_CTL,1;
			GOTO	STANDBY_COMP_DESBLQ_EST1;
		BTFSS	EST_CTL,2;
			GOTO	STANDBY_COMP_DESBLQ_EST2;
		BTFSS	EST_CTL,3;
			GOTO	STANDBY_COMP_DESBLQ_EST3;

		;**********************************************************************;
		; Estas rutinas están pensadas teniendo como logico que avanzar es lo normal
		;
		;***** STANDBY_COMP_DESBLQ_EST0 *****;llegamos desde la nada, en teoria no hay nada pulsado
		;;
		; Estado 0, donde solo queremos que este pulsada la *
		; @param KEYHL - miramos a la * y la #
		; @return EST_CTL - indica en el estado que estamos dentro de STANDBY
		;;
		STANDBY_COMP_DESBLQ_EST0:
			BTFSC	KEYHL,0; Si la * esta pulsada, pasamos a siguiente fase 
				BSF	EST_CTL,0; 
			BTFSS	KEYHL,0; Si no, nos quedamos en esta
				BCF	EST_CTL,0;
			BTFSC	KEYHL,2; Si la # esta pulsada, nos quedamos en esta seguro
				BCF	EST_CTL,0;
			BCF	EST_CTL,1;Nos aseguramos de entrar en la siguiente fase si podemos
			RETURN;
		;***** STANDBY_COMP_DESBLQ_EST1 *****;llegamos por que se ha pulsado la * 
		;;
		; Estado 1, donde queremos que este pulsada la *, y que se pulse la #
		; @param KEYHL - miramos a la * y la #
		; @return EST_CTL - indica en el estado que estamos dentro de STANDBY
		;;
		STANDBY_COMP_DESBLQ_EST1:
			BTFSS	KEYHL,0; Si no esta pulsada la *, tenemos que ir hacia atras
				BCF	EST_CTL,0;
			BTFSC	KEYHL,2; Si la # esta pulsada, podemos avanzar
				BSF	EST_CTL,1;
			BTFSS	KEYHL,2; Si no, nos quedamos aqui
				BCF	EST_CTL,1;
			BCF	EST_CTL,2;Nos aseguramos de entrar en la siguiente fase
			RETURN;
		;***** STANDBY_COMP_DESBLQ_EST2 *****;llegamos por que se ha pulsado la * y la #
		;;
		; Estado 2, donde queremos que este pulsada la * y la #, y que se avance soltando la *.
		; @param KEYHL - miramos a la * y la #
		; @return EST_CTL - indica en el estado que estamos dentro de STANDBY
		;;
		STANDBY_COMP_DESBLQ_EST2:
			BTFSC	KEYHL,0;Si la * esta pulsada aqui nos quedamos
				BCF	EST_CTL,2;
			BTFSS	KEYHL,0;Si no, iremos hacia delante
				BSF	EST_CTL,2; 
			BTFSS	KEYHL,2;Si la # no esta pulsada vamos hacia atras
				BCF	EST_CTL,1;
			BCF	EST_CTL,3;
			RETURN
		;***** STANDBY_COMP_DESBLQ_EST3 *****;llegamos por que se ha pulsado la #
		;;
		; Estado 3, donde queremos que este pulsada la #, y cuando se suelte... salimos!
		; @param KEYHL - miramos a la * y la #
		; @return EST_CTL - indica en el estado que estamos dentro de STANDBY
		;;
		STANDBY_COMP_DESBLQ_EST3:
			BTFSC	KEYHL,0;Si la * esta pulsada
				BCF	EST_CTL,2;
			BTFSS	KEYHL,2;Si la # esta pulsada
				BCF	EST_CTL,3;
			BTFSC	KEYHL,2;Si no, se acaba con la ultima fase.
				BSF	EST_CTL,3;
			BCF	EST_CTL,4;
			RETURN;

;*********** UNLOCK_ ***********;
;;
; El estado en el que el teléfono se encuentra desbloqueado a la espera de
; que se entre en el menú
; @param MAQUINAL_EST - Contiene información del estado en el 
; que se encuentra la máquina de estados generales
; @return MAQUINA_EST - Devuelve el estado en el que está 
;;
				
UNLOCK_:
	BANKSEL	MAQUINA_EST;
	MOVF	MAQUINA_EST;
	XORLW	UNLOCK;
	BTFSS	STATUS,Z;
		CLRF	EST_CTL;
	MOVLW	UNLOCK;
	MOVWF	MAQUINA_EST;
	CALL	PUT_COMPANY;
	CALL	GOIN;
	BTFSC	EST_CTL,1;
		GOTO	MENU12_1_;
	RETURN;
	;************* PUT_COMPANY **************;
	;;
	; Pone en la pantalla el nombre de la compañía telefónica
	; @param LCD_CTL - Control del LCD
	; @return LCD_CTL - Cambia el lcd
	;;
	PUT_COMPANY:
		BANKSEL	LCD_CTL;
		MOVF	LCD_CTL,W;
		XORLW	LTR_COMPANY_;
		BTFSC	STATUS,Z;
			RETURN;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set|h'5'; Mover el cursor a la posicion 6
		CALL	LCDIWR;
		CLRF	LCD_CONT;
		PUT_COMPANY_LOOP:
			PAGESELW	LTR_COMPANY;
			MOVF	LCD_CONT,W;Ponemos el indice de la tabla
			CALL	LTR_COMPANY&7FF;
			ANDLW	H'FF';
			PAGESEL	PUT_COMPANY_LOOP_END;
			BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_COMPANY_LOOP_END;si hemos llegado, SALIMOS
			CALL	LCDDWR;Escribo la letra en pantalla
			INCF	LCD_CONT,F;Incremento el contador
			GOTO	PUT_COMPANY_LOOP;vuelvo a contar
		PUT_COMPANY_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_COMPANY_;Cambiamos lo que hay en pantalla a "COMPANY"
		MOVWF	LCD_CTL;
		RETURN;
	;********** GOIN ***********;
	;;
	; Es una funcion que tiene 1 estado en el que marca si se puede pasar al siguiente estado
	; se activa con el verde.
	; @param KEYHU - Ahí es donde se activa el verde.
	; @return EST_CTL - Ahí se señala si se puede pasar al siguiente estado, en el bit 1
	;;
	GOIN:	
		BTFSS	EST_CTL,0;Si hay un 0 en la posicion 0 se entra (lo mismo que para todas)
			GOTO	UNLOCK_COMP_GOIN_EST0;
		BTFSS	EST_CTL,1;
			GOTO	UNLOCK_COMP_GOIN_EST1;
			
		;******************************************************************************;
		;**** Rutinas para el paso del menú exterior al menú interior *****************;
		;******************************************************************************;
		;
		;**** UNLOCK_COMP_GOIN_EST0 ****;
		UNLOCK_COMP_GOIN_EST0:
			MOVF	KEYHL,W;
			IORWF	KEYHU,W;
			BTFSC	STATUS,Z; Comprobamos que no haya nada pulsado, y si es así, avanzamos
				BSF	EST_CTL,0;
			BCF	EST_CTL,1;
			RETURN;
	
		;**** UNLOCK_COMP_GOIN_EST1 ****;
		UNLOCK_COMP_GOIN_EST1:
			MOVF	KEYHL,F;
			BTFSC	STATUS,Z;
				BCF	EST_CTL,0; Comprobamos que no haya nada pulsado en las dos filas de abajo
			MOVF	KEYHU,W;
			ANDLW	B'11111110';
			BTFSC	STATUS,Z; Comprobamos que no haya nada pulsado en las dos de arriba, a excepción del verde
				BCF	EST_CTL,0;
			BTFSC	KEYHU,7; Si esta pulsado el verde, avanzamos
				BSF	EST_CTL,1;
			RETURN;
MENU12_1_:
	BANKSEL	MAQUINA_EST;
	MOVF	MAQUINA_EST;
	XORLW	MENU12_1_;
	BTFSS	STATUS,Z;
		CLRF	EST_CTL;
	MOVLW	MENU12_1;
	MOVWF	MAQUINA_EST;
	CALL	PUT_MENU12_1;
	CALL	GOIN;
	BTFSS	EST_CTL,1;
		GOTO	ESCRIBIR_SMS_;
	RETURN;
	;************* PUT_COMPANY **************;
	PUT_MENU12_1:
		BANKSEL	LCD_CTL;
		MOVF	LCD_CTL,W;
		XORLW	LTR_MENU12_1_;
		BTFSC	STATUS,Z;
			RETURN;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set; Mover el cursor a la posicion 0
		CALL	LCDIWR;
		CLRF	LCD_CONT;
		PUT_MENU12_1_LOOP:
			PAGESELW	LTR_MENU12_1;
			MOVF	LCD_CONT,W;Ponemos el indice de la tabla
			CALL	LTR_MENU12_1&7FF;
			MOVWF	EST_CTL;
			ANDLW	H'FF';
			PAGESEL	PUT_MENU12_1_LOOP_END;
			BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_MENU12_1_LOOP_END;si hemos llegado, SALIMOS
			DECFSZ	EST_CTL,F;Si es 0 saltara
				GOTO	PUT_MENU12_1_LOOP_SALTO;
			CALL	GONEXTLINE;
			INCF	LCD_CONT,F;
			GOTO	PUT_MENU12_1_LOOP;
			PUT_MENU12_1_LOOP_SALTO:
			CALL	LCDDWR;Escribo la letra en pantalla
			INCF	LCD_CONT,F;Incremento el contador
			GOTO	PUT_MENU12_1_LOOP;vuelvo a contar
		PUT_MENU12_1_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_MENU12_1_;Cambiamos lo que hay en pantalla a que es el menu 12_1
		MOVWF	LCD_CTL;
		RETURN;
		
		GONEXTLINE:
			MOVLW	cur_set|h'40';
			CALL	LCDIWR;
			RETURN;

;************* ESCRIBIR_SMS_ ******************;
;;
; Estado encargado de escribir (interpretar) las pulsaciones en el teclado
; @param KEYHL - números de 7-9, flecha de abajo, rojo, 0 * y #
; @param KEYHU - números de 1-3, 4-6, verde y flecha de arriba
;;
ESCRIBIR_SMS_:
	BANKSEL	MAQUINA_EST;
	MOVF	MAQUINA_EST;
	XORLW	ESCRIBIR_SMS;
	BTFSS	STATUS,Z;
		CLRF	EST_CTL;
	MOVLW	MENU12_1;
	MOVWF	ESCRIBIR_SMS;
	CALL	ESCRIBIR_SMS_PARSER;
	
	
	RETURN;
	
	;*********** ESCRIBIR_SMS_PARSER ***********;
	;;
	; Parser que se encarga de tener a punto un diagrama de estados 
	; en el que ir logueando las teclas que se tienen pulsadas, en esta
	; versión, será de numeros, pero estará preparado para funciones más complejas
	; @param KEYHU - 
	; @param KEYHL -
	;;
	ESCRIBIR_SMS_PARSER:
		PAGESELW	NUMAKEYR;
		MOVF	PARSER_LETTER,W;
		ANDLW	H'07';
		CALL	NUMAKEYR;
		
		BTFSS	PARSER_LETTER,3; Si la tecla que tenemos que comparar 
			ANDWF	KEYHL,W; está en el registro de abajo, cojemos este,
		BTFSC	PARSER_LETTER,3; si no, cojemos el de arriba 
			ANDWF	KEYHU,W;
		
		BTFSS	STATUS,Z;
			


		BTFSS	EST_CTL,0;Si hay un 0 en la posicion 0 se entra (lo mismo que para todas)
			GOTO	ESCRIBIR_SMS_EST0;
		BTFSS	EST_CTL,1;
			GOTO	ESCRIBIR_SMS_EST1;
		BTFSS	EST_CTL,2;
			GOTO	ESCRIBIR_SMS_EST2;
		BTFSS	EST_CTL,3;
			GOTO	ESCRIBIR_SMS_EST3;
			
			
			
			