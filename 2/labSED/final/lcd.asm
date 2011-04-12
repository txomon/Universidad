;********************************************************************************************************
;*LCD****************************************************************************************************
;********************************************************************************************************

;*****************************************************
; Estas rutinas consideran que el módulo LCD
; utiliza una interfaz de 4 bits de datos.


;*****************************************************
; LCDINIT
; Inicializa pantalla y puerto de pantalla

LCDINIT:

	BSF	STATUS, RP0	; Se reconfigura puerto de datos LCD
	MOVLW   0F0h		; 4 bits de datos = Salida
	ANDWF	P_LCDDA,F	;
	BCF	P_LCDdi,b_LCDdi	; Dato/instrucción = Salida
	BCF	P_LCDrw,b_LCDrw	; Read/Write = Salida
	BCF	P_LCDen,b_LCDen	; Strobe = Salida
	BCF	STATUS, RP0	;

	BCF	P_LCDdi,b_LCDdi	; Dato/instrucción = Instrucción
	BCF	P_LCDrw,b_LCDrw	; Read/Write = Write
	BCF	P_LCDen,b_LCDen	; desactiva el strobe

	MOVLW	0F0h		; Se prepara primer dato de inicialización de 4 bits
	ANDWF	P_LCDDA,F	; (que hay que enviar 3 veces)
	MOVLW	B'0011'		; 
	IORWF	P_LCDDA,F	;

	MOVLW	D'20'		; Se esperan 20ms
	CALL	LCDWAIT		;

	BSF	P_LCDen,b_LCDen	; Primer envio
	BCF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe

	MOVLW	D'5'		; Se esperan 5ms
	CALL	LCDWAIT		;

	BSF	P_LCDen,b_LCDen	; Segundo envio
	BCF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe

	MOVLW	D'1'		; Se espera 1ms
	CALL	LCDWAIT		;

	BSF	P_LCDen,b_LCDen	; Tercer envio
	BCF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe

	MOVLW	D'5'		; Se esperan 5ms
	CALL	LCDWAIT		;

	MOVLW	0F0h		; Se prepara segundo dato de inicialización de 4 bits
	ANDWF	P_LCDDA,F	;
	MOVLW	B'0010'		;
	IORWF	P_LCDDA,F	;

	BSF	P_LCDen,b_LCDen	; Envio
	BCF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe

	MOVLW	D'5'		; Se esperan 5ms
	CALL	LCDWAIT		;

	MOVLW	lcd_set		; Se envia instrucción para fijar tipo de pantalla
	CALL	LCDIWR		;

	MOVLW	D'5'		; Se esperan 5ms
	CALL	LCDWAIT		;

	MOVLW	lcd_off		; Se envia instrucción para apagar pantalla
	CALL	LCDIWR		;

	MOVLW	lcd_on		; Se envia instrucción para encender pantalla
	CALL	LCDIWR		;

	MOVLW	lcd_mod		; Se envia instrucción para forma de operar pantalla
	CALL	LCDIWR		;

	MOVLW	lcd_clr		;
	CALL	LCDIWR		;

	MOVLW	D'100'		; Se esperan 100 ms
	CALL	LCDWAIT		;

	RETURN


;*****************************************************
; LCDDWR
; LCD Data write
; Recibe: W=Dato a escribir

LCDDWR:
	BSF	P_LCDdi,b_LCDdi	; Dato/instrucción = Dato
	GOTO	LCDWRAUX	;


;*****************************************************
; LCDIWR
; LCD Instruction write
; Recibe: W=Dato a escribir

LCDIWR:
	BCF	P_LCDdi,b_LCDdi	; Dato/instrucción = Dato
	GOTO	LCDWRAUX	;

