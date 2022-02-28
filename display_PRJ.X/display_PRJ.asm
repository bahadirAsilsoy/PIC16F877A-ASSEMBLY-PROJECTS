	;KODLAMA SABLONU

	list		p=16f877A	; hangi pic
	#include	<p16f877A.inc>	; SFR register 'lar?n tan?mland??? kutuphane
	
	__CONFIG H'3F31'

; WDT, ossilatör gibi register ayarlar?

	
;KULLANILACAK DEGISKENLER
	
VAR_1	EQU 0x20
VAR_2	EQU 0x21
VAR_3	EQU 0x22
VAR_4	EQU 0x23
	
VAR_SOL	EQU 0x24
VAR_SAG	EQU 0x25
	
VAR_TMP	EQU 0x26
	
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
	MOVLW	0xC8
	MOVWF	VAR_3
	
LOOP3	MOVLW	0x07
	MOVWF	VAR_2
	
LOOP2	MOVLW	0xFF
	MOVWF	VAR_1
		
LOOP1	DECFSZ	VAR_1,F
	GOTO	LOOP1
	
	DECFSZ	VAR_2,F
	GOTO	LOOP2
	
	BTFSC	PORTA,0
	CALL	SUPURME_2
	CALL	SUPURME_1
	
	DECFSZ	VAR_3,F
	GOTO	LOOP3

	RETURN
;***********************************************************************************************
SUPURME_1
	MOVLW	b'00000010'
	MOVWF	PORTA
	RETURN
SUPURME_2
	MOVLW	b'00000001'
	MOVWF	PORTA
	RETURN
;***********************************************************************************************
PORTA_AYARLA
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
CONF?G
ADDWF	PCL,F
RETLW	0x3F	;0
RETLW	0x06 	;1	
RETLW	0x5B	;2
RETLW	0x4F	;3
RETLW	0x66	;4
RETLW	0x6D	;5  
RETLW	0x7D	;6  
RETLW	0x07	;7
RETLW	0x7F	;8
RETLW	0x6F	;9
;***********************************************************************************************
KONTROL
	MOVLW	d'9'
	ANDWF	PORTB,0
	MOVWF	VAR_TMP
	BTFSS	VAR_TMP,0
	CALL	SAG_ARTTIR
	CALL	SOL_ARTTIR
	RETURN
;***********************************************************************************************
SAG_ARTTIR
	INCF	VAR_SAG,F
	RETURN	
SOL_ARTTIR
	INCF	VAR_SOL,F
	RETURN
;***********************************************************************************************	
BASLA	
	CALL	PORTA_AYARLA
	CALL	PORTB_AYARLA
	
DD	CALL	GECIKME
	CALL	KONTROL
	GOTO	DD
	
	END                       ; Program sonu