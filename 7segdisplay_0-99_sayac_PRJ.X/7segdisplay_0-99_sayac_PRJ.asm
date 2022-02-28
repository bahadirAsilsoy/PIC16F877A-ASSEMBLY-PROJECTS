	;KODLAMA SABLONU

	list		p=16f877A	; hangi pic
	#include	<p16f877A.inc>	; SFR register 'lar?n tan?mland??? kutuphane
	
	__CONFIG H'3F31'

; WDT, ossilatÃ¶r gibi register ayarlar?

	
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
	
LOOP2	MOVLW	0x77
	MOVWF	D1
	
LOOP	DECFSZ	D1,F
	GOTO	LOOP
	
	DECFSZ	D2,F
	GOTO	LOOP2
	RETURN
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
BASLA	
	;PORT A YI AYARLA
	
	BANKSEL	TRISA
	MOVLW	0x06
	MOVWF	ADCON1
	
	MOVLW	b'00111100'
	MOVWF	TRISA
	;PORT B YI AYARLA
	BANKSEL TRISB
	CLRF	TRISB
	
	BANKSEL	PORTB
	CLRF	PORTB
	
	MOVLW	0X00		;birler basama?? 
	MOVWF	BIRLER

	MOVLW	0X09		;birler basama?? sayaç?
	MOVWF	SAYAC_BIRLER		;her 9 oldu?unda 0 a dönmesi için 

	MOVLW	0X00		;onlar basama?? (soldaki 7segment)
	MOVWF	ONLAR

	MOVLW	0X0A		;onlar basama?? sayac? 9 oldugunda 0 a dönsün
	MOVWF	SAYAC_ONLAR
	
DONGU1	MOVLW	b'00000001'
	MOVWF	PORTA		;porta,1 clear seçme ucuna gelen ver?y? okuyacakt?r
	INCF	BIRLER,F		;birler basama?? 1-1 artacakt?r
	MOVF	BIRLER,W	;birler basama??n?n anl?k de?eri workinge yüklenip
	CALL	RAKAMLAR	;rakamlardan de?er al?nacakt?r
	MOVWF	PORTB
	CALL	GECIKME

	MOVLW	b'00000010'	;onlar basama?? için porta,0 seçim ucu kullan?lm??t?r
	MOVWF	PORTA		;birler basama?? set edip kapand???nda onlar basama??na yaz?lacakt?r de?er
	MOVF	ONLAR,W		;lookup table dan de?er al?nacakt?r
	CALL	RAKAMLAR
	MOVWF	PORTB
	CALL	GECIKME
	DECFSZ	SAYAC_BIRLER		;her dongude sayac birler 1-1 azalacakt?r
	CALL	DONGU1
	
	MOVLW	0x00
	MOVWF	BIRLER
	
	MOVLW	0x09
	MOVWF	SAYAC_BIRLER
	
DONGU2	MOVLW	b'00000010'	;?imdi yapmam?z gereken soldaki rakam? yani onlar basama??n?
	MOVWF	PORTA		;1 art?rmak bu sayede 9 dan sonra 10
	INCF	ONLAR		; 19 dan sonra 20 .... 89 dan sonra 90 gelecektir
	MOVF	ONLAR,W
	CALL	RAKAMLAR
	MOVWF	PORTB
	CALL	GECIKME
	DECFSZ	SAYAC_ONLAR		;sayac onlarda s?f?r olduysa demektirki 99 say?s?n? görüyoruz ?imdi bütün i?lemleri ba?a almam?z gerekiyor
	CALL	DONGU1
	
	MOVLW	0x00		;99 olduysa bütün de?erleri ba?tan yükleyip ilk döngüye tekrar dallan?yoruz
	MOVWF	BIRLER

	MOVLW	0x09
	MOVWF	SAYAC_BIRLER

	MOVLW	0x00
	MOVWF	ONLAR

	MOVLW	0x0A
	MOVWF	SAYAC_ONLAR
	CALL	DONGU1
	END                       ; Program sonu