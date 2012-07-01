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
lcd_to	EQU	d'200'		; Time-out para display ocupado


;*****************************************************
; Configuración y Comandos LCD
;;;;;; Voy a separar con lineas asi las cosas que tienen que ir separadas
; Limpiar la pantalla
lcdf_clr		EQU	b'00000001'	; Limpia la pantalla LCD, pero no lo mueve a home
;;;;;;
; Display a la posición original
lcdf_hm		EQU	b'00000010'	; Pone (¿el cursor y?) la pantalla en la posición 0
;;;;;;
; Configurar el modo de entrada del lcd
lcdf_em		EQU	b'00000100'	; para configurar el modo en el que mueve el cursor y si la pantalla se mueve
lcdf_cde	EQU	b'00000010'	; el cursor va hacia la derecha
lcdf_ciz	EQU	b'00000000'	; el cursor va hacia la izquierda
lcdf_dso	EQU	b'00000001'	; el display se mueve (shift display)
lcdf_dsf	EQU	0		; el display no se mueve
;;;;;;
; Configurar el display y el cursor
lcdf_dc		EQU	b'00001000'	; para configurar el display, si el cursor esta y si parpadea
lcdf_do		EQU	b'00000100'	; display on
lcdf_df		EQU	0		; display off
lcdf_co		EQU	B'00000010'	; cursor on
lcdf_cf 	EQU	0		; cursor off
lcdf_cbo	EQU	B'00000001'	; cursor parpadea
lcdf_cbf	EQU	0		; cursor no parpadea
;;;;;;
; Mover, o cambiar una posicion el display o el cursor
lcdf_cuds	EQU	B'00010000'	; mover cursor o display
lcdf_ds		EQU	B'00001000'	; mover	display
lcdf_cu		EQU	0		; mover cursor
lcdf_der	EQU	B'00000100'	; mover a la derecha
lcdf_izq	EQU	0		; mover a la izquierda
;;;;;;
; Configuración de los chips que controlan el lcd
lcdf_fs		EQU	B'00100000'	; Configurar los chips
lcdf_i8		EQU	B'00010000'	; La interfaz es de 8 bits
lcdf_i4		EQU	0		; La interfaz es de 4 bits
lcdf_l2		EQU	B'00001000'	; La pantalla tiene 2 lineas
lcdf_l1		EQU	0		; La pantalla tiene 1 linea
lcdf_c10	EQU	B'00000100'	; Los caracteres son de 5x10
lcdf_c7		EQU	0		; Los caracteres son de 5x7
;;;;;;
; Estabecer la posición en el mapa de caracteres
lcdf_cg		EQU	b'01000000'	; Caracter generator
;;;;;;
; Establecer la posición del cursor
lcdf_dd		EQU	b'10000000'	; Cursor set position en diplay

;*****************************************************
;  configuraciones, hechas a partir de las anteriores
lcd_clr		EQU	lcdf_clr				; Es un alias, ya que no neceista parametros
cur_hm		EQU	lcdf_hm					; Es un alias, ya que no necesita parametros
cur_set		EQU	lcdf_dd
; Configuración de la manera de comportarse la pantalla ante una entrada 
lcd_mod		EQU	lcdf_em|lcdf_cde|lcdf_dsf		; El configuramos el entry mode para que el cursor se mueva hacia la derecha
; Configuración del display y del cursor
lcd_off		EQU	lcdf_dc|lcdf_df|lcdf_cf|lcdf_cbf	; Display off(, cursor off, blink off)
lcd_on		EQU	lcdf_dc|lcdf_do|lcdf_cf|lcdf_cbf	; Display on, cursor off(, blink off)
cur_on		EQU	lcdf_dc|lcdf_do|lcdf_co|lcdf_cbf	; Display on, cursor on, blink off
cur_off 	EQU	lcd_off					; Cursor off=Display on, cursor off
; Configuración del LCD
lcd_conf	EQU	lcdf_fs|lcdf_i4|lcdf_l2|lcdf_c7		; Configurar los controladores con interfaz de 4 bits
								; 2 lineas y 5x7 puntos