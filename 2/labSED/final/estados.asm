;******** EJECUCIONES EN CADA ESTADO ********;
;************ POR_ *************;
POR_:
	MOVLW	POR;
	BANKSEL	MAQUINA_EST;
	MOVWF	MAQUINA_EST;
	BTFSS	EST_CTL,0;
		CALL	POR_CTL_PER_CONFIG;
	BTFSC	EST_CTL,0;
		CALL	POR_CTL_PER_ANALIZE;
	BTFSC	EST_CTL,1;	
		GOTO STANDBY_;
	RETURN;
	
		;******** POR_CONTROL_PERIPHERIAL_START_NO_ECHO *******;
		; MODEM => NO ECHO & NUM MODE
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
				NOP			; Ajustando al milisegundo
				NOP			;
				DECFSZ	TMP2,F		; Se decrementa contador básico
				GOTO	POR_WAIT	; hasta llegar a cero

			RETURN;
			
		;******** POR_CTL_PER_ANALIZE ********;
		; IF MODEM ANSWER:
		POR_CTL_PER_ANALIZE:
			MOVF	RCV_CONT,W;
			BTFSC	STATUS,Z;
				RETURN;	
			MOVLW	H'1F'
			MOVWF	FSR;
			BSF	STATUS,IRP;
				MOVLW	cur_set|h'40'; Mover el cursor a la posicion 6
				CALL	LCDIWR;
			MOVF	INDF,W;
				CALL	LCDDWR;Escribo la letra en pantalla
			MOVF	INDF,W;
			XORLW	'0';
			BTFSS	STATUS,Z;
				BCF	EST_CTL,0;
			BTFSS	STATUS,Z;
				RETURN;
			BSF	EST_CTL,1;
			RETURN
		
		
		
;************ STANDBY_ *************;
STANDBY_:
	BANKSEL	KEYHL;
	MOVLW	STANDBY;
	MOVWF	MAQUINA_EST;Decimos que estamos en STANDBY
	CALL	PUT_STANDBY;
	CALL	STANDBY_COMP_DESBLQ;
	RETURN
	;******	PUT_STANDBY ******;
	; PONE STANDBY EN LA PANTALLA
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
	;
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
		MOVLW	UNLOCK
		BTFSS	EST_CTL,4;
			MOVWF	MAQUINA_EST;
		
		RETURN;Este return esta para antes de saltar a UNLOCK_
		
		;**********************************************************************;
		; Estas rutinas están pensadas teniendo como logico que avanzar es lo normal
		;
		;***** STANDBY_COMP_DESBLQ_EST0 *****;llegamos desde la nada, en teoria no hay nada pulsado
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
		STANDBY_COMP_DESBLQ_EST3:
			BTFSC	KEYHL,0;Si la * esta pulsada
				BCF	EST_CTL,2;
			BTFSS	KEYHL,2;Si la # esta pulsada
				BCF	EST_CTL,3;
			BTFSC	KEYHL,2;Si no, se acaba con la ultima fase.
				BSF	EST_CTL,3;
			BCF	EST_CTL,4;
			RETURN;
				
				
UNLOCK_:
	BANKSEL	MAQUINA_EST;
	MOVLW	UNLOCK;
	MOVWF	MAQUINA_EST;
	CALL	PUT_COMPANY;
	RETURN;
	;************* PUT_COMPANY **************;
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
	
	
MENU12_1_:
	BANKSEL	MAQUINA_EST;
	MOVLW	MENU12_1;
	MOVWF	MAQUINA_EST;
	CALL	PUT_MENU12_1;
	CALL	MENU12_1_GOIN;
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
		MOVLW	cur_set; Mover el cursor a la posicion 6
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
		PUT_COMPANY_LOOP_END:;Hemos salido
		BANKSEL LCD_CTL;
		MOVLW	LTR_MENU12_1_;Cambiamos lo que hay en pantalla a "COMPANY"
		MOVWF	LCD_CTL;
		RETURN;
		
		GONEXTLINE:
			MOVLW	cur_set|h'40';
			CALL	LCDIWR;
			RETURN;
	PUT_MENU12_1_GOIN:
	
		
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