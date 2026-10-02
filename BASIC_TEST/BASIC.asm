[bits 16]
[org 0x0000]

push cs
pop ds

mov ax, 03h
int 10h

store_string: equ 0x1000

mov si, welcome_msg
call print


; ----------------- [Program Loader] -----------------

mov di, store_string
loop_input:
    cld
    mov ah, 0x0
    mov al, 0x0
    int 16h

    display_char:
    cmp al, 0xD
        jz enter
    cmp al, 0x01
        jz ctl_A
    
    stosb
    mov ah, 0x0e
    int 10h
    jmp loop_input

enter:
    mov si, retour
    call print

    mov ah, 0x0
    int 16h

    cmp al, 0xD
        jz INTERPRETOR
jmp display_char

ctl_A:
    mov si, welcome_msg
    call print
jmp loop_input

jmp STOP

; ----------------- [BubbleBASIC INTERPRETOR] -----------------
INTERPRETOR:

mov al, 0
stosb
mov ax, 03h
int 10h

mov si, interpretor_msg
call print
mov si, store_string
call print
jmp STOP

; ---------- [FONCTIONS ALREADY DEFINE IN MAIN FILE] ----------

print:
    lodsb
    or al,al
    jz stop_print
    mov ah, 0x0e
    int 10h
    jmp print
    stop_print:
ret

store:
    lodsb
    or al,al
    jz stop_store
    stosb
    jmp store
stop_store:
ret

wait_space:
    wait_space_loop:
        lodsb
        cmp al, 0x20
        jz space_found
    jmp wait_space_loop
    space_found:
ret


welcome_msg: db "BubbleBASIC Developpement Version 0.1", 10,13, "DO NOT DISTRIBUTE", 10,13, 0
interpretor_msg: db "Start Interpreting", 10,13,0
retour: db 10,13, 0


STOP:
    cli
    hlt
times (6*512)-($-$$) db 0