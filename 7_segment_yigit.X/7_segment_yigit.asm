list		p=16f877A	
#include	<p16f877A.inc>	
	
;*******************************************************************************
GECIKME1	EQU	0x20   
GECIKME2	EQU	0x21   
GECIKME3	EQU	0x22  
	
GECIKME4	EQU	0x23   
GECIKME5	EQU	0x24   

RIGHT_SEG	EQU	0x25
LEFT_SEG	EQU	0x26
	
TEMP		EQU	0x27	
ONE_DIGIT_COUNTER	EQU	0x28
TEN_DIGIT_COUNTER	EQU	0x29	
;*******************************************************************************
    ORG     0x000             	
    NOP	
    GOTO    START              	
;*******************************************************************************
ONE_SECOND_DELAY
    MOVLW	0x50
    MOVWF	GECIKME1	
DONGU1	
    MOVLW	0x10
    MOVWF	GECIKME2
DONGU2    
    MOVLW	0xFF
    MOVWF	GECIKME3
DONGU3
    DECFSZ	GECIKME3,1
    GOTO	DONGU3
    
    DECFSZ	GECIKME2,1
    GOTO	DONGU2
			    ; TAM BU NOKTADA 0,5 MILLISECOND BEKLEME YAŞANMIŞ OLUR
    CALL	SUPURME
    MOVWF	PORTA	   ;PORT A DEĞİŞİKLİĞİ YAPILDI
    CALL	R_OR_L	   ;AKTİF PORTUN KONTROLÜ YAPILDI VE SOL İSE 0X25 SAĞ İSE 0X26 ALINDI W REG'INE KOYULDU 
    MOVWF	TEMP	   ; TEMP DEĞİŞKENİNE HANGİ DİSPLAYİN GÖSTERİLECEĞİ BİLGİSİ VERİLDİ (ADRES BİLGİSİ)
    CALL	GET_CUR_DISP_VAL  ; ŞUANKİ DİSPLAYİN DEĞERİ ALINDI
    CALL	CONFIG_TABLE	   ; TABLE'DAN İLGİLİ DIPLAY DEĞERİ ALINIR 
    MOVWF	PORTB	; İLGİLİ DEĞER PORTB'YE YÜKLENİR
    
    DECFSZ	GECIKME1,1
    GOTO	DONGU1
			; TAM BU NOKTADA 1 SECOND BEKLEME YAŞANMIŞ OLUR
    RETURN
;*******************************************************************************
SUPURME
    BANKSEL	PORTA		
    BTFSC	PORTA,0	; PORT'A NIN 0. BIT'I EĞER SIFIRSA 10 DURUMUNDADIR EĞER DEĞİLSE 01 DURUMUNDADIR
    RETLW	0x02	;  01'İ 10 YAPARIM
    RETLW	0x01	;  10'I 01 YAPARIM
;*******************************************************************************
R_OR_L
    BTFSC	PORTA,0 ; PORT'A NIN DURUMUNA GÖRE HANGİ LED'IN REGISTER ADRESINI ALACAĞIMA KARAR VERİYORUM
    RETLW	0x25	; 01'SE 0x25'i ALIYORUM  SAĞ SEGMENT   
    RETLW	0x26	; 10'SA 0x26'yı ALIYORUM    SOL SEGMENT
;*******************************************************************************
GET_CUR_DISP_VAL
    BTFSC	TEMP,0
    GOTO	$+2
    MOVF	0x26,0
    BTFSS	TEMP,0
    GOTO	$+2
    MOVF	0x25,0
    RETURN
;*******************************************************************************
CONFIG_TABLE
    ADDWF	PCL,1
    RETLW	0x3F ; 0
    RETLW	0x06 ; 1
    RETLW	0x5B ; 2
    RETLW	0x4F ; 3
    RETLW	0x66 ; 4
    RETLW	0x6D ; 5
    RETLW	0x7D ; 6
    RETLW	0x07 ; 7
    RETLW	0x7F ; 8
    RETLW	0x6F ; 9
;*******************************************************************************     
PORT_A_AYARLA
    BANKSEL	TRISA
    MOVLW	0x06 
    MOVWF	ADCON1 
    MOVLW	b'00111100' 
    MOVWF	TRISA
    BANKSEL	PORTA
    CLRF	PORTA
    MOVLW	b'00000010'
    MOVWF	PORTA  
    RETURN
;*******************************************************************************	     
PORT_B_AYARLA
    BANKSEL	TRISB
    CLRF	TRISB
    BANKSEL	PORTB
    CLRF	PORTB
    RETURN
;*******************************************************************************           
START
    MOVLW	0x0A
    MOVWF	ONE_DIGIT_COUNTER
    MOVLW	0x0A
    MOVWF	TEN_DIGIT_COUNTER
    CALL	PORT_A_AYARLA
    CALL	PORT_B_AYARLA
;*******************************************************************************   
KONTROL
    CALL	ONE_SECOND_DELAY
    INCF	RIGHT_SEG,1
    DECFSZ	ONE_DIGIT_COUNTER,1
    GOTO	$-3
    INCF	LEFT_SEG,1
    CLRF	RIGHT_SEG
    MOVLW	0x0A
    MOVWF	ONE_DIGIT_COUNTER
    
    DECFSZ	TEN_DIGIT_COUNTER,1
    GOTO	KONTROL
    MOVLW	0x0A
    MOVWF	TEN_DIGIT_COUNTER
    GOTO	KONTROL
    END                    