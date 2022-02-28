	;KODLAMA SABLONU

	list		p=16f877A	; hangi pic
	#include	<p16f877A.inc>	; SFR register 'lar?n tan?mland??? kutuphane
	
	__CONFIG H'3F31'

; WDT, ossilatör gibi register ayarlar?

	
;KULLANILACAK DEGISKENLER
D1		EQU	0x20
D2		EQU	0x21
D3		EQU	0x22		
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
	MOVLW	0x05
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
PORTA_AYARLA
	
	BANKSEL	TRISA
	MOVLW	0x06
	MOVWF	ADCON1
	
	MOVLW	b'00111111'
	MOVWF	TRISA
	
	BANKSEL PORTB
	
	RETURN
;***********************************************************************************************
PORTB_AYARLA
	
	BANKSEL	PORTB
	CLRF	PORTB
	BANKSEL	TRISB
	CLRF	TRISB
	
	BANKSEL	PORTB
	
	RETURN
;***********************************************************************************************
	
BASLA
	
	CALL	PORTA_AYARLA
	CALL	PORTB_AYARLA

KONTROL	
	BTFSS	PORTA,0
	GOTO	YAK_0
	BTFSS	PORTA,1
	GOTO	YAK_1
	BTFSS	PORTA,2
	GOTO	YAK_2
	BTFSS	PORTA,3
	GOTO	YAK_3
	BTFSS	PORTA,4
	GOTO	YAK_4
	BTFSS	PORTA,5
	GOTO	YAK_5
	GOTO	KONTROL
	
YAK_0	
	MOVLW	b'00000001'
	MOVWF	PORTB
	GOTO	TEKRAR
YAK_1
	MOVLW	b'00000010'
	MOVWF	PORTB
	GOTO	TEKRAR
YAK_2	
	MOVLW	b'00000100'
	MOVWF	PORTB
	GOTO	TEKRAR
YAK_3	
	MOVLW	b'00001000'
	MOVWF	PORTB	
	GOTO	TEKRAR
YAK_4	
	MOVLW	b'00010000'
	MOVWF	PORTB
	GOTO	TEKRAR
YAK_5	
	MOVLW	b'00100000'
	MOVWF	PORTB
	GOTO	TEKRAR	
	
TEKRAR	
	GOTO KONTROL
	
	
	END                       ; Program sonu