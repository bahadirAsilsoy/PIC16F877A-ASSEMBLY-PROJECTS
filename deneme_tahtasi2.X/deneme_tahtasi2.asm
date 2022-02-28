	;M?KRO ??LEMC? ÖDEV?
	list		p=16f877A	; hangi pic
	#include	<p16f877A.inc>	; SFR register 'lar?n tan?mland??? kutuphane
	
	__CONFIG H'3F31'    ; WDT, ossilat?r gibi register ayarlar?

	
;KULLANILACAK DEGISKENLER

			       ;Degisken kullanmak icin GPR alan?nda istediginiz adresi yazabilirsiniz
BASAMA		EQU	0x20
SAYI1		EQU	0x21
SAYI2		EQU	0x22

;*** Kesme durumunda kaydedilmesi gereken SFR ler icin kullanilacak yardimci degiskenler
w_temp		EQU	0x7D		
status_temp	EQU	0x7E		
pclath_temp	EQU	0x7F					


;********************************
	ORG     0x000             	; Baslama vektoru

	nop			  			  	; ICD ozelliginin aktif edilmesi icin gereken bekleme 
  	goto    BASLA              	; As?l kodlar?n yazili oldugu baslama etiketine git

	
;********************************
	ORG     0x004             	; kesme vektoru
	 ; yedekler depola
	MOVWF	w_temp	
	MOVF   STATUS,W
	MOVWF  status_temp
	MOVF	PCLATH,W
	MOVWF	pclath_temp
	
	; Timer 0 kesmesi olduktan sonra yineden ona de?er atmak gerek 
	MOVLW	D'100'
	MOVWF	TMR0
	
	;button bas?ld??? zaman RB0 kesmesinin bayra?? 1 olur
	BTFSC	INTCON,INTF	;e?er RB0 kesmesinin bayra?? 0 ise atla (button bas?lmad? demek) 1 ise devam et
	CALL	ARTIR
	BTFSC   INTCON,T0IF	;e?er Timer 0 kesmesi 0 ise atla (Timer kesmesi yok demek) 1 ise devam et
	CALL	CALISTIR
	
	
CIK 
	; yedekler geri al
	MOVF pclath_temp,W
	MOVWF PCLATH
	MOVF status_temp,W
	MOVWF STATUS
	SWAPF w_temp,F
	SWAPF w_temp,W
	RETFIE

;*********************************

ARTIR
	BCF	INTCON,INTF 

	INCF	SAYI1	
	CALL	BIRTEST	
	RETURN

BIRTEST

	BCF	STATUS,Z
	MOVLW	0x0A
	SUBWF	SAYI1,W
	BTFSC	STATUS,Z
	CALL	ONARTIR
	RETURN
ONARTIR	
	MOVLW	0x0A
	SUBWF	SAYI1,F 
	INCF	SAYI2   
	CALL	ONTEST	
	RETURN

ONTEST
	BCF	STATUS,Z
	MOVLW	0x0A
	SUBWF	SAYI2,W
	BCF	STATUS,C
	BTFSC	STATUS,Z
	CLRF	SAYI2
	RETURN
;********************************

CALISTIR
	    BCF	    INTCON,T0IF	
	
	    BTFSS   BASAMA,0	    
	    GOTO    BASAMA1
	 
	    MOVLW   B'11111110'
	    MOVWF   PORTD
	    MOVF    SAYI2,W
	    CALL    LOOKUPTABLE
	    MOVWF   PORTC
	  
	    MOVLW   D'2'
	    MOVWF   BASAMA
	    RETURN
	 
BASAMA1	
	 
	    MOVLW   B'11111101'
	    MOVWF   PORTD
	    MOVF    SAYI1,W
	    CALL    LOOKUPTABLE
	    MOVWF   PORTC
	 
	    MOVLW   D'1' 
	    MOVWF   BASAMA	
	    RETURN
	 
;*********************************
LOOKUPTABLE
	    ADDWF   PCL,F
	    RETLW   0x3F
	    RETLW   0x06
	    RETLW   0x5B
	    RETLW   0x4F
	    RETLW   0x66
	    RETLW   0x6D
	    RETLW   0x7D
	    RETLW   0x07
	    RETLW   0x7F
	    RETLW   0x6F   
	 
;***********************************

	    
TMR0AYARLA

	    BANKSEL OPTION_REG
	    MOVLW   B'01000100'	    
	    MOVWF   OPTION_REG
	    
	    BANKSEL TMR0
	    MOVLW   D'100'	
	    MOVWF   TMR0
	    
	    RETURN
	    
KEMSEAYARLA
	    BSF INTCON,T0IE 
	    BSF INTCON,INTE 
	    BSF INTCON,GIE 
	    
	    RETURN

;********************************	
BASLA
	    BANKSEL	TRISB
	    MOVLW   0x01
	    MOVWF   TRISB	    
	    CLRF    TRISC	    
	    CLRF    TRISD	    
	    
	   
	    BANKSEL PORTB
	    CLRF    PORTC
	    CLRF    PORTD
	    CLRF    PORTB
	    
	    
	    MOVLW   0x02
	    MOVWF   BASAMA
	    
	  
	    MOVLW   0x00
	    MOVWF   SAYI1 
	    MOVLW   0x00
	    MOVWF   SAYI2
	    
	
	    CALL    TMR0AYARLA
	    CALL    KEMSEAYARLA
	   
BITME
	    GOTO    BITME


	END


