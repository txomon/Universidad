;******** SERIAL.INC ********;
;***** REGISTROS *****; Empezamos con los registros especificos
	
	CBLOCK;
SERIAL_CTL; Registro de control
RC_CONT; nº caracter recibido
RC_MAX; para almacenar cuantos hemos recibido en total
TX_CONT; nº caracter enviado
TX_MAX; para almacenar cuantos 
SER_TMP; registro temporal
	ENDC;
	;***** SERIAL_CTL BITS *****;
	IS_SND	EQU	1;
	EEPROM	EQU	2;
	TX_RC	EQU	3;TX=0 RC=1
