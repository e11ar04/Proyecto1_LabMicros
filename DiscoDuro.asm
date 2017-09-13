;**************************************************************************
%include "Macros.mac"
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
%define sizeof(x) x %+ _size

section .data
string_memoria_libre: db 'Memoria Libre del Disco Duro: ',0
tam_string_memoria_libre: equ $-string_memoria_libre
fileName: db '/',0
nombre_archivo: db '/sys/block/sda/size',0
tam_nombre_archivo: equ $-nombre_archivo
space db ' '
string_memoria_total: db 'Memoria Total del Disco Duro: ',0
tam_string_memoria_total: equ $-string_memoria_total
break_line db 0xa
string_GB: db 'GB'
tam_string_GB: equ $-string_GB
memoria_disp1: db '/sys/block/sda/stat',0
tam_memoria_disp: equ $-memoria_disp1
bufsize1 dw 1


section .bss
statfs: resb sizeof(STATFS)
contenido_archivo: resb 10
cosa1: resb 8
cosa2: resb 16
contenido_disp1: resb 10

section .text
global _start

_start:
mov ebx,nombre_archivo
mov eax,5
mov ecx,0
mov edx,0
int 80h

break1:
mov eax,3
mov ebx,3
mov ecx,contenido_archivo
mov edx,8
int 80h

break2:
mov eax,4
mov ebx,1
mov ecx,contenido_archivo
break3:

mov rax,rcx ;Se mueve el valor a rax para poder trabajar con el
break4:
atoi	    ;Se pasa rax de ASCII a entero
break5:
mov r8,512
mul r8	    ;Se multiplica rax con 512 para pasar de bloques a bytes
mov r9,1000000000
div r9	    ;Se multiplica rax con 1000000000 para pasar de bytes a GB
mov r10, rax ;Para que el valor de rax no se vea afectado por la impresion del string
break6:
print string_memoria_total,tam_string_memoria_total
break7:
;mov rax, r10 ;Se pone el valor anteriormente guardado de rax nuevamente en rax
printInt r10, cosa1
print string_GB,tam_string_GB
mov rax, 1
mov rsi, break_line
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
break8:
mov r12,512
mul r12	    ;Se multiplica rax con 512 para pasar de bloques a bytes
mov r13,1000000000
div r13	    ;Se multiplica rax con 1000000000 para pasar de bytes a GB
break9:
mov r14, rax ;Para que el valor de rax no se vea afectado por la impresion del string
print string_memoria_libre,tam_string_memoria_libre
mov rax, r14 ;Se pone el valor anteriormente guardado de rax nuevamente en rax
printInt rax,cosa1
print string_GB,tam_string_GB
mov rax, 1
mov rsi, break_line
mov rdx, 1    ;Imprime un 'enter'
syscall


exit



;**************************************************************************
