;Bubble OS version ALPHA 0.2, 10/2026
;

[bits 16]
[org 0x0000]


push cs
pop ds


test_load: equ 0x0800

start_os:

mov ax, 0x0003          ; Set display and clear screen
int 10h

mov si, msg
call print
call new_line

mov di, input_string
input:                       

    mov ah, 0x0                 ;Obtenir touche ------> al
    int 16h

    if_enter:
        cmp al, 0xD
        jz enter
    else_enter:
        stosb
        mov ah, 0xE
        int 10h
    end_enter:
jmp input

enter:
    mov al, 0x0
    stosb

    handle_fonction:
        mov si, input_string
        lodsb
        cmp al, 0
            jz end_handle_fct
        cmp al, 0x76 ;v
            jz fct_v
        cmp al, 0x73 ;s
            jz stop
        cmp al, 0X65 ;e
            jz echo
        cmp al, 0x63 ;c
            jz clear
        cmp al, 0x68 ;h
            jz help
        else_handle_fct:
        mov si, unknown_fct
        call print
    end_handle_fct:
    call new_line
    call reset
    mov di, input_string
jmp end_enter


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

new_line:
    mov si, start_line
    call print
ret

print_retour:
    mov si, retour
    call print
ret

fct_v:
    mov si, retour
    call print

    mov si, input_string
    call wait_space
    lodsb
    cmp al, 0x68
    jz helloworld
    mov si, version
    call print

jmp end_handle_fct

helloworld:
    mov si, hello
    call print
jmp end_handle_fct

reset:
    mov cx, 16
    mov di, input_string
    loop_reset_input:
        mov al, 0
        stosb
        loop loop_reset_input
ret

echo:
    mov si, retour
    call print
    mov si, input_string
    call wait_space
    call print
jmp end_handle_fct

wait_space:
    wait_space_loop:
        lodsb
        cmp al, 0x20
        jz space_found
    jmp wait_space_loop
    space_found:
ret


clear:
    mov ax, 0x0003          ; Set display and clear screen
    int 10h
jmp end_handle_fct



help:
    mov si, help_str
    call print
    jmp end_handle_fct



msg: db "Welcome on Bubble OS", 10,13, "Version Alpha 0.1",0
version: db "Bubble OS Alpha 0.1", 0
retour: db 10,13, 0
start_line: db 10,13,">", 0
unknown_fct: db 10,13,"Unknown Fonction ", 0
hello: db "HelloWorld!", 0
stop_msg: db 10,13, "Goodbye", 0
space_indx: db 0
before_input: db 0xFF
input_string: times 16 db 0
help_str: db 10,13,"Help:", 10,13, "h -> display this help page", 10,13,"e [str] -> echo string", 10,13, "v [h] -> version",10,13, "c -> reset screen", 10,13,"s -> stop the OS", 0

stop:
    mov si, stop_msg
    call print
    cli
    hlt


times (5*512)-($-$$) db 0