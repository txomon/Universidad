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
; input = w -> data
;         EE_CTL, ORI_EXT -> 1 if eeadr has been previously read
 
EEPROM_WRITE:
	BANKSEL	EEDAT;
	MOVWF	EEDAT&7F;move data to data field
	
	BANKSEL WRITE00;
	BTFSS	EE_CTL,ORI_EXT;
		MOVF	WRITE00,W;
	BANKSEL EEADR;
	BTFSS	EE_CTL,ORI_EXT;
		MOVWF	EEADR&7F;move address to address field
	
	BANKSEL	EECON1 ;
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
	BCF	EECON1&7F, WREN;Set WREN bit to prevent accidents
	RETFIE;

;******* EEPROM_READ ************;
; input  = eeaddr
; output = w -> DATA
	
EEPROM_READ:
	;Address to read
	BANKSEL EECON1 ;
	BCF EECON1&7F, EEPGD ;Point to DATA memory
	BSF EECON1&7F, RD ;EE Read
	BANKSEL EEDAT;
	MOVF EEDAT&7F, W ;W <= EEDAT
	RETURN;








