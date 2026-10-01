[bits 16]
[org 0x0000]

payload_start:
    ; Ajuster DS au segment courant (0x1000)
    push cs
    pop ds

    mov si, message
print:
    lodsb
    or al, al
    jz done
    mov ah, 0x0e
    int 0x10
    jmp print

done:
    cli
    hlt

message: db "Programme charge avec succes en RAM !", 13, 10, 0

; Remplir le secteur pour faire exactement 512 octets
times 512 - ($ - $$) db 0