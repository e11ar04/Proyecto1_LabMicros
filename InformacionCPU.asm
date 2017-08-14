;--------------------Segmento de datos--------------------
;Aqui se declaran las constantes de uso frecuente en el programa
section .data 

        ;Textos auxiliares
        salida: db 'Cerrando programa ', 0xa	; Instrucciones para el usuario
        tam_salida: equ $-salida					; Longitud


        ;Información  a Imprimir
        id db "id del Vendedor = 'XXXXXXXXXXXX'",0xA
        modelo db "Modelo = 'xxxxxxxxxxxx'",0xA
;###################################################

;--------------------Segmento de codigo--------------------
;Secuencia de ejecucion del programa

section .text
global _start
global _break ;Etiqueta para depurar

_start:

        ;ID del Vendedor
        mov eax,0    ;Pone eax en 0
        cpuid        ;Toma la información
        mov edi,id  ;Copia el string id para modificarlo con la nueva información
        mov [edi+19],ebx;Copia los primeros 4 bytes en las posiciones de las x
        mov [edi+23],edx;Copia los siguientes bytes en las posiciones de las x
        mov [edi+27],ecx;Copia los ultimos bytes en las posiciones de las x

        ;Imprime el texto ya modificado
        mov eax,4
        mov ebx,1
        mov ecx,id
        mov edx,41 ;Tamaño
        int 0x80


;###############################################################################
        ;Version Information: Type, Family, Model, and Stepping ID
        mov eax,1   ;Pone eax en 1
        cpuid       ;Toma la información
        ;Modelo

        ;El modelo esta dato en eax[7:4]
        mov r10d,eax   ;copia el contenido de eax
        and r10d,0x10  ;deja solamente la informacion del modelo

        ;Comparaciones para determinar el texto del modelo

        cmp r10d,0x90
        jne .fin

        ;mov edi,modelo;Copia el texto a modificar
        ;mov [edi+10],0

        ;Imprime el texto
        mov eax,4
        mov ebx,1
        mov ecx,modelo
        mov edx,41
        int 0x80


        ;Fin
        .fin:

        ;Mensaje de fin

      	mov rax,1							;rax = "sys_write"
      	mov rdi,1							;rdi = 1 (standard output = pantalla)
      	mov rsi,salida					;rsi = mensaje a imprimir
      	mov rdx,tam_salida						;rdx=solo se imprime 1 byte
      	syscall								;Llamar al sistema

        mov eax,1
        xor ebx,ebx
        int 0x80
