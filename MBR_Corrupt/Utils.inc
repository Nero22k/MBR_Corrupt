; Library Fucntions
strcmp proc
    Loop_CMP:
        mov al, [si]
        cmp al, [bx] 
        
        
        jne Exit_Error
        
        cmp byte ptr [bx], 0
        je Exit_Successful
        
        inc bx
        inc si
        jmp Loop_CMP

    Exit_Successful:
        cmp byte ptr [si], 0
        jne Exit_Error
        xor ax, ax
        ret

    Exit_Error:
        mov ax, 1
        ret

strcmp endp