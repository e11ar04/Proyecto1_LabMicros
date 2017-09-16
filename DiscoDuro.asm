;**************************************************************************
;%include "Macros.mac"
default rel
global getSize
sys_statfs      equ 137

    STRUC STATFS
        .f_type:    resq 1
        .f_bsize:   resq 1
        .f_blocks:  resq 1
        .f_bfree:   resq 1
        .f_bavail:  resq 1
        .f_files:   resq 1
        .f_ffree:   resq 1
        .f_fsid:    resq 1
        .f_namelen: resq 1
        .f_frsize:  resq 1
        .f_flags:   resq 1
        .f_spare:   resq 1

    ENDSTRUC

hddd:
mov ebx,nombre_archivo
mov eax,5
mov ecx,0
mov edx,0
int 80h


mov eax,3
mov ebx,3
mov ecx,contenido_archivo
mov edx,8
int 80h


mov eax,4
mov ebx,1
mov ecx,contenido_archivo


mov rax,rcx ;Se mueve el valor a rax para poder trabajar con el

atoi	    ;Se pasa rax de ASCII a entero

mov r8,512
mul r8	    ;Se multiplica rax con 512 para pasar de bloques a bytes
mov r9,1000000000
div r9	    ;Se multiplica rax con 1000000000 para pasar de bytes a GB
mov r10, rax ;Para que el valor de rax no se vea afectado por la impresion del string

print string_memoria_total,tam_string_memoria_total

;mov rax, r10 ;Se pone el valor anteriormente guardado de rax nuevamente en rax
printInt r10, cosa1
print string_GB,tam_string_GB
mov rax, 1
mov rsi, 0xa
mov rdx, 1    ;Imprime un 'enter'
syscall

xor rax,rax
xor rdi,rdi
xor rsi,rsi ;Para limpiar los registros

mov rdi, fileName ;Se pasa la direccion de la montura del dispositivo
mov rax, sys_statfs; Se hace la llamada al sistema de la funcion statfs
mov rsi, statfs ; Se asigna el puntero como buffer
syscall
mov rax, [statfs + STATFS.f_bfree] ;Se transfiere el parametro de la estructura
                                   ;correspndiente a la cantidad de bloques libres

mov r12,512
mul r12	    ;Se multiplica rax con 512 para pasar de bloques a bytes
mov r13,1000000000
div r13	    ;Se multiplica rax con 1000000000 para pasar de bytes a GB

mov r14, rax ;Para que el valor de rax no se vea afectado por la impresion del string
print string_memoria_libre,tam_string_memoria_libre
mov rax, r14 ;Se pone el valor anteriormente guardado de rax nuevamente en rax
printInt rax,cosa1
print string_GB,tam_string_GB
mov rax, 1
mov rsi, 0xa
mov rdx, 1    ;Imprime un 'enter'
syscall


;exit
ret
;**************************************************************************bre
