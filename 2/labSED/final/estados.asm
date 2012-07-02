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
	BTFSC	KEYHU,7;Si está pulsada la tecla 
		BCF	EST_CTL,0;
	BTFSC	KEYHU,7;
		RETURN;
	BTFSC	KEYHL,3;
		CALL	ESCRIBIR_RECEPCION;
	BTFSS	EST_CTL,0;
		GOTO	POR_CTL_PER_CONFIG; Intenta configurarlo
	BTFSS	EST_CTL,1;
		GOTO	POR_CTL_PER_ANALIZE; Mira si lo ha conseguido
	BTFSS	EST_CTL,2;
		GOTO	STANDBY_; Salta a la siguiente etapa
	RETURN;
		ESCRIBIR_RECEPCION:
			MOVLW	cur_set|H'40';
			CALL	LCDIWR;
			MOVLW	SERIAL_RECEIVE_DATA&H'FF';
			MOVWF	FSR;
			BSF	STATUS,IRP;
			ESC_RECEPCION:
			MOVF	INDF,W;Cojemos el número
			BTFSC	STATUS,Z; Si es 0, hemos acabado
				RETURN;
			CALL	LCDDWR;
			INCF	FSR,W;
			XORLW	(SERIAL_RECEIVE_DATA+H'A')&H'FF';
			BTFSC	STATUS,Z;
				RETURN;
			INCF	FSR,F;
			GOTO	ESC_RECEPCION
	
		;******** POR_CTL_PER_CONFIG *******;
		;;
		; Se encarga de inicializar el periférico para que no haga echo, y tenga
		; respuestas numéricas.
		;;
		POR_CTL_PER_CONFIG:
			CLRF	SER_CTL;
			BSF	SER_CTL,IS_CMD; Marcamos que vamos a enviar un comando
			MOVLW	MODEM_CMD_NUM_NO_ECHO&H'FF'; Movemos el indice del comando al contador
			MOVWF	SND_CONT;
			CALL	SEND_AT; Mandamos AT, activamos interrupciones y ponemos IS_SND
			BANKSEL	STATUS; BANCO 0
			BSF	EST_CTL,0;

			MOVLW	lcd_clr; limpio la pantalla
			CALL	LCDIWR;
			MOVLW	cur_set|h'1'; Mover el cursor a la posicion 6
			CALL	LCDIWR;
			CLRF	LCD_CONT;
			PUT_POR_LOOP:
				PAGESELW	LTR_POR;
				MOVF	LCD_CONT,W;Ponemos el indice de la tabla
				CALL	LTR_POR&7FF;
				ANDLW	H'FF'; Necesario para que cambie Z
				PAGESEL	PUT_POR_LOOP_END;
				BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
					GOTO PUT_POR_LOOP_END;si hemos llegado, SALIMOS
				CALL	LCDDWR;Escribo la letra en pantalla
				INCF	LCD_CONT,F;Incremento el contador
				GOTO	PUT_POR_LOOP;vuelvo a contar
			PUT_POR_LOOP_END:;Hemos salido
			MOVLW	LTR_POR_;Cambiamos lo que hay en pantalla a "STANDBY"
			MOVWF	LCD_CTL;
			
			BCF	EST_CTL,1; Damos unas cuantas vueltas para dejar que se mande el comando
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
			BTFSS	SER_CTL,IS_RCV;
				RETURN;
			MOVLW	(SERIAL_RECEIVE_DATA - 1 )&H'FF'; La posición en la que está puesto lo que se recibe.
			BSF	STATUS,IRP;
			MOVWF	FSR;

			INCF	FSR,F;
			MOVF	INDF,W; Comprobamos si el ultimo caracter es 0
			BTFSS	STATUS,Z;
				GOTO	$-3;
			DECF	FSR,F;
			MOVF	INDF,W;
			XORLW	H'A';
			BTFSC	STATUS,Z;
				GOTO	POR_CTL_PER_ANA_CR;
			INCF	FSR,F;
			POR_CTL_PER_ANA_CR:
			DECF	FSR,F;
			MOVF	INDF,W;
			XORLW	H'D';
			BTFSC	STATUS,Z;
				GOTO	POR_CTL_PER_ANA_Z;
			POR_CTL_PER_ANA_Z:
			DECF	FSR,F;
			MOVF	INDF,W;
			XORLW	'0';
			BTFSC	STATUS,Z;
				BSF	EST_CTL,1; Si llegamo aqui es que pasamos al siguiente estado,
				; ya que este ha recibido la respuesta esperada.
			BTFSS	EST_CTL,1;
				GOTO	POR_CTL_PER_ANA_AGA; Si no ha recibido la respuesta esperada, volver a hacer
				;la peticion del comando
			BCF	EST_CTL,2;
			RETURN
			
			POR_CTL_PER_ANA_AGA:
			BTFSC	EST_CTL,7;
				GOTO	POR_CTL_PER_ANA_AGA_FIN;
			CLRF	PARSER_CTL;
			MOVLW	H'2F';
			CALL	LCDWAIT
			INCFSZ	PARSER_CTL,F;
				GOTO	$-3;
			BTFSS	SER_CTL,IS_RCV;
				BSF	EST_CTL,7;
			GOTO	POR_CTL_PER_ANALIZE;
			
			POR_CTL_PER_ANA_AGA_FIN:
			BCF	EST_CTL,0;
			BCF	EST_CTL,1;
			RETURN;


		
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
	MOVF	MAQUINA_EST,W; Comprobamos si estamos aquí por primera vez
	XORLW	STANDBY;
	BTFSS	STATUS,Z; Si estamos por primera vez
		CLRF	EST_CTL;

	MOVLW	STANDBY;
	MOVWF	MAQUINA_EST;Decimos que estamos en STANDBY
	CALL	PUT_STANDBY;
	GOTO	STANDBY_COMP_DESBLQ;

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

		MOVF	KEYHL,W;miramos que abajo haya como mucho la * y el # pulsadas
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
		BTFSS	EST_CTL,4;
			GOTO	UNLOCK_;

		;**********************************************************************;
		; Estas rutinas están pensadas teniendo como logico que avanzar es lo normal
		;
		
		;***** STANDBY_COMP_DESBLQ_EST0 *****;llegamos desde la nada, en teoria no hay nada pulsado
		;;
		; Estado 0, donde solo queremos que este pulsada la *
		; @param KEYHL - miramos a la * y el 8
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
			RETURN;

		;***** STANDBY_COMP_DESBLQ_EST3 *****;llegamos por que se ha pulsado la #
		;;
		; Estado 3, donde queremos que este pulsada la #, y cuando se suelte... salimos!
		; @param KEYHL - miramos a la * y la #
		; @return EST_CTL - indica en el estado que estamos dentro de STANDBY
		;;
		STANDBY_COMP_DESBLQ_EST3:
			BTFSC	KEYHL,0;Si la * esta pulsada
				BCF	EST_CTL,2;
			BTFSC	KEYHL,2;Si la # esta pulsada
				BCF	EST_CTL,3;
			BTFSS	KEYHL,2;Si no, se acaba con la ultima fase.
				BSF	EST_CTL,3;
			RETURN;

