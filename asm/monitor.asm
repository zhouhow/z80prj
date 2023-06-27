; --------------------------------------------------
; Simple monitor program.
; Hein Pragt 2021
;
; Commands:
;
;   Cxxxx          -> Call the routine at XXXX
;
;   Dxxxx          -> Dump 16 bytes of RAM at address.
;   D              -> Dump next 16 bytes 
;
;   Ixxxx xx xx xx -> Enter bytes at addreess
;   I xx xx xx	   -> Store bytes in next addresses
;

	.ORG	0

	ld	sp,stack_start		; Set stack pointer

; ---------------------------------
; Entry point 
; ---------------------------------

	ld 	hl,startline 		; Print start line
	call	printline

; ---------------------------------
; Main loop
; ---------------------------------
	
monitor:
        ld 	a,'>'			; Show Prompt
        out 	(1),a
        ld 	hl,input_buffer
        ld 	(hl),0			; Overwrite old content

; ---------------------------------
; Wait for command 
; ---------------------------------

monitor_input_loop:
	IN	A,(1)			; Wait for key
	CP	0
	JR	Z,monitor_input_loop

	out	(1),a			; Echo key
	ld 	(hl),a
	cp 	0aH			;'\n'
	jr 	z,process_input_line
	cp	0dH			;'\r'
	jr 	z,process_input_line

	inc 	hl
	jr 	monitor_input_loop


; ---------------------------------
; Process input line
;  C => CALL
;  D => DUMP
;  I => INPUT
; ---------------------------------

process_input_line:

	ld 	hl,input_buffer
	ld 	a,(hl)
	call	toupper

	cp 	'C'
	jr 	z,call_handler

	cp 	'D'
	jr 	z,dump_handler

	cp 	'I'
	jr 	z,input_handler

	ld 	hl,error 	   	; Print error line
	call	printline
	jr 	monitor			; Back to main loop


; ---------------------------------
; Process CALL command Cxxxx
; ---------------------------------

call_handler:
	ld 	hl,input_buffer+1	; Skip command C     
	call 	read_hex4_number	; Read address into BC
	ld	hl,monitor		; Adress main loop
	push 	hl			; Put in on stack
	push 	bc			; Push adress to call on stack
	ret				; Ret = goto adress on stack


; ---------------------------------
; Process DUMP command Dxxxx
; dump next 16 bytes 
; or dump 16 byte from xxxx 
; ---------------------------------

dump_handler:

        ld 	hl,input_buffer+1	; Skip command D	
        ld 	a,(hl)
        cp 	0aH			;'\n'
        jr 	z,dump_no_address
        cp 	0dH			;'\r'
        jr 	z,dump_no_address

        call 	read_hex4_number	; Get address
        ld 	(dump_address),bc

dump_no_address:
        ld 	hl,(dump_address)
        call	output_4hex

        ld b,16
dump_byte:
        ld	a,' '			; print space
        out	(1),a
        ld	c,(hl)
        call	output_2hex
        inc	hl
        djnz	dump_byte		; Loop

        ld 	a,0aH			; print '\n'
        out 	(1),a
        ld 	(dump_address),hl	; Save address
        jp	monitor			; Back to CMD line


; ---------------------------------
; Process INPUT command Ixxxx xx xx
; or I xx xx xx to continu input
; ---------------------------------

input_handler:

        ld	hl,input_buffer+1	; Skip command I
        ld	a,(hl)
        cp	' '			; Compare ro space
        jr 	z,input_no_address

        call 	read_hex4_number	; Get address
        ld 	(input_address),bc	; Save address

input_no_address:
        ld 	a,(hl)
        inc 	hl
        cp 	' '			; Skipp spaces
        jr 	z,input_no_address

        cp 	0aH			;'\n'
        jr 	z,input_done
        cp 	0dH			;'\r'
        jr 	z,input_done

        dec 	hl
        call 	read_hex2_number
        ld 	bc,(input_address)
        ld 	(bc),a			; Store it at address
        inc 	bc			; Next address
        ld 	(input_address),bc	; Save it
        jr 	input_no_address	; Loop

input_done:
        jp	monitor			; Back to CMD line

; ---------------------------------
; Convert a 4-digit ASCII (HEX) number
; pointed to by HL to a number in BC
; ---------------------------------

read_hex4_number:
	call		read_hex2_number
	ld		b,a
	call		read_hex2_number
	ld		c,a
	ret

; ---------------------------------
; Convert a 2-digit ASCII (HEX) number
; pointed to by HL to a number in A
; ---------------------------------

read_hex2_number:
	ld	a,(hl)
	call	toupper
	call	read_hex2_number_digit
	rla
	rla
	rla
	rla
	and	0f0H
	ld	d,a
	inc	hl
	ld	a,(hl)
	call	toupper
	call	read_hex2_number_digit
	or	d
	inc	hl
	ret

; ---------------------------------
; Convert a 1-digit ASCII (HEX) number
; in A to a decimal number in A
; ---------------------------------

read_hex2_number_digit:
	sub	'0'
	cp	10
	ret	c
	sub	'A'-'0'-10
	ret


; ---------------------------------
; Toupper A
; ---------------------------------

toupper:
        cp 	'a'		; Check lower
        jr 	c,upperskip
        cp 	'z'
        jr 	nc,upperskip
        sub 	32		; Make uppercase
upperskip:
	ret



; ---------------------------------
; Display 16-bit number in HL to hex.
; ---------------------------------

output_4hex:
	ld	c,h
	call	output_2hex
	ld	c,l
	call	output_2hex
	ret


; ---------------------------------
; Display 8-bit number in C to hex.
; ---------------------------------

output_2hex:
	ld	a,c
	rra
	rra
	rra
	rra
	call	output_hex
 	ld	a,c
output_hex:
	and	$0F
	add	a,$90
 	daa
	adc	a,$40
	daa
	out	(1),a
	ret


; ---------------------------------
; Routine to print out a line in (hl)
; --------------------------------

printline:                   
	ld	a,(hl)	   	; Get cha to print
	cp	'$'	   	; Check '$' terminator
	jp	z,printend 	; jmp to end
;
	out	(1),a
	inc	hl		; Next char
	jp	printline	; Loop
printend:
	ret
	
; ---------------------------------
; Memory defines
; --------------------------------

startline:	
	.DB	12,"HMP Monitor program 1.00",13,10,'$'
error:
	.DB	"ERROR!",13,10,'$'

dump_address:
        .DB	0,0

input_address:
        .DB	0,0

input_buffer:
	; space for input buffer

	.FILL	512,0		; Reserve some space
stack_start:


.END