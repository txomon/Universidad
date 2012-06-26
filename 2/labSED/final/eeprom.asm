;********* EEPROM.ASM *********;
;
;
;***********************************************

;******* EEPROM_INIT ********;
; NO INPUT NO OUTPUT
EEPROM_INIT:
	BANKSEL	PIE2
	BCF	PIE2&7F,EEIE;
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
	MOVWF	TMP1; Guardamos en tmp1 el dato
	MOVF	WRITE00,W ; movemos la dirección a W
	BANKSEL EEADR ; BANCO 2
	BTFSS	EE_CTL,ORI_EXT ; 
		MOVWF	EEADR&7F ; move address to address field
	BANKSEL	TMP1;
	MOVF	TMP1,W;
	BANKSEL	EEDAT ; BANCO 2
	MOVWF	EEDAT&7F ; move data to data field
	
	;;;;;;;;;;;;;
	BANKSEL	EECON1 ; BANCO 3
	BCF	EECON1&7F,EEPGD ; Point to DATA memory
	BSF	EECON1&7F,WREN ; Enable writes
	BCF	INTCON,GIE ; Disable INTs
	BTFSC	INTCON,GIE ; SEE AN576
		GOTO	$-2;
	MOVLW	H'55' ;
	MOVWF	EECON2&7F ; Write 55h
	MOVLW	H'AA' ;
	MOVWF	EECON2&7F ; Write AAh
	BSF	EECON1&7F,WR ; Set WR bit to begin write
	;;;;;;;;;;;;;

	BTFSS	EECON1,WR ; Comprobamos que se haya echo la escritura
		GOTO	$-1 ; hasta que no se haya escrito, no salimos de aqui
	BCF	PIR2,EEIF ;
	BANKSEL	EECON1 ; BANCO 3
	BCF	EECON1&7F,WREN ;
	BSF	INTCON,GIE ;
	BANKSEL WRITE00 ; BANCO 0
	BCF	PIR2,EEIF;
	BTFSS	EE_CTL,ORI_EXT
		INCF	WRITE00,F ;
	RETURN;

;******* EEPROM_READ ************;
;;
; @param  W - address to read 
; @return W - Data read
;;	
EEPROM_READ:
	;Address to read
	BTFSS	EE_CTL,ORI_EXT ;
		MOVF	READ00,W
	BANKSEL	EEADR; BANCO 2
	MOVWF	EEADR&7F;
	BANKSEL	EECON1; BANCO 3
	BCF	EECON1&7F, EEPGD ;Point to DATA memory
	BSF	EECON1&7F, RD ;EE Read
	BTFSC	EECON1,RD;
		GOTO	$-1;
	BANKSEL	EEDAT; BANCO 2
	MOVF	EEDAT&7F, W ;W <= EEDAT
	BANKSEL	STATUS; BANCO 0
	BTFSS	EE_CTL,ORI_EXT ;
		INCF	READ00,F
	RETURN;








