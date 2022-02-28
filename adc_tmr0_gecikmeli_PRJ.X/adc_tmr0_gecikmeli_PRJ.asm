;ADC SABLONU

	    list		p=16f877A	
	    #include	<p16f877A.inc>	

    ;KULLANILACAK DEGISKENLER
    
    KACKEZ	EQU	0x20
   
    w_temp	EQU	0x7D		
    status_temp	EQU	0x7E		
    pclath_temp	EQU	0x7F					
    ;********************************************************************************************
	    ORG     0x000             	

	    nop			  			  	
	    goto    BASLA              

    ;**********************************************************************************************
	    ORG     0x004             	

	    movwf   w_temp            	
	    movf    STATUS,w          	
	    movwf   status_temp       	
	    movf    PCLATH,w	  		
	    movwf   pclath_temp	  		

	    BCF	INTCON,T0IF
	
	    DECFSZ  KACKEZ,F
	    GOTO    CIK
	    CALL    ADC_OKU
	    
	    MOVLW   d'20'
	    MOVWF   KACKEZ
    CIK	    
	    BSF	INTCON,GIE
	    movf    pclath_temp,w	  	
	    movwf   PCLATH		  		
	    movf    status_temp,w     	
	    movwf   STATUS            	
	    swapf   w_temp,f 
	    swapf   w_temp,w          	
	    retfie                    	
    ;***********************************************************************************************
    ADC_AYARLA  
	    ;FOSC/2 SECMEK ICIN 0-00 DEGERI YUKLICEZ
	    ;FOSC/4 SECMEK ICIN 1-00 DEGERI YUKLICEZ
	    ;FOSC/8 SECMEK ICIN 0-01 DEGERI YUKLICEZ
	    ;FOSC/16 SECMEK ICIN 1-01 DEGERI YUKLICEZ
	    ;FOSC/32 SECMEK ICIN 0-10 DEGERI YUKLICEZ
	    ;FOSC/64 SECMEK ICIN 1-10 DEGERI YUKLICEZ
	    ;SABLONDA FOSC/32 KULLANMISIZ
	    BANKSEL ADCON0
	    MOVLW   b'10001001'	; ADCON0'IN 3,4,5 BITINDEN POTU BAGLADIGIN YERE GORE AYAR YAP. BURDA RA1/AN1 ICIN AYAR YAPMISIM.
	    MOVWF   ADCON0

	    BANKSEL ADCON1
	    MOVLW   b'10000000'
	    MOVWF   ADCON1
	    
	    ;TRISA'NIN HEPSINI GIRIS YAPALIM
	    BANKSEL TRISA
	    MOVLW   b'11111111'
	    MOVWF   TRISA

	    RETURN
    ;***********************************************************************************************
    ADC_OKU
	    ;GO/DONE 'I YANI ADCNIN FLAGINI 1 YAPALIM
	    BANKSEL ADCON0
	    BSF	    ADCON0,GO

	    ;GO/DONE 0 OLANA KADAR YANI ADCNIN BAYRAGI 0 OLANA KADAR DONGUYE ALDIK. 1 OLUNCA DONGUDEN CIKACAK.
    DONGU   BTFSC   ADCON0,GO
	    GOTO    DONGU

	    BANKSEL ADRESH
	    MOVF    ADRESH,W ;SAYI H YERINE 2 LED OLAN PORTA YAZDIR. MESELA PORTBDE OLSUN BANKSEL PORTB MOVWF PORTB YAP.
	    BANKSEL PORTC
	    MOVWF   PORTC

	    BANKSEL ADRESL
	    MOVF    ADRESL,W ;SAYI L YERINE 8 LED OLAN PORTA YAZDIR. MESELA PORTCDE OLSUN BANKSEL PORTC MOVWF PORTC YAP.
	    BANKSEL PORTB
	    MOVWF   PORTB

	    RETURN
    ;***********************************************************************************************
    PORT_AYARLA
	    
	    BANKSEL TRISB
	    CLRF    TRISB
	    CLRF    TRISC
	    BANKSEL PORTB
	    CLRF    PORTB
	    CLRF    PORTC
    
	    RETURN
    ;***********************************************************************************************
    TMR0_AYARLA
	    BANKSEL OPTION_REG
	    MOVLW   b'00000001' ;PRESCALAR AYARLAMA
	    MOVWF   OPTION_REG
	
	    BANKSEL TMR0    ;TMR0 AYARLAMA
	    MOVLW   d'6'
	    MOVWF   TMR0
	    
	    MOVLW   d'20'   ;COUNTER AYARLAMA
	    MOVWF   KACKEZ 
	    
	    BSF	    INTCON,T0IE
	    BSF	    INTCON,GIE
	    
	    RETURN
    ;***********************************************************************************************
    BASLA
	    CALL    PORT_AYARLA
	    CALL    TMR0_AYARLA
	    CALL    ADC_AYARLA
    
    XD	 
	    GOTO    XD

	    END                       ; Program sonu


