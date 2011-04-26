;******** EJECUCIONES EN CADA ESTADO ********;
;************ POR_ *************;
POR_:
	MOVLW	STANDBY;
	MOVWF	MAQUINA_EST;
	RETURN;
;************ STANDBY_ *************;
STANDBY_:
	BANKSEL	KEYHL;
	CALL	PUT_STANDBY;
	CALL	STANDBY_COMP_DESBLQ;
	RETURN
	;******	PUT_STANDBY ******;
	; PONE STANDBY EN LA PANTALLA
	PUT_STANDBY:
		BANKSEL	LED_CTL;
		MOVF	LED_CTL,W;
		XORLW	LTR_STANDBY_;
		BTFSC	STATUS,Z;
			RETURN;
		MOVLW	lcd_clr; limpio la pantalla
		PAGESEL	LCDIWR;
		CALL	LCDIWR;
		MOVLW	cur_set|d'6'; Mover el cursor a la posicion 6
		CALL	LCDIWR;
		CLRF	TMP1;
		PUT_STANDBY_LOOP:
			PAGESELW	LTR_STANDBY;
			MOVF	TMP1,W;Ponemos el indice de la tabla
			CALL	LTR_STANDBY;
			XORLW	H'00';
			PAGESEL	PUT_STANDBY_LOOP_END;
			BTFSS	STATUS,Z;Comprobamos que no hemos llegado al final
				GOTO PUT_STANDBY_LOOP_END;si hemos llegado, SALIMOS
			PAGESEL	LCDDWR;Escribo la letra en pantalla
			CALL	LCDDWR;
			PAGESEL PUT_STANBY_LOOP;
			INCF	TMP1,F;Incremento el contador
			GOTO	PUT_STANDBY_LOOP;vuelvo a contar
		PUT_STANDBY_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_STANDBY_;Cambiamos lo que hay en pantalla a "STANDBY"
		MOVWF	LCD_CTL;
		RETURN;
	;****** STANDBY_COMP_DESBLQ ******;
	;
	STANDBY_COMP_DESBLQ:
		BANKSEL KEYHU;miramos que no haya  nada en las dos filas de arriba pulsado
		MOVF	KEYHU,W;
		BTFSS	STATUS,Z;
			CLRF	EST_CTL; Si lo hay, se vuelve a 0 (secuencia inválida)
			
		MOVF	KEYHU,W;miramos que haya algo pulsado
		IORWF	KEYHL,W;
		BTFSC	STATUS,Z;
			CLRF	EST_CTL; Si no hay nada, se vuelve a 0
		
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
		
		RETURN;Este return esta por si las moscas, no se deberia usar
		
		;***** STANDBY_COMP_DESBLQ_EST0 *****;
		STANDBY_COMP_DESBLQ_EST0:
			BTFSC	KEYHL,0; Si la * esta pulsada, est_ctl es 001 
				BSF	EST_CTL,0; 
			BTFSS	KEYHL,0; Si no, est_ctl es 000
				BCF	EST_CTL,0;
			BCF	EST_CTL,1;Nos aseguramos de entrar en la siguiente fase
			RETURN;
		;***** STANDBY_COMP_DESBLQ_EST1 *****;
		STANDBY_COMP_DESBLQ_EST1:
			BTFSS	KEYHL,0; Si la * esta pulsada, est_ctl es 001
				BCF	EST_CTL,0;
			BTFSC	KEYHL,0; Si no, est_ctl es 000
				BSF	EST_CTL,0;
			BTFSS	KEYHL,2; Si la # esta pulsada, est_ctl es 010
				BCF	EST_CTL,1;
			BTFSC	KEYHL,2; Si no, est_ctl es 000
				BSF	EST_CTL,1;
			BCF	EST_CTL,2;Nos aseguramos de entrar en la siguiente fase
			RETURN;
		;***** STANDBY_COMP_DESBLQ_EST2 *****;
		STANDBY_COMP_DESBLQ_EST2:
			BTFSC	KEYHL,0;Si la * esta pulsada
				BCF	EST_CTL,0; Hacemos que salte al estado 0 en la siguiente fase
			BTFSC	KEYHL,2;Si la # esta pulsada
UNLOCK_:
	RETURN;
MENU12_1_:
	RETURN;
MARCA_:
	RETURN;
MENSAJES_1_:
	RETURN;
MENSAJES_2_:
	RETURN;
ESCRIBIR_SMS_:
	RETURN;
LEER_SMS_:
	RETURN;