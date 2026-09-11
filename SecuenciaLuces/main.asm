; Programa que implementa ocho patrones de secuencia de luces;
; Los patrones son seleccionados mediante RA2, RA1 y RA0.
; Los LEDs están conectados al PORTB.
; Autor: Alejandro Perez y yojan bolaños
; Institución: Universidad del Cauca
; Fecha: 10-09-2026
    
LIST	P=16f887
#include "p16f887.inc"

; CONFIG1
; __config 0x3FC5
 __CONFIG _CONFIG1, _FOSC_INTRC_CLKOUT & _WDTE_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOREN_ON & _IESO_ON & _FCMEN_ON & _LVP_OFF

; CONFIG2
; __config 0x3FFF
 __CONFIG _CONFIG2, _BOR4V_BOR40V & _WRT_OFF

; Declaración de variables
cont1	    equ 20h
cont2	    equ 21h
cont3	    equ 22h
selector    equ 23h

RES_VECT  CODE    0x0000  ; vector de reset del procesador
    GOTO    START         ; va al inicio del programa

MAIN_PROG CODE            ; permite que el linker ubique el programa principal

START

; ======= **** Configuración del microcontrolador **** =======

; Configuración del oscilador
    BANKSEL	OSCCON
    MOVLW	0x41
    MOVWF	OSCCON	    ; Oscilador interno a 1 MHz

; Configuración de puertos
    BANKSEL	PORTA
    CLRF	PORTA	    ; Inicialización de PORTA (en ceros)
    CLRF	PORTB	    ; Inicialización de PORTB (en ceros)
    
    BANKSEL	ANSEL
    CLRF	ANSEL	    ; I/O digital
    CLRF	ANSELH	    ; I/O digital
    
    BANKSEL	TRISA
    MOVLW	0xFF
    MOVWF	TRISA	    ; PORTA como entrada (1 en cada bit)
    CLRF	TRISB	    ; PORTB como salida (0 en cada bit)


; Inicialización de variables
    BANKSEL	PORTA
    CLRF	cont1
    CLRF	cont2
    CLRF	cont3
    CLRF	selector


; ======= **** Bucle principal **** =======

LOOP

; Lectura del selector
    MOVF	PORTA,W
    ANDLW	0x07		; Conserva RA2, RA1 y RA0
    MOVWF	selector


; Selección del patrón
    MOVF	selector,W
    XORLW	0x00
    BTFSC	STATUS,Z
    GOTO	PATRON0

    MOVF	selector,W
    XORLW	0x01
    BTFSC	STATUS,Z
    GOTO	PATRON1

    MOVF	selector,W
    XORLW	0x02
    BTFSC	STATUS,Z
    GOTO	PATRON2

    MOVF	selector,W
    XORLW	0x03
    BTFSC	STATUS,Z
    GOTO	PATRON3

    MOVF	selector,W
    XORLW	0x04
    BTFSC	STATUS,Z
    GOTO	PATRON4

    MOVF	selector,W
    XORLW	0x05
    BTFSC	STATUS,Z
    GOTO	PATRON5

    MOVF	selector,W
    XORLW	0x06
    BTFSC	STATUS,Z
    GOTO	PATRON6

    GOTO	PATRON7


; ======= **** Patrón 0 **** =======
; Desplazamiento de RB0 hacia RB7

PATRON0
    MOVLW	0x01
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x02
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x04
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x08
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x10
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x20
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x40
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x80
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Patrón 1 **** =======
; Desplazamiento de RB7 hacia RB0

PATRON1
    MOVLW	0x80
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x40
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x20
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x10
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x08
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x04
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x02
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x01
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Patrón 2 **** =======
; Encendido progresivo desde RB0

PATRON2
    MOVLW	0x01
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x03
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x07
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x0F
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x1F
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x3F
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x7F
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xFF
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Patrón 3 **** =======
; Encendido progresivo desde RB7

PATRON3
    MOVLW	0x80
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xC0
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xE0
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xF0
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xF8
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xFC
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xFE
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xFF
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Patrón 4 **** =======
; Encendido alternado de los LEDs

PATRON4
    MOVLW	0xAA
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x55
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xAA
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x55
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xAA
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x55
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xAA
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x55
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Patrón 5 **** =======
; Desplazamiento desde el centro hacia los extremos

PATRON5
    MOVLW	0x18
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x24
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x42
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x81
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x42
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x24
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x18
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x00
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Patrón 6 **** =======
; Desplazamiento de dos LEDs consecutivos

PATRON6
    MOVLW	0x03
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x06
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x0C
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x18
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x30
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x60
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xC0
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x00
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Patrón 7 **** =======
; Expansión y contracción desde el centro

PATRON7
    MOVLW	0x18
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x3C
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x7E
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0xFF
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x7E
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x3C
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x18
    MOVWF	PORTB
    CALL	DELAY

    MOVLW	0x00
    MOVWF	PORTB
    CALL	DELAY

    GOTO	LOOP


; ======= **** Retardo **** =======

DELAY
    MOVLW	0x02
    MOVWF	cont3

LOOP3
    MOVLW	0xFF
    MOVWF	cont2

LOOP2
    MOVLW	0xFF
    MOVWF	cont1

LOOP1
    DECFSZ	cont1,F		; cont1 = cont1 - 1
    GOTO	LOOP1

    DECFSZ	cont2,F		; cont2 = cont2 - 1
    GOTO	LOOP2

    DECFSZ	cont3,F		; cont3 = cont3 - 1
    GOTO	LOOP3

    RETURN

    END	