;*********** UNLOCK_ ***********;
;;
; El estado en el que el teléfono se encuentra desbloqueado a la espera de
; que se entre en el menú. 
; Se manda el número 2 por el puerto serie.
; @param MAQUINAL_EST - Contiene información del estado en
; el que se encuentra la máquina de estados generales
; @return MAQUINA_EST - Devuelve el estado en el que está 
;;
				
UNLOCK_:
	BANKSEL	MAQUINA_EST;
	MOVF	MAQUINA_EST,W;
	XORLW	UNLOCK;
	BTFSS	STATUS,Z;
		CLRF	EST_CTL;

	MOVLW	UNLOCK;
	MOVWF	MAQUINA_EST;
	CALL	PUT_COMPANY;
	CALL	GOIN;
	BTFSC	EST_CTL,2;
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
		MOVLW	cur_set|h'4'; Mover el cursor a la posicion 6
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
		;;
		; El paso del menu exterior al interior, en el primer nivel, se comprueba que no haya
		; nada pulsado, si lo hubiera, se estaría regresando a esta función.
		;;
		UNLOCK_COMP_GOIN_EST0:
			MOVF	KEYHL,W;
			IORWF	KEYHU,W;
			BTFSC	STATUS,Z; Comprobamos que no haya nada pulsado, y si es así, avanzamos
				BSF	EST_CTL,0;
			BCF	EST_CTL,1;
			RETURN;
	
		;**** UNLOCK_COMP_GOIN_EST1 ****;
		;;
		; El paso del menu exterior al interior, en el segundo y último nivel, se comprueba que 
		; el botón verde esté pulsado, cuando esté pulsado, se señaliza el estado en el bit 2, y
		; cuando se suelte, se pondrá a 1 el bit 1 también, desbloqueando el estado.
		;;
		UNLOCK_COMP_GOIN_EST1:
			MOVF	KEYHL,F;
			BTFSS	STATUS,Z;
				BCF	EST_CTL,0; Comprobamos que no haya nada pulsado en las dos filas de abajo
			MOVF	KEYHU,W;
			ANDLW	B'01111111';
			BTFSS	STATUS,Z; Comprobamos que no haya nada pulsado en las dos de arriba, a excepción del verde
				BCF	EST_CTL,0;
			BTFSC	KEYHU,7; Si esta pulsado el verde, avanzamos
				BSF	EST_CTL,2;
			BTFSS	EST_CTL,2;	
				BSF	EST_CTL,1;
			RETURN;
			
