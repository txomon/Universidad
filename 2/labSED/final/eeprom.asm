;********* EEPROM.ASM *********;
;
;
;***********************************************

;******* EEPROM_INIT ********;
; NO INPUT NO OUTPUT
EEPROM_INIT:
	BANKSEL	PIE1
	BCF	PIE1,EEIE;
	BANKSEL	READ00;
	CLRF	READ00;
	CLRF	WRITE00;
	CLRF	EE_CTL;
	RETURN;
	
	
;******* EEPROM_WRITE_00 ************;
; input = w -> data
;         EE_CTL, ORI_EXT -> 1 if eeadr has been previously read
 
EEPROM_WRITE_00:
	BANKSEL	EEDAT;
	MOVWF	EEDAT;move data to data field
	
	BANKSEL WRITE00;
	BTFSS	EE_CTL,ORI_EXT;
		MOVF	WRITE00,W;
	BANKSEL EEADR;
	BTFSS	EE_CTL,ORI_EXT;
		MOVWF	EEADR;move address to address field
	
	BANKSEL	EECON1 ;
	BCF	EECON1, EEPGD ;Point to DATA memory
	BSF	EECON1, WREN ;Enable writes
	BCF	INTCON, GIE ;Disable INTs.
	BTFSC	INTCON, GIE ;SEE AN576
	GOTO	$-2
	MOVLW	H'55';
	MOVWF	EECON2 ;Write 55h
	MOVLW	H'AA';
	MOVWF	EECON2 ;Write AAh
	BSF	EECON1, WR ;Set WR bit to begin write
	BCF	EECON1, WREN;Set WREN bit to prevent accidents
	RETFIE;

;******* EEPROM_READ_00 ************;
; no input,
; output = w -> DATA
	
EEPROM_READ_00:
	BANKSEL READ00;
	BTFSS	EE_CTL,ORI_EXT;
		MOVF	READ00;
	BTFSS	EE_CTL,ORI_EXT;
		MOVWF EEADR ;Data Memory
	;Address to read
	BANKSEL EECON1 ;
	BCF EECON1, EEPGD ;Point to DATA memory
	BSF EECON1, RD ;EE Read
	BANKSEL EEDAT ;
	MOVF EEDAT, W ;W <= EEDAT
	RETURN;








