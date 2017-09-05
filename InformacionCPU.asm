;#######################################################################
;Primer Proyecto - Información del PC -  Información del CPU
;EL4313 - Laboratorio de Estructura de Microprocesadores
;#######################################################################
;Este programa es capaz de obtener el Brand Id, Stepping ID. Fabricante,
;modelo, frecuencia base, cantidad de núcleos, tamaños de las memorias caché
;familia, y modelo extendido del CPU del sistema
;#######################################################################

section .data

;Datos de InformacionCPU

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

brand db 'Brand Id = XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX',0xA
brand_size: equ $-brand


InformacionCPU:
	;----------------------------brand ID--------------------------------------

	mov eax, 80000002h
	cpuid
	mov edi,brand  ;Copia el string id para modificarlo con la nueva información
        mov [edi+11],eax;Copia los primeros 4 bytes en las posiciones de las x
        mov [edi+15],ebx;Copia los primeros 4 bytes en las posiciones de las x
        mov [edi+19],ecx;Copia los primeros 4 bytes en las posiciones de las x
	mov [edi+23],edx;Copia los primeros 4 bytes en las posiciones de las x


	mov eax, 80000003h
	cpuid
	mov [edi+27],eax;Copia los primeros 4 bytes en las posiciones de las x
	mov [edi+31],ebx;Copia los primeros 4 bytes en las posiciones de las x
	mov [edi+35],ecx;Copia los primeros 4 bytes en las posiciones de las x
	mov [edi+39],edx;Copia los primeros 4 bytes en las posiciones de las x

	mov eax, 80000004h
	cpuid
	mov [edi+43],eax;Copia los primeros 4 bytes en las posiciones de las x
	mov [edi+47],ebx;Copia los primeros 4 bytes en las posiciones de las x
	mov [edi+51],ecx;Copia los primeros 4 bytes en las posiciones de las x
	mov [edi+55],edx;Copia los primeros 4 bytes en las posiciones de las x
	print brand, brand_size



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

        ;Obteniendo el modelo
        ;El modelo esta dado en eax[7:4]
				mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf  ;deja solamente la informacion del modelo
        printInt rdx,numbuf ;Imprime el Stepping ID
				print SLinea,1   ;Salto de linea

        ;_______________________________________________________________________
        ;Modelo

        ;Imprime el texto Modelo =
        print modelo,tam_modelo

        ;Obteniendo el modelo
        ;El modelo esta dado en eax[7:4]
				mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf0  ;deja solamente la informacion del modelo
				shr rdx,4  		;desplaza el modelo a la posicion correcta
        printInt rdx,numbuf ;Imprime el modelo
				print SLinea,1   ;Salto de linea

				;_______________________________________________________________________
				;Familia

				;Imprime el texto Modelo =
				print familia,tam_familia
        ;Obteniendo la familia
        mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf00  ;deja solamente la informacion la familia
				shr rdx,8 		;desplaza la familia a la posicion correcta
        printInt rdx,numbuf
				print SLinea,1   ;Salto de linea

				;_______________________________________________________________________
				;Tipo

				;Imprime el texto Tipo =
				print tipo,tam_tipo
        ;Obteniendo la familia
        mov rdx,r15   ;copia el contenido de rax
        and rdx,0xf000
				shr rdx,12
        printInt rdx,numbuf
				print SLinea,1   ;Salto de linea

				;_______________________________________________________________________
				;Modelo Extendido

				;Imprime el texto Modelo Extendido =
				print ModeloExt,tam_ModeloExt
				;Obteniendo la familia
				mov rdx,r15   ;copia el contenido de rax
				and rdx,0xf0000
				shr rdx,16
				printInt rdx,numbuf
				print SLinea,1   ;Salto de linea

				;Fin del programa



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

  ret