;*************** MENU12_1_ *****************;
;;
; En esta función se escribe el menú de opciones, y el paso a la siguiente función
; se trata a través de la misma función de comprobación que la anterior, pulsando 
; el botón verde.
; Se envía el dígito 3 por el puerto serie
;;

MENU12_1_:
	BANKSEL	MAQUINA_EST;
	MOVF	MAQUINA_EST,W;
	XORLW	MENU12_1;
	BTFSS	STATUS,Z;
		CLRF	EST_CTL;
			
	MOVLW	MENU12_1;
	MOVWF	MAQUINA_EST;
	CALL	PUT_MENU12_1;
	CALL	GOIN;
	BTFSC	EST_CTL,2;
		GOTO	ESCRIBIR_NUMERO_;
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
			PAGESELW	LTR_MENU12_1; Cambiamos de página
			MOVF	LCD_CONT,W;Ponemos el contador de la tabla en W
			CALL	LTR_MENU12_1&7FF; Conseguimos el siguiente caracter
			MOVWF	EST_CTL; lo guardamos en est_ctl
			ANDLW	H'FF';
			PAGESEL	PUT_MENU12_1_LOOP_END;
			BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_MENU12_1_LOOP_END;si hemos llegado, SALIMOS
			DECFSZ	EST_CTL,F;Si es 0 saltara
				GOTO	PUT_MENU12_1_LOOP_SALTO;	
			MOVLW	cur_set|H'40';
			CALL	LCDIWR;
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

