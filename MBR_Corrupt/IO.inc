; input output functions
setColors proc
    mov ah, 06h     ;Function 0x06 = Scroll up function
	xor al, al      ; Number of lines by which to scroll up (00h = clear entire window)
    xor cx, cx      ;From upper left corner
    mov dx, 184Fh   ;To lower right corner
    mov bh, 4Fh     ;Set colors
    int 10h         ;Call the bios video interrupt
    ret             ;Return
setColors endp

puts proc      
	cmp byte ptr [si], 0        ; Check if end of string
	je end_put                  ; If so, return
		
	mov al, [si]       			; Get char
	call putc                   ; Print char
	inc si                      ; Increment pointer to next char
	jmp puts                    ; Loop
puts endp

putc proc
	mov ah, 0Eh                 ; TeleTYpe output
	xor bh, bh                  ; Page number
	mov bl, 4Fh                 ; Color
	int 10h                     ; Call BIOS video interrupt
	ret
putc endp

end_put:
	ret                     ; Return

get_user_input proc

	Loop_Get_Input:
		xor ah, ah              ; Get char from keyboard
		int 16h
		
		cmp al, 0Dh             ; User Press Enter
		je Exit_Input
		cmp al, 08h             ; User Press BackSpace
		je Remove_Char
		mov [si], al   ; Put char in the current address
		call putc               ; Print char
		inc si                  ; Increment pointer to next char
		jmp Loop_Get_Input      ; Again

	Remove_Char:
		mov al, 08h             ; Go Back
		call putc
		mov al, 20h             ; Print Space to remove 
		call putc
		mov al, 08h             ; Go Back
		call putc
		dec si
		xor al, al
		mov [si], al            ;  Put null In The Current Address to remove the Char 

		jmp Loop_Get_Input
	
	Exit_Input:
		int 10h
		xor al, al
		inc si
		mov [si], al           ; null-terminate input string 
		ret                             ; callable

get_user_input endp