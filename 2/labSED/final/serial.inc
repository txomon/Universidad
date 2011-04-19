;******** SERIAL.INC ********;
;***** REGISTROS *****; Empezamos con los registros especificos
RX_CONT	EQU	DOWN_CONT; nº caracter recibido
RX_MAX 	EQU	DOWN_MAX; para almacenar cuantos hemos recibido en total
TX_CONT	EQU	UP_CONT; nº caracter enviado
TX_MAX	EQU	UP_MAX; para almacenar cuantos vamos a enviar, comparacion
	
	CBLOCK;
SERIAL_CTL; Registro de control
	ENDC;
ISSENDING	EQU	1;

