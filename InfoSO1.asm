;Base de Codigo tomado de author: mmxm (https://github.com/hc0d3r/asm/blob/master/uname.asm) y modificado y adaptado por
;John Junier Thomas(John-JT)

SYS_WRITE equ 1
SYS_UNAME equ 63
SYS_EXIT equ 60
STDOUT equ 1
UTSNAME_SIZE equ 65

;-------------------------  MACRO #1  ----------------------------------
;Macro-1: impr_texto.
;	Imprime un mensaje que se pasa como parametro
;	Recibe 2 parametros de entrada:
;		%1 es la direccion del texto a imprimir
;		%2 es la cantidad de bytes a imprimir
;-----------------------------------------------------------------------
%macro impr_texto 2 	;recibe 2 parametros
	mov rax,SYS_WRITE	;sys_write
	mov rdi,STDOUT  	;std_out
	mov rsi,%1	        ;primer parametro: Texto
	mov rdx,%2	        ;segundo parametro: Tamano texto
	syscall
	mov rax,SYS_WRITE	        ;sys_write
	mov rdi,STDOUT  	        ;std_out
	mov rsi,space 		        ;primer parametro: Texto
	mov rdx,1	                ;segundo parametro: Tamano texto
	syscall

%endmacro
;------------------------- FIN DE MACRO --------------------------------

section .bss
  uname_res resb UTSNAME_SIZE*5

section .data
  space db ' '
  break_line db 0xa
  cons_kernel: db 'Kernel: '
  cons_tam_kernel: equ $-cons_kernel
  cons_hostname: db 'Hostname: '
  cons_tam_hostname: equ $-cons_hostname
  cons_kernelrelease: db 'Kernel Release: '
  cons_tam_kernelrelease: equ $-cons_kernelrelease
  cons_kernelversion: db 'Kernel Version: '
  cons_tam_kernelversion: equ $-cons_kernelversion
  cons_machine: db 'Machine: '
  cons_tam_machine: equ $-cons_machine        ; Definición de los strings y sus tamaños para su impresión en consola


InfoSO:

  mov rax, SYS_UNAME
  mov rdi, uname_res
  syscall            ;Básicamente esta es la parte donde se busca la información del sistema operativo proveniente del comando en consola
  		     ; uname

  mov rdi, 1
  cmp rax, 0
  jne exit1

  call print_all_utsname

  xor rdi, rdi
  jmp exit1

print_all_utsname:
  xor rcx, rcx
  xor rbx, rbx
  mov cl, 5

  mov rdi, STDOUT

  L1:
    push rcx

			;Estas comparaciones se dan cada 65 bits porque la información de cada uno de los apartados del comando "uname"
			;están contenidas en arreglos de ese tamaño. Por lo tanto, se hace la comparación se imprime el string respectivo
			;y contiguamente se imprime la información que corresponde a ese apartado del sistema operativo.
    cmp rbx, 0
    je kernel

    cmp rbx, 65
    je hostname

    cmp rbx, 130
    je kernelrelease

    cmp rbx, 195
    je kernelversion

    cmp rbx, 260
    je machine

   .CNT:
   				;Esta parte se encarga de tanto imprimir la información del sistema operativo en consola, además suma
				;65 bits cada vez que ya se imprimió la información de la posición en memoria previa para continuar
				;con el resto de apartados del sistema operativo.
    mov rax, SYS_WRITE
    mov rdx, UTSNAME_SIZE
    lea rsi, [uname_res + rbx]
    add bx, UTSNAME_SIZE
    syscall

				;Cada vez que se imprime uno de los apartados de la inforamción del sistema operativo se procede a realizar
				;un "enter" para imprimir lo siguiente en la próxima fila.
    mov rax, SYS_WRITE
    mov rsi, break_line
    mov rdx, 1
    syscall

    pop rcx

  loop L1

  mov rax, SYS_WRITE
  mov rsi, break_line
  mov rdx, 1
  syscall

  ret

exit1:
  ret

			; De esta línea en adelante se llaman las funciones respectivas para imprimir los strings que acompañan
			;la información relativa al sistema operativo: Kernel, Hostname, Kernelrelease, Kernelversion & Machine
kernel:

  impr_texto cons_kernel, cons_tam_kernel
  jmp L1.CNT		;Una vez impreso el string respectivo se vuelve al ciclo para imprimir la información respectiva del sistema operativo

hostname:

  impr_texto cons_hostname, cons_tam_hostname
  jmp L1.CNT		;Una vez impreso el string respectivo se vuelve al ciclo para imprimir la información respectiva del sistema operativo

kernelrelease:

  impr_texto cons_kernelrelease, cons_tam_kernelrelease
  jmp L1.CNT		;Una vez impreso el string respectivo se vuelve al ciclo para imprimir la información respectiva del sistema operativo

kernelversion:

  impr_texto cons_kernelversion, cons_tam_kernelversion
  jmp L1.CNT		;Una vez impreso el string respectivo se vuelve al ciclo para imprimir la información respectiva del sistema operativo

machine:

  impr_texto cons_machine, cons_tam_machine
  jmp L1.CNT		;Una vez impreso el string respectivo se vuelve al ciclo para imprimir la información respectiva del sistema operativo