;************* ESCRIBIR_SMS_ ******************;
;;
; Estado encargado de escribir (interpretar) las pulsaciones en el teclado
; @param KEYHL - números de 7-9, flecha de abajo, rojo, 0 * y #
; @param KEYHU - números de 1-3, 4-6, verde y flecha de arriba
;;
ESCRIBIR_NUMERO_:
	BANKSEL	MAQUINA_EST;
	MOVF	MAQUINA_EST,W;
	XORLW	ESCRIBIR_NUMERO;
	BTFSS	STATUS,Z;
		CALL	INIT_ESCRIBIR_NUMERO;

	GOTO	ESCRIBIR_NUMERO_PARSER;
	;********** INIT_ESCRIBIR_SMS ***********;
	;; 
	; se encarga de inicializar a 0 siempre que se entre en el estado
	;;
	INIT_ESCRIBIR_NUMERO:
		CLRF	PARSER_LTR;
		CLRF	EST_CTL;
		CLRF	PARSER_LTR_INFO;
		CLRF	LCD_LTR_CONT;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set; Mover el cursor a la posicion 0
		CALL	LCDIWR;
		CLRF	LCD_CONT;
		PUT_E_N_LOOP:
			PAGESELW	LTR_ESCRIBIR_NUMERO; Cambiamos de página
			MOVF	LCD_CONT,W;Ponemos el contador de la tabla en W
			CALL	LTR_ESCRIBIR_NUMERO&7FF; Conseguimos el siguiente caracter
			MOVWF	EST_CTL; lo guardamos en est_ctl
			ANDLW	H'FF';
			PAGESEL	PUT_E_N_LOOP_END;
			BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_E_N_LOOP_END;si hemos llegado, SALIMOS
			DECFSZ	EST_CTL,F;Si es 0 saltara
				GOTO	PUT_E_N_LOOP_SALTO;	
			MOVLW	cur_set|H'40';
			CALL	LCDIWR;
			INCF	LCD_CONT,F;
			GOTO	PUT_E_N_LOOP;
			PUT_E_N_LOOP_SALTO:
			CALL	LCDDWR;Escribo la letra en pantalla
			INCF	LCD_CONT,F;Incremento el contador
			GOTO	PUT_E_N_LOOP;vuelvo a contar
		PUT_E_N_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_ESCRIBIR_NUMERO_;Cambiamos lo que hay en pantalla a "COMPANY"
		MOVWF	LCD_CTL;
		MOVLW	ESCRIBIR_NUMERO;
		MOVWF	MAQUINA_EST
		RETURN;
	;*********** ESCRIBIR_SMS_PARSER ***********;
	;;
	; Parser que se encarga de tener a punto un diagrama de estados 
	; en el que ir logueando las teclas que se tienen pulsadas, en esta
	; versión, será de numeros, pero estará preparado para funciones más complejas
	; @param KEYHU - El registro de las teclas de arriba
	; @param KEYHL - El registro de las teclas de abajo
	;;
	ESCRIBIR_NUMERO_PARSER:
		BTFSS	EST_CTL,0;Si hay un 0 en la posicion 0 se entra (lo mismo que para todas)
			GOTO	ESC_NUM_EST0;
		BTFSS	EST_CTL,1;
			GOTO	ESC_NUM_EST1;
		BTFSS	EST_CTL,2;
			GOTO	ESC_NUM_EST2;
		; Aqui va cuando haya acabado de escribir

	
		;**** ESC_NUM_EST0 ****;
		;;
		; El paso del menu exterior al interior, en el primer nivel, se comprueba que no haya
		; nada pulsado, si lo hubiera, se estaría regresando a esta función.
		;;
		ESC_NUM_EST0:
			MOVF	KEYHL,W;
			IORWF	KEYHU,W;
			BTFSC	STATUS,Z; Comprobamos que no haya nada pulsado, y si es así, avanzamos
				BSF	EST_CTL,0;
			BCF	EST_CTL,1;
			RETURN;
	
		;**** ESC_NUM_EST1 ****;
		;;
		; El paso de que haya una tecla pulsada, si no la hay, volveremos más tarde. Cuando la haya, 1, entonces se consigue el caracter(numero)
		; indicado.
		;;
		ESC_NUM_EST1:
			MOVF	KEYHL,W; Juntamos el registro de arriba con
			IORWF	KEYHU,W; el de abajo
			BTFSC	STATUS,Z; y si no hay nada pulsado, 
				RETURN; volvemos
			CALL	PARSE_NUM;
			PAGESEL	ESC_NUM_EST1; Hay que hacer esto por que la llamada la hemos devuelto desde otra página
			MOVWF	PARSER_TEMP; Guardamos el caracter
			XORLW	"V";
			BTFSC	STATUS,Z; Si han pulsado el verde, pasamos al siguiente estado
				BSF	EST_CTL,1;
			BTFSS	STATUS,Z; Si han pulsado cualquier otra tecla, pasamos al 0
				BCF	EST_CTL,0;
			BTFSC	STATUS,Z;
				GOTO	ESC_NUM_EST1_END;
			;;;;;;;
			MOVF	PARSER_TEMP,W;
			CALL	LCDDWR;
			MOVLW	SERIAL_SEND_DATA&H'FF'; Movemos la dirección de la ram a W
			ADDWF	PARSER_LTR,W; Le sumamos el desplazamiento
			MOVWF	FSR; Muevo la dirección resultante a FSR
			BSF	STATUS,IRP; Ponemos que es la segunda página
			MOVF	PARSER_TEMP,W; Movemos a W el caracter
			MOVWF	INDF; y lo ponemos en la RAM
			INCF	PARSER_LTR,F; Incrementamos el contador de letra
			;;;;;;;
			ESC_NUM_EST1_END:
			BCF	EST_CTL,2; Preparamos la posible entrada a la siguiente
			RETURN;
		
		;**** ESC_NUM_EST2 ****;
		;;
		; Este paso es cuando ya hemos pulsado el botón verde.
		;;
		ESC_NUM_EST2:
			MOVLW	SERIAL_SEND_DATA&H'FF';
			ADDWF	PARSER_LTR,W;
			MOVWF	FSR;
			BSF	STATUS,IRP;
			MOVLW	A'"'; Ponemos una comilla
			MOVWF	INDF;
			INCF	FSR,F;
			MOVLW	H'0D'; Ponemos un intro
			MOVWF	INDF;
			;Y ya esta, hemos puesto lo que mandaríamos normalmente en un sms.
			; en la eeprom habría que poner ahora el sms en sí.
			;Ahora vamos a poner el 0 para acabar la secuencia de transmisión (el enviador serie)
			INCF	FSR,F;
			MOVLW	0; Ponemos el 0
			MOVWF	INDF;
			GOTO	ESCRIBIR_SMS_;

		;************ PARSE_NUM ************;
		;;
		; Este parser en específico, pasa de teclas a números. Nada más regresar, hacer cambio de página.
		;;

		PARSE_NUM:
			; CLRF	PARSER_CTL; a 0 las cosas. No se usa en parse_num.
			BCF	INTCON,GIE;
			CLRF	PARSER_CONT; que vamos a usar
			MOVF	KEYHL,W; miramos si el low
			BTFSC	STATUS,Z; es 0
				GOTO	PARSE_NUM_U_P; si es 0 vamos a comprobar el up directamente
			MOVWF	PARSER_TEMP; Se guarda el low en el temporal
			BCF	STATUS,C; Ya que los bits pasan por carry al hacer un shift, hay que ponerlo a 0
			
			PARSE_NUM_L: ; Parsear el registro low
			RRF	PARSER_TEMP,F; Rotamos
			BTFSC	STATUS,C; miramos si estaba a 1 el bit
				GOTO	PARSE_NUM_K; Ya tenemos la tecla en el contador que está pulsada
			INCF	PARSER_CONT,F; Incrementamos el contador para la siguiente vuelta
			BCF	STATUS,C;
			BTFSS	PARSER_CONT,3; Miramos si hemos llegado a 8
				GOTO	PARSE_NUM_L;
			
			PARSE_NUM_U_P: ;Aqui nos preparamos para el siguiente registro (up)
			MOVLW	H'8';
			MOVWF	PARSER_CONT;
			MOVF	KEYHU,W; Movemos el registro a 
			MOVWF	PARSER_TEMP; parser_temp
			BCF	STATUS,C; y limpiamos el bit de status por si acaso
			
			PARSE_NUM_U: ; Parsear el registro up
			RRF	PARSER_TEMP,F; Rotamos
			BTFSC	STATUS,C; miramos si estaba a 1 ese bit
				GOTO	PARSE_NUM_K; En PARSER_CONT tenemos la tecla en cuestión
			INCF	PARSER_CONT,F; Incrementamos el contador para la siguiente vuelta
			BCF	STATUS,C;
			BTFSS	PARSER_CONT,4; Miramos si hemos llegado a 16
				GOTO	PARSE_NUM_U; Para el siguiente salto
			;; Si llegamos aqui, es que ha habido un error... por que significa que no hay tecla pulsada,
			; y esto está preparado solo para que haya una. El hecho de que haya varias no repercute porque 
			; es muy improbable que haya dos pulsaciones simultáneas. Mandaremos el caracter ! para señalar
			; que ha habido un error
			BSF	INTCON,GIE;
			RETLW	"!";
