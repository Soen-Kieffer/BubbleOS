;BBL (BubbleBootLoader)
;The bootloader of BubbleOS

;Made by Soen KIEFFER
;Github repo: https://github.com/Soen-Kieffer/BubbleOS


[bits 16]
[org 0x7c00]

start:
    cli
    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax
    mov sp, 0x7c00
    sti

    mov [BOOT_DRIVE], dl

    mov ax, 0x1000          ; Segment de destination
    mov es, ax
    xor bx, bx              ; Offset de destination (ES:BX = 0x1000:0x0000)

    mov ah, 0x02            ; Fonction : lire les secteurs
    mov al, 5               ; Nombre de secteurs à lire
    mov ch, 0               ; Cylindre 0
    mov cl, 2               ; Secteur 2 (le secteur 1 est le bootloader)
    mov dh, 0               ; Tête 0
    mov dl, [BOOT_DRIVE]    ; Lecteur de démarrage
    int 0x13
    jc disk_error           ; Le drapeau Carry (CF) est levé en cas d'erreur

    jmp 0x1000:0x0000

disk_error:
    mov si, err_msg
print_loop:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0e
    int 0x10
    jmp print_loop

halt:
    cli
    hlt

BOOT_DRIVE: db 0
err_msg:    db "Erreur lecture disque !", 0

; Remplissage jusqu'à 510 octets, puis signature de boot (0xAA55)
times 510 - ($ - $$) db 0
dw 0xaa55