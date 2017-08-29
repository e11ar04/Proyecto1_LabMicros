;;macros a utilizar:
%include "mac.mac"

;strings que se imprimen a traves de la corrida del programa:
section .data
        infocpu0 db ">>> PORCENTAJE DE USO DEL CPU <<<",10,0
        infocpu1 db "  Ultimo minuto: ",0
        infocpu2 db "  Ultimos 5 minutos: ",0
        infocpu3 db "  Ultimos 15 minutos: ",0
        ncores db "  Cantidad de nucleos: ",0
        decimal db "."

;bytes utilizados para almacenar lo que se extrae del llamado sys_sysinfo
;en estos tambien se almacena la info a imprimir
section .bss
        cpuload0 resb 32        ;se almacenan los primeros 4 bytes que da sys_sysinfo
        cpuload1 resb 16        ;bytes utilizados para imprimir el porcentaje de uso
        cpuload2 resb 8
        acores resb 16          ;bytes utilizados para imprimir # cores
        bcores resb 8

;programa principal:
section .text
        global _start

_start:
        mov rax, 99             ;se extraen los primeros 4 bytes que da sys_sysinfo
        mov rdi, cpuload0       ;se guarda en cpuload0
        syscall

        mov rax, infocpu0       ;se imprime un 'titulo'
        printstring

        mov rax, ncores
        printstring

        cantnuc
        mov r15d, ebx
        mov eax, ebx
        printnum acores, bcores ;se imprime la cantidad de nucleos, queda almacenado en rbx

        mov rax, infocpu1
        printstring
                                ;se calcula el porcentaje de uso:
        mov rax, [cpuload0+8]

        mov rdx, 0              ;se divide entre la cantidad de nucleos
        div r15d

        mov rcx, 1000
        mul rcx                 ;se multiplica por mil para ver los decimales

        mov rcx, 65536
        mov rdx, 0              ;se divide entre 2^16 para obtener decimal
        div rcx

        mov rcx, 10
        mov rdx, 0
        div rcx
        mov r15, rdx
        printnum cpuload1, cpuload2 ;se imprime el % de uso del cpu en el ultimo minuto

        mov rax, 1
        mov rdi, 1
        mov rsi, decimal
        mov rdx, 1
        syscall

        mov rax, r15
        printnum cpuload1, cpuload2

        exit
