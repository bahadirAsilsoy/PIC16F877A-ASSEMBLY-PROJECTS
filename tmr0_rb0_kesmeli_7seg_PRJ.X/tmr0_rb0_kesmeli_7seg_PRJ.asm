;KODLAMA SABLONU

	list		p=16f877A	
	#include	<p16f877A.inc>	
	
	__CONFIG H'3F31'

	
;kullanilacak degiskenler
KACKEZ		EQU	    0x20
BIRLER		EQU	    0x21
ONLAR		EQU	    0x22		
		
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
	
	BTFSC	INTCON,INTF
	GOTO	RB0_ALTPROGRAM
	
	BCF	INTCON,T0IF
	BCF	INTCON,INTF
	
	MOVLW	d'6'
	MOVWF	TMR0
	
	DECFSZ	KACKEZ,F
	GOTO	CIK
	CALL	TMR0_ALTPROGRAM
	
CIK	BSF	INTCON,GIE
	
	movf	status_temp,w
	movwf	STATUS
	movf	pclath_temp,w
	movwf	PCLATH
	swapf	w_temp,f
	swapf	w_temp,w
	retfie
;***********************************************************************************************
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
RB0_ALTPROGRAM
	
	MOVLW	b'00000001'
	MOVWF	PORTA
	MOVF	BIRLER,W
	CALL	RAKAMLAR
	MOVWF	PORTC
	INCF	BIRLER,F

	RETURN
;***********************************************************************************************
TMR0_ALTPROGRAM
	
	MOVLW	d'1'
	MOVWF	KACKEZ

	BANKSEL	PORTA		
	BTFSC	PORTA,0	
	GOTO	SIFIR
	GOTO	BIR

SIFIR	MOVLW   b'00000010'
	MOVWF   PORTA
	RETURN
	
BIR	MOVLW   b'00000001'
	MOVWF   PORTA
	RETURN

	RETURN
;***********************************************************************************************	
RB0_KESME_AYARLA
	BSF	INTCON,INTE
	BSF	INTCON,GIE
	
	BCF	OPTION_REG,INTEDG	;DUSEN KENAR OLARAK AYARLAMAK ICIN INTEDG YI SIFIRLADIK
					;YUKSELEN KENAR OLARAK AYARLAMAK ISTESEYDIK BSF ILE 1 VERIRDIK
	RETURN
;***********************************************************************************************
TMR0_AYARLA
	;PRESCALER DE?ER LAZIM OLURSA BURDA BSF KOMUTLARIYLA OPTION REG ÜZER?NDEN AYARLA
	BANKSEL    OPTION_REG
	BSF	OPTION_REG,0
	BSF	OPTION_REG,1
	
	BANKSEL	TMR0
	MOVLW	d'6'
	MOVWF	TMR0
	
	RETURN
;***********************************************************************************************
TMR0_KESME_AYARLA
	BSF	INTCON,T0IE
	BSF	INTCON,GIE
	RETURN
;***********************************************************************************************	
PORTA_AYARLA
	BANKSEL	TRISA
	MOVLW	0x06
	MOVWF	ADCON1
	
	MOVLW	b'00111100'
	MOVWF	TRISA
	
	BANKSEL	PORTA
	CLRF	PORTA
	
	RETURN
;***********************************************************************************************
PORTB_AYARLA
	BANKSEL	TRISB
	MOVLW	b'00000001'
	MOVWF	TRISB
	
	BANKSEL	PORTB
	CLRF	PORTB
	
	RETURN
;***********************************************************************************************
PORTC_AYARLA
	BANKSEL	TRISC
	CLRF	TRISC
	
	BANKSEL	PORTC
	CLRF	PORTC
	
	RETURN
;***********************************************************************************************	
BASLA	
	MOVLW	d'1'
	MOVWF	KACKEZ
	
	MOVLW	0x00
	MOVWF	BIRLER
	
	MOVLW	0x00
	MOVWF	ONLAR
	
	CALL	TMR0_AYARLA
	CALL	TMR0_KESME_AYARLA
	
	CALL	RB0_KESME_AYARLA
	
	CALL	PORTA_AYARLA
	CALL	PORTB_AYARLA
	CALL	PORTC_AYARLA
	
XD	
	GOTO	XD
	END                       ; Program sonu


