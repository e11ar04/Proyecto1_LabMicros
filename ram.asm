;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro


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

	ram db 'Tamaño de la RAM = 0x'
	tam_ram: equ $-ram

	tabla: db "0123456789ABCDEF",0
		
	SLinea db 0xA
	
	 cons_nueva_linea: db 0xa





section .bss
resultado: resb 56
  salida: resb 1









section .text
global _start
global _dos
global _tres
global _cuatro



_start:
nop
mov rdi,resultado
mov rax,0x63
syscall




impr_texto ram,tam_ram



mov al,0
lea ebx,[tabla]
mov edx,[resultado + 0x24]
and edx,0x000F
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0xF0000000
shr edx,28
mov al,dl
xlat
mov [salida],ax
impr_texto salida,1


mov edx,[resultado + 0x20]
and edx,0x0F000000
shr edx,24
mov al,dl
xlat
mov [salida],ax
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


;Se liberan los recursos
	mov rax,60 
	mov rdi,0 
	mov ebx,0
	mov r15,0
	
	
       syscall  

