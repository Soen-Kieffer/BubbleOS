[bits 16]
[org 0x0000]

push cs
pop ds

mov ax, 03h
int 10h

store_string: equ 0x1000
string_handle: equ 0x2000


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

mov [count], 0

start_convert:
mov al, [count]
mov ah, 0
mov si, store_string   ; aller a la bonne position (debut de store string + bh)
mov di, string_handle
add si, ax
add di, ax

lodsb
cmp al, 0x3B
jz stop_convert
mov bl, al
mov si, table_nbr
loop_convert_STRINT:
    lodsb
    cmp al, bl
    jz find
    cmp al, 0
    jz ERREUR
    jmp loop_convert_STRINT

find:
    inc si
    lodsb
    stosb
    inc [count]
    jmp start_convert

stop_convert:
mov si, string_handle
lodsb
mov bl, al
lodsb
mov ah, al
mov si, table_nbr
add bl, bh
mov ah, 0
mov bh, 0
loop_convert_INTSTR:
    lodsb
    cmp bx, ax
    jz findA

findA:
    dec si
    lodsb
    stosb
    mov si, retour
    call print
    mov ah, 0x0e
    int 10h
    jmp STOP


ERREUR:
    mov si, err_msg
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
finish: db "finish",0
err_msg: db "ERROR!",0
av: db "X",0
retour: db 10,13, 0
table_nbr: db "1",1,"2",2,"3",3,"4",4,"5",5,"6",6,"7",7,"8",8,"9",9,"0",0
numbers: db "1","2","3","4","5","6","7","8","9","0"
oper: db "+","-"
count: db 0
STOP:
    cli
    hlt
times (10*512)-($-$$) db 0