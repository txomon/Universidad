;******** EEPROM.INC *********;

;00                                                            FF
;----------------------------------------------------------------
;|000000XXXXXXXXXXXXXX|     |XXXXXXXXXXXXXXXXXXX0000000000000000|
;|000000XXXXXXXXXXXXXX|     |XXXXXXXXXXXXXXXXXXX0000000000000000|
;|000000XXXXXXXXXXXXXX|     |XXXXXXXXXXXXXXXXXXX0000000000000000|
;------|--------------|-------------------------|----------------
;   UP_CONT        UP_MAX DOWN_MAX           DOWN_CONT                 

;****** RAM CODES *******;
	CBLOCK;
DOWN_CONT
DOWN_MAX
UP_CONT
UP_MAX
	ENDC;


