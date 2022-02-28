	;KODLAMA SABLONU

	list		p=16f877A	; hangi pic
	#include	<p16f877A.inc>	; SFR register 'lar?n tan?mland??? kutuphane
	
	__CONFIG H'3F31'

; WDT, ossilatör gibi register ayarlar?

	
;KULLANILACAK DEGISKENLER
D1		EQU	0x20
D2		EQU	0x21
D3		EQU	0x22
SOLSAG		EQU	0X23		

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
	MOVLW	0x03
	MOVWF	D3
	
LOOP3	MOVLW	0xFF
	MOVWF	D2
	
LOOP2	MOVLW	0xFF
	MOVWF	D1
	
LOOP	DECFSZ	D1,F
	GOTO	LOOP
	
	DECFSZ	D2,F
	GOTO	LOOP2
	
	DECFSZ	D3,F
	GOTO	LOOP3
	RETURN
;***********************************************************************************************
SSDON	
	BTFSC	SOLSAG,0
	GOTO	SAGAGIT
	GOTO	SOLAGIT
	
SOLAGIT	RLF	PORTB
	RETURN

SAGAGIT	RRF	PORTB
	RETURN
;***********************************************************************************************
SOLKONTROL
	BTFSS	PORTB,7
	RETURN
	MOVLW	0x01
	MOVWF	SOLSAG
	RETURN
;***********************************************************************************************
SAGKONTROL
	BTFSS	PORTB,0
	RETURN
	MOVLW	0x00
	MOVWF	SOLSAG
	RETURN
;***********************************************************************************************
BASLA	
	BCF	STATUS,C	    ; RRF VE RLF ELDE B?T? (C) ?LE DONUS YAPAR BU NEDENLE BA?TA ELDE B?T? SIFIRLANMALI
	BANKSEL	PORTB
	CLRF	PORTB
	
	BANKSEL	TRISB
	CLRF	TRISB
	
	BANKSEL	PORTB
	
	MOVLW	0x00
	MOVWF	SOLSAG
	MOVLW	0x01
	MOVWF	PORTB
	
XD	CALL	GECIKME
	CALL	SSDON
	CALL	SOLKONTROL
	CALL	SAGKONTROL
	GOTO	XD
	
	
	END                       ; Program sonu