;This is a example of the Hello World CP/M program.
; Im z80 code  2022 Hein Pragt
; Assemble and use cp/m command SAVE 1 hello2.com 
;
	.ORG	100h		; CP/M programs start at 100h.

	JP	START		; Jump to program start.

;Data
MsgStr:	.DB	13,10,"Hello world.",13,10,0
Stack1:	.DW	0		; Place to save old stack.
SBOT:	.FILL	32		; Temp stack for us to use.

;Constants
STOP:	.EQU	$-1		; Top of our stack (current address).
BDOS:	.EQU	5		; Address of BDOS entry.

;Code
START:	
	LD	(Stack1),SP	; Save original stack.
	LD	SP, STOP	; Stack pointer = our stack.
	LD	HL, MsgStr	; HL = address of text.
LOOP1:	
	LD	A,(HL)		; Get char from string.
	OR	A		; set cpu flags.
	JP	Z ,EXIT		; if char = 0 done.
;
	LD	E, A		; E = char to send.
	LD	C, 2		; We want BDOS func 2.
	PUSH	HL		; Save HL register.
	CALL	BDOS		; Call BDOS function.
	POP	HL		; Restore HL register
	INC	HL		; Point to next char.
	JP	LOOP1
;
EXIT:	
	LD	SP,(Stack1)	; SP back to old adresss.
	RET			; Return control back to CPM.
	
	.END
