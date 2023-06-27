;This is test for Z80 SIO PORT B
;BUFFER CONFIGURATION
CIRBUF:     EQU         9B00H  ;Location of Circular Buffer
BUFFHD:     EQU         9D00H  ;Restore the Head of the Circular Buffer 
BUFFTL:     EQU         9D01H  ;Restore the Tail of the Circular Buffer 

;BUFFER SIZES
BUFSIZ:     EQU         1FH    ;32 bytes 

;SIO ADDRESS
SIO_DA:     EQU         20H    
SIO_DB:     EQU         21H    
SIO_CA:     EQU         22H  
SIO_CB:     EQU         23H    

;CTC ADDRESS
CTC_CH0:    EQU         00H    
CTC_CH1:    EQU         01H    
CTC_CH2:    EQU         02H    
CTC_CH3:    EQU         03H    

;INTERRUPT VECTOR TABLE 
; Channel    D3  D2  D1  add   Interrupt Type 
;    B       0   0   0   00H   Transmit Buffer Empty 
;    B       0   0   1   02H   External/Status Change 
;    B       0   1   0   04H   Receive Character Available 
;    B       0   1   1   06H   Special Receive Condition 
;    A       1   0   0   08H   Transmit Buffer Empty 
;    A       1   0   1   0AH   External/Status Change 
;    A       1   1   0   0CH   Receive Character Available 
;    A       1   1   1   0EH   Special Receive Condition 

;SIO INTERRUPT VECTOR TABLE
SIO_IV:     EQU         0E000H              ;High Byte of Interrupt Vector
SIO_WV:     EQU         0E000H              ;Transmit Interrupt Vector
SIO_EV:     EQU         0E002H              ;External Status Interrupt Vector 
SIO_RV:     EQU         0E004H              ;Receive Interrupt Vector
SIO_SV:     EQU         0E006H              ;Special Receive Interrupt Vector 

            ORG     0000H
START:
            LD      SP,9000H            ;Stack Point 
;Initialize interrupt system and SIO
            DI                          ;Disable interrupts
                        
;Initialise interrupt vectors
            LD      HL,SIO_IV           ;Get Interupt high page number
            LD      A,H                 ;Save H in A
            LD      I,A                 ;Set interrupt vector high address (0B)
            IM      2                   ;Interrupt Mode 2, Vector in table

;Link interrupt vector address to handler routines
            LD      HL,READ_HANDLE      ;Store Receive Vector
            LD      (SIO_RV),HL         ;
            LD      HL,WRITE_HANDLE     ;Store Transmit Vector
            LD      (SIO_WV),HL         ;
            LD      HL,EXTERNAL_HANDLE  ;Store External Status Vector
            LD      (SIO_EV),HL         ;
            LD      HL,ERROR_HANDLE     ;Store Receive Error Vector
            LD      (SIO_SV),HL         ;

;Initialise the SIO and CTC
            CALL    INIT_CTC            ;Set up the CTC
            CALL    INIT_SIO            ;Set up the SIO  

;Set Buffer Head and Tail pointers based of LSB of circular buffer
            LD      HL,CIRBUF           ;Load Circular buffer address
            LD      A,L                 ;Head/Tail = LSB of buffer
            LD      (BUFFHD),A          ;Save initial Head pointer
            LD      (BUFFTL),A          ;Save initial Tail pointer

            EI                          ;Enable Interrrupts

;Start Background task. This will loop continually until the SIO sends an interrupt.
;Set it up to do what ever you want.  As this example
;simply echos a character back to the terminal, a check for a non empty buffer
;is performed.  And if non-empty, the character at the tail of the buffer is
;sent back to the terminal.  This will then trigger the Transmit Buffer empty interrupt.
;to repeast the transmit if more data is available to be sent.
WAIT_LOOP:
            CALL    DO_TRANSMIT         ;Check for non empty buffer and transmit
            JR      WAIT_LOOP

;SIO Interrupt Service Routines

;Receive Character Available Interrupt
READ_HANDLE:
            PUSH    AF                  ;Save AF
;Check if buffer is full
            LD      A,(BUFFHD)          ;Get the HEAD pointer
            LD      B,A                 ;Save in B
            LD      A,(BUFFTL)          ;Get the TAIL pointer
            DEC     A                   ;Decrease it by one
            AND     BUFSIZ              ;Mask for wrap around
            CP      B                   ;Is HEAD = TAIL - 1 
            JR      NZ,READ_OKAY        ;Different so save to buffer
;Buffer is full                         ;read and lose data
            IN      A,(SIO_DB)          ;Read overflow byte to clear interrupt
            JR      READ_EXIT           ;Exit Safely
;Buffer in not full
READ_OKAY:    
            IN      A,(SIO_DB)          ;Read data from SIO
            LD      HL,CIRBUF           ;Load Buffer in HL
            LD      L,B                 ;Load Head Pointer to L to index the Circular Buffer
            LD      (HL),A              ;Save Data at head of buffer

            LD      A,L                 ;Load Head Pointer to A
            INC     A                   ;Increase Head pointer by one 
            AND     BUFSIZ              ;Mask for wrap around
            LD      (BUFFHD),A          ;Save new head
READ_EXIT:  
            POP     AF                  ;Restore AF
            EI                          ;Reenable Interrupts
            RETI                        ;Return from Interrupt
      
