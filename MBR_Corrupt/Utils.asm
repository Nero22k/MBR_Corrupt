; Library Fucntions

strcmp proc uses bx si:
    Loop_CMP:
        mov al, byte ptr [si]
        cmp al, byte ptr [bx] 
        
        
        jne Exit_Error
        
        cmp byte ptr [bx], 0h
        je Exit_Successful
        
        inc bx
        inc si
        jmp Loop_CMP

    Exit_Successful:
        cmp byte ptr [si], 0h
        jne Exit_Error
        xor ax, ax
        ret

    Exit_Error:
        mov ax, 1
        ret

strcmp endp