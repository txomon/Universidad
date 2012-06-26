;********* EEPROM.ASM *********;
;
;
;***********************************************

;******* EEPROM_INIT ********;
; NO INPUT NO OUTPUT
EEPROM_INIT:
	BANKSEL	PIE1
	BCF	PIE1&7F,EEIE;
	BANKSEL	READ00;
	CLRF	READ00;
	CLRF	WRITE00;
	CLRF	EE_CTL;
	RETURN;
	
	
;******* EEPROM_WRITE ************;
;;
; @param W - El dato que se quiere escribir
; @param EE_CTL.ORI_EXT - esta variable si esta a 0, se coje lo que haya en el registro propio, 
; si está a 1, supone que el valor ya ha sido metido, de origen externo.
;;
 
EEPROM_WRITE:
	BANKSEL	EEDAT;
	MOVWF	EEDAT&7F;move data to data field
	
	BANKSEL WRITE00;
	MOVF	WRITE00,W;
	BANKSEL EEADR;
	BTFSS	EE_CTL,ORI_EXT;
		MOVWF	EEADR&7F;move address to address field
	
	BANKSEL	EECON1 ;
	BTFSC	EECON1&7F,WR; Comprobamos que se pueda escribir
		GOTO	$-1; hasta que no se pueda escribir, saltamos
	BCF	EECON1&7F, EEPGD ;Point to DATA memory
	BSF	EECON1&7F, WREN ;Enable writes
	BCF	INTCON, GIE ;Disable INTs.
	BTFSC	INTCON, GIE ;SEE AN576
		GOTO	$-2
	MOVLW	H'55';
	MOVWF	EECON2&7F ;Write 55h
	MOVLW	H'AA';
	MOVWF	EECON2&7F ;Write AAh
	BSF	EECON1&7F, WR ;Set WR bit to begin write
	BCF	EECON1&7F,WREN;
	BSF	INTCON,GIE;
	BTFSC	EECON1&7F,WR; Comprobamos que se pueda escribir
		GOTO	$-1; hasta que no se pueda escribir, saltamos
	BANKSEL	TMP1;
	MOVLW	D'6';
	CALL 	LCDWAIT;
	BANKSEL STATUS;
	RETURN;

;******* EEPROM_READ ************;
;;
; @param  W - address to read 
; @return W - Data read
;;	
EEPROM_READ:
	;Address to read
	BANKSEL	EEADR; BANCO 2
	MOVWF	EEADR&7F;
	BANKSEL	EECON1; BANCO 3
	BCF	EECON1&7F, EEPGD ;Point to DATA memory
	BSF	EECON1&7F, RD ;EE Read
	BANKSEL	EEDAT; BANCO 2
	MOVF	EEDAT&7F, W ;W <= EEDAT
	BANKSEL	STATUS; BANCO 0
	RETURN;








