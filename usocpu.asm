;Dalberth Corrales (dalbc)
;Programa que imprime en consola el porcentaje de uso del cpu en el ultimo minuto, ultimos 5 minutos
;y ultimos 15 minutos, imprime cada segundo los n segundos que el usuario desee. Ademas, se crea
;un archivo de texto (usocpu.txt) y en este se guardan las n mediciones del % de uso en el ultimo minuto.
;Los porcentajes los calcula a partir de la carga del cpu y la cantidad de nucleos
;--------------------------------------Macros del Programa---------------------------------------------
;%include "Macros.mac"


;---------------------------------------------Data-------------------------------------------------------
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
        file db "usocpu.txt",0
        usocpu db "    "


;----------------------------------------Bytes Reservados-----------------------------------------------
;bytes utilizados para almacenar lo que se extrae del llamado sys_sysinfo, lo que se desea
;imprimir de lo extraido y tambien donde se almacena input del usuario
;section .bss
        ;cpuload0 resb 4         ;se almacenan los primeros 4 bytes que da sys_sysinfo
        ;numbufx resb 16         ;bytes utilizados para imprimir numeros enteros
        ;numbufy resb 8
        ;seconds resb 8          ;almacena la cantidad de segundos que se va correr el programa
        ;residuo resb 8


;--------------------------------------Inicio de programa---------------------------------------------
;programa principal:
;section .text
;        global _start
UsoCPU:
;REGISTROS GLOBALES
;r15 - cantidad de nucleos del CPU
;r14 - contador para definir el ciclo uso_cpu
;r13 - file descriptor de usocpu.txt
;r12 - intermediario para escribir en .txt

;rbx - se utiliza para multiplicar y dividir
;rax - cambia continuamente
;_start:
        mov rax, infocpu0       ;se imprimen titulos
        printstring
        mov rax, ncores
        printstring

        cantnuc                 ;se imprime la cantidad de nucleos, queda almacenado en r15
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

        mov r13, file
        openfile r13, 66, 0666o ;se abre el archivo donde se se va escribir el % de uso del cpu
        mov r13, rax


;--------------------------------------Ciclo General------------------------------------------------
;-------Porcentaje de uso del cpu en el ultimo minuto
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
        jg _cienporciento1      ;si la carga del CPU es mayor a 65536, entonces el % de uso
                                ;va dar mayor a 100, entonces simplemente deberia ser 100%
_siga1:
        mov rbx, 100
        mul rbx                 ;se multiplica por mil para ver los decimales

        mov rbx, 65536
        mov rdx, 0              ;se divide entre 2^16 para obtener el numero en forma decimal
        div rbx

        mov r12, rax
        printInt rax, numbufx   ;se imprime el % de uso del cpu (parte entera)

        mov rax, r12
        filenum usocpu          ;se escribe en un archivo .txt el porcentaje de uso obtenido
        writefile r13, usocpu, 4

        mov rax, porcentaje     ;se imprime signo de porcentaje
        printstring

;-------Porcentaje de uso del cpu en los ultimos 5 minutos
        mov rax, infocpu2       ;Se repiten las ultimas lineas de codigo pero con cpuload0+16
        printstring             ;Ademas, en esta seccion no se escribe sobre archivos de texto

        mov rax, [cpuload0+16]

        mov rdx, 0
        div r15d

        cmp rax, 65536
        jg _cienporciento2

_siga2:
        mov rbx, 100
        mul rbx

        mov rbx, 65536
        mov rdx, 0
        div rbx

        printInt rax, numbufx

        mov rax, porcentaje
        printstring

;-------Porcentaje de uso del cpu en los ultimos 15 minutos
        mov rax, infocpu3       ;Se repiten las ultimas lineas de codigo pero con cpuload0+24
        printstring             ;Ademas, en esta seccion no se escribe sobre archivos de texto

        mov rax, [cpuload0+24]

        mov rdx, 0
        div r15d

        cmp rax, 65536
        jg _cienporciento3

_siga3:
        mov rbx, 100
        mul rbx

        mov rbx, 65536
        mov rdx, 0
        div rbx

        printInt rax, numbufx

        mov rax, porcentaje
        printstring

;--------------------------------------Ciclo Delay 1seg------------------------------------------------
        mov r10, 1         ;loop que genera un delay de aprox 1 segundo con una suma y una comparacion
_loopseg:
        inc r10
        cmp r10, 2100000000
        jl _loopseg

        cmp r14, 1              ;compara el contador para saber si el programa debe seguir
        jne _loopusocpu         ;segun las repeticiones/segundos que el usuario quiere


;--------------------------------------Fin de Programa------------------------------------------------
        closefile r13           ;cierra el archivo de texto
        ;ret
        exit                    ;macro que termina el programa


;---------------------------------------Funciones Extra-----------------------------------------------
;fuerza un valor de 100% de uso
_cienporciento1:
        mov rax, 65536
        jmp _siga1

_cienporciento2:
        mov rax, 65536
        jmp _siga2

_cienporciento3:
        mov rax, 65536
        jmp _siga3
