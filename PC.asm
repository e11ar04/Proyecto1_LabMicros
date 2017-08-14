;#######################################################################
;Primer Proyecto - Información del PC
;EL4313 - Laboratorio de Estructura de Microprocesadores
;#######################################################################
;Este programa es capaz de identificar en sistemas operativos basados en el SO Linux
;la Información del microprocesador del sistema (Fabricante, modelo, frecuencia base,
;familia), información de la memoria RAM e información del sistema operativo
;(versión, revisión, etc) y mostrarla a su usuario
;#######################################################################


;--------------------Segmento de Macros--------------------

;-------------------------  MACRO #1  ----------------------------------
;Macro-1: print.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro print 2 	;recibe 2 parametros
	mov rax,1	;sys_write
	mov rdi,1	;std_out
	mov rsi,%1	;primer parametro: Texto
	mov rdx,%2	;segundo parametro: Tamano texto
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------

;-------------------------  MACRO #2  ----------------------------------
;Macro-2: leer_texto.
;	Lee un mensaje desde teclado y se almacena en la variable que se
;	pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion de memoria donde se guarda el texto
;		%2 es la cantidad de bytes a guardar
;-----------------------------------------------------------------------
%macro read 2 	;recibe 2 parametros
	mov rax,0	;sys_read
	mov rdi,0	;std_input
	mov rsi,%1	;primer parametro: Variable
	mov rdx,%2	;segundo parametro: Tamano
	syscall
%endmacro
;------------------------- FIN DE MACRO --------------------------------



;--------------------Segmento de datos--------------------
;Aqui se declaran las constantes de uso frecuente en el programa

