;**************** 4-bit ALU *************
; 4-bit input data P (P0.3 to P0.1)  in R0
; 4-bit input data Q (P0.3 to P0.1)  in R1  
; 2-bit Control input S1, S0 (P1.1, P1.0) in R2
;S1S0 -> 00 - Addition
;S1S0 -> 01 - Subtraction
;S1S0 -> 10 - Logical AND
;S1S0 -> 11 - Logical OR
; Result on P2.4 to P2.0
;********************************************
        ORG		00h
		SJMP	main

;************** Main routine begins ***********
		ORG		64h
MAIN:
        ACALL   INIT
        ACALL   READ_PQ
        ACALL   READ_CI
        ACALL   ALU4bit
        ACALL   DISP_RES
        SJMP    MAIN
;************** Main routine ends ***********

INIT:
        ; Configure Port 0 and 1 as inputs
        MOV     P0, #0xFF
        MOV     P1, #0xFF
        
        RET
READ_PQ:
        ; Read 4-bit P (Port 0.3 to 0.1) in to R0 and 
        ; 4-bit Q (Port 0.7 to 0.4) in to R1. 
        MOV     A, P0
        MOV     R2, A
        ANL     A, #0x0F
        MOV     R0, A
        MOV     A, R2
        ANL     A, #0xF0
        SWAP    A
        MOV     R1, A
        RET
        
READ_CI:
        ;Read control inputs from Port 1 to R2
        MOV     A, P1
        ANL     A, #0x3
        MOV     R2, A
        RET 
        
ALU4bit:
        ;As per the control inputs in R2 
        ; process the data in R0 (P) and R1 (Q) 
        ; Result willl be stored in Accumulator
        MOV     A, R0
        CJNE    R2, #0x0, subtract1
        ADD     A, R1
        RET
subtract1:
        CJNE    R2, #0x1, and1
        SUBB     A, R1
        RET
and1:   
        CJNE    R2, #0x2, OR1
        ANL     A, R1
        RET
OR1:
        ORL     A, R1
        RET

DISP_RES:
        ;Display the result on LEDs connected to Port 2. 
        MOV     P2, A
        RET
        
        END

