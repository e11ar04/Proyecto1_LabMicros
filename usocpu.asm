;macros a utilizar:
%include "Macros.mac"

;strings que se imprimen a traves de la corrida del programa:
section .data
        infocpu0 db ">>> PORCENTAJE DE USO DEL CPU <<<",10,0
        infocpu1 db 10,"  Ultimo minuto: ",0
        infocpu2 db "  Ultimos 5 minutos: ",0
        infocpu3 db "  Ultimos 15 minutos: ",0
        ncores db "  Cantidad de nucleos: ",0
        decimal db ".",0
        porcentaje db "%",10,0
        inputseg db "  Cuantos segundos desea correr el programa? ",0

;bytes utilizados para almacenar lo que se extrae del llamado sys_sysinfo, lo que se desea
;imprimir de lo extraido y tambien donde se almacena input del usuario
section .bss
        cpuload0 resb 4         ;se almacenan los primeros 4 bytes que da sys_sysinfo
        numbufx resb 16         ;bytes utilizados para imprimir numeros enteros
        numbufy resb 8
        seconds resb 8          ;almacena la cantidad de segundos que se va correr el programa
        resultado resb 1

;programa principal:
section .text
        global _start
        global _break1

;--------------------------------------Inicio de programa---------------------------------------------
_start:
        mov rax, infocpu0       ;se imprimen titulos
        printstring
        mov rax, ncores
        printstring

        cantnuc                 ;se imprime la cantidad de nucleos, queda almacenado en rbx y r15
        mov r15d, ebx
        mov eax, ebx
        printnum numbufx, numbufy

        mov rax, inputseg       ;se pide la cantidad de segundos que va correr el programa
        printstring

        read seconds, 8         ;se almacena la cantidad de segundos
        mov rax, seconds
        atoi                    ;se pasa de string a entero los segundos,
        mov r14, rax            ;y queda almacenado en r14, se va utilizar como un "contador"
        inc r14                 ;para definir un el ciclo "_loopusocpu"

;--------------------------------------Ciclo General------------------------------------------------
_loopusocpu:
        dec r14                 ;se diminuye en 1 el contador

        mov rax, 99             ;se extraen los primeros 4 bytes que da sys_sysinfo (99=sys_sysinfo)
        mov rdi, cpuload0       ;se guarda en cpuload0
        syscall

        mov rax, infocpu1       ;titulo
        printstring

                                ;Se calcula el porcentaje de uso:
        mov rax, [cpuload0+8]   ;segundo byte de cpuload0 es carga en el CPU en el ultimo min

        mov rdx, 0              ;se divide entre la cantidad de nucleos
        div r15d

        cmp rax, 65536
        jg _cienporciento       ;si la carga del CPU es mayor a 65536, entonces el % de uso
                                ;va dar mayor a 100, entonces simplemente deberia ser 100%
_siga1:

        mov rcx, 1000
        mul rcx                 ;se multiplica por mil para ver los decimales

        ;mov rcx, 65536
        ;mov rdx, 0              ;se divide entre 2^16 para obtener el numero en forma decimal
        ;div rcx

        mov rcx, 6553 ;Se dividio entre 10 de una vez
        mov rdx, 0
        div rcx                 ;se divide entre 10 para tener la parte entera en un registro
        mov r15, rdx            ;y la parte decimal en otro registro
        mov [resultado], rax
_break1:
        printInt rax, numbufx   ;se imprime el % de uso del cpu (parte entera)

        mov rax, decimal        ;se imprime un punto decimal
        printstring

        mov rax, r15
        printInt rax, numbufx   ;se imprime la parte decimal del porcentaje de uso

        mov rax, porcentaje     ;se imprime signo de porcentaje
        printstring

                                ;loop que genera un delay de aprox 1 segundo con una suma y una comparacion
        mov r10, 1
_loopseg:
        inc r10
        cmp r10, 2140000000
        jl _loopseg

        cmp r14, 1              ;compara el contador para saber si el programa debe seguir
        jne _loopusocpu


_exit:                          ;termina el programa

        exit


_cienporciento:
        mov rax, 65536          ;fuerza un valor de 100% de uso
        jmp _siga1
