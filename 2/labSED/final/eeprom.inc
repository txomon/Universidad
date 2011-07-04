;******** EEPROM.INC *********;

;00                                                            FF
;----------------------------------------------------------------
;|000000XXXXXXXXXXXXXX|     |XXXXXXXXXXXXXXXXXXX0000000000000000|
;|000000XXXXXXXXXXXXXX|     |XXXXXXXXXXXXXXXXXXX0000000000000000|
;|000000XXXXXXXXXXXXXX|     |XXXXXXXXXXXXXXXXXXX0000000000000000|
;------|--------------|-------------------------|----------------
;   READ00         WRITE00 WRITEFF            READFF                 

;****** RAM CODES *******;
	CBLOCK;
READ00
WRITE00
;READFF
;WRITEFF
	ENDC;
EE_CTL	EQU	H'70'

	;******* EE_CTL *******;
	ORI_EXT	EQU	0;

