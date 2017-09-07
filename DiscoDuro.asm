;**************************************************************************
%include "Macros.mac"
section .data
nombre_archivo: db '/sys/block/sda/size',0
tam_nombre_archivo: equ $-nombre_archivo
space db ' '
break_line db 0xa

section .bss
contenido_archivo: resb 10
cosa1: resb 8
cosa2: resb 16

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
;int 80h

mov rax,rcx ;Se mueve el valor a rax para poder trabajar con el
atoi	    ;Se pasa rax de ASCII a entero
mov r8,512  
mul r8	    ;Se multiplica rax con 512 para pasar de bloques a bytes
mov r9,1000000000
div r9	    ;Se multiplica rax con 1000000000 para pasar de bytes a GB
printnum cosa2, cosa1



exit



;**************************************************************************