        org     0100h

; do the print call
        ld      hl,msg
        call    vprint

; exit back to the operating system
        ld      c,0
        call    5
        halt

; Print a null-terminated string to CONOUT
; HL = Start address of string
vprint: ld      a,(hl)
        cp      0       ; terminator?
        ret     z       ; return if so
        inc     hl      ; bump string pointer
        push    hl      ; and save it for later
        ld      e,a     ; E = character to print
        ld      c,2     ; C = BDOS conout
        call    5
        pop     hl
        jr      vprint

msg:    db      'Hello',0
