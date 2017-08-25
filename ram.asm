
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

	nada db ' '
	tam_nada: equ $-nada

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


mov r15,[resultado + 0x20]	
mov r14,[resultado + 0x28]
impr_texto ram,tam_ram		; imprime encambezado

printInt r15,numbuf
impr_linea nada,1

impr_texto ram_free,tam_ram_free		; imprime encambezado

printInt r14,numbuf
impr_linea nada,1





;salida
ret



       syscall
