;************** SERIAL.INC *******************;
;**** VARIABLES ****;

	CBLOCK
	SER_CTL
	SND_CONT
	RCV_CONT
	ENDC
	
	CBLOCK	H'110'
	SERIAL_SEND_DATA:H'F' ;Con 16 bytes de memoria deberia ser suficiente
	SERIAL_RECEIVE_DATA:H'A';
	ENDC

	;**** SER_CTL ****;
	IS_CMD	EQU	0; Lo que se va a enviar tiene comando?
	IS_DAT	EQU	1; Lo que se va a enviar tiene datos de RAM?
	IS_EEP	EQU	2; Lo que se va a enviar tiene datos de EEPROM?
	IS_SIF	EQU	5
	IS_SND	EQU	6
	IS_RCV	EQU	7
	;**** DAT_CTL ***;
	EEP_MEM	EQU	0;
	
	
;***** MODEM_TABLE *****;
	MODEM_TABLE:
	MOVWF	PCL;
	
	MODEM_CMD_NUM_NO_ECHO:
	DT	" E0 V0",H'D',0;Modem => no echo y modo numerico
	MODEM_CMD_RESET:
	DT	"&F0",H'D',0;Reseteamos el modem
	MODEM_CMD_SEND_SMS:
	DT	"+CMGS=",H'22',0
	
	
	
	