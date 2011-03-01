;*****************************************************************************************************************
;EJERCICIO_1.asm; LED intermitente
;*****************************************************************************************************************
	LIST P=16F887				;
;*****************************************************************************************************************
; Registros y constantes propios del micro
F	EQU	1				; Destino F ; Estos dos están para cuando hay que especificar en tu
W	EQU	0				; Destino W ; operación, cual es el destino del resultado
STATUS	EQU	03				; El registro de status está en 03h en todos los bancos de memoria
RP0	EQU	5				; Las posiciones de los bits de direccionamiento a banco de memoria
RP1	EQU	6				; son la pos 5 y la 6
PORTA	EQU	05				; El puerto A esta en el banco de memoria 1 posicion 05h
INTCON	EQU	0B				; Es la posición de memoria desde la que se controlan las interrupcciones
ANSEL	EQU	188				; Es la posición de memoria en la que se define si es digital (0) o analogica (1)
ANSELH	EQU	189				; En esa posición se define si es digital o analógica la entrada
; Esto puede ser confuso, pero lo que se consigue con ello es que opere como salida digital y entrada analógica.
;Configuración de conversor A/D
;*****************************************************************************************************************
; Registros particulares del programa
CONT1	EQU	20				;
CONT2	EQU	21				;
;*****************************************************************************************************************
; Asignación de puertos
P_LED	EQU	PORTA				; Se define el puerto de led
B_LED	EQU	0				; Se define la posición del led dentro del puerto
;*****************************************************************************************************************
;*****************************************************************************************************************
; Inicio de programa. Dirección de Reset
;*****************************************************************************************************************
;*****************************************************************************************************************
	ORG	003				; Se define el inicio de programa
	GOTO	PROGPPAL			; Se define la dirección de reset
;*****************************************************************************************************************
; Programa principal
;*****************************************************************************************************************
PROGPPAL:
;******	Inicializaciones
	BSF	STATUS,RP0			; Ponemos a 1 el bit RP0 (para cambiar de banco de memoria)
	BSF	STATUS,RP1			; Lo mismo, ahora estaríamos en el banco 4
	CLRF	ANSEL&7F			; ponemos a 0 
	CLRF	ANSELH&7F			;
	BCF	STATUS,RP1			; ponemos a 0 el bit rp1 para cambiar de banco
	CLRF	P_LED				; ponemos a 0 el puerto A (puerto del led a partir de ahora) basicamente, el programa empieza con el led a 0
	BCF	STATUS,RP0			; rp0 cambio de banco
;******	Lazo principal
LAZOPPAL:
	BCF	P_LED,B_LED			; a 0 el led
	MOVLW	0FF				; ponemos FF en Workbench
	MOVWF	CONT1				; guardamos el workbench en cont1
PAUS11:
	MOVLW	0FF				; cargammos FF en el Workbench
	MOVWF	CONT2				; guardamos el workbench en cont2
PAUS12:
	DECFSZ	CONT2,F				; se decrementa y si es 0 se salta la siguiente instruccion (el resultado siempre se guarda en cont2)
	GOTO	PAUS12				; se retorna al bucle PAUS12
	DECFSZ	CONT1,F				; se decrementa y si es 0 se salta la siguiente instruccion (el resultado siempre se guarda en cont1)
	GOTO	PAUS11				; se retorna al bucle PAUS11
	BSF	P_LED,B_LED			; se pone a 1 el pin del led el el puerto del led
	MOVLW	7F				; se carga 7F en el workbench
	MOVWF	CONT1				; se guarda en CONT1
PAUS21:
	MOVLW	0FF				; lo mismo de antes otra vez pero ahora con el led a 1
	MOVWF	CONT2				;
PAUS22:
	DECFSZ	CONT2,F				;
	GOTO	PAUS22				;
	DECFSZ	CONT1,F				;
	GOTO	PAUS21				;
	GOTO	LAZOPPAL			; y esto hace que nunca se llegue al end
;*****************************************************************************************************************
	END;