;Transmit Buffer Empty Interrupt, When a character is transmitted, this
;interrupt will be called when the SIO clears its buffer.  It then checks for 
;more data to send.  If no more data is to be sent, to stop this interrupt from
;being repeatingly triggered, a command to reset the Transmit interrupt is sent
WRITE_HANDLE:
            PUSH    AF                  ;Save AF
            CALL    DO_TRANSMIT         ;Do the Transmit, Carry flag is set if buffer is empty
            JR      NC,WRITE_EXIT       ;Data was tramitted, Exit Safely
;Buffer is Empty, reset transmit interrupt
            LD      A,00101000B         ;Reset SIO Transmit Interrupt
            OUT     (SIO_CB),A          ;Write into WR0 
WRITE_EXIT:
            POP     AF                  ;Restore AF 
            EI                          ;Reenable Interrupts
            RETI                        ;Return from Interrupt

;External Status/Change Interrupt.  Not handled, Just reset the status interrupt
EXTERNAL_HANDLE:
            PUSH    AF                  ;Save AF
            LD      A,00010000B         ;Reset Status Interrupt
            OUT     (SIO_CB),A          ;Write into WR0
            POP     AF                  ;Restore AF
            EI                          ;Reenable Interrupts
            RETI                        ;Return from Interrupt

;Special Receive Interrupt.  Not handled, Just reset the status interrupt
ERROR_HANDLE:
            PUSH    AF                  ;Save AF
            LD      A,00110000B         ;Reset Receive Error Interrupt
            OUT     (SIO_CB),A          ;Write into WR0
            POP     AF                  ;Restore AF
            EI                          ;Reenable Interrupts
            RETI                        ;Return from Interrupt

;Consume one byte if any to consume
DO_TRANSMIT:
            DI                          ;Disable interrupts
;Check if buffer is empty
            LD      A,(BUFFTL)          ;Get the TAIL pointer
            LD      B,A                 ;Save in B
            LD      A,(BUFFHD)          ;Get the HEAD pointer
            CP      B                   ;Does TAIL == HEAD 
            JR      NZ,WRITE_OKAY       ;No, Transmit data at Tail
;Buffer is Empty                        ;set the carry flag and exit 
            SCF                         ;Set the Carry Flag
            EI                          ;Restore interrupts
            RET                         ;Exit
;Buffer is not empty
WRITE_OKAY:
            LD      HL,CIRBUF           ;Load Buffer in HL
            LD      L,B                 ;Load Tail Pointer to L to index the Circular Buffer
            LD      A,(HL)              ;Get byte at Tail.
            OUT     (SIO_DB),A          ;Transmit byte to SIO
;Output has occured
            LD      A,L                 ;Load Tail Pointer to A
            INC     A                   ;Increase Tail pointer by 1
            AND     BUFSIZ              ;Mask for wrap around
            LD      (BUFFTL),A          ;Save new tail
            OR      A                   ;Reset Carry Flag
            EI                          ;Restore interrupts
            RET                         ;Exit

;CTC Configuration Routines

INIT_CTC:

;CH1 provides to SIO SERIAL B the RX/TX clock
            LD      A,00000111B         ;interrupt off, timer mode, prsc=16, falling edge (doesn't matter) 
                                        ;start upon load, constant follows, software reset, command word 
            OUT     (CTC_CH1),A
            LD      A,00000011B         ;time constant 3 
            OUT     (CTC_CH1),A 
            RET                         ;TO0 output frequency=CPU_CLK/prcs/time constant = 153600 Hz 
                                        ;baud rate = 153600 / 16 = 9600 (16 times clock, SIO: WR4) 

;SIO Configuration Routines

INIT_SIO:            
           
;CHANNEL B
            ;LD      A,00000000B         ;write into WR0: select WR0 
            ;OUT     (SIO_CA), A 
            LD      A,00011000B         ;write into WR0: channel reset
            OUT     (SIO_CB), A

;CHANNEL B
            LD      A,00000010B         ;write into WR0: select WR2
            OUT     (SIO_CB), A
            LD      A,00000000B         ;write into WR2: set base interrupt vector for SIO (0000)
            OUT     (SIO_CB), A

            LD      A,00000001B         ;write into WR0: select WR1 
            OUT     (SIO_CB), A
            LD      A,00000100B         ;write into WR1: allow status to affect vector
            OUT     (SIO_CB), A

;CHANNEL B  
            LD      A,00010100B         ;write into WR0: select WR4 / Reset Int
            OUT     (SIO_CB), A
            LD      A,01000100B         ;write into WR4: presc. 16x, 1 stop bit, no parity
            OUT     (SIO_CB), A

            LD      A,00000011B         ;write into WR0: select WR3
            OUT     (SIO_CB), A
            LD      A,11000001B         ;write into WR3: 8 bits/RX char; auto enable OFF; RX enable
            OUT     (SIO_CB), A

            LD      A,00000101B         ;write into WR0: select WR5
            OUT     (SIO_CB), A
            LD      A,01101010B         ;write into WR5: TX 8 bits, TX Enable, No RTS
            OUT     (SIO_CB), A

            LD      A,00000001B         ;write into WR0: select WR1
            OUT     (SIO_CB), A
            LD      A,00011011B         ;write into WR1: Int on All RX (No Parity), TX Int, Ex Int
            OUT     (SIO_CB), A
            RET     