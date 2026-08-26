; Programa para el PIC16F887 que suma dos números de cuatro bits (A y B).
; A corresponde a la parte baja del puerto A (PORTA) <A3:A0>
; B corresponde a la parte alta del puerto A (PORTA) <A7:A4>
; El resultado de la suma es mostrado en el puerto B (PORTB) <B7:B0>
; Autor: Alejandro Perez
; Institución: Universidad del Cauca
; Fecha: 13-08-2026
    
LIST P=16f887
#include "p16f887.inc" ; Importa la definición de los registros del PIC


; ======= AGREGADO PARA EL PIC FISICO =======

__CONFIG _CONFIG1, _INTRC_OSC_NOCLKOUT & _WDT_OFF & _PWRTE_ON & _MCLRE_OFF & _CP_OFF & _CPD_OFF & _BOR_OFF & _IESO_OFF & _FCMEN_OFF & _LVP_OFF
__CONFIG _CONFIG2, _WRT_OFF & _BOR21V


; Declaración de variables
operandoA equ 20h
operandoB equ 21h
resultado equ 22h
selector  equ 23h
contador  equ 24h
temporal  equ 25h  


RES_VECT CODE 0x0000 ; vector de reset del procesador
GOTO START ; va al inicio del programa

MAIN_PROG CODE ; permite que el linker ubique el programa principal

START


; ======= AGREGADO PARA EL PIC FISICO =======

BANKSEL OSCCON
MOVLW b'01100001'
MOVWF OSCCON


; ======= **** Configuración del microcontrolador **** =======

BANKSEL PORTA
CLRF PORTA ; Inicialización de PORTA (en ceros)
CLRF PORTB ; Inicialización de PORTB (en ceros)

BANKSEL ANSEL
CLRF ANSEL ; I/O digital

; ======= AGREGADO PARA EL PIC FISICO =======
CLRF ANSELH


BANKSEL TRISA
MOVLW 0xFF
MOVWF TRISA ; PORTA como entrada (1 en cada bit)

CLRF TRISB ; PORTB como salida (0 en cada bit)

MOVLW 0x07
MOVWF TRISC ; C0, C1 y C2 como entradas


; ======= **** Bucle principal **** =======

LOOP

BANKSEL PORTA ; necesario para direccionar el banco donde están los registros que empleamos


; Obtenemos los operandos A y B

MOVF PORTA,0 ; El valor del puerto A (PORTA) lo mueve W (d=0)
ANDLW 0x0F ; Obtiene el nibble inferior (operando A)
MOVWF operandoA ; Guarda el operando A

MOVF PORTA,0 ; El valor del puerto A (PORTA) lo mueve W (d=0)
ANDLW 0xF0 ; Obtiene el nibble superior (operando B)
MOVWF operandoB ; Guarda el operando B

SWAPF operandoB,1 ; Invierte los nibbles de operandoB y el resultado lo reescribe en operandoB (d=1)


; Leemos el selector de operacion desde PORTC

MOVF PORTC,0
ANDLW 0x07
MOVWF selector 
 

; Seleccion de operacion 


; ¿selector = 0? -> SUMA

MOVF selector,0
XORLW 0x00
BTFSC STATUS,Z
GOTO SUMA


; ¿selector = 1? -> RESTA

MOVF selector,0
XORLW 0x01
BTFSC STATUS,Z
GOTO RESTA


; ¿Selector = 2? -> MULTIPLICACION 

MOVF selector,0
XORLW 0x02
BTFSC STATUS,Z
GOTO MULTIPLICACION


; ----- ¿Selector = 3? -> DIVISION -----

MOVF selector,0
XORLW 0x03
BTFSC STATUS,Z
GOTO DIVISION


; ----- Selector = 4 -> AND -----

MOVF selector,0
XORLW 0x04
BTFSC STATUS,Z
GOTO OP_AND


; ----- Selector = 5 -> OR -----

MOVF selector,0
XORLW 0x05
BTFSC STATUS,Z
GOTO OP_OR


; ----- Selector = 6 -> XOR -----

MOVF selector,0
XORLW 0x06
BTFSC STATUS,Z
GOTO OP_XOR


; ----- Selector = 7 -> NOT -----

MOVF selector,0
XORLW 0x07
BTFSC STATUS,Z
GOTO OP_NOT
    
GOTO LOOP 
 

; ======= SUMA =======

SUMA

MOVF operandoA,0
ADDWF operandoB,0

MOVWF resultado
MOVWF PORTB

GOTO LOOP


; ======= RESTA =======

RESTA

MOVF operandoB,0
SUBWF operandoA,0

MOVWF resultado
MOVWF PORTB

GOTO LOOP


; ======= MULTIPLICACION =======

MULTIPLICACION

CLRF resultado        ; resultado comienza en 0

MOVF operandoB,0
MOVWF contador        ; contador = B

; Comprobamos si B es 0

MOVF contador,1
BTFSC STATUS,Z
GOTO FIN_MULT


CICLO_MULT

MOVF operandoA,0
ADDWF resultado,1     ; resultado = resultado + A

DECFSZ contador,1     ; contador = contador - 1
GOTO CICLO_MULT


FIN_MULT

MOVF resultado,0
MOVWF PORTB

GOTO LOOP


; ======= DIVISION =======

DIVISION

CLRF resultado

; Comprobar division entre cero

MOVF operandoB,0
BTFSC STATUS,Z
GOTO DIV_CERO

; temporal = A

MOVF operandoA,0
MOVWF temporal


CICLO_DIV

; temporal - B

MOVF operandoB,0
SUBWF temporal,0

; Si temporal < B termina

BTFSS STATUS,C
GOTO FIN_DIV

; Guardamos la resta

MOVWF temporal

; resultado = resultado + 1

INCF resultado,1

GOTO CICLO_DIV


FIN_DIV

MOVF resultado,0
MOVWF PORTB

GOTO LOOP


DIV_CERO

CLRF resultado
CLRF PORTB


; ======= AND =======

OP_AND

MOVF operandoA,0
ANDWF operandoB,0

MOVWF resultado
MOVWF PORTB

GOTO LOOP


; ======= OR =======

OP_OR

MOVF operandoA,0
IORWF operandoB,0

MOVWF resultado
MOVWF PORTB

GOTO LOOP


; ======= XOR =======

OP_XOR

MOVF operandoA,0
XORWF operandoB,0

MOVWF resultado
MOVWF PORTB

GOTO LOOP


; ======= NOT =======

OP_NOT

COMF operandoA,0
ANDLW 0x0F

MOVWF resultado
MOVWF PORTB

GOTO LOOP


END