#include <p16f877A.inc>
tmr_sureuzat EQU 0x20
w_temp EQU 0x7D
status_temp EQU 0x7E
pclath_temp EQU 0x7F

	org 0x000
        goto BAS
	
	org 0x004
	movwf w_temp
	movf STATUS,W
	movwf status_temp
	movf PCLATH,W
	movwf pclath_temp
	bcf INTCON, T0IF ;tmr0 flag s?f?r


	decfsz tmr_sureuzat,F ;tmr0 suresini 20 kez uzat. 
	goto SON

	call ADC_OKU ;20msn doldu
	movlw d'20' ;Uzatma bitip kod çal???nca tmr_sureuzat de?i?keni tekrar 20 olsun.
	movwf tmr_sureuzat
	
SON
	bsf INTCON,T0IF
	movf pclath_temp,W
	movwf PCLATH
	movf status_temp,W
	movwf STATUS
	swapf w_temp,F
	swapf w_temp,W
	retfie


ADC_OKU
	banksel ADCON0
	bsf ADCON0,2 ;godone'? 1 yaparak analog veri okumay? ba?lat.
DD  btfsc ADCON0,2 ; godone okumay? bitirip 0 olana kadar dön.
	goto DD

	banksel ADRESH
	movf ADRESH,W
	movwf PORTC
	banksel ADRESL
	movf ADRESL,W
	movwf PORTB
	return



ADC_AYAR
	banksel ADCON0 ;porta n?n 0. bitinden (AN0 portu) analog veri als?n.
	movlw b'10000001' ;kanal an0, godone kurulumda 0, adon 1
	movwf ADCON0
	
	banksel ADCON1
	movlw b'10000000' ;örnekleme frekans? fosc/32, sa?a dayal? yaz?m.
	movwf ADCON1
	return

TMR_AYAR
	;gecikme 20 msn olsun
	banksel OPTION_REG
	movlw b'00000001' ;prescalar 4
	movwf OPTION_REG
	banksel TMR0
	movlw 0x06 ;250 defa say
	movwf TMR0
	movlw d'20'
	movwf tmr_sureuzat ;(1mikrosn*4*250*20=20000mikrosn=20msn)
	
	bsf INTCON, T0IE ;tmr interrupt aktif
	bsf INTCON, GIE ;interruptlar aktif
	return

BANK_AYAR
	banksel TRISB ;portb ve portc output
	clrf TRISB
	clrf TRISC
	banksel PORTB
	clrf PORTB
	clrf PORTC
	return

BAS
	call ADC_AYAR
	call BANK_AYAR
	call TMR_AYAR


DONGU

	goto DONGU
    
end
	
	
    


