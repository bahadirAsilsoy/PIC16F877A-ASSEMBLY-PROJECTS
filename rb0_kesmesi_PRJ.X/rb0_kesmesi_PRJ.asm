;KODLAMA SABLONU

	list		p=16f877A	
	#include	<p16f877A.inc>	
	
	__CONFIG H'3F31'

	
;kullanilacak degiskenler		

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
	
	BCF	INTCON,INTF
	
	CALL	ALTPROGRAM
	
	BSF	INTCON,GIE
	
	movf	status_temp,w
	movwf	STATUS
	movf	pclath_temp,w
	movwf	PCLATH
	swapf	w_temp,f
	swapf	w_temp,w
	retfie
;***********************************************************************************************
ALTPROGRAM
	
	MOVLW	b'00001000'
	XORWF	PORTB,F
	
	RETURN
	
;***********************************************************************************************
KESME_AYARLA
	BSF	INTCON,INTE
	BSF	INTCON,GIE
	
	BCF	OPTION_REG,INTEDG	;DUSEN KENAR OLARAK AYARLAMAK ICIN INTEDG YI SIFIRLADIK
					;YUKSELEN KENAR OLARAK AYARLAMAK ISTESEYDIK BSF ILE 1 VERIRDIK
	RETURN
;***********************************************************************************************
PORT_AYARLA
	
	BANKSEL	TRISB
	MOVLW	b'00000001'
	MOVWF	TRISB
	
	BANKSEL	PORTB
	CLRF	PORTB
	
	RETURN
;***********************************************************************************************	
BASLA	

	CALL	KESME_AYARLA
	CALL	PORT_AYARLA
	
XD	
	GOTO	XD
	END                       ; Program sonu


