%include "mac.mac"

section .data
        infocpu0 db ">> Porcentaje de uso del CPU <<",10,0
        infocpu1 db "Ultimo minuto: ",0
        infocpu2 db "Ultimos 5 minutos: ",0
        infocpu3 db "Ultimos 15 minutos: ",0

section .bss
        cpuload0 resb 32
        cpuload1 resb 16
        cpuload2 resb 8

section .text
        global _start

_start:
        mov rax, 99
        mov rdi, cpuload0
        syscall

        mov rax, infocpu0
        printstring

        mov rax, infocpu1
        printstring

        mov rax, [cpuload0+8]
        mov rbx, 65536
        mov rdx, 0
        div rbx
        printnum cpuload1, cpuload2

        exit
