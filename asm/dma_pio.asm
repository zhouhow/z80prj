;PIO ADDRESS (010XXXXX)
PIO_DA:  EQU     40H 
PIO_DB:  EQU     41H 
PIO_CA:  EQU     42H 
PIO_CB:  EQU     43H 

;DMA ADDRESS (011XXXXX)
DMA_AD:  EQU     60H              ;DMA address 

;DATE ADDRESS 
PORT_A:  EQU     0A000H           ;source address 
PORT_B:  EQU     0B000H           ;destination address 
LENGTH:  EQU     00100H           ;block length 

;SOME LABLES 
DMA_EN:  EQU     0x87             ;enable DMA
DMA_DI:  EQU     0x83             ;disable DMA 

;Initializes  DMA and PIO  

       LD       SP,9000H          ;stack pointer 

       LD       A,0x23            ;source value  
       LD       (PORT_A),A        

       CALL     INT_PIO 

MAIN:  LD       A,0x00            ;turn off the lights  
       OUT      (PIO_DB),A
       CALL     DELAY         

       CALL     INT_DMA           ;start DMA operation

       LD       HL,PORT_B          
       INC      HL
       LD       A,(HL) 
       OUT      (PIO_DB),A        ;turn on the light    
        
       CALL     DELAY 
 
       JP       MAIN              ;endless loop 

;Initializes  PIO 
INT_PIO:
       LD       A,11001111B       ;mode3 (btctrl)
       OUT      (PIO_CB),A
       LD       A,00000000B       ;portB (OUTPUT)
       OUT      (PIO_CB),A
       RET 

;Initializes DMA 
INT_DMA:
       DI

       LD       A,DMA_DI          ;disable DMA
       OUT      (DMA_AD),A

       LD       A,0x7D            ;Transfer, A->B, port A address, block length
       OUT      (DMA_AD),A

       LD       HL,PORT_A         ;source address
       LD       A,L
       OUT      (DMA_AD),A
       LD       A,H
       OUT      (DMA_AD),A

       LD       BC,LENGTH         ;block length 
       LD       A,C
       OUT      (DMA_AD),A
       LD       A,B
       OUT      (DMA_AD),A


       LD       A,0x24            ;port A fixed, memory
       OUT      (DMA_AD),A

       LD       A,0x10
       OUT      (DMA_AD),A        ;port B increase, memory

       LD       A,0xAD            ;Contious, port B address follows
       OUT      (DMA_AD),A

       LD       DE,PORT_B         ;destination address  
       LD       A,E
       OUT      (DMA_AD),A
       LD       A,D
       OUT      (DMA_AD),A

       LD       A,0xCF            ;load 
       OUT      (DMA_AD),A

       LD       A,DMA_EN          ;enable DMA 
       OUT      (DMA_AD),A

       EI
       RET    
              
;A Little Delay 
DELAY:  
       PUSH     BC
       PUSH     DE
       LD       D, 0xFF
LOOP1:
       LD       B, 0xFF
LOOP2:
       DJNZ     LOOP2 
       DEC      D
       JP       NZ, LOOP1
       POP      DE
       POP      BC
       RET      
