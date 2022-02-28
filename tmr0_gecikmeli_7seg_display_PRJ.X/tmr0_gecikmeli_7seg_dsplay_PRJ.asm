#include    <p16f877a.inc>	    
 
;kullanilacak degiskinler
BIRLER		    EQU	    0x20
SAYAC_BIRLER	    EQU	    0x21
ONLAR		    EQU	    0x22
SAYAC_ONLAR	    EQU	    0x23		    
	    
KACKEZ		    EQU	    0x24		    
;kesme s?ras?nda yedekleme icin kullanilacak degiskenler
w_temp		    EQU	    0x7D
status_temp	    EQU	    0x7E
pclath_temp	    EQU	    0X7F
;*******************************************************************************    
	    ORG	    0x000
	    
	    nop
	    
	    GOTO    BASLA    
;*******************************************************************************
	    ORG	    0x004
	    
	    movwf   w_temp
	    movf    STATUS,w
	    movwf   status_temp
	    movf    PCLATH,w
	    movwf   pclath_temp
	    
	    BCF	    INTCON,T0IF
	    
	    MOVLW   d'6'
	    MOVWF   TMR0
	    
	    DECFSZ  KACKEZ,F
	    GOTO    CIK
	    CALL    YAZDIR
	    
    CIK	    
	    BSF	    INTCON,GIE
	    
	    movf    pclath_temp,w
	    movwf   PCLATH
	    movf    status_temp,w
	    movwf   STATUS
	    swapf   w_temp,f
	    swapf   w_temp,w
	    retfie
;*******************************************************************************
RAKAMLAR
	    ADDWF   PCL,F
	    RETLW   b'00111111' ;0
	    RETLW   b'00000110' ;1
	    RETLW   b'01011011' ;2
	    RETLW   b'01001111' ;3
	    RETLW   b'01100110' ;4
	    RETLW   b'01101101' ;5 
	    RETLW   b'01111101' ;6 
	    RETLW   b'00000111' ;7
	    RETLW   b'01111111' ;8
	    RETLW   b'01101111' ;9	    
;*******************************************************************************	    
YAZDIR	    
	    BANKSEL TMR0
	    MOVLW   d'250'
	    MOVWF   KACKEZ
	    
	    MOVLW   b'00000010'
	    MOVWF   PORTA
	    MOVLW   d'3'
	    CALL    RAKAMLAR
	    MOVWF   PORTB
	    
	    MOVLW   b'00000001'
	    MOVWF   PORTA
	    MOVLW   d'1'
	    CALL    RAKAMLAR
	    MOVWF   PORTB
	    RETURN
;*******************************************************************************	    
TMR0_AYARLA
	    BANKSEL OPTION_REG
	    MOVLW   b'00000011'
	    MOVWF   OPTION_REG
	    
	    BANKSEL TMR0
	    MOVLW   d'6'
	    MOVWF   TMR0
	    RETURN
;*******************************************************************************
KESME_AYARLA
	    BANKSEL INTCON
	    BSF	    INTCON,T0IE
	    BSF	    INTCON,GIE
	    RETURN
;*******************************************************************************	    
BASLA	
	    MOVLW   d'250'
	    MOVWF   KACKEZ
	    
	    CALL    TMR0_AYARLA
	    CALL    KESME_AYARLA
	    
	    BANKSEL PORTA
	    CLRF    PORTA
	    
	    BANKSEL TRISA
	    MOVLW   0x06
	    MOVWF   ADCON1
	    
	    MOVLW   b'00111100'
	    MOVWF   TRISA
	    
	    BANKSEL TRISB
	    CLRF    TRISB
	    
	    BANKSEL PORTB
	    CLRF    PORTB
	    
	    
	    
	    
    DD	    
	    GOTO    DD
	    END	
	  


