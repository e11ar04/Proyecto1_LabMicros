
;------Segmento de macros--------------------

;-------------------------  MACRO #1  ----------------------------------
;Programa Elaborado por Simon Whitehead, 2015
;Reestructurado en una serie de macros para ser utilizado en este programa
; ---------------------
; Convierte numeros enteros a sus caracteres ASCII y los imprime

%macro printt 2
    mov rax,4
    mov rbx,1
    mov rcx,%1 ;rdi
    mov rdx,%2 ;rsi
    int 0x80
%endmacro

%macro itoa 1
    push rbp
    mov rbp,rsp
    sub rsp,4		; allocate 4 bytes for our local string length counter

    mov rax,rdi		; Move the passed in argument to rax
    lea rdi,[%1+10]	; load the end address of the buffer (past the very end)
    mov rcx,10		; divisor
    mov [rbp-4],dword 0	; rbp-4 will contain 4 bytes representing the length of the string - start at zero
%endmacro

%macro printInt 2
    mov rdi,%1	; Move the number (123456789) into rax
    itoa	%2	; call the function

		call .divloop

		; Write the string returned in rax out to stdout
		mov rdi,rax		; The string pointer is returned in rax - move it to rdi for the function call
		mov rsi,rcx
		printt rdi,rsi
		printt 10,1


%endmacro

;------------------------- FIN DE MACRO --------------------------------


%include "Macros.mac"  ;Inclusión de los demas macros


;------Segmento de datos--------------------

;Aqui se declaran las constantes de uso frecuente en el programa
section .data

        ;Información  a Imprimir
        id db "id del Vendedor = XXXXXXXXXXXX",0xA
        tam_id: equ $-id

	SteppingID db 'Stepping ID = '
        tam_SteppingID: equ $-SteppingID

        modelo db 'Modelo = '
        tam_modelo: equ $-modelo

	familia db 'Familia = '
        tam_familia: equ $-familia

	tipo db 'Tipo de Procesador= '
        tam_tipo: equ $-tipo

	ModeloExt db 'Modelo Extendido = '
        tam_ModeloExt: equ $-ModeloExt

	SLinea db 0xA

	cache_size db 'Tamano de la Cache de Instrucciones L1 en Bytes = '
	tam_cache_size: equ $-cache_size
	
	cache_size2 db 'Tamano de la Cache de Datos L1 en Bytes = '
	tam_cache_size2: equ $-cache_size2
	
	cacheL2 db 'Tamano de la Cache L2 en Bytes = '
	cacheL2_size: equ $-cacheL2
	
	cacheL3 db 'Tamano de la Cache L3 en Bytes = '
	cacheL3_size: equ $-cacheL3
	
	cores db 'Numero de nucleos = '
	cores_size: equ $-cores
	

section .bss
				;Para el Macro printInt
				 numbuf resb 10		; A buffer to store our string of numbers in

;###################################################

;--------------------Segmento de codigo--------------------
;Secuencia de ejecucion del programa

section .text
global _start
global _break
global _break1



_start:

        ;ID del Vendedor
        mov eax,0    ;Pone eax en 0
        cpuid        ;Toma la información
        mov edi,id  ;Copia el string id para modificarlo con la nueva información
        mov [edi+18],ebx;Copia los primeros 4 bytes en las posiciones de las x
        mov [edi+22],edx;Copia los siguientes bytes en las posiciones de las x
        mov [edi+26],ecx;Copia los ultimos bytes en las posiciones de las x
        print id,tam_id ;Imprime el id


;###############################################################################
        ;Version Information: Type, Family, Model, and Stepping ID

        mov eax,1   ;Pone eax en 1
        cpuid       ;Toma la información
	mov r15,rax ;guarda la informacion de rax en otro registro para reutilizarla

				;_______________________________________________________________________
        ;Stepping ID

        ;Imprime el texto Stepping ID =
        print SteppingID,tam_SteppingID
	printInt rbx,numbuf
        ;Obteniendo el modelo
        ;El modelo esta dado en eax[7:4]
	mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf  ;deja solamente la informacion del modelo
	printInt rbx,numbuf
	print SLinea,1   ;Salto de linea

        ;_______________________________________________________________________
        ;Modelo

        ;Imprime el texto Modelo =
        print modelo,tam_modelo

        ;Obteniendo el modelo
        ;El modelo esta dado en eax[7:4]
				mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf0  ;deja solamente la informacion del modelo
				shr rdx,4  		;desplaza el modelo a la posicion correcta	        printInt rdx,numbuf ;Imprime el modelo
				printInt rbx,numbuf
				print SLinea,1   ;Salto de linea


				;_______________________________________________________________________
				;Familia

				;Imprime el texto Modelo =
				print familia,tam_familia
        ;Obteniendo la familia
        mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf00  ;deja solamente la informacion la familia
				shr rdx,8 		;desplaza la familia a la posicion correcta
				printInt rbx,numbuf
				print SLinea,1   ;Salto de linea

				;_______________________________________________________________________
				;Tipo

				;Imprime el texto Tipo =
				print tipo,tam_tipo
        ;Obteniendo la familia
        mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf000
				shr rdx,12
				printInt rbx,numbuf
				print SLinea,1   ;Salto de linea

	;_______________________________________________________________________
	;Modelo Extendido

	;Imprime el texto Modelo Extendido =
	print ModeloExt,tam_ModeloExt
	;Obteniendo la familia
	mov rdx,r15   ;copia el contenido de rax
	and rdx,0xf0000
	shr rdx,16
	printInt rbx,numbuf
	print SLinea,1   ;Salto de linea
	

