; ******************************************************
; BASIC .ASM template file for
; ******************************************************

.include "C:\VMLAB\include\m32def.inc"


; Define here Reset and interrupt vectors, if any

reset:
   rjmp start
   .ORG 0X16
   RJMP I_HANDLER

   reti      ; Addr $01
   reti      ; Addr $02
   reti      ; Addr $03
   reti      ; Addr $04
   reti      ; Addr $05
   reti      ; Addr $06        Use 'rjmp myVector'
   reti      ; Addr $07        to define a interrupt vector
   reti      ; Addr $08
   reti      ; Addr $09
   reti      ; Addr $0A
   reti      ; Addr $0B        This is just an example
   reti      ; Addr $0C        Not all MCUs have the same
   reti      ; Addr $0D        number of interrupt vectors
   reti      ; Addr $0E
   reti      ; Addr $0F
   reti      ; Addr $10

; Program starts here after Reset

start:
			LDI XH,HIGH(0X100)
			LDI XL,LOW(0X100)
			LDI YH,HIGH(0X200)
			LDI YL,LOW(0X200)

			LDI R16,0XFF		
			OUT DDRB,R16

			LDI R16,0X200
			OUT TCNT0,R16
			LDI R16,0X01
			OUT TCCR0,R16

SEI
			LDI R16,(1<<TOV0)
			OUT TIMSK,R16
			RJMP BLINKING

BLINKING:

			LDI R16,HIGH(0X100)
			OUT SPH,R16
			LDI R16,LOW(0X100)
			OUT SPL,R16
			LDI R31,0X00

AGAIN:	
			OUT PORTB,R16
			LDI R17,0X01
			CALL DELAY
			IN R16,PORTB
			EOR R16,R17
			OUT PORTB,R16
			RJMP AGAIN

DELAY:
			LDI R19,1
			LOOP:
			DEC R19
			BRNE LOOP
			RET

I_HANDLER:
			CPI R31,0X00
			BREQ BL_STACK
			RJMP UART_STACK

BL_STACK:
			PUSH R16
			PUSH R17
			PUSH R18
			PUSH R19
			IN XH,SPH
			IN XL,SPL

;PUSH SREG
			OUT SPH,YH
			OUT SPL,YL
;POP SREPOP
			POP R18
			POP R17
			POP R16
			SEI
			LDI R30,(1<<TOV0)
			OUT TIFR,R30
			RJMP UART

UART_STACK:
   		OUT SPH,YH
   		OUT SPL,YL

			PUSH R16
   		PUSH R17
   		PUSH R18
   		PUSH R19
   		IN YH,SPH
   		IN YL,SPL
;PUSH SREG
			OUT SPH,XH
			OUT SPL,XL
;POP SREPOP
			POP R19
			POP R18
			POP R17
			POP R16
			SEI
			LDI R30,(1<<TOV0)
			OUT TIFR,R30
			LDI R31,0X00
			RET

UART:
			LDI R31,0X01
			OUT PORTB,R16
			LDI R17,0X02

AGAIN1:
			CALL DELAY1
			IN R16,PORTB
			EOR R16,R17
			OUT PORTB,R16
			RJMP AGAIN1

DELAY1:
			LDI R19,1
			LOOP1:
			DEC R19
    		BRNE LOOP1
   		RET

forever:
    		nop
     		nop       ; Infinite loop.
     		nop       ; Define your main system
     		nop       ; behaviour here
   		rjmp forever






