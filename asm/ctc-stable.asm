;The ROM (0000H~7FFFH), RAM (8000H~FFFFH) 
;This is test for Z80 CTC 

;CTC ADDRESS 
CTC_CH0:     EQU        00H 
CTC_CH1:     EQU        01H 
CTC_CH2:     EQU        02H
CTC_CH3:     EQU        03H 

;Original Address of Codes 
         ORG        0000H 

;Initilizes CH1 
;CH1 divides CPU CLK by (256*128), providing a clock signal at TO1. TO1 is connected to TRG2 
;T01 outputs f= CPU_CLK/(256*128) => 7.3728MHz / ( 256 * 128 ) => 225Hz 
         LD      A,0x27        ;interrupt off, timer mode, presc=256, start upon load 
                               ;time constant follows, software reset, command word 
         OUT     (CTC_CH1),A
         LD      A,0x80        ;time constant ( 128 ) 
         OUT     (CTC_CH1),A 

;Initilizes CH2 
;CH2 counts TRG2 CLK clock, providing a clock signal at TO2. TO2 is connected to 74HC74 
;T02 outputs f= CLK / 225 => 225Hz / 225 => 1Hz ~ 1s (pluse)
         LD      A,0x47        ;interrupt off, counter mode, presc=16 (don't care in counter) 
                               ;start upon load, constant follows,software reset, command word 
         OUT     (CTC_CH2),A
         LD      A,0xE1        ;time constant 225 
         OUT     (CTC_CH2),A 