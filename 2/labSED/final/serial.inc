;************** SERIAL.INC *******************;
;**** VARIABLES ****;

	CBLOCK
	SER_CTL
	CMD_CTL 
	SND_CONT
	DAT_CTL
	ENDC
	
	CBLOCK	H'110'
	SERIAL_SEND_DATA:16 ;Con 16 bytes de memoria deberia ser suficiente
	SERIAL_RECEIVE_DATA:10;
	ENDC

	;**** SER_CTL ****;
	IS_AT	EQU	0
	IS_CMD	EQU	1
	IS_DAT	EQU	2
	IS_EEP	EQU	3
	;**** DAT_CTL ****;
	EEP_MEM	EQU	0;
	
	
;***** MODEM_TABLE *****;
	MODEM_TABLE:
	ADDWF	PCL,W;
	ADDLW	H'4';
	BTFSC	STATUS,C;
		INCF	PCLATH,F;
	MOVWF	PCL;
	
	MODEM_CMD_NO_ECHO:
	DT	"E0",H'D',0;Configuramos el modem para que no haya echo
	MODEM_CMD_NUMERIC:
	DT	"V0",H'D',0;Configuramos el modem para que los resultados sean numéricos
	MODEM_CMD_RESET:
	DT	"&F0",H'D',0;Reseteamos el modem
	MODEM_CMD_
	
	
	
	