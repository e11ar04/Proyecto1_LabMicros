
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
;%macro impr_texto 2 	;recibe 2 parametros
	;mov rax,1	;sys_write
	;mov rdi,1	;std_out
	;mov rsi,%1	;primer parametro: Texto
	;mov rdx,%2	;segundo parametro: Tamano texto
	;syscall
;%endmacro


;Macro-2: impr_linea.
;	Imprime un mensaje que se pasa como parametro y un salto de linea
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_linea 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
  mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,cons_nueva_linea	;primer parametro: Texto
	mov rdx,1	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO ----------------------------



section .data

	ram db 'Memoria RAM total = 0x'
	tam_ram: equ $-ram

	ram_free db 'Memoria RAM libre = 0x'
	tam_ram_free: equ $-ram_free

	tabla: db "0123456789ABCDEF",0

	;SLinea db 0xA

	 cons_nueva_linea: db 0xa





section .bss
resultado: resb 56
  salida: resb 1




section .text

InformacionRAM:
nop
mov rdi,resultado   		;se le asigna una direccion donde se guarde la info del sistema
mov rax,0x63       		;se llama a sysinfo
syscall


			;INICIA BUSCAR MEM RAM TOTAL

impr_texto ram,tam_ram		; imprime encambezado



mov al,0			;pone a al en 0
lea ebx,[tabla]			;direcciona los valores de tabla a ebx
mov edx,[resultado + 0x24]	;busca el segundo registro de memoria total de ram
and edx,0x0000000F		;hace un and y deja solo los ultimos 4 bits del registro
mov al,dl			;pone en al el valor a buscar en tabla
xlat
mov [salida],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
impr_texto salida,1		;imprime el primer simbolo


mov edx,[resultado + 0x20]	;busca el primer registro de memoria total de ram
and edx,0xF0000000		;hace un and y solo deja los 4 bits mas significativos
shr edx,28			;hace un corrimiento de 28 espacios a la derecha
mov al,dl			;pone en al el valor a buscar en tabla
xlat
mov [salida],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
impr_texto salida,1


mov edx,[resultado + 0x20]	;busca el primer registro de memoria total de ram
and edx,0x0F000000		;hace un and y solo deja los bits entre [28:24]
shr edx,24			;hace un corrimiento de 24 espacios a la derecha
mov al,dl			;pone en al el valor a buscar en tabla
xlat
mov [salida],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x00F00000
shr edx,20
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x000F0000
shr edx,16
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x0000F000
shr edx,12
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x00000F00
shr edx,8
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x000000F0
shr edx,4
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x0000000F

mov al,dl
xlat
mov [salida],ax
impr_linea salida,1

		;FINALIZA BUSCAR RAM TOTAL


		;INICIA BUSCAR MEM RAM LIBRE


impr_texto ram_free,tam_ram_free		; imprime encambezado



mov al,0			;pone a al en 0
lea ebx,[tabla]			;direcciona los valores de tabla a ebx
mov edx,[resultado + 0x2c]	;busca el segundo registro de memoria ram libre
and edx,0x0000000F		;hace un and y deja solo los ultimos 4 bits del registro
mov al,dl			;pone en al el valor a buscar en tabla
xlat
mov [salida],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
impr_texto salida,1		;imprime el primer simbolo


mov edx,[resultado + 0x28]	;busca el primer registro de memoria ram libre
and edx,0xF0000000		;hace un and y solo deja los 4 bits mas significativos
shr edx,28			;hace un corrimiento de 28 espacios a la derecha
mov al,dl			;pone en al el valor a buscar en tabla
xlat
mov [salida],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
impr_texto salida,1


mov edx,[resultado + 0x28]	;busca el primer registro de memoria ram libre
and edx,0x0F000000		;hace un and y solo deja los bits entre [28:24]
shr edx,24			;hace un corrimiento de 24 espacios a la derecha
mov al,dl			;pone en al el valor a buscar en tabla
xlat
mov [salida],ax			;pone en la direccion de salida el valor del numero ASCII respectivo a esos 4 bits
impr_texto salida,1


mov edx,[resultado + 0x28]
and edx,0x00F00000
shr edx,20
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x28]
and edx,0x000F0000
shr edx,16
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x28]
and edx,0x0000F000
shr edx,12
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x00000F00
shr edx,8
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x28]
and edx,0x000000F0
shr edx,4
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x28]
and edx,0x0000000F

mov al,dl
xlat
mov [salida],ax
impr_linea salida,1




;salida
ret



       syscall
