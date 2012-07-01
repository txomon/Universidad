;******** CONTROL DEL PROGRAMA ********;
	CBLOCK
	MAQUINA_EST
	EST_CTL
	LCD_CTL
	LCD_CONT
	PARSER_LTR; Contador del caracter por el que vamos guardando
	PARSER_CTL; 
	PARSER_TEMP; Temporal utilizado para shifts etc. se puede utilizar si es necesario
	PARSER_CONT; Contador utilizado para los shifts
	PARSER_LTR_INFO
	ENDC	
		;** PARSER_LTR_INFO **;
		PLI_INUSE	EQU	H'0'; PARSER_LTR tiene datos validos (está en uso), como tenemos 
		; que poder validar que todas las pulsaciones de las teclas son para este estado,
		; tendremos que saber si primero hay que esperar a que no haya nada pulsado para empezar.
		PLI_WASPRESSED	EQU	H'1'; El último estado de PARSER_LTR era pulsado	
	
		;** ESTADOS DE LA MÁQUINA **;
		POR		EQU	H'00'
		STANDBY		EQU	H'01'
		UNLOCK		EQU	H'02'
		MENU12_1	EQU	H'03'
		ESCRIBIR_NUMERO	EQU	H'04'
		ESCRIBIR_SMS	EQU	H'05'
		ENVIAR_SMS	EQU	H'06'
		
		;** ESTADOS DEL CONTROL LCD **;
		LTR_NONE_	EQU	H'00'
		LTR_POR_	EQU	H'01'
		LTR_STANDBY_	EQU	H'02'
		LTR_COMPANY_	EQU	H'03'
		LTR_MENU12_1_	EQU	H'04'
		LTR_ESCRIBIR_NUMERO_	EQU	H'05'
		LTR_ENVIANDO_	EQU	H'06'
		LTR_ENVIADO_	EQU	H'07'

	LTR_POR:
	ADDWF	PCL,F;
	DT	"POWER ON RESET",0;
	LTR_STANDBY:
	ADDWF	PCL,F;
	DT	"STANDBY",0;
	LTR_COMPANY:
	ADDWF	PCL,F;
	DT	"UNLOCKED!",0;
	LTR_MENU12_1:
	ADDWF	PCL,F;
	DT	"Escribir mensaje",1,"Leer mensaje",0;
	LTR_ESCRIBIR_NUMERO:
	ADDWF	PCL,F;
	DT	"Marca el numero:",1,0;
	LTR_ENVIANDO:
	ADDWF	PCL,F;
	DT	"Enviando",0;
	LTR_ENVIADO:
	ADDWF	PCL,F;
	DT	"Enviado!",0;