;The ROM (0000H~7FFFH), RAM (8000H~FFFFH) 
;This is test for Z80 PIO and RAM 
;PIO ADDRESS
PIO_DA:     EQU         40H
PIO_DB:     EQU         41H
PIO_CA:     EQU         42H
PIO_CB:     EQU         43H

BUFFER:     EQU         0E000H   ;one byte in RAM 

        ORG     0000H
;Main Codes   
MAIN:   
        LD      SP,9000H        ;stack pointer 

        CALL    INT_PIO         

        LD      HL,BUFFER 
        LD      (HL),0x01       ;turn on the light 
        LD      A,(BUFFER) 
        OUT     (PIO_DB),A 
        
        CALL    DELAY           ;a little delay

        LD      HL,BUFFER
        LD      (HL),0x00       ;turn off the light 
        LD      A,(BUFFER)
        OUT     (PIO_DB),A
        
        CALL    DELAY           ;a little delay 

        JP      MAIN            ;endless loop

;Delay
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

;Initilizes  PIO
INT_PIO:
        LD      A,0xCF          ;mode3 (bitcontrol) 
        OUT     (PIO_CB),A
        LD      A,0x00          ;port B (output) 
        OUT     (PIO_CB),A 
        RET 