;ERROR
			PARSE_NUM_K: ; En PARSER_CONT tenemos el número de tecla que está pulsado, ahora conseguimos el caracter
			BSF	INTCON,GIE;
			PAGESELW	NUMACHAR; La siguiente llamada va a ser a otra página
			MOVF	PARSER_CONT,W; ponemos en W el contador, para saber donde está. En teoría, no debería ser mayor de 15
			GOTO	NUMACHAR&7FF; Es una tabla que retorna la llamada conla que nos han llamado.

;**************** MANDAR_SMS_ *******************;
;;
; Esta 
;;
ESCRIBIR_SMS_:
	BANKSEL	MAQUINA_EST;
	MOVF	MAQUINA_EST,W;
	XORLW	ESCRIBIR_SMS;
	BTFSS	STATUS,Z;
		CALL	INIT_ESCRIBIR_SMS; Reutilizamos la rutina porque total vamos a utilizar las mismas variables
	GOTO	ESCRIBIR_SMS_PARSER;
	RETURN;
	
	INIT_ESCRIBIR_SMS:
		CLRF	STATUS;
		CLRF	PARSER_LTR;
		CLRF	PARSER_LTR_INFO;
		CLRF	EST_CTL;
		CLRF	READ00;
		CLRF	WRITE00;
		CLRF	LCD_LTR_CONT;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set; Mover el cursor a la posicion 0
		CALL	LCDIWR;
		MOVLW	ESCRIBIR_SMS;
		MOVWF	MAQUINA_EST
		RETURN;
	
	ESCRIBIR_SMS_PARSER:
		BTFSS	EST_CTL,0;Si hay un 0 en la posicion 0 se entra (lo mismo que para todas)
			GOTO	ESC_NUM_EST0;
		BTFSS	EST_CTL,1;
			GOTO	ESC_SMS_EST1;
		BTFSS	EST_CTL,2;
			GOTO	ESC_SMS_EST2;
		
		;**** ESC_NUM_EST1 ****;
		;;
		; El paso de que haya una tecla pulsada, si no la hay, volveremos más tarde. Cuando la haya, 1, entonces se consigue el caracter(numero)
		; indicado.
		;;
		ESC_SMS_EST1:
			MOVF	KEYHL,W ; Juntamos el registro de arriba con
			IORWF	KEYHU,W; el de abajo			
			BTFSC	STATUS,Z; y si no hay nada pulsado, 
				RETURN; volvemos
			CALL	PARSE_NUM; Conseguimos el caracter o lo que sea
			PAGESEL	ESC_NUM_EST1; Hay que hacer esto por que la llamada la hemos devuelto desde otra página
			MOVWF	PARSER_TEMP; Se mueve en el temp
			XORLW	"V";
			BTFSC	STATUS,Z; Si han pulsado el verde, pasamos al siguiente estado
				BSF	EST_CTL,1;
			BTFSS	STATUS,Z; Si han pulsado cualquier otra tecla, pasamos al 0
				BCF	EST_CTL,0;
			BTFSC	STATUS,Z;
				GOTO	ESC_SMS_EST1_END;

			;;;;;;; Aquí guardo el caracter en la eeprom.
			BCF	EE_CTL,ORI_EXT;
			MOVF	PARSER_TEMP,W;
			CALL	EEPROM_WRITE;
			CALL 	EEPROM_READ;
			MOVF	PARSER_TEMP,W;
			CALL	LCD_LTRW;
			;;;;;;;

			ESC_SMS_EST1_END:
			BCF	EST_CTL,2; Preparamos la posible entrada a la siguiente
			RETURN;

		;**** ESC_NUM_EST2 ****;
		;;
		; Este paso es cuando ya hemos pulsado el botón verde.
		;;
		ESC_SMS_EST2:
			BCF	EE_CTL,ORI_EXT;
			MOVLW	D'26'; Ponemos un escape
			CALL	EEPROM_WRITE;
			CALL	EEPROM_READ;
			MOVLW	H'FF'; Esperamos un cojon
			CALL	LCDWAIT;
			;Y ya esta, hemos puesto lo que mandaríamos normalmente en un sms.
			;Ahora vamos a poner el 0 para acabar la secuencia de transmisión (el enviador serie)
			MOVLW	0; Ponemos el 0
			CALL	EEPROM_WRITE;
			; Esto va a enviar SMS, que es el siguiente paso ;)


