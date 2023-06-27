; Z80 code disassembly ZTRAN4 progeram
; 2022 Hein Pragt
; Assemble and save to com file using SAVE 10 ztran4.com
;
cpm	.equ	0
bdos	.equ	5
bel	.equ	7
tab	.equ	9
lf	.equ	0ah
cr	.equ	0dh
;
		.ORG	0100H
;
		JP	1DEH

		.db	">> ZTRAN version"
		.db	" 1.4  (C) Elliam"
		.db	" Associates 1986"
		.db	" <<",cr,lf
		.db	tab,"** 8080 to Z80"
		.db	" code Translator"
		.db	" **",cr,lf,lf,0

		JP	0CA0H		;???

		JP	0D05H		;???

		LD	HL,(1F80H)	;???
		LD	H,0		;???
		EX	DE,HL		;???
		LD	C,4		;???
		CALL	bdos		;???
		JP	0D05H		;???

		LD	HL,3		;???
		LD	(HL),0		;???
		JP	0CCFH		;???

		JP	0D05H		;???

		LD	HL,3		;???
		LD	(HL),1		;???
		JP	0CCFH		;???

		JP	0D05H		;???

		LD	HL,3		;???
		LD	(HL),3		;???
		JP	0CCFH		;???

		JP	0D05H		;???

		LD	HL,(1F80H)	;???
		LD	H,0		;???
		EX	DE,HL		;???
		LD	C,2		;???
		CALL	bdos		;???
		JP	0D05H		;???

		.dw	0C0AH
		.dw	0C2EH
		.dw	0C31H
		.dw	0C34H
		.dw	0C37H
		.dw	0C3AH
		.dw	0C3DH
		.dw	0C46H
		.dw	0C50H
		.dw	0C5BH
		.dw	0C66H
		.dw	0C71H
		.dw	0C7FH
		.dw	0C8AH
		.dw	0C95H
		.dw	0CA0H
		.dw	0CAEH
		.dw	0CB9H
		.dw	0CC4H
		.dw	0CCFH

		LD	A,(1F81H)	;???
		LD	(3),A		;???
		RET			;???

		LD	HL,1F82H	;???
		LD	(HL),C		;???
		LD	A,(1F82H)	;???
		CP	9		;???
		JP	Z,0D22H		;???
		.db	2ah,82h		;???

		LD	HL,0
		ADD	HL,SP
		LD	(0E8FH),HL
		LD	SP,1DEH
		LD	DE,103H		;sign-on msg.
		CALL	846H		;print string
		CALL	5FBH		;open files
		CALL	782H
		CALL	1F9H
		JR	1F1H		;loop

		CALL	2F3H
		JP	Z,2D3H
		LD	HL,856H
		LD	BC,0AH
		CALL	351H
		JP	Z,382H
		LD	HL,9E7H
		LD	BC,0AH
		CALL	351H
		JP	Z,388H
		LD	HL,0A74H
		LD	BC,0AH
		CALL	351H
		JP	Z,3AEH
		LD	HL,0AD9H
		LD	BC,0AH
		CALL	351H
		JP	Z,404H
		LD	HL,0B2AH
		LD	BC,5
		CALL	351H
		JP	Z,413H
		LD	HL,0B53H
		LD	BC,5
		CALL	351H
		JP	Z,422H
		LD	HL,0B7CH
		LD	BC,5
		CALL	351H
		JP	Z,42DH
		LD	HL,0BA5H
		LD	BC,0CH
		CALL	351H
		JP	Z,457H
		LD	B,5
		LD	HL,0E91H
		LD	A,(HL)
		CP	20H
		JR	Z,273H
		CP	9
		JR	Z,273H
		CALL	70CH
		INC	HL
		DJNZ	264H
		LD	A,9
		CALL	70CH
		LD	HL,(0E99H)
		LD	C,0
		LD	A,(HL)
		CP	20H
		JR	Z,29DH
		CP	9
		JR	Z,29DH
		CP	0DH
		JR	Z,2D3H
		CP	';'
		JR	Z,2AFH
		CP	27H
		JR	NZ,297H
		DEC	C
		JR	Z,297H
		LD	C,1
		CALL	70CH
		INC	HL
		JR	27DH

		PUSH	HL
		CALL	6ABH
		POP	HL
		CP	cr
		JR	Z,2D3H
		CP	';'
		JR	Z,2AFH
		CALL	2E5H
		JR	27DH

		DEC	C
		INC	C
		JR	NZ,297H
		CALL	6ABH
		LD	B,')'
		LD	A,(0E8EH)
		CP	B
		JR	NC,2D3H
		DEC	A
		AND	0F8H
		ADD	A,9
		CP	B
		JR	Z,2D3H
		JR	C,2CCH
		LD	A,' '
		JR	2CEH

		LD	A,9
		CALL	70CH
		JR	2B8H

		CALL	2DCH
		LD	A,1
		LD	(0E8EH),A
		RET

		LD	A,(HL)
		AND	A
		RET	Z
		CALL	70CH
		INC	HL
		JR	2DCH

		LD	A,(HL)
		CP	' '
		JR	Z,2EDH
		CP	tab
		RET	NZ
		CALL	70CH
		INC	HL
		JR	2E5H

		LD	HL,0EE5H
		LD	A,(HL)
		CP	' '
		JR	Z,31DH
		CP	tab
		JR	Z,31DH
		CP	';'
		RET	Z
		LD	A,(HL)
		CP	':'
		JR	Z,32BH
		CP	tab
		JR	Z,32BH
		CP	cr
		JR	Z,32CH
		CP	';'
		JR	Z,32CH
		CP	' '
		JR	Z,32BH
		CALL	70CH
		INC	HL
		JR	302H

		CALL	6ABH
		PUSH	HL
		CALL	689H
		CP	':'
		POP	HL
		JR	Z,302H
		JR	331H

		INC	HL
		LD	A,':'
		CALL	70CH
		LD	A,tab
		CALL	70CH
		CALL	6ABH
		LD	A,(HL)
		CP	';'
		RET	Z
		CP	cr
		RET	Z
		LD	B,5
		LD	DE,0E91H
		CALL	692H
		CALL	6ABH
		LD	(0E99H),HL
		XOR	A
		INC	A
		RET

		LD	A,(HL)
		AND	A
		JR	Z,363H
		PUSH	BC
		LD	B,5
		LD	DE,0E91H
		CALL	6EEH
		POP	BC
		RET	Z
		ADD	HL,BC
		JR	351H

		INC	A
		RET

		LD	B,5		;???
		JR	36EH		;???

		LD	BC,5
		ADD	HL,BC
		LD	B,C
		LD	A,(HL)
		CP	' '
		JR	Z,37DH
		CP	tab
		JR	Z,37DH
		CALL	70CH
		INC	HL
		DJNZ	36EH
		LD	A,9
		JP	70CH

		CALL	369H
		JP	278H

		CALL	369H
		LD	HL,(0E99H)
		LD	A,(HL)
		AND	5FH
		CP	'M'
		JR	NZ,3A1H
		INC	HL
		PUSH	HL
		LD	HL,3A9H
		CALL	2DCH
		POP	HL
		JP	27BH

		LD	C,0
		LD	A,(HL)
		AND	5FH
		JP	27EH

		.db	"(HL)",0

		CALL	369H
		LD	HL,(0E99H)
		PUSH	HL
		LD	A,(HL)
		AND	5FH
		CP	'B'
		JR	Z,3E1H
		CP	'D'
		JR	Z,3E6H
		CP	'H'
		JR	Z,3EBH
		CP	'P'
		JR	NZ,3F4H
		INC	HL
		LD	A,(HL)
		AND	5FH
		CP	'S'
		JR	NZ,3F4H
		INC	HL
		LD	A,(HL)
		AND	5FH
		CP	'W'
		JR	NZ,3F4H
		POP	HL
		INC	HL
		INC	HL
		PUSH	HL
		LD	HL,3F8H
		JR	3EEH

		LD	HL,3FBH
		JR	3EEH

		LD	HL,3FEH
		JR	3EEH

		LD	HL,401H
		CALL	2DCH
		POP	HL
		INC	HL
		PUSH	HL
		POP	HL
		JP	27BH

		.db	"AF",0

		.db	"BC",0

		.db	"DE",0

		.db	"HL",0

		CALL	369H
		LD	HL,410H
		CALL	2DCH
		JP	38BH

		.db	"A,",0

		LD	HL,417H
		CALL	441H
		JP	278H

		.db	"RET  ",0

		LD	HL,422H
		JR	430H

		.db	"CALL ",0

		LD	HL,436H
		CALL	441H
		LD	A,','
		CALL	70CH
		JP	278H

		.db	"JP   ",0

		CALL	369H
		LD	A,(0E92H)
		AND	5FH
		CALL	70CH
		LD	A,(0E93H)
		AND	5FH
		CP	' '
		RET	Z
		JP	70CH

		PUSH	HL
		LD	BC,0AH
		ADD	HL,BC
		LD	C,(HL)
		INC	HL
		LD	B,(HL)
		POP	HL		;executes addr.
		PUSH	BC		;loaded from
		RET			;memory?

		CALL	369H
		LD	HL,46EH
		CALL	2DCH
		JP	3B1H

		.db	"HL,",0

		CALL	369H
		LD	HL,47BH
		JP	5C1H

		.db	"A,",0

		CALL	369H
		LD	HL,486H
		JR	4BEH

		.db	"A,(",0

		CALL	369H
		LD	HL,(0E99H)
		LD	A,(HL)
		AND	5FH
		CP	'B'
		JR	Z,49EH
		CP	'D'
		JR	Z,4A4H
		JP	27BH

		LD	HL,4AAH	
		JP	595H

		LD	HL,4B1H
		JP	595H

		.db	"A,(BC)",0

		.db	"A,(DE)",0

		CALL	369H
		LD	HL,4CCH
		CALL	2DCH
		CALL	5CFH
		LD	A,')'
		CALL	70CH
		JP	27BH

		.db	"HL,(",0

		CALL	369H
		LD	HL,(0E99H)
		LD	A,(HL)
		AND	5FH
		CP	'M'
		JR	NZ,4F1H
		PUSH	HL
		LD	HL,3A9H
		CALL	2DCH
		POP	HL
		INC	HL
		JP	0F45H

		CALL	70CH
		INC	HL
		JP	38EH

		CALL	70CH
		JR	4E6H

		CALL	369H
		PUSH	HL
		LD	HL,522H
		CALL	2DCH
		POP	HL
		CALL	5CFH
		LD	A,')'
		CALL	70CH
		JP	27BH

		CALL	369H
		LD	A,'('
		CALL	70CH
		INC	HL
		CALL	5CFH
		PUSH	HL
		LD	HL,51EH
		JR	56EH

		.db	"),A",0

		.db	"A,(",0

		CALL	369H
		LD	HL,3A9H
		JP	5C1H

		CALL	369H
		LD	HL,538H
		JP	5C1H

		.db	"8*",0

		CALL	369H
		LD	A,'('
		CALL	70CH
		CALL	5CFH
		PUSH	HL
		LD	HL,54CH
		JR	56EH

		.db	"),HL",0

		CALL	369H
		LD	HL,559H
		JR	5C1H

		.db	"SP,HL",0

		CALL	369H
		LD	A,'('
		CALL	70CH
		CALL	5CFH
		PUSH	HL
		LD	HL,575H
		CALL	2DCH
		POP	HL
		JP	27BH

		.db	"),A",0

		CALL	369H
		LD	HL,(0E99H)
		LD	A,(HL)
		AND	5FH
		CP	'B'
		JR	Z,58DH
		CP	'D'
		JR	Z,592H
		JP	27BH

		LD	HL,59FH
		JR	595H

		LD	HL,5A6H
		CALL	2DCH
		LD	HL,(0E99H)
		INC	HL
		JP	27BH

		.db	"(BC),A",0

		.db	"(DE),A",0

		CALL	369H
		LD	HL,5B5H
		JR	5C1H

		.db	"DE,HL",0

		CALL	369H
		LD	HL,5C7H
		CALL	2DCH
		JP	278H

		.db	"(SP),HL",0

		LD	HL,(0E99H)
		LD	A,(HL)
		CP	';'
		JR	Z,5DEH
		CP	cr
		JR	Z,5DEH
		INC	HL
		JR	5D2H

		DEC	HL
		LD	A,(HL)
		CP	' '
		JR	Z,5DEH
		CP	tab
		JR	Z,5DEH
		INC	HL
		EX	DE,HL
		LD	HL,(0E99H)
		LD	A,D
		CP	H
		JR	NZ,5F4H
		LD	A,E
		CP	L
		RET	Z
		LD	A,(HL)
		CALL	70CH
		INC	HL
		JR	5EDH

		XOR	A
		LD	(0E8AH),A
		LD	(0E8BH),A
		INC	A
		LD	(0E8EH),A
		CALL	620H
		LD	DE,0D70H	;ASM file opened
		CALL	846H		;print string
		CALL	63CH
		LD	DE,0D9CH	;Z80 output ready
		CALL	846H		;print string
		LD	A,(6DH)
		CP	' '
		RET	NZ
		XOR	A
		RET

		LD	HL,5CH
		LD	DE,0EA1H
		LD	BC,9
		LDIR
		LD	DE,0EA1H
		LD	C,0FH		;open file
		CALL	bdos
		INC	A
		JR	Z,669H
		LD	A,80H
		LD	(0EA0H),A
		RET

		LD	HL,5CH
		LD	DE,0EC3H
		LD	BC,9
		LDIR
		LD	DE,0EC3H
		LD	C,11H		;search for first
		CALL	bdos
		INC	A
		JR	NZ,673H
		LD	DE,0EC3H
		LD	C,16H		;make file
		CALL	bdos
		INC	A
		JR	Z,66EH
		LD	A,80H
		LD	(0E9DH),A
		LD	HL,0F4FH
		LD	(0E9BH),HL
		RET

		LD	DE,0E16H	;src file not found
		JR	67BH

		LD	DE,0E35H	;disk full
		JR	67BH

		LD	DE,0E4EH	;duplicate output f.n.
		JR	67BH

		LD	DE,0DDEH	;in. file rd. err.
		PUSH	DE
		LD	DE,0E87H	;cr/lf
		CALL	846H
		POP	DE
		CALL	846H
		JP	cpm

		PUSH	BC
		CALL	6B6H
		POP	BC
		RET	Z
		INC	HL
		JR	689H

		LD	C,B
		LD	B,0
		PUSH	BC
		PUSH	DE
		PUSH	HL
		CALL	702H
		POP	HL
		POP	DE
		POP	BC
		PUSH	BC
		CALL	6B6H
		POP	BC
		RET	Z
		LDI
		JP	PO,6B6H
		JR	69EH

		LD	A,(HL)
		CP	' '
		JR	Z,6B3H
		CP	tab
		RET	NZ
		INC	HL
		JR	6ABH

		PUSH	DE
		EX	DE,HL
		LD	HL,6C2H
		CALL	6D0H
		EX	DE,HL
		LD	A,(HL)
		POP	DE
		RET

		.db	1
		.db	1

		.db	",:+-/* );"
		.db	cr,tab,0

		CALL	6DAH
		RET	NZ
		LD	C,B
		LD	B,0
		ADD	HL,BC
		SUB	A
		RET

		LD	B,(HL)
		INC	HL
		LD	C,(HL)
		INC	HL
		LD	A,(HL)
		AND	A
		JR	Z,6ECH
		CALL	6EEH
		RET	Z
		LD	A,C
		CALL	6FDH
		JR	6DEH

		INC	A
		RET

		PUSH	HL
		PUSH	DE
		PUSH	BC
		LD	A,(DE)
		CP	(HL)
		JR	NZ,6F9H
		INC	HL
		INC	DE
		DJNZ	6F1H
		POP	BC
		POP	DE
		POP	HL
		RET

		ADD	A,L
		LD	L,A
		RET	NC
		INC	HL
		RET

		LD	A,' '
		LD	(DE),A
		LD	H,D
		LD	L,E
		INC	DE
		DEC	BC
		LDIR
		RET

		PUSH	HL
		PUSH	DE
		PUSH	BC
		PUSH	AF
		LD	HL,(0E9BH)
		LD	(HL),A
		CP	9
		JR	NZ,722H
		LD	A,(0E8EH)
		DEC	A
		AND	0F8H
		ADD	A,9
		JR	726H

		LD	A,(0E8EH)
		INC	A
		LD	(0E8EH),A
		INC	HL
		LD	A,(0E9DH)
		DEC	A
		JR	NZ,743H
		LD	DE,0F4FH
		LD	C,1AH		;set DMA
		CALL	bdos
		LD	DE,0EC3H
		CALL	74EH
		LD	HL,0F4FH
		LD	A,80H
		LD	(0E9BH),HL
		LD	(0E9DH),A
		POP	AF
		POP	BC
		POP	DE
		POP	HL
		RET

		LD	C,15H		;write sequential
		CALL	bdos
		AND	A
		RET	Z
		LD	DE,0DF9H	;output file wr. err.
		JP	67BH

		LD	A,(0E9DH)
		CP	80H
		JR	Z,769H
		LD	A,1AH
		CALL	70CH
		JR	75BH

		LD	DE,0EC3H
		LD	C,10H		;close file
		CALL	bdos
		LD	DE,0E87H	;cr/lf
		CALL	846H
		LD	DE,0E6EH	;end of trans.
		CALL	846H
		LD	HL,(0E8FH)
		LD	SP,HL
		RET

		LD	HL,0EE5H
		LD	B,'P'
		LD	DE,(0E9EH)
		LD	A,(0EA0H)
		CP	80H
		JR	NZ,007BFH
		EXX
		LD	A,(0E8BH)
		CP	0
		JR	NZ,7A5H	
		LD	A,(0E8AH)
		CP	0FFH
		JP	Z,75BH
		CALL	7FEH
		LD	HL,(0E8CH)
		LD	DE,0FD1H
		LD	BC,80H
		LDIR
		CALL	7F3H
		LD	A,(0E8BH)
		DEC	A
		LD	(0E8BH),A
		EXX
		LD	DE,0FD1H
		XOR	A
		LD	(0EA0H),A
		LD	A,(DE)
		INC	DE
		LD	(0E9EH),DE
		PUSH	HL
		LD	HL,0EA0H
		INC	(HL)
		POP	HL
		LD	(HL),A
		CP	cr
		JR	Z,7E3H
		CP	tab
		JR	Z,7DBH
		CP	' '
		JR	C,787H
		DEC	B
		INC	HL
		JR	NZ,787H
		INC	B
		DEC	HL
		JR	787H

		INC	HL
		LD	(HL),0AH
		INC	HL
		LD	(HL),0
		LD	(0E9EH),DE
		LD	A,B
		SUB	'P'
		JR	Z,782H
		RET

		LD	HL,(0E8CH)
		LD	DE,80H
		ADD	HL,DE
		LD	(0E8CH),HL
		RET

		XOR	A
		LD	(0E8BH),A
		LD	HL,0FD3H
		LD	(0E8CH),HL
		CALL	7F3H
		LD	DE,(0E8CH)
		LD	C,1AH		;set DMA
		CALL	bdos
		LD	DE,0EA1H
		LD	C,14H		;read sequential
		CALL	bdos
		CP	1
		JR	Z,837H
		CP	0
		JP	NZ,678H
		LD	A,(0E8BH)
		INC	A
		LD	(0E8BH),A
		CP	10H
		JR	NZ,808H
		LD	HL,1053H
		LD	(0E8CH),HL
		RET

		LD	A,0FFH
		LD	(0E8AH),A
		LD	A,(0E8BH)
		CP	0
		JP	Z,75BH
		JR	830H

		LD	A,(DE)		;print string
		AND	A
		RET	Z
		PUSH	DE
		LD	E,A
		LD	D,0
		LD	C,2		;console output
		CALL	bdos
		POP	DE
		INC	DE
		JR	846H

		.db	"ANI  "
		.db	"AND  "
		.db	"ani  "
		.db	"AND  "
		.db	"call "
		.db	"CALL "
		.db	"CMA  "
		.db	"CPL  "
		.db	"cma  "
		.db	"CPL  "
		.db	"CMC  "
		.db	"CCF  "
		.db	"cmc  "
		.db	"CCF  "
		.db	"CPI  "
		.db	"CP   "
		.db	"cpi  "
		.db	"CP   "
		.db	"HLT  "
		.db	"HALT "
		.db	"hlt  "
		.db	"HALT "
		.db	"JMP  "
		.db	"JP   "
		.db	"jmp  "
		.db	"JP   "
		.db	"ORI  "
		.db	"OR   "
		.db	"ori  "
		.db	"OR   "
		.db	"RAL  "
		.db	"RLA  "
		.db	"ral  "
		.db	"RLA  "
		.db	"RAR  "
		.db	"RRA  "
		.db	"rar  "
		.db	"RRA  "
		.db	"ret  "
		.db	"RET  "
		.db	"RLC  "
		.db	"RLCA "
		.db	"rlc  "
		.db	"RLCA "
		.db	"RRC  "
		.db	"RRCA "
		.db	"rrc  "
		.db	"RRCA "
		.db	"STC  "
		.db	"SCF  "
		.db	"stc  "
		.db	"SCF  "
		.db	"XRI  "
		.db	"XOR  "
		.db	"xri  "
		.db	"XOR  "
		.db	"DB   "
		.db	"DEFB "
		.db	"db   "
		.db	"DEFB "
		.db	"DS   "
		.db	"DEFS "
		.db	"ds   "
		.db	"DEFS "
		.db	"DW   "
		.db	"DEFW "
		.db	"dw   "
		.db	"DEFW "
		.db	"SET  "
		.db	"DEFL "
		.db	"set  "
		.db	"DEFL "
		.db	"ASEG "
		.db	"ABS  "
		.db	"CSEG "
		.db	"REL  "
		.db	"DSEG "
		.db	"DATA "
		.db	"ENDM "
		.db	"MEND "
		.db	0

		.db	"ANA  "
		.db	"AND  "
		.db	"ana  "
		.db	"AND  "
		.db	"CMP  "
		.db	"CP   "
		.db	"cmp  "
		.db	"CP   "
		.db	"DCR  "
		.db	"DEC  "
		.db	"dcr  "
		.db	"DEC  "
		.db	"INR  "
		.db	"INC  "
		.db	"inr  "
		.db	"INC  "
		.db	"MVI  "
		.db	"LD   "
		.db	"mvi  "
		.db	"LD   "
		.db	"ORA  "
		.db	"OR   "
		.db	"ora  "
		.db	"OR   "
		.db	"XRA  "
		.db	"XOR  "
		.db	"xra  "
		.db	"XOR  "
		.db	0

		.db	"DCX  "
		.db	"DEC  "
		.db	"dcx  "
		.db	"DEC  "
		.db	"INX  "
		.db	"INC  "
		.db	"inx  "
		.db	"INC  "
		.db	"LXI  "
		.db	"LD   "
		.db	"lxi  "
		.db	"LD   "
		.db	"POP  "
		.db	"POP  "
		.db	"pop  "
		.db	"POP  "
		.db	"PUSH "
		.db	"PUSH "
		.db	"push "
		.db	"PUSH "
		.db	0

		.db	"ADC  "
		.db	"ADC  "
		.db	"adc  "
		.db	"ADC  "
		.db	"ADD  "
		.db	"ADD  "
		.db	"add  "
		.db	"ADD  "
		.db	"SBB  "
		.db	"SBC  "
		.db	"sbb  "
		.db	"SBC  "
		.db	"SUB  "
		.db	"SUB  "
		.db	"sub  "
		.db	"SUB  "
		.db	0

		.db	"RC   "
		.db	"RNC  "
		.db	"RZ   "
		.db	"RNZ  "
		.db	"RP   "
		.db	"RM   "
		.db	"RPE  "
		.db	"RPO  "
		.db	0

		.db	"CC   "
		.db	"CNC  "
		.db	"CZ   "
		.db	"CNZ  "
		.db	"CP   "
		.db	"CM   "
		.db	"CPE  "
		.db	"CPO  "
		.db	0

		.db	"JC   "
		.db	"JNC  "
		.db	"JZ   "
		.db	"JNZ  "
		.db	"JP   "
		.db	"JM   "
		.db	"JPE  "
		.db	"JPO  "
		.db	0

		.db	"ACI  "
		.db	"ADC  "
		.dw	472H

		.db	"aci  "
		.db	"ADC  "
		.dw	472H

		.db	"ADI  "
		.db	"ADD  "
		.dw	472H

		.db	"adi  "
		.db	"ADD  "
		.dw	472H

		.db	"SBI  "
		.db	"SBC  "
		.dw	472H

		.db	"sbi  "
		.db	"SBC  "
		.dw	472H

		.db	"SUI  "
		.db	"SUB  "
		.dw	472H

		.db	"sui  "
		.db	"SUB  "
		.dw	472H

		.db	"DAD  "
		.db	"ADD  "
		.dw	462H

		.db	"dad  "
		.db	"ADD  "
		.dw	462H

		.db	"IN   "
		.db	"IN   "
		.dw	4F6H

		.db	"in   "
		.db	"IN   "
		.dw	4F6H

		.db	"LDA  "
		.db	"LD   "
		.dw	47EH

		.db	"lda  "
		.db	"LD   "
		.dw	47EH

		.db	"LDAX "
		.db	"LD   "
		.dw	48AH

		.db	"ldax "
		.db	"LD   "
		.dw	48AH

		.db	"LHLD "
		.db	"LD   "
		.dw	4B8H

		.db	"lhld "
		.db	"LD   "
		.dw	4B8H

		.db	"MOV  "
		.db	"LD   "
		.dw	4D1H

		.db	"mov  "
		.db	"LD   "
		.dw	4D1H

		.db	"OUT  "
		.db	"OUT  "
		.dw	50CH

		.db	"out  "
		.db	"OUT  "
		.dw	50CH

		.db	"PCHL "
		.db	"JP   "
		.dw	526H

		.db	"pchl "
		.db	"JP   "
		.dw	526H

		.db	"RST  "
		.db	"RST  "
		.dw	52FH

		.db	"rst  "
		.db	"RST  "
		.dw	52FH

		.db	"SHLD "
		.db	"LD   "
		.dw	53BH

		.db	"shld "
		.db	"LD   "
		.dw	53BH

		.db	"SPHL "
		.db	"LD   "
		.dw	551H

		.db	"sphl "
		.db	"LD   "
		.dw	551H

		.db	"STA  "
		.db	"LD   "
		.dw	55FH

		.db	"sta  "
		.db	"LD   "
		.dw	55FH

		.db	"STAX "
		.db	"LD   "
		.dw	579H

		.db	"stax "
		.db	"LD   "
		.dw	579H

		.db	"XCHG "
		.db	"EX   "
		.dw	5ADH

		.db	"xchg "
		.db	"EX   "
		.dw	5ADH

		.db	"XTHL "
		.db	"EX   "
		.dw	5BBH

		.db	"xthl "
		.db	"EX   "
		.dw	5BBH

		.db	0
		.db	0
		.db	0

		.db	tab,"** Input ASM"
		.db	" File Located and"
		.db	" Opened **",cr,lf
		.db	lf,0

		.db	tab,"** Output Z80"
		.db	" File Opened **"
		.db	cr,lf,lf
		.db	tab,"** Transla"
		.db	"tion in Progress"
		.db	" **",cr,lf,lf,0

		.db	"Input File Read"
		.db	" Error",cr,lf
		.db	bel,bel,bel,0

		.db	"Output File Write"
		.db	" Error",cr,lf
		.db	bel,bel,bel,0

		.db	"ASM Source File"
		.db	" Not Found",cr,lf
		.db	bel,bel,bel,0

		.db	"Disk Full--No"
		.db	" Space",cr,lf
		.db	bel,bel,bel,0

		.db	"Duplicate Out"
		.db	"put File Name"
		.db	cr,lf,bel,bel,bel,0

		.db	tab,">> End of"
		.db	" Translation"
		.db	" <<",cr,lf,0
