;******** CONTROL DEL PROGRAMA ********;
	CBLOCK
	MAQUINA_EST
	EST_CTL
	LCD_CTL
	LCD_CONT
	PARSER_LTR
	PARSER_CTL
	PARSER_TEMP
	PARSER_CONT
	PARSER_LTR_INFO
	ENDC
		;** PARSER_LTR USO **;
		; PARSER_LTR,<3-0> ULTIMA TECLA
		; PARSER_LTR,<7-4> VECES PULSADA
		
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
		ESCRIBIR_SMS	EQU	H'04'
		MANDAR_SMS	EQU	H'05'
		ENVIAR_SMS	EQU	H'06'
		
		;** ESTADOS DEL CONTROL LCD **;
		LTR_NONE_	EQU	H'00'
		LTR_STANDBY_	EQU	H'01'
		LTR_COMPANY_	EQU	H'02'
		LTR_MENU12_1_	EQU	H'03'
		LTR_ENVIAR_	EQU	H'04'
		LTR_POR_	EQU	H'05'


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
	DT	"Escribir mensaje",1,"Leer mensaje";
	LTR_ENVIAR:
	ADDWF	PCL,F;
	DT	"Enviando",0;
	