;********************************************************************************************************
;*LCD****************************************************************************************************
;********************************************************************************************************

	CBLOCK
TMP1
TMP2
LCD_LTR_CONT

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
; Configuración y Comandos LCD
;;;;;; Voy a separar con lineas asi las cosas que tienen que ir separadas
lcd_clr	EQU	b'00000001'	; Limpia la pantalla LCD, pero no lo mueve a home
;;;;;;
cur_hm	EQU	b'00000010'	; Pone el cursor y la pantalla en la posición 0
;;;;;;
; Configurar el modo de entrada del lcd
lcdf_em	EQU	b'00000100'	; para configurar el modo en el que mueve el cursor
				; y si la pantalla se mueve
lcdf_de	EQU	b'00000010'	; el cursor va hacia la derecha
lcdf_iz	EQU	b'00000000'	; el cursor va hacia la izquierda
lcdf_sd	EQU	b'00000001'	; el display se mueve (shift display)
;;;;;;
cur_on	EQU	b'00001010'	; Cursor on
cur_off EQU	b'00001000'	; Cursor off
;;;;;;
cur_rm	EQU	b'00010100'	; Cursor right move
cur_lm	EQU	b'00010000'	; Cursor left move
cur_set	EQU	b'10000000'	; Cursor set position

;*****************************************************
;  LCD

; Configuración del LCD
lcd_set	EQU	b'00100000'	; LCD: 4 bits, 1 línea, 5x7 puntos
; Configuración de la manera de comportarse la pantalla
lcd_mod	EQU	lcdf_em|lcdf_de	;
lcd_on	EQU	b'00001100'	; Display on, cursor off, blink off
lcd_off	EQU	b'00001000'	;
lcd_to	EQU	d'200'		; Time-out para display ocupado