;;
; Esta función se encarga de enviar el sms, ya que todos los datos necesarios etc.
; Han sido puestos anteriormente en sus respectivos sitios
;;
ENVIAR_SMS_:
	BANKSEL	KEYHL;
	MOVF	MAQUINA_EST,W; Comprobamos si estamos aquí por primera vez
	XORLW	ENVIAR_SMS;
	BTFSS	STATUS,Z; Si estamos por primera vez
		CALL	INIT_ENVIAR_SMS;
	MOVLW	ENVIAR_SMS;
	MOVWF	MAQUINA_EST;Decimos que estamos en ENVIAR_SMS
	
	BTFSS	EST_CTL,0;
		GOTO	ENVIAR;
	BTFSS	EST_CTL,1;
		GOTO	POR_CTL_PER_ANALIZE;
	BTFSS	EST_CTL,2;
		GOTO	ENVIADO;
	RETURN; Por si acaso (además he hecho bién por que ya he tenido un fallo
	
	;****** INIT_ENVIAR_SMS *******;	
	INIT_ENVIAR_SMS:
		CLRF	EST_CTL;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set; Mover el cursor a la posicion 0
		CALL	LCDIWR;
		MOVLW	ENVIAR_SMS;
		MOVWF	MAQUINA_EST
		RETURN;
	
	;******	PUT_STANDBY ******;
	;;
	; Pone STANDBY en la pantalla, cambiando también el estado de la variable
	; @param LCD_CTL - Variable para controlar lo que tiene la pantalla en ese momento
	; @return LCD_CTL - Devuelve el estado que hay despues, lo cambia ahí mismo
	;;
	ENVIAR:
		BANKSEL	LCD_CTL;
		MOVF	LCD_CTL,W;
		XORLW	LTR_ENVIANDO_;
		BTFSC	STATUS,Z;
			GOTO	ENVIAR_DESPUES;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set|h'4'; Mover el cursor a la posicion 6
		CALL	LCDIWR;
		CLRF	LCD_CONT;
		PUT_ENVIAR_LOOP:
			PAGESELW	LTR_ENVIANDO;
			MOVF	LCD_CONT,W;Ponemos el indice de la tabla
			CALL	LTR_ENVIANDO&7FF;
			ANDLW	H'FF';
			PAGESEL	PUT_ENVIAR_LOOP_END;
			BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_ENVIAR_LOOP_END;si hemos llegado, SALIMOS
			CALL	LCDDWR;Escribo la letra en pantalla
			INCF	LCD_CONT,F;Incremento el contador
			GOTO	PUT_ENVIAR_LOOP;vuelvo a contar
		PUT_ENVIAR_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_ENVIANDO_;Cambiamos lo que hay en pantalla a "Enviando"
		MOVWF	LCD_CTL;
		; Hasta aqui, hemos puesto "enviando" en la pantalla 
		
		ENVIAR_DESPUES; Esto es cuando ya hemos puesto lo de la pantalla.
		CLRF	SER_CTL;
		BSF	SER_CTL,IS_CMD; Marcamos que vamos a enviar un comando
		BSF	SER_CTL,IS_DAT; Marcamos que vamos a enviar x ram
		BSF	SER_CTL,IS_EEP; Marcamos que vamos a enviar de la eeprom
		MOVLW	MODEM_CMD_SEND_SMS&H'FF';
		MOVWF	SND_CONT;
		CALL	SEND_AT;

		BANKSEL	STATUS; BANCO 0
		BSF	EST_CTL,0;
		MOVLW	H'3F';
		MOVWF	TMP2;
		EPOR_WAIT:
			NOP			; 
			DECFSZ	TMP2,F		; Se decrementa contador básico
			GOTO	EPOR_WAIT	; hasta llegar a cero
		BCF	EST_CTL,1;
		RETURN;
		
	;******* ENVIADO ********;
	;;
	; El estado enviado es cuando ya lo hemos enviado y hemos recibido el return 0
	;;
	
	ENVIADO:
		BANKSEL	LCD_CTL;
		MOVF	LCD_CTL,W;
		XORLW	LTR_ENVIADO_;
		BTFSC	STATUS,Z;
			GOTO	ENVIADO_FIN;
		MOVLW	lcd_clr; limpio la pantalla
		CALL	LCDIWR;
		MOVLW	cur_set|h'4'; Mover el cursor a la posicion 6
		CALL	LCDIWR;
		CLRF	LCD_CONT;
		PUT_ENVIADO_LOOP:
			PAGESELW	LTR_ENVIADO;
			MOVF	LCD_CONT,W;Ponemos el indice de la tabla
			CALL	LTR_ENVIADO&7FF;
			ANDLW	H'FF';
			PAGESEL	PUT_ENVIADO_LOOP_END;
			BTFSC	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_ENVIADO_LOOP_END;si hemos llegado, SALIMOS
			CALL	LCDDWR;Escribo la letra en pantalla
			INCF	LCD_CONT,F;Incremento el contador
			GOTO	PUT_ENVIADO_LOOP;vuelvo a contar
		PUT_ENVIADO_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_ENVIADO_;Cambiamos lo que hay en pantalla a "Enviando"
		MOVWF	LCD_CTL;
		ENVIADO_FIN;
		
		RETURN;
		; Hasta aqui, hemos puesto "enviando" en la pantalla 