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
  cons_kernel: db ' Kernel: '
  cons_tam_kernel: equ $-cons_kernel
  cons_hostname: db ' Hostname: '
  cons_tam_hostname: equ $-cons_hostname
  cons_kernelrelease: db 'Kernel Release: '
  cons_tam_kernelrelease: equ $-cons_kernelrelease
  cons_kernelversion: db 'Kernel Version: '
  cons_tam_kernelversion: equ $-cons_kernelversion
  cons_machine: db 'Machine: '
  cons_tam_machine: equ $-cons_machine


section .text
  global _start

_start:
  mov rax, SYS_UNAME
  mov rdi, uname_res
  syscall

  mov rdi, 1
  cmp rax, 0
  jne exit

  call print_all_utsname

  xor rdi, rdi
  call exit

print_all_utsname:
  xor rcx, rcx
  xor rbx, rbx
  mov cl, 5

  mov rdi, STDOUT

  L1:
    push rcx
    
    impr_texto cons_kernel, cons_tam_kernel

    mov rax, SYS_WRITE
    mov rdx, UTSNAME_SIZE
    lea rsi, [uname_res + rbx]
    add bx, UTSNAME_SIZE
    syscall

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

exit:
  mov rax, SYS_EXIT
  syscall