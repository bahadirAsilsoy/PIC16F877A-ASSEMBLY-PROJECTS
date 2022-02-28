#include    <p16f877a.inc>
    
;BUTONA HER BASILDI?INDA 00' I 1 ARTTIRMA        
D1	    EQU		0x20
D2	    EQU		0x21
D3	    EQU	    	0x23
	    
BIRLER	    EQU		0x24
ONLAR	    EQU		0x25
	    
;******************************************************************************	    
	ORG   0x000
	        
	nop
	    
	GOTO    BASLA
;******************************************************************************
GECIKME
	MOVLW	0xCC
	MOVWF	D1
	
LOOP	DECFSZ	D1,F
	GOTO	LOOP
	RETURN
;******************************************************************************	
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
;******************************************************************************
ARTTIR
	MOVLW	b'00000101'
	MOVWF	PORTA
	INCF	BIRLER,F
	MOVF	BIRLER,W
	CALL	RAKAMLAR
	MOVWF	PORTB
	CALL	GECIKME
	RETURN
;******************************************************************************	
BASLA
	;PORTA AYARLA
	BANKSEL	PORTA
	CLRF	PORTA
	
	BANKSEL	TRISA
	MOVLW	0x06
	MOVWF	ADCON1
	
	MOVLW	b'00000100'
	MOVWF	TRISA
	
	;PORTB AYARLA
	
	BANKSEL	TRISB
	CLRF	TRISB
	
	BANKSEL	PORTB
	CLRF	PORTB
	
	;DEG?SKENLER? AYARLA
	
	MOVLW	0x00
	MOVWF	BIRLER
	
	MOVLW	0x00
	MOVWF	ONLAR
	
	
DONGU	MOVLW	b'00000101'
	MOVWF	PORTA
	MOVF	BIRLER,W
	CALL	RAKAMLAR
	MOVWF	PORTB
	CALL	GECIKME
	
	MOVLW	b'00000110'
	MOVWF	PORTA
	MOVF	ONLAR,W
	CALL	RAKAMLAR
	MOVWF	PORTB
	CALL	GECIKME
	CALL	DONGU
	
KONTROL	BTFSC	PORTA,2
	CALL	ARTTIR
	CALL	GECIKME
	CALL	GECIKME
	CALL	GECIKME
	CALL	GECIKME
	GOTO	KONTROL
	

	END


