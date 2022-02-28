#include	<p16f877a.inc>

		
;kullanilacak degiskenler
		
KACKEZ		EQU	    0x25
;kesme icin kullanilacak yardimci degiskenler
w_temp		EQU	    0x7D
status_temp	EQU	    0x7E	
pclath_temp	EQU	    0x7F	
;******************************************************************************* 
		ORG	    0x000
		
		nop
		
		GOTO	    BASLA
;*******************************************************************************		
	ORG	0x004
	
	movwf	w_temp
	movf	STATUS,w
	movwf	status_temp
	movf	PCLATH,W
	movwf	pclath_temp
	
	BCF	INTCON,T0IF
	
	MOVLW	d'6'
	MOVWF	TMR0
	
	DECFSZ	KACKEZ,F
	GOTO	CIK
	CALL	TMR0_ALTPROGRAM
	
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
TMR0_ALTPROGRAM
	BANKSEL	TMR0
	MOVLW	d'162'
	MOVWF	KACKEZ
	
	BTFSS	PORTB,0
	GOTO	LED0
	GOTO	LED1
	
LED0	MOVLW	d'1'
	MOVWF	PORTB
	RETURN
	
LED1	MOVLW	d'2'
	MOVWF	PORTB
	RETURN
	
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
	
	MOVLW	b'00001001'
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
	
	MOVLW	d'162'
	MOVWF	KACKEZ
	
	CALL	TMR0_AYARLA
	CALL	KESME_AYARLA
	CALL	PORTA_AYARLA
	CALL	PORTB_AYARLA
	

SON		
	GOTO	SON
	END


