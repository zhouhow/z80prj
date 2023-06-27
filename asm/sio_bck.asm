;This dosen't Work 
;CTC ADDRESS
CTC_CH0:     equ 00000000b
CTC_CH1:     equ 00000001b
CTC_CH2:     equ 00000010b
CTC_CH3:     equ 00000011b

;SIO ADDRESS
SIO_DA:      equ 00100000b
SIO_DB:      equ 00100001b
SIO_CA:      equ 00100010b
SIO_CB:      equ 00100011b

;RAMCELL     equ 0x8000
RX_TABLE:    equ 0xa00c
SP_TABLE:    equ 0xa00e

;MAIN

        org 0000h
main:
        ld sp,9000h         ; the stack pointer

        call delay          ; little delay

        call setCTC         ; set CTC
        call setSIO         ; set SIO

        ld a,0xa0           ; set high byte of interrupt vectors to point to page 0
        ld i,a
        im 2                ; set int mode 2
        ei                  ; enable interupts

        ld hl,RX_CHA_AVAILABLE ; link 
        ld (RX_TABLE),hl
        ld hl,SPEC_RX_CONDITON
        ld (SP_TABLE),hl
        

setSIO:
        ;the followings are settings for channel A
        ;ld a,00110000b      ; write into WR0: error reset, select WR0
        ;out (SIO_CA),a
        ld a,00011000b      ; write into WR0: channel reset
        out (SIO_CA),a

        ld a,00000100b      ; write into WR0: select WR4
        out (SIO_CA),a
        ld a,01000100b      ; write into WR4: presc. 16x, 1 stop bit, no parity
        out (SIO_CA),a

        ld a,00000101b      ; write into WR0: select WR5
        out (SIO_CA),a
        ld a,11101000b      ; write into WR5: DTR on, TX 8 bits, BREAK off, TX on, RTS off
        out (SIO_CA),a

        ; the following are settings for channel B
        ld a,00000001b      ; write into WR0: select WR1
        out (SIO_CB),a
        ld a,00000100b      ; write into WR0: status affects interrupt vectors
        out (SIO_CB),a

        ld a,00000010b      ; write into WR0: select WR2
        out (SIO_CB),a
        ld a,00000000b      ; write into WR2: set interrupt vector, but bits D3/D2/D1 of this vector
                            ; will be affected by the channel & condition that raised the interrupt
                            ; (see datasheet): in our example, 0x0C for Ch.A receiving a char, 0x0E
                            ; for special conditions
        out (SIO_CB),a

        ; the following are settings for channel A
        ld a,00000001b      ; write into WR0: select WR1
        out (SIO_CA),a
        ld a,00011000b      ; interrupts on every RX char; parity is no special condition;
                            ; buffer overrun is special condition
        out (SIO_CA),a

SIO_A_EI:
        ;enable SIO channel A RX
        ld a,00000011b      ; write into WR0: select WR3
        out (SIO_CA),a
        ld a,11000001b      ; 8 bits/RX char; auto enable OFF; RX enable
        out (SIO_CA),a
        ret

setCTC:
;init CH0
;CH0 provides to SIO SERIAL A the RX/TX clock
        ld a,00000111b      ; interrupt off, timer mode, prsc=256 (doesn't matter), ext. start,
                            ; start upon loading time constant, time constant follows, sw reset, command word
        out (CTC_CH0),a
        ld a,0x03           ; time constant 3
        out (CTC_CH0),a
        ret     
                            ; TO0 output frequency=INPUT CLK/prsc/time constant = 153600 Hz (7372800/16/3)
                            ; baud rate (9600 x 16 = 153600 Hz)

;delay 
delay:
        push bc
        push de
        ld d,0xff
loop1:
        ld b,0xff
loop2:
        djnz loop2
        dec d
        jp nz, loop1
        pop de  
        pop bc
        ret

;serial management 
A_RTS_OFF:
        ld a,00000101b      ; write into WR0: select WR5
        out (SIO_CA),a
        ld a,11101000b      ; 8 bits/TX char; TX enable; RTS disable
        out (SIO_CA),a
        ret

A_RTS_ON:
        ld a,00000101b      ; write into WR0: select WR5
        out (SIO_CA),a
        ld a,11101010b      ; 8 bits/TX char; TX enable; RTS enable
        out (SIO_CA),a
        ret

SIO_A_DI:
        ;disable SIO channel A RX
        ld a,00000011b      ; write into WR0: select WR3
        out (SIO_CA),a
        ld a,11000000b      ; write into WR3: RX disable;
        out (SIO_CA),a
        ret

RX_CHA_AVAILABLE:
        push af             ; backup AF
        call A_RTS_OFF      ; disable RTS
        in a,(SIO_DA)       ; read RX character into A 
        out (SIO_DA),a      ; echo char to transmitter
        call TX_EMP         ; wait for outgoing char to be sent
        call A_RTS_ON       ; enable again RTS
        pop af
        ei
        reti

SPEC_RX_CONDITON:
        PUSH    AF                  ;Save AF
        LD      A,00110000B         ;Reset Receive Error Interrupt
        OUT     (SIO_CA),A          ;Write into WR0
        POP     AF                  ;Restore AF
        EI                          ;Reenable Interrupts
        RETI     

TX_EMP:
        ; check for TX buffer empty
        sub a
        inc a
        out (SIO_CA),a
        in a,(SIO_CA)
        bit 0,a
        jp z,TX_EMP
        ret

RX_EMP:
        ;check for RX buffer empty 
        sub a               ;clear a, write into WR0: select RR0
        out (SIO_CA),a
        in a,(SIO_CA)       ;read RRx
        bit 0,a
        ret z               ;if any rx char left in rx buffer
        in a,(SIO_DA)       ;read that char
        jp RX_EMP