# Proyecto1_LabMicros
//
PC.asm es el código principal que une todos los demás, es el que se debe compilar y linkear y para correr el programa.
//

//
Macros.mac contiene la mayoría de macros empleados en los subprogramas, allí se describen detalladamente y la idea de este archivo es disminuir las líneas en otros archivos y hacer el código más legible.
//

-----Requisitos-----

El programa debe retornar la siguiente información del procesador: 
-Modelo, familia y fabricante -Frecuencia de operación -Numero de núcleos (cores) 
 -Cantidad de memoria cache
El programa debe tener una interface básica en modo texto que se ejecuta desde la consola del sistema operativo
El programa debe retornar la siguiente información de la memoria RAM: -Cantidad de memoria disponible -Frecuencia de operación de la memoria
El problema debe reportar el tamaño y la cantidad de espacio disponible en el disco primario (disco duro) del sistema
El programa debe mostrar el porcentaje de uso del CPU por n segundos según lo desee el usuario, una vez por segundo y en un archivo de texto se debe almacenar estos valores junto con la fecha y hora de medición.

-----Links útiles-----

x86 Assembly Guide
http://www.cs.virginia.edu/~evans/cs216/guides/x86.html
Los registros utilizados no son los mismos para x64

x64 architecture Registers 
https://docs.microsoft.com/en-us/windows-hardware/drivers/debugger/x64-architecture

Información del procesador:

CPU Identification
http://www.tptp.cc/mirrors/siyobik.info/instruction/CPUID.html

https://www.microbe.cz/docs/CPUID.pdf


RAM   

https://stackoverflow.com/questions/17339068/finding-memory-size-in-boot-without-dos-windows-linux

http://wiki.osdev.org/Detecting_Memory_%28x86%29




-syscall

http://man7.org/linux/man-pages/man2/

http://blog.rchapman.org/posts/Linux_System_Call_Table_for_x86_64/

-comandos disco duro

http://www.binarytides.com/linux-command-check-disk-partitions/

-info comando uptime y carga del cpu

https://www.computerhope.com/unix/uptime.htm

https://unix.stackexchange.com/questions/118124/why-how-does-uptime-show-cpu-load-1

http://blog.scoutapp.com/articles/2009/07/31/understanding-load-averages

http://www.linuxjournal.com/article/9001

-sys info

https://stackoverflow.com/questions/12303141/can-not-understand-load-returned-by-sysinfo

-atoi

http://asmtutor.com/#lesson16
