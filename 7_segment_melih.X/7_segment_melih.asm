 ;butona basildiginda 1 arttiriyor supurme teknigini kullaniyor
    LIST P=16F877A
#INCLUDE <P16F877A.INC>
 
 
 ORG 0X00
 GOTO	BASLA
 
 
 ;DEGISKENKER
 
 DEGISKEN1  EQU	0X20
 DEGISKEN2  EQU	0X21
 DEGISKEN3  EQU	0X22
 BIRLER	    EQU	0X23
 ONLAR	    EQU	0X24
 
 
 ;DEGISKEBNLER
 TABLO
    ADDWF   PCL,F
    RETLW   0X3F
    RETLW   0X06
    RETLW   0X5B
    RETLW   0X4F
    RETLW   0X66
    RETLW   0X6D
    RETLW   0X7D
    RETLW   0X07
    RETLW   0X7F
    RETLW   0X6F
    
 
 YUKLE
    MOVLW   0X16
    MOVWF   DEGISKEN1
    MOVLW   0X3A
    MOVWF   DEGISKEN2
    GOTO    DONGU
 
 DONGU
    DECFSZ  DEGISKEN1,F
    GOTO    DONGU
    DECFSZ  DEGISKEN2,F
    GOTO    DONGU
    RETURN
 
 
 BASLA
    CLRF    PORTB
    BANKSEL TRISB
    CLRF    TRISB
    MOVLW   0X06
    MOVWF   ADCON1
    CLRF    TRISA
    BSF	    TRISA,3
    BANKSEL PORTA
    ;MOVLW   B'00000101'
    ;MOVWF   PORTA
    ;MOVLW   0X6D
    ;MOVWF   PORTB
    MOVLW   0X00
    MOVWF   BIRLER
    MOVLW   0X00
    MOVWF   ONLAR
 
    
    SUPUR
	MOVLW   B'00000101'
	MOVWF   PORTA
	MOVF	BIRLER,W
	CALL	TABLO
	MOVWF   PORTB
	;CALL	YUKLE
	CALL	YUKLE
	
	MOVLW   B'00000110'
	MOVWF   PORTA
	MOVF	ONLAR,W
	CALL	TABLO
	MOVWF	PORTB
	CALL	YUKLE
	;CALL	YUKLE
	;CALL	YUKLE
	
	BTFSC	PORTA,2
	GOTO	SUPUR
	CALL	YUKLE
	CALL	YUKLE
	CALL	YUKLE
	CALL	YUKLE
	INCF	BIRLER,F
	MOVF	BIRLER,W
	CALL	TABLO
	MOVWF	PORTB
	GOTO	SUPUR
	
 END
 