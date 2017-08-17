;#######################################################################
;Primer Proyecto - Información del PC
;EL4313 - Laboratorio de Estructura de Microprocesadores
;#######################################################################
;Este programa es capaz de identificar en sistemas operativos basados en el SO Linux
;la Información del microprocesador del sistema (Fabricante, modelo, frecuencia base,
;familia), información de la memoria RAM e información del sistema operativo
;(versión, revisión, etc) y mostrarla a su usuario
;#######################################################################

%include "Macros.mac" ;Inclusión del archivo que contiene los macros

;--------------------Segmento de datos--------------------
;Aqui se declaran las constantes de uso frecuente en el programa

section .data

  ;Instrucciones
	instrucciones: db 'Elija la información que desea visualizar: ' ,  0Ah	,0Ah,'1-Información del Microprocesador ',0Ah	,	'2-Información de la Memoria RAM ',0Ah	,'3-Información del SO ', 0xa	,'4-Salir', 0xa,  0Ah		; Instrucciones para el usuario
	tam_instrucciones: equ $-instrucciones					; Longitud

	tecla: db ''													;Almacenamiento de la tecla capturada


	inst1: db   0Ah	,'Seleccionado : Información del Microprocesador ',  0Ah; Instrucciones para el usuario
	tam_inst1: equ $-inst1					; Longitud

	inst2: db   0Ah	,'Seleccionado : Información de la memoria RAM ',  0Ah; Instrucciones para el usuario
	tam_inst2: equ $-inst2					; Longitud

	inst3: db   0Ah	,'Seleccionado : Información del SO ',  0Ah; Instrucciones para el usuario
	tam_inst3: equ $-inst3					; Longitud

	cerrar: db   0Ah	,0Ah	,'Cerrando el programa',0Ah; Instrucciones para el usuario
	tam_cerrar: equ $-cerrar					; Longitud

	volver: db   0Ah	,'Desea visualizar alguna otra información? ',0Ah, "1-Sí    2-No",0Ah;; Instrucciones para el usuario
	tam_volver: equ $-volver					; Longitud


	;Definicion de los caracteres especiales para limpiar la pantalla
	limpiar    db 0x1b, "[2J", 0x1b, "[H"
	tam_limpiar equ $ - limpiar

  ;Funciones

  termios:        times 36 db 0									;Estructura de 36bytes que contiene el modo de operacion de la consola
  stdin:          equ 0												  ;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
  ICANON:         equ 1<<1											;ICANON: Valor de control para encender/apagar el modo canonico
  ECHO:           equ 1<<3											;ECHO: Valor de control para encender/apagar el modo de eco





  ;--------------------Segmento de codigo--------------------
  ;Secuencia de ejecucion del programa

  section .text
  	global _start		;Definicion del punto de partida
		global _break   ;etiqueta para depurar
		global _break2   ;etiqueta para depurar

  _start:
	  canonical_off ICANON,termios ;Desactiva tener que apretar enter despues de ingresar un dato
		print limpiar,tam_limpiar;Limpia la consola


  	;Impresión de las instrucciones

		print instrucciones,tam_instrucciones

		;Captura de opcion elegida
		read tecla,1 ;Lee una tecla
		mov r9b,[rsi] ; Guarda la tecla ingresada en r9b (1 byte)

    ;Elegir opción
		mov r10b,'1' ;Guarda en r10 un  1
		mov r11b,'2' ;;Guarda en r11 un  2
		mov r12b,'3' ;;Guarda en r12 un  3
		mov r13b,'4' ;;Guarda en r12 un  4
	_break:

		;Comparación de la tecla ingresada con cada opción
		cmp r10b,r9b
		je .cpu
		cmp r11b,r9b
		je .mem
		cmp r12b,r9b
		je .so
		cmp r13b,r9b
		je .fin

		;Impresión error por opcion invalida
		jmp _start           ;Vuelve a mostrar las opciones

	.cpu:
		print limpiar,tam_limpiar;Limpia la consola
		;Impresión de la inctrucción
		print inst1,tam_inst1
		jmp .reinicio

	.mem:
		print limpiar,tam_limpiar;Limpia la consola
		;Impresión de la inctrucción
		print inst2,tam_inst2
		jmp .reinicio

	.so:
		print limpiar,tam_limpiar;Limpia la consola
		;Impresión de la inctrucción
		print inst3, tam_inst3

	.reinicio:
	 ;Impresión del mensaje
	 print volver,tam_volver

	 ;Captura de opcion elegida
	 read tecla,1 ;Lee una tecla
	 mov r9b,[rsi] ; Guarda la tecla ingresada en r9b (1 byte)

	 ;Comparación con las opciones
	 cmp r10b,r9b
	 je _start



  .fin:
		print cerrar,tam_cerrar;Impresión del mensaje
    ;Salida del programa
		canonical_on ICANON,termios     ;Vuelve a encender el modo canonical
  	mov rax,60						;se carga la llamada 60d (sys_exit) en rax
  	mov rdi,0							;en rdi se carga un 0
  	syscall								;se llama al sistema.


  ;fin del programa
