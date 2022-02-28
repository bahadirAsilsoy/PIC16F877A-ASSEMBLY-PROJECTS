;KODLAMA SABLONU

	list		p=16f877A	; hangi pic
	#include	<p16f877A.inc>	; SFR register 'lar?n tan?mland??? kutuphane
	
	__CONFIG H'3F31'

; WDT, ossilatör gibi register ayarlar?

	
;KULLANILACAK DEGISKENLER
D1		EQU	0x20
D2		EQU	0x21	
D3		EQU	0x22		    

BIRLER		EQU	0x23
ONLAR		EQU	0x24
SAYAC_BIRLER	EQU	0x25
SAYAC_ONLAR	EQU	0x26    	
;***** Kesme durumunda kaydedilmesi gereken SFR ler icin kullanilacak yardimci degiskenler
w_temp		EQU	0x7D		
status_temp	EQU	0x7E		
pclath_temp	EQU	0x7F					


;********************************************************************************************
	ORG     0x000             	; Baslama vektoru

	nop			  			  	; ICD ozelliginin aktif edilmesi icin gereken bekleme 
  	goto    BASLA              	; baslama etiketine gir

	
;**********************************************************************************************
	ORG     0x004             	; kesme vektoru

	movwf   w_temp            	; W n?n yedegini al
	movf	STATUS,w          	; Status un yedegini almak icin onu once W ya al
	movwf	status_temp       	; Status u yedek register '?na al
	movf	PCLATH,w	  		; PCLATH '? yedeklemek icin onu once W 'ya al
	movwf	pclath_temp	  		; PCLATH '? yedek register a al

	; gerekli kodlar

	movf	pclath_temp,w	  	; Geri donmeden once tum yedekleri geri yukle
	movwf	PCLATH		  		
	movf    status_temp,w     	
	movwf	STATUS            	
	swapf   w_temp,f
	swapf   w_temp,w          	
	retfie                    	; Kesme 'den don
;***********************************************************************************************

GECIKME
	MOVLW	0x55
	MOVWF	D2
	
LOOP2	MOVLW	0x55
	MOVWF	D1
	
LOOP	DECFSZ	D1,F
	GOTO	LOOP
	
	DECFSZ	D2,F
	GOTO	LOOP2
	
	RETURN
;***********************************************************************************************
PORTA_AYARLA
	BANKSEL	PORTA
	CLRF	PORTA
	
	BANKSEL	TRISA
	MOVLW	0x06
	MOVWF	ADCON1
	
	MOVLW	b'00111100'
	MOVWF	TRISA
	RETURN
;***********************************************************************************************
PORTB_AYARLA
	BANKSEL	TRISB
	CLRF	TRISB
	
	BANKSEL	PORTB
	CLRF	PORTB
	RETURN
;***********************************************************************************************
KATOT_LOOKUP
	ADDWF	PCL,F
	RETLW	b'00111111'	;0
	RETLW	b'00000110'	;1    
	RETLW	b'01011011'	;2
	RETLW	b'01001111'	;3
	RETLW	b'01100110'	;4
	RETLW	b'01101101'	;5  
	RETLW	b'01111101'	;6
	RETLW	b'00000111'	;7
	RETLW	b'01111111'	;8
	RETLW	b'01101111'	;9
;***********************************************************************************************
ARTTIR	
	MOVLW	0x00
	MOVWF	BIRLER
	
	MOVLW	0x09
	MOVLW	SAYAC_BIRLER
	
	MOVLW	0x00
	MOVWF	ONLAR
	
	MOVLW	0X0A
	MOVWF	SAYAC_ONLAR
	
DONGU1	MOVLW	b'00000001'
	MOVWF	PORTA
	INCF	BIRLER,F
	MOVF	BIRLER,W
	CALL	KATOT_LOOKUP
	MOVWF	PORTB
	CALL	GECIKME
	
	MOVLW	b'00000010'
	MOVWF	PORTA
	INCF	ONLAR,W
	CALL	KATOT_LOOKUP
	MOVWF	PORTB
	CALL	GECIKME
	DECFSZ	SAYAC_BIRLER
	CALL	DONGU1
	
	MOVLW	0x00
	MOVWF	BIRLER
	
	MOVLW	0x09
	MOVWF	SAYAC_BIRLER
	
DONGU2	
	MOVLW	b'00000010'
	MOVWF	PORTA
	INCF	ONLAR,F
	MOVF	ONLAR,W
	CALL	KATOT_LOOKUP
	MOVWF	PORTB
	CALL	GECIKME
	DECFSZ	SAYAC_ONLAR
	CALL	DONGU1
	
	MOVLW	0x00
	MOVWF	BIRLER
	
	MOVLW	0x09
	MOVLW	SAYAC_BIRLER
	
	MOVLW	0x00
	MOVWF	ONLAR
	
	MOVLW	0X0A
	MOVWF	SAYAC_ONLAR
	CALL	DONGU1
	RETURN
;***********************************************************************************************	
BASLA
	CALL	PORTA_AYARLA
	CALL	PORTB_AYARLA
	

DON	CALL	ARTTIR
	GOTO	DON
	
	END                       ; Program sonu


