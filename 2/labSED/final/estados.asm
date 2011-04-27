;******** EJECUCIONES EN CADA ESTADO ********;
;************ POR_ *************;
POR_:
	GOTO STANDBY_;
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
			PAGESEL PUT_STANDBY_LOOP;
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