LCDWRAUX:
	BCF	P_LCDrw,b_LCDrw	; Read/Write = Write
	MOVWF	TMP1		; Se guarda dato para posterior uso

	MOVLW	0F0h		; Se borran bits lsb del puerto
	ANDWF	P_LCDDA,F	;
	SWAPF	TMP1,W		; Se escribe el nible superior
	ANDLW	00Fh		;
	IORWF	P_LCDDA,F	;
	BSF	P_LCDen,b_LCDen	;  activa el strobe
	BCF	P_LCDen,b_LCDen	;  desactiva el strobe

	MOVLW	0F0h		; Se borran bits lsb del puerto
	ANDWF	P_LCDDA,F	;
	MOVF	TMP1,W		; Se escribe nible inferior	
	ANDLW	00Fh		;
	IORWF	P_LCDDA,F	;
	BSF	P_LCDen,b_LCDen	;  activa el strobe
	BCF	P_LCDen,b_LCDen	;  desactiva el strobe

	CALL	LCDBSY		;
	
	RETURN

;*****************************************************
; LCDWAIT
; Recibe:  W=Número de milisegundos a esperar

LCDWAIT:
WAIT:
	MOVWF	TMP1		; Se almacena el número de milisegundos en CONT1
LCDW1:	MOVLW	klcdw		; Se almacena contador básico
	MOVWF	TMP2		;
LCDW2:	NOP			; Ajustando al milisegundo
	NOP			;
	DECFSZ	TMP2,F		; Se decrementa contador básico
	GOTO	LCDW2		; hasta llegar a cero
	DECFSZ	TMP1,F		; Se repite el contador básico tantas
	GOTO	LCDW1		; veces como número de milisegundos
	RETURN			;

;*****************************************************
; LCDBSY
; LCD Busy: espera desocupación de LCD (con time-out)
; Retorna: W=0 desocupado / W=1 error time-out superado

LCDBSY:
	MOVLW	lcd_to		; Se prepara contador de time-out
	MOVWF	TMP1		;
	CALL	LCDDIN		; Se pone el bus como entrada
	BCF	P_LCDdi,b_LCDdi	; Dato/instrucción = Instruccion
	BSF	P_LCDrw,b_LCDrw	; Read/Write = Write
LCDBS1:
	BSF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe
	BCF	P_LCDen,b_LCDen	;
	MOVF	P_LCDDA,W	; Se lee nibble MSN con busy flag BF
	BSF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe
	BCF	P_LCDen,b_LCDen	;
	ANDLW	08h		;
	BTFSC	STATUS,Z	; Si BF=0 el LCD esta desocupado
	GOTO	LCDBS2		;

	DECFSZ	TMP1,F		; Se verifica si hay time out
	GOTO	LCDBS1		;
	
	CLRF	TMP1		; Hay time-out
	CALL	LCDDOUT		;
	RETLW	01		; Retorna error por time-out

LCDBS2:				; Desocupado
	CALL	LCDDOUT		;
	RETLW	00		; Retorna desocupado sin errores

;*****************************************************
; CURADD
; Lee dirección del cursor
; Retorna: W=dirección del cursor (0-79d)

CURADD:
	CALL	LCDDIN		; Se reconfigura puerto de datos LCD como entrada

	BCF	P_LCDdi,b_LCDdi	; Dato/instrucción = Instruccion
	BSF	P_LCDrw,b_LCDrw	; Read/Write = Write

	BSF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe
	BCF	P_LCDen,b_LCDen	;
	MOVF	P_LCDDA,W	; Se lee nibble MSN
	ANDLW	07h		;
	MOVWF	TMP1		;
	SWAPF	TMP1,F		;
	BSF	P_LCDen,b_LCDen	;  activar strobe / desactivar strobe
	BCF	P_LCDen,b_LCDen	;
	MOVF	P_LCDDA,W	; Se lee nibble LSN
	ANDLW	0Fh		;
	IORWF	TMP1,W		;
	CALL	LCDDOUT		;
	RETURN			;


;*****************************************************

LCDDIN:				; Bus de datos LCD como entrada
	BSF	STATUS, RP0	; Se reconfigura puerto de datos LCD
	MOVLW   00Fh		; como entrada
	IORWF	P_LCDDA,W	;
	MOVWF	P_LCDDA		;
	BCF	STATUS, RP0	;
	RETURN			;

LCDDOUT:			; Bus de datos LCD como salida
	BSF	STATUS, RP0	; Se reconfigura puerto de datos LCD
	MOVLW   0F0h		; como salida
	ANDWF	P_LCDDA,W	;
	MOVWF	P_LCDDA		;
	BCF	STATUS, RP0	;
	MOVF	TMP1,W		;
	RETURN