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
; -----------[SETUP APM]-------------

;perform an APM installation check
mov ah,53h
mov al,00h
xor bx,bx
int 15h
jc APM_error


;connect to an APM interface
mov ah,53h
mov al,01h
xor bx,bx
int 15h
jc APM_error




mov ah,53h               ;this is an APM command
mov al,0eh               ;set driver supported version command
mov bx,0000h             ;device ID of system BIOS
mov ch,01h               ;APM driver major version
mov cl,01h               ;APM driver minor version (can be 01h or 02h if the latter one is supported)
int 15h
jc .version_error
;at this point AX holds the APM version that is connected, AH=major version AL=minor version
;so an additional check might be implemented
jmp .no_error
.version_error:
mov ah, 0x0e
mov al, "V"
int 10h
.no_error:
;continue


;Enable power management for all devices
mov ah,53h              ;this is an APM command
mov al,08h              ;Change the state of power management...
mov bx,0001h            ;...on all devices to...
mov cx,0001h            ;...power management on.
int 15h                 ;call the BIOS function through interrupt 15h
jc APM_error            ;if the carry flag is set there was an error

; ----------[LOAD SECTORS]-----------
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
    mov si, err_mem_msg
    call print_loop
    jmp halt
APM_error:
    mov si, err_APM_msg
    call print_loop
    jmp halt
print_loop:
    lodsb
    or al, al
    jz halt
    mov ah, 0x0e
    int 0x10
    jmp print_loop
ret
halt:
    cli
    hlt

BOOT_DRIVE: db 0
err_mem_msg: db "Erreur lecture disque !", 0
err_APM_msg: db "APM Error", 0

; Remplissage jusqu'à 510 octets, puis signature de boot (0xAA55)
times 510 - ($ - $$) db 0
dw 0xaa55