;------------------------------------------------------------------------
; dice2.asm
; A simple 2 dice rolling game
; Author : San Bergmans
; Date   : 15-12-2005
; Found it on the Internet and modified it for the workbench!
;------------------------------------------------------------------------
; This program abuses the Z80's refresh register to generate pseudo
; random numbers which are translated to two dice rolls.
;------------------------------------------------------------------------

	.org   01800H         ; RAM starts here, so are we

;------------------------------------------------------------------------
;  Monitor routines
;------------------------------------------------------------------------

SCAN            .EQU     005FEH    ; Scan display until a key pressed
HEX7            .EQU     00689H    ; Convert digit to 7-segement

;------------------------------------------------------------------------
;  DICE
;------------------------------------------------------------------------

DICE            LD      A,R        ; Copy refresh register and use it
                RLA                ; as a  pseudo random number
                LD      L,A
                RLCA               ; Prepare random number for 2nd
                RLCA               ; die
                RLCA
                LD      B,A

                LD      H,0         ; Multiply random number by 6
                ADD     HL,HL       ; this results in a range from
                LD      D,H         ; 0..5
                LD      E,L         ; (Hint: ADD HL,HL ---> HL x 2)
                ADD     HL,HL
                ADD     HL,DE
                LD      A,H
                INC     A            ; Make it range from 1..6
                CALL    HEX7            ; Convert it to 7-segments
                LD      (DSP_BFFR+4),A  ; and display it

                LD      L,B           ; Do the same for the second die
                LD      H,0
                ADD     HL,HL
                LD      D,H
                LD      E,L
                ADD     HL,HL
                ADD     HL,DE
                LD      A,H
                INC     A
                CALL    HEX7
                LD      (DSP_BFFR+1),A

                LD      IX,DSP_BFFR    ; Scan the display until a key
                CALL    SCAN           ; is pressed
;
                JR      DICE           ; That's all! Do it again & again

;------------------------------------------------------------------------

DSP_BFFR        .DB     0              ; Display buffer (from right to
                .DB     0              ; left)
                .DB     0
                .DB     0
                .DB     0
                .DB     0

;------------------------------------------------------------------------
		.org	0		; Reset to MPF entry point
		.end