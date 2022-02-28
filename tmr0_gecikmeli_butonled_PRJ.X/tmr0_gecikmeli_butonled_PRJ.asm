    #include	<p16f877a.inc>

;KULLANILACAK DEG?SKENLER
D1		EQU	0x19		
KACKEZ		EQU	0x20

BIRLER		EQU	0x23
ONLAR		EQU	0x24
SAYAC_BIRLER	EQU	0x25
SAYAC_ONLAR	EQU	0x26		
;*******************************************************************************

;KESME ?C?N KULLANILACAK YARDIMCI DEGS?SKENLER
w_temp		EQU	0x7D
status_temp	EQU	0x7E
pclath_temp	EQU	0x7F
	
;*******************************************************************************    
		ORG	0x000
		
		nop
		
		GOTO	BASLA
;*******************************************************************************
	ORG	0x004
	movwf	w_temp
	movf	STATUS,w
	movwf	status_temp
	movf	PCLATH,w
	movwf	pclath_temp
	
	BCF	INTCON,T0IF
	
	MOVLW	d'6'
	MOVWF	TMR0
	
	DECFSZ	KACKEZ,F
	GOTO	CIK
	CALL	YAK
	
CIK	
	BSF	INTCON,GIE
	
	movf	status_temp,w
	movwf	STATUS
	movf	pclath_temp,w
	movwf	PCLATH
	swapf	w_temp,f
	swapf	w_temp,w
	retfie
;*******************************************************************************
SUPUR
    BANKSEL	PORTA		
    BTFSC	PORTA,0	; PORT'A NIN 0. BIT'I EĞER SIFIRSA 10 DURUMUNDADIR EĞER DEĞİLSE 01 DURUMUNDADIR
    RETLW	0x02	;  01'İ 10 YAPARIM
    RETLW	0x01	;  10'I 01 YAPARIM
;*******************************************************************************	
RAKAMLAR
ADDWF	PCL,F
RETLW	b'00111111' ;0
RETLW	b'00000110' ;1
RETLW	b'01011011' ;2
RETLW	b'01001111' ;3
RETLW	b'01100110' ;4
RETLW	b'01101101' ;5 
RETLW	b'01111101' ;6 
RETLW	b'00000111' ;7	 
RETLW	b'01111111' ;8
RETLW	b'01101111' ;9
;***********************************************************************************************	
YAK	
	BANKSEL	TMR0
	MOVLW	d'250'
	MOVWF	KACKEZ
	
	CALL	SUPUR
	
	MOVLW	0x00
	MOVWF	BIRLER
	
	MOVLW	0x00
	MOVWF	ONLAR
	
	CALL	SUPUR
	
DONGU1	BTFSS	PORTA,3
	GOTO	ARTTIR
	BTFSS	PORTA,4
	GOTO	EKSILT
	GOTO	DONGU1
	
ARTTIR	CALL	SUPUR
	MOVLW	b'00000001'
	MOVWF	PORTA
	INCF	BIRLER,F
	MOVF	BIRLER,W
	CALL	RAKAMLAR
	MOVWF	PORTB
	CALL	SUPUR
	RETURN
	MOVLW	b'00000010'
	MOVWF	PORTA
	MOVF	ONLAR,W
	CALL	RAKAMLAR
	MOVWF	PORTB
	CALL	SUPUR
	
	RETURN
;*******************************************************************************
TMR0_AYARLA
	BANKSEL	OPTION_REG
	MOVLW	b'00000011'
	MOVWF	OPTION_REG
	
	BANKSEL	TMR0
	MOVLW	d'6'
	MOVWF	TMR0
	RETURN
;*******************************************************************************
KESME_AYARLA
	BSF	INTCON,T0IE
	BSF	INTCON,GIE
	RETURN
;*******************************************************************************
PORTA_AYARLA
	BANKSEL	PORTA
	CLRF	PORTA
	
	BANKSEL	TRISA
	MOVLW	0x06
	MOVWF	ADCON1
	
	MOVLW	b'00001000'
	MOVWF	TRISA
	RETURN
;*******************************************************************************
PORTB_AYARLA
	BANKSEL	TRISB
	CLRF	TRISB
	
	BANKSEL	PORTB
	CLRF	PORTB
	RETURN
;*******************************************************************************	
BASLA
	MOVLW	d'250'
	MOVWF	KACKEZ
	
	CALL	TMR0_AYARLA
	CALL	KESME_AYARLA
	
	CALL	PORTA_AYARLA
	CALL	PORTB_AYARLA

DD	
	GOTO	DD
        END