;-------tamano de la cache {L1 instruction cache}
	
	mov rax, 4  ;eax en 4
	mov rcx, 0  ;cache
	cpuid       ;extrae datos de la cache
	
	;------extraccion del primer factor para determinar el tamano de la cache
	mov r11, rbx
	and r11d, 0xffc00000
	shr r11, 22
	add r11, 1

	;------extraccion del segundo factor para determinar el tamano de la cache	

	mov r12, rbx
	and r12d, 0x003ff000
	shr r12, 12
	add r12, 1

	;------extraccion del tercer factor para determinar el tamano de la cache	
	mov r13, rbx
	and r13d, 0x00000fff
	add r13, 1

	;------extraccion del cuarto factor para determinar el tamano de la cache	
	mov r14, rcx
	add r14,1
	
	;------calculo de cache

   	mov rax,1
	mul r11d
	mul r12d
	mul r13d
	mul r14d

	mov ebx,eax
	print cache_size,tam_cache_size
	printInt rbx,numbuf
	print SLinea,1   ;-------------------Salto de linea
	

	;####################################################################
	
;-------tamano de la cache {L1 data cache}

	mov rax, 4  ;eax en 4
	mov rcx, 1  ;cache
	cpuid       ;extrae datos de la cache
	
	;------extraccion del primer factor para determinar el tamano de la cache
	mov r11, rbx
	and r11d, 0xffc00000
	shr r11, 22
	add r11, 1

	;------extraccion del segundo factor para determinar el tamano de la cache	

	mov r12, rbx
	and r12d, 0x003ff000
	shr r12, 12
	add r12, 1

	;------extraccion del tercer factor para determinar el tamano de la cache	
	mov r13, rbx
	and r13d, 0x00000fff
	add r13, 1

	;------extraccion del cuarto factor para determinar el tamano de la cache	
	mov r14, rcx
	add r14,1
	
	;------calculo de cache

   	mov rax,1
	mul r11d
	mul r12d
	mul r13d
	mul r14d

	mov ebx,eax
	print cache_size2,tam_cache_size2
	printInt rbx,numbuf
	print SLinea,1   ;-------------------Salto de linea
	
;-------tamano de la cache {Cache L2}

	mov rax, 4  ;eax en 4
	mov rcx, 2  ;cache
	cpuid       ;extrae datos de la cache
	
	;------extraccion del primer factor para determinar el tamano de la cache
	mov r11, rbx
	and r11d, 0xffc00000
	shr r11, 22
	add r11, 1

	;------extraccion del segundo factor para determinar el tamano de la cache	

	mov r12, rbx
	and r12d, 0x003ff000
	shr r12, 12
	add r12, 1

	;------extraccion del tercer factor para determinar el tamano de la cache	
	mov r13, rbx
	and r13d, 0x00000fff
	add r13, 1

	;------extraccion del cuarto factor para determinar el tamano de la cache	
	mov r14, rcx
	add r14,1
	
	;------calculo de cache

   	mov rax,1
	mul r11d
	mul r12d
	mul r13d
	mul r14d

	mov ebx,eax
	print cacheL2,cacheL2_size
	printInt rbx,numbuf
	print SLinea,1   ;-------------------Salto de linea

	
;-------tamano de la cache {Cache L3}

	mov rax, 4  ;eax en 4
	mov rcx, 3  ;cache
	cpuid       ;extrae datos de la cache
	
	;------extraccion del primer factor para determinar el tamano de la cache
	mov r11, rbx
	and r11d, 0xffc00000
	shr r11, 22
	add r11, 1

	;------extraccion del segundo factor para determinar el tamano de la cache	

	mov r12, rbx
	and r12d, 0x003ff000
	shr r12, 12
	add r12, 1

	;------extraccion del tercer factor para determinar el tamano de la cache	
	mov r13, rbx
	and r13d, 0x00000fff
	add r13, 1

	;------extraccion del cuarto factor para determinar el tamano de la cache	
	mov r14, rcx
	add r14,1
	
	;------calculo de cache

   	mov rax,1
	mul r11d
	mul r12d
	mul r13d
	mul r14d

	mov ebx,eax
	print cacheL3,cacheL3_size
	printInt rbx,numbuf
	print SLinea,1   ;-------------------Salto de linea

	
;----------------------------numero de nucleos--------------------------

	mov eax,0xb ;---Se carga eax con 0xb para obtener el numero de nucleos en en ebx
	mov ecx,1
	cpuid
	mov r10d,ebx
	and ebx,0x0000ffff

	print cores,cores_size
	printInt rbx,numbuf
	print SLinea,1   ;-------------------Salto de linea
	
	

;Fin del programa  	
	

	


;Se liberan los recursos
        mov eax,1
        xor ebx,ebx
        int 0x80







;Loop de division necesario para el macro printInt
		 .divloop:
						xor rdx,rdx		; Zero out rdx (where our remainder goes after idiv)
						idiv rcx		; divide rax (the number) by 10 (the remainder is placed in rdx)
						add rdx,0x30	; add 0x30 to the remainder so we get the correct ASCII value
						dec rdi		; move the pointer backwards in the buffer
						mov byte [rdi],dl	; move the character into the buffer
						inc dword [rbp-4]	; increase the length

						cmp rax,0		; was the result zero?
						jnz .divloop	; no it wasn't, keep looping

						mov rax,rdi		; rdi now points to the beginning of the string - move it into rax
						mov rcx,[rbp-4]	; rbp-4 contains the length - move it into rcx

						ret