;
;  everything below here just left-over junk?
;
		.db	0,0,0,0,0

		.db	"Opened *"
		.db	"*",cr,lf,lf
		.db	0

		.db	tab,"** O"

		.db	0,0,0,0,0,0,0,0
		.db	0,"ASM"

		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0

		.db	"Z80"

		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0

		.db	"ile Read Error"
		.db	cr,lf,7,7,7,0

		.db	"Output File Write"
		.db	" Error",cr,lf
		.db	7,7,7,0

		.db	"ASM Source File"
		.db	" Not Found",cr,lf
		.db	7,7,7,0

		.db	"Disk Full--No"
		.db	" Sp~",0FEh,","
		.db	"(",2,0E6h,"_"
		JP	4EAH		;<--maybe not junk.  This
					;is the only reference to
					;4EAH in the code!

		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0

		.db	"File Write Err"
		.db	"or",cr,lf,7,7,7,0

		.db	"ASM Source File"
		.db	" Not Found",cr,lf
		.db	7,7,7,0

		.db	"Disk Full--No"
		.db	" Spac"


		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0,0,0,0,0,0,0,0
		.db	0

		LD	B,(HL)
		CALL	0CA05H
		LD	A,(0D4ACH)
		CALL	0CA05H
		LD	A,(IY+6)
		LD	C,'S'
		CALL	0D6B1H
		LD	C,'Z'
		CALL	0D6B1H
		RLA
		LD	C,'H'
		CALL	0D6B1H
		RLA
		LD	C,'P'
		CALL	0D6B1H
		LD	C,'N'
		CALL	0D6B1H
		LD	C,'C'
		CALL	0D6B1H
		CALL	0C9F2H
		RET

		RLA
		PUSH	AF
		JR	NC,10B8H
		LD	A,C
		JR	10BAH

		LD	A,' '
		CALL	0CA05H
		POP	AF
		RET

		PUSH	HL
		EX	DE,HL
		CALL	0C9FEH
		LD	A,(0D4ACH)
		CALL	0CA05H
		POP	HL
		CALL	0CA5BH
		CALL	0C9F2H
		RET

		PUSH	AF
		LD	A,C
		CALL	0CA05H
		LD	A,(0D4ACH)
		CALL	0CA05H
		POP	AF
		CALL	0CA62H
		CALL	0C9F2H
		RET

		LD	A,(IY+7)
		LD	C,'A'
		JR	10D2H

		LD	A,(IY+1)
		LD	C,'B'
		JR	10D2H

		LD	A,(IY+0)
		LD	C,'C'
		JR	10D2H

		LD	A,(IY+3)
		LD	C,'D'
		.DB	18H

		.END
