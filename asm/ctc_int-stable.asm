;The ROM (0000H~7FFFH), RAM (8000H~FFFFH) 
;This is test for Z80 CTC Interrupter 
;CTC ADDRESS
CTC_CH0:        EQU     00H 
CTC_CH1:        EQU     01H 
CTC_CH2:        EQU     02H 
CTC_CH3:        EQU     03H 

;PIO ADDRESS 
PIO_DA:         EQU     40H
PIO_DB:         EQU     41H
PIO_CA:         EQU     42H
PIO_CB:         EQU     43H

;Interrupter Vector Table (Low byte)
INT_CH0:        EQU     00H
INT_CH1:        EQU     02H
INT_CH2:        EQU     04H
INT_CH3:        EQU     06H

;Interrupter Vector (High byte), Register I 
INT_HGH:        EQU     0A000H  

;Main codes 
        ORG     0000H 
MAIN:
        LD      SP,9000H        ;stack pointer

        DI                      ;Disable interrupts 
        
        LD      HL,ISR_CH2      ;Link CH2 Interrupter Service Routines 
        LD      (INT_HGH + INT_CH2),HL 

        
        LD      HL,INT_HGH
        LD      A,H
        LD      I,A

        IM      2               ;Interrupt mode 2 

        CALL    INT_PIO         ;Inintializes the PIO 
        CALL    INT_CTC         ;Inintializes the CTC 

        EI                      ;Enable interrupts 

DO_NOTHING:                     ;CPU is waitting for Interrupt 
        CALL    DELAY 
        JP      DO_NOTHING

;Interrupt service routine for CH2
ISR_CH2:
        DI                      ;Disable interrupts
        PUSH    AF

        LD      A,0x01          ;turn on the light 
        OUT     (PIO_DB),A
        CALL    DELAY           ;a little delay 

        LD      A,0x00          ;turn off the light
        OUT     (PIO_DB),A

        POP     AF
        EI                      ;enable interrupts
        RETI                    ;exit from ISR                    

INT_CTC:
;Initilizes CH1 
;CH1 divides CPU CLK by (256*128), providing a clock signal at TO1. TO1 is connected to TRG2 
;T01 outputs f= CPU_CLK/(256*128) => 7.3728MHz / ( 256 * 128 ) => 225Hz 
        LD      A,0x27          ;interrupt off, timer mode, presc=256, start upon load 
                                ;time constant follows, software reset, command word 
        OUT     (CTC_CH1),A
        
        LD      A,0x80          ;time constant ( 128 ) 
        OUT     (CTC_CH1),A 

;Initilizes CH2 
;CH2 counts TRG2 CLK clock, providing a clock signal at TO2 
;T02 outputs f= CLK / 225 => 225Hz / 225 => 1Hz ~ 1s (pluse)
        LD      A,0xC7          ;interrupt on, counter mode, presc=16 (don't care) 
                                ;start upon load, constant follows, software reset, command word 
        OUT     (CTC_CH2),A

        LD      A,0xE1          ;time constant 225 
        OUT     (CTC_CH2),A 

        LD      A,0x00          ;Low Interrupter Vector 
        OUT     (CTC_CH0),A     ;Interrupter Vector only write in Channel 0  

        RET 
        
;Inintializes the PIO port B 
INT_PIO:
        LD      A,0xCF          ;mode 3 (bit control)    
        OUT     (PIO_CB),A
        LD      A,0x00          ;port B (output)  
        OUT     (PIO_CB),A
        RET     

;Delay Codes
DELAY: 
        PUSH    BC
        PUSH    DE
        LD      D,0xFF
LOOP1:
        LD      B,0xFF
LOOP2:
        DJNZ    LOOP2
        DEC     D
        JP      NZ,LOOP1        
        POP     DE
        POP     BC              
        RET     