section .data

  ;Instrucciones
	instrucciones: db 'Elija la información que desea visualizar: ' ,  0Ah	,'1-Información del Microprocesador ',0Ah	,	'2-Información de la Memoria RAM ',0Ah	,'3-Información del SO ', 0xa	,'4-Salir', 0xa	; Instrucciones para el usuario
	tam_instrucciones: equ $-instrucciones					; Longitud

	tecla: db ''													;Almacenamiento de la tecla capturada


	inst1: db   0Ah	,'Seleccionada : Información del Microprocesador '; Instrucciones para el usuario
	tam_inst1: equ $-inst1					; Longitud

	inst2: db   0Ah	,'Seleccionada : Información de la memoria RAM '; Instrucciones para el usuario
	tam_inst2: equ $-inst2					; Longitud

	inst3: db   0Ah	,'Seleccionada : Información del SO '; Instrucciones para el usuario
	tam_inst3: equ $-inst3					; Longitud

	error: db   0Ah	,'Ingrese una opción valida '; Instrucciones para el usuario
	tam_error: equ $-error					; Longitud

  ;Funciones

  termios:        times 36 db 0									;Estructura de 36bytes que contiene el modo de operacion de la consola
  stdin:          	  equ 0												;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
  ICANON:      equ 1<<1											;ICANON: Valor de control para encender/apagar el modo canonico
  ECHO:           equ 1<<3											;ECHO: Valor de control para encender/apagar el modo de eco



 		;###################################################
 		canonical_off:

 			;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
 			;TERMIOS son los parametros de configuracion que usa Linux para STDIN
 		        call read_stdin_termios

 			;Se escribe el nuevo valor de ICANON en EAX, para apagar el modo canonico
 		        push rax
 		        mov eax, ICANON
 		        not eax
 		        and [termios+12], eax
 		        pop rax

 			;Se escribe la nueva configuracion de TERMIOS
 		        call write_stdin_termios
 		        ret
 		        ;Final de la funcion
 		;###################################################

		canonical_on:

			;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
			;TERMIOS son los parametros de configuracion que usa Linux para STDIN
		        call read_stdin_termios

		        ;Se escribe el nuevo valor de modo Canonico
		        or dword [termios+12], ICANON

			;Se escribe la nueva configuracion de TERMIOS
		        call write_stdin_termios
		        ret
		        ;Final de la funcion
		;###################################################

		;###################################################
		echo_off:

			;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
			;TERMIOS son los parametros de configuracion que usa Linux para STDIN
		        call read_stdin_termios

		        ;Se escribe el nuevo valor de ECHO en EAX para apagar el echo
		        push rax
		        mov eax, ECHO
		        not eax
		        and [termios+12], eax
		        pop rax

			;Se escribe la nueva configuracion de TERMIOS
		        call write_stdin_termios
		        ret
		        ;Final de la funcion

		;###################################################
		echo_on:

			;Se llama a la funcion que lee el estado actual del TERMIOS en STDIN
			;TERMIOS son los parametros de configuracion que usa Linux para STDIN
		        call read_stdin_termios

		        ;Se escribe el nuevo valor de modo echo
		        or dword [termios+12], ECHO

			;Se escribe la nueva configuracion de TERMIOS
		        call write_stdin_termios
		        ret
		        ;Final de la funcion
		;###################################################

 		read_stdin_termios:
 		        push rax
 		        push rbx
 		        push rcx
 		        push rdx

 		        mov eax, 36h
 		        mov ebx, stdin
 		        mov ecx, 5401h
 		        mov edx, termios
 		        int 80h

 		        pop rdx
 		        pop rcx
 		        pop rbx
 		        pop rax
 		        ret
 		        ;Final de la funcion

 		;###################################################
 		write_stdin_termios:
 		        push rax
 		        push rbx
 		        push rcx
 		        push rdx

 		        mov eax, 36h
 		        mov ebx, stdin
 		        mov ecx, 5402h
 		        mov edx, termios
 		        int 80h

 		        pop rdx
 		        pop rcx
 		        pop rbx
 		        pop rax
 		        ret
 		        ;Final de la funcion
 		;###################################################



  ;--------------------Segmento de codigo--------------------
  ;Secuencia de ejecucion del programa

  section .text
  	global _start		;Definicion del punto de partida
		global _break   ;etiqueta para depurar
		global _break2   ;etiqueta para depurar

  _start:
	  call canonical_off ;Desactiva tener que apretar enter despues de ingresar un dato


	.inicio:
  	;Impresión de las instrucciones
		print instrucciones,tam_instrucciones

		;Captura de opcion elegida
		read tecla,1

    ;Elegir opción
		mov r10,'1' ;Guarda en r10 un  1
		mov r11,'2' ;;Guarda en r11 un  2
		mov r12,'3' ;;Guarda en r12 un  3
		mov r13,'4' ;;Guarda en r12 un  4
	_break:

;*******************************************************************************
;CORREGIR
;*******************************************************************************
		;Se supone que se copia el contenido almacenado en la direccion de memoria
		;rsi el cual es la tecla presionada pero no sucede así, por eso no entra en el menú
		mov r9,[rsi] ;

		;Comparación de la tecla ingresada con cada opción
		cmp r10,r9
		je .cpu
		cmp r11,r9
		je .mem
		cmp r12,r9
		je .so
		cmp r13,r9
		je .fin

		;Impresión error por opcion invalida
		print error,tam_error
		jmp _start           ;Vuelve a mostrar las opciones

	.cpu:
		;Impresión de la inctrucción
		print inst1,tam_inst1
		jmp .fin

	.mem:
		;Impresión de la inctrucción
		print inst2,tam_inst2
		jmp .fin

	.so:
		;Impresión de la inctrucción
		print inst3, tam_inst3
		jmp .fin


  .fin:
    ;Salida del programa
		call canonical_on     ;Vuelve a encender el modo canonical
  	mov rax,60						;se carga la llamada 60d (sys_exit) en rax
  	mov rdi,0							;en rdi se carga un 0
  	syscall								;se llama al sistema.


  ;fin del programa
