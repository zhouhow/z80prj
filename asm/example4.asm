; ----------------------------------------------------------------------------------------
; 99 Bottles of Beer program in o Z80 assembly .
; Version 2, added newline / return characters and removed the clear screen in the loop.
; ----------------------------------------------------------------------------------------

	.ORG	8000h

start:
	LD	A,12	   ; cls
	OUT	(1),a 
	LD	A,0ffh
	OUT	(2),A	   ; Select all seven segments
	LD	A,0
	OUT	(1),A	   ; Erase all seven segemsnts
	OUT	(2),A	   ; Disable seven segments
;
	LD	C,99	   ; Number of bottles to start with
loopstart:
;	LD	A,12	   ; cls
;	OUT	(1),A  
	CALL 	printc	   ; Print number on terminal
	CALL	printc7	   ; Print number on seven segment
 	LD	A,C 
	OUT	(3),A	   ; Output number to leds
;
	LD 	HL,line1   ; Print first line
	CALL	printline
	CALL	printc     ; Print number 
	LD 	HL,line2_3 ; Print 2nd and 3rd line
	CALL	printline
	DEC	C	   ; Take one bottle away
	CALL	printc	   ; Print number
	LD 	HL,line4   ; Print fourth line
	CALL	printline
	LD	A,C
	CP	0  	   ; No more bottles?
	 JP	NZ,loopstart 
; 
	CALL	printc7	   ; Print number on seven segment
	OUT	(3),A	   ; Output number to leds
; 
	 HALT		   ; Stop the programm 
; ---------------------------------
;  Print C register as ASCII decimal
; --------------------------------
printc:                       
	LD	A,C
	CALL 	dtoa2d	   ; Cobvert to number in D and E
	LD 	A,D	   ;  Print first digit in D
	CP 	'0'	   ;  Skip leading 0
	JR	Z,printc2
	OUT	(1),A 
printc2:
	LD	A,E	   ; Print second digit in E
	OUT	(1),A  
	RET

; ---------------------------------
; Routine to print out a line in (hl)
; --------------------------------
printline:                   
	LD	A,(HL)	   ; Get cha to print
	CP	'$'	   ; Check '$' terminator
	JP	Z,printend    ;  jmp to end
;
	OUT	(1),A
	INC	HL 	   ;  Next char
	JP	printline	   ;  Loop
printend:
	RET

; ---------------------------------
; Decimal to ASCII (2 digits only), in: A, out: DE
; --------------------------------
dtoa2d:                        
	LD	D,'0'	   ;  ASCII '0' 
	DEC	D 	   ;  Because we are inc'ing in the loop
	LD	E,10	   ; Base 10 
	AND	A 	   ; Clear carry flag
dtoa2a
	INC	D	   ; Increase the number of tens
	SUB	E	   ; Subtract 10 A
	JR	NC,dtoa2a   ; Loop untril < 10
;
	ADD	A,E 	   ;  Add10 again
	ADD	A,'0'	   ; Convert to ASCII
	LD	E,A	   ; Remainder in E
	RET

; ---------------------------------
;  Print C register as ASCII decimal
; On last seven segment
; --------------------------------
printc7:                       
	PUSH	HL
	PUSH	DE
;
	LD	A,C
dtonum1:                        
	LD	D,0FFh 	   ;  Because we are inc'ing in the loop
	LD	E,10	   ;  Base 10 
	AND	A 	   ;  Clear carry flag
dtonum2:
	INC	D	   ; Increase the number of tens
	SUB	E	   ; Subtract 10  from A
	JR	NC,dtonum2 ; Loop untril < 10
;
	ADD	A,E 	   ;  Add10 again
	LD	E,A	   ;  Remainder in E
;
	LD	A,01h
	OUT	(2),A	   ; Select segment 5
;
	LD	A,E
	LD	HL, segtab
	AND	0FH
	ADD	A, L
	LD	L, A
	LD	A, (HL)
	OUT	(1),A	   ; Write digit
;
	LD	A,02h
	OUT	(2),A	   ; Select segment 4
;
	LD	A,D
	LD	HL, segtab
	AND	0FH
	ADD	A, L
	LD	L, A
	LD	A, (HL)
	OUT	(1),A	   ; Write digit
;
	LD	A,0h
	OUT	(2),A	   ; Disable seven segments
;
	POP	DE
 	POP	HL
	RET

; --------------------
; Data
; -------------------

line1:	 .DB	" bottles of beer on the wall,",13,10,'$'
line2_3: .DB	" bottles of beer,",13,10,"Take one down, pass it around,",13,10,'$'
line4:	 .DB	" bottles of beer on the wall.",13,10,13,10,'$'

segtab:	.DB	0BDH		;'0'
	.DB	030H		;'1'
	.DB	09BH		;'2'
	.DB	0BAH		;'3'
	.DB	036H		;'4'
	.DB	0AEH		;'5'
	.DB	0AFH		;'6'
	.DB	038H		;'7'
	.DB	0BFH		;'8'
	.DB	0BEH		;'9'
	.DB	03FH		;'A'
	.DB	0A7H		;'B'
	.DB	08DH		;'C'
	.DB	0B3H		;'D'
	.DB	08FH		;'E'
	.DB	00FH		;'F'

	.END
