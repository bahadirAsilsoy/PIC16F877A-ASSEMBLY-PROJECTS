#include    <p16f877a.inc>
    
  
;KULLANILACAK DEG?SKENLER
		    
TMR0_BAS	    EQU	    0x20    ;TMR0 ' IN BASLANGIC DEGERINI TUTMAK ICIN
KACKEZ		    EQU	    0x21    ;TMR0 ' IN CALISMA SAYISI
YATAYDIKEY	    EQU	    0x22    ;DOT MATR?XDE SATIRI MI SUTUNU MU YAKMAYA KARAR VERME ICIN
	    
;********************************************************************************
;KESME SIRASINDA YEDEKLEME YAPMAK ICIN KULLANILACAK DEGISKENLER	    
w_temp		    EQU	    0x7D
status_temp	    EQU	    0x7E
pclath_temp	    EQU	    0x7F	    
;********************************************************************************     
		    ORG	    0x000
		    
		    nop
		    
		    GOTO    BASLA
;********************************************************************************
	ORG	0x004
	
	movwf	w_temp		;w ' nin yedegini al
	movf	STATUS,w	;STATUS ' un yedegini almak icin omegaya y�kle
	movwf	status_temp	;STATUS ' u yedek register?na y�kle
	movf	PCLATH,w	;PCLATH' ,yedeklemek icin omegaya y�kle
	movwf	pclath_temp	;PCLATH' i yedek register?na y�kle
	
	BCF	INTCON,T0IF	;�nce kesme isaretini sifirla
	
	MOVLW	d'6'		;tmr0'?n bir kez daha calismasi icin degerini y�kle
	MOVWF	TMR0
	
	DECFSZ	KACKEZ,F
	GOTO	CIK
	CALL	BIR_SN_DOLDU	;kesme alt programini cagir
	
CIK	BSF	INTCON,GIE	;kesmenin calismasi icin GIE yi aktif et yani 1 yap
	
	movf	pclath_temp,w	;geri d�nmeden �nce t�m yedekleri y�kle
	movwf	PCLATH
	movf	status_temp,w
	movwf	STATUS	
	swapf	w_temp,f
	swapf	w_temp,w
	retfie			;kesmeden d�n
;********************************************************************************
BIR_SN_DOLDU
	
	BANKSEL	TMR0
	MOVLW	d'250'		;tekrar 1 sn calismasi icin kesme s?ras?nda cag?rd?g?m?z alt programda bu komutu tekrarl?yoruz.
	MOVWF	KACKEZ
	
	BTFSS	YATAYDIKEY,0	;yatay mi dikey mi kontrol� yap?l?yor
	GOTO	DIKEY
	
	MOVLW	b'00000001'	;7 satir da yanicak ve hepside yanicak.
	MOVWF	PORTB
	MOVLW	b'00011111'	;s�t�nlar yansin
	MOVWF	PORTC
	MOVLW	d'2'		;bir sonrakinde DIKEY'in calismasi icin 1 den farkl? bir deger y�kledik.
	MOVWF	YATAYDIKEY
	RETURN

DIKEY	
	MOVLW	b'01111111'	;s�t�nlar?n hepsi 
	MOVWF	PORTB
	MOVLW	b'00000001'	;bir satir
	MOVWF	PORTC
	MOVLW	d'1'
	MOVWF	YATAYDIKEY	;bir sonrakine yatay
	RETURN
;********************************************************************************	
TMR0_AYARLA
	BANKSEL	OPTION_REG
	MOVLW	b'00000011'	; prescaler ' i 1:16 ya ayarladik.
	MOVWF	OPTION_REG  
	BANKSEL	TMR0		; g�zel bir zaman hesaplamasi icin tmr0 ' i 6 dan baslattik.
	MOVLW	d'6'
	MOVWF	TMR0
	RETURN
;********************************************************************************
KESME_AYARLA
	BSF	INTCON,T0IE	;tmr0 gecikmesinin baslamasi icin T0IE ve GIE yi aktif ettik.
	BSF	INTCON,GIE
	RETURN
;********************************************************************************	
BASLA
	MOVLW	d'1'
	MOVWF	YATAYDIKEY
	
	MOVLW	d'250'
	MOVWF	KACKEZ
	
	CALL	TMR0_AYARLA
	CALL	KESME_AYARLA
	
	BANKSEL	TRISB		;PORTB ve PORTC yi cikis olarak ayarlad?k
	CLRF	TRISB
	CLRF	TRISC
	
	BANKSEL	PORTB		;PORTB ye deger yuklemek icin bank1 e gectik
	CLRF	PORTB
	CLRF	PORTC
	
DD	
	GOTO	DD
	
	END	    
		    
		    