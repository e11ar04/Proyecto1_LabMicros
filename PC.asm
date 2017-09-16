;#######################################################################
;Primer Proyecto - Información del PC -  Principal
;EL4313 - Laboratorio de Estructura de Microprocesadores
;#######################################################################
;Este programa es capaz de identificar en sistemas operativos basados en Linux
;la Información del microprocesador del sistema (Fabricante, modelo, frecuencia base,
;familia), información de la memoria RAM e información del sistema operativo
;(versión, revisión, etc) y mostrarla a su usuario
;#######################################################################

%include "Macros.mac" ;Inclusión del archivo que contiene los macros
%include "InformacionCPU.asm"
%include "InfoSO1.asm"
%include "ram.asm"
%include "usocpu.asm"
%include "DiscoDuro.asm"

%define sizeof(x) x %+ _size

section .bss
				;Para el Macro printInt
				 numbuf resb 10		; A buffer to store our string of numbers in
				 cpuload0 resb 4         ;se almacenan los primeros 4 bytes que da sys_sysinfo
			   numbufx resb 16         ;bytes utilizados para imprimir numeros enteros
			   numbufy resb 8
			   seconds resb 8          ;almacena la cantidad de segundos que se va correr el programa
			   resultadoo resb 1


				 statfs: resb sizeof(STATFS)
				 contenido_archivo: resb 10
				 cosa1: resb 8
				 cosa2: resb 16
				 contenido_disp1: resb 10

;--------------------Segmento de datos--------------------
;Aqui se declaran las constantes de uso frecuente en el programa

section .data


  ;Instrucciones
	instrucciones: db 'Elija la información que desea visualizar: ' ,  0Ah	,0Ah,'1-Información del Microprocesador ',0Ah	,	'2-Información de la Memoria RAM ',0Ah	,'3-Información del SO ', 0xa	,'4-Porcentaje de uso del CPU ',0Ah	,'5-Información del disco duro ', 0xa ,'6-Salir', 0xa,  0Ah		; Instrucciones para el usuario
	tam_instrucciones: equ $-instrucciones					; Longitud

	tecla: db ''													;Almacenamiento de la tecla capturada


	inst1: db   0Ah	,'Seleccionado : Información del Microprocesador ',  0Ah,0Ah; Instrucciones para el usuario
	tam_inst1: equ $-inst1					; Longitud

	inst2: db   0Ah	,'Seleccionado : Información de la memoria RAM ',  0Ah,0Ah; Instrucciones para el usuario
	tam_inst2: equ $-inst2					; Longitud

	inst3: db   0Ah	,'Seleccionado : Información del SO ',  0Ah,0Ah; Instrucciones para el usuario
	tam_inst3: equ $-inst3					; Longitud

	cerrar: db   0Ah	,0Ah	,'Cerrando el programa',0Ah; Instrucciones para el usuario
	tam_cerrar: equ $-cerrar					; Longitud

	volver: db   0Ah	,'Desea visualizar alguna otra información? ',0Ah, "1-Sí    2-No",0Ah;; Instrucciones para el usuario
	tam_volver: equ $-volver					; Longitud


	;Definicion de los caracteres especiales para limpiar la pantalla
	limpiar    db 0x1b, "[2J", 0x1b, "[H"
	tam_limpiar equ $ - limpiar

  ;Datos necesarios para los macros
  termios:        times 36 db 0									;Estructura de 36bytes que contiene el modo de operacion de la consola
  stdin:          equ 0												  ;Standard Input (se usa stdin en lugar de escribir manualmente los valores)
  ICANON:         equ 1<<1											;ICANON: Valor de control para encender/apagar el modo canonico
  ECHO:           equ 1<<3											;ECHO: Valor de control para encender/apagar el modo de eco


	string_memoria_libre: db 'Memoria Libre del Disco Duro: ',0
	tam_string_memoria_libre: equ $-string_memoria_libre
	fileName: db '/',0
	nombre_archivo: db '/sys/block/sda/size',0
	tam_nombre_archivo: equ $-nombre_archivo

	string_memoria_total: db 'Memoria Total del Disco Duro: ',0
	tam_string_memoria_total: equ $-string_memoria_total
	;break_line: db 0xa
	string_GB: db 'GB'
	tam_string_GB: equ $-string_GB
	memoria_disp1: db '/sys/block/sda/stat',0
	tam_memoria_disp: equ $-memoria_disp1
	bufsize1 dw 1



  ;--------------------Segmento de codigo--------------------
  ;Secuencia de ejecucion del programa

  section .text
  	global _start		;Definicion del punto de partida

  _start:
	  canonical_off ICANON,termios ;Desactiva tener que apretar enter despues de ingresar un dato
		echo_off ECHO,termios
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
		mov r13b,'4' ;;Guarda en r13 un  4
		mov r14b,'5' ;;Guarda en r14 un  5
		mov r15b,'6' ;;Guarda en r15 un  6


		;Comparación de la tecla ingresada con cada opción
		cmp r10b,r9b
		je .cpu
		cmp r11b,r9b
		je .mem
		cmp r12b,r9b
		je .so
		cmp r13b,r9b
		je .usocpu
		cmp r14b,r9b
		je .hdd
		cmp r15b,r9b
		je .fin

		;Opción Incorrecta reinicia el menú
		jmp _start           ;Vuelve a mostrar las opciones

	.cpu:
		print limpiar,tam_limpiar;Limpia la consola
		print inst1,tam_inst1;Impresión de la inctrucción
		call InformacionCPU ;Obtiene l información del CPU

		jmp .reinicio

	.mem:
		print limpiar,tam_limpiar;Limpia la consola
		print inst2,tam_inst2;Impresión de la inctrucción
		call InformacionRAM
		jmp .reinicio

	.so:
		print limpiar,tam_limpiar;Limpia la consola
		print inst3, tam_inst3;Impresión de la inctrucción
		call InfoSO;Obtiene la información del Sistema Operativo
		jmp .reinicio

	.usocpu:
		print limpiar,tam_limpiar;Limpia la consola
		canonical_on ICANON,termios     ;Vuelve a encender el modo canonical
		echo_on termios								  ;Vuelve a encender el echo de Linux
		call UsoCPU;Obtiene la información del Sistema Operativo
		canonical_off ICANON,termios     ;Vuelve a apagar el modo canonical
		echo_off ECHO,termios								;Vuelve a apagar el echo de Linux
		jmp .reinicio

	.hdd:
		print limpiar,tam_limpiar;Limpia la consola
		call hddd

	.reinicio:
	 print volver,tam_volver;Impresión del mensaje

	.incorrecta:
	 ;Captura de opcion elegida
	 read tecla,1 ;Lee una tecla
	 mov r9b,[rsi] ; Guarda la tecla ingresada en r9b (1 byte)
	 mov r10b,'1' ;Guarda en r10 un  1
	 mov r11b,'2' ;;Guarda en r11 un  2
	 ;Comparación con las opciones
	 cmp r10b,r9b ;Si es un 1 vuelve a mostrar las opciones
	 je _start
	 cmp r11b,r9b ;Si es un 2 cierra el programa
	 jne .incorrecta



  .fin:
		print cerrar,tam_cerrar;Impresión del mensaje
    ;Salida del programa, libera recursos
		canonical_on ICANON,termios     ;Vuelve a encender el modo canonical
		echo_on termios								;Vuelve a encender el echo de Linux
  	mov rax,60						;se carga la llamada 60d (sys_exit) en rax
  	mov rdi,0							;en rdi se carga un 0
  	syscall								;se llama al sistema.
  ;fin del programa
