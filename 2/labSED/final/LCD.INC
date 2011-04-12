;********************************************************************************************************
;*LCD****************************************************************************************************
;********************************************************************************************************

	CBLOCK
TMP1
TMP2
	ENDC

;*****************************************************
; Estas rutinas consideran que el módulo LCD
; utiliza una interfaz de 4 bits de datos.

;*****************************************************
; Puertos LCD

P_LCDen	EQU	PORTD		; Puerto de bit de enable(strobe) LCD
b_LCDen	EQU	 4		;  bit de enable(strobe) LCD
P_LCDrw	EQU	PORTD		; Puerto de bit de read/write LCD
b_LCDrw	EQU	 5		;  bit de read/write LCD
P_LCDdi	EQU	PORTD		; Puerto de bit de dato/instruccion LCD
b_LCDdi	EQU	 6		;  bit de dato/instruccion LCD
P_LCDDA	EQU	PORTD		; Puerto de dato de LCD (los 4 bits menos significativos!)

;*****************************************************
; Constantes de tiempo (pueden variar segun frecuencia
;                       de operacion del microcontrolador)

klcdw	EQU	0FFh		; Constante para pausa 

;*****************************************************
; Configuración LCD

lcd_set	EQU	b'00100000'	; LCD: 4 bits, 1 línea, 5x7 puntos
lcd_mod	EQU	b'00000110'	;
lcd_on	EQU	b'00001100'	; Display on, cursor off, blink off
lcd_off	EQU	b'00001000'	;
lcd_to	EQU	d'200'		; Time-out para display ocupado

;*****************************************************
; Comandos LCD

lcd_clr	EQU	b'00000001'	; LCD clear
cur_hm	EQU	b'00000010'	; Cursor to home
cur_on	EQU	b'00001010'	; Cursor on
cur_off EQU	b'00001000'	; Cursor off
cur_rm	EQU	b'00010100'	; Cursor right move
cur_lm	EQU	b'00010000'	; Cursor left move
