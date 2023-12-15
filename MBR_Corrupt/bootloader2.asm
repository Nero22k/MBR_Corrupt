;---------------------------------------------------

.386						; Compile for a 80386 CPU
option segment:use16		; Force 16 bit segments instead of default 32 bit
.model tiny					; Tiny memory model
.code						; Start of code segment
org 07C00h					; Bootloader entry point
;---------------------------------------------------

start:
    mov byte ptr [DISK], dl

DiskRead:
	mov ah, 02h                 ; Function: read disk
	mov bx, SECOND_STAGE        ; The address that we need it in the disk
	mov al, 02h                 ; Read for about 1024 bytes or / 2 sectors
	mov dl, byte ptr [DISK]     ; Hardcoded Disk number


	xor ch, ch                  ; Set hard drive cylinder -> 0
	xor dh, dh                  ; Set hard drive header -> 0
	mov cl, 02h                 ; Set start sector for reading 
	
	int 13h                     ; Call BIOS interrupt 13h
	jc DiskRead                 ; read again on error

	jmp SECOND_STAGE            ; Indirect far jump

SECOND_STAGE dw 07E00h
DISK db 0
db 510-($-start) dup(0)
dw 0AA55h
end start