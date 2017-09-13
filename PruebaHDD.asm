%include "Macros.mac"
default rel
global getSize
sys_newstat     equ 4
sys_statfs      equ 137

    STRUC STATFS
        .f_type:
        .f_bsize:
        .f_blocks:
        .f_bfree:
        .f_bavail:
        .f_files:
        .f_ffree:
        .f_fsid:
        .f_namelen:
        .f_frsize:
        .f_flags:
        .f_spare:

    ENDSTRUC
    __statfs_word f_type;
  	__statfs_word f_bsize;
  	__statfs_word f_blocks;
  	__statfs_word f_bfree;
  	__statfs_word f_bavail;
  	__statfs_word f_files;
  	__statfs_word f_ffree;
  	__kernel_fsid_t f_fsid;
  	__statfs_word f_namelen;
  	__statfs_word f_frsize;
  	__statfs_word f_flags;
  	__statfs_word f_spare[4];
    STRUC STAT
        .st_dev:        resq 1
        .st_ino:        resq 1
        .st_nlink:      resq 1
        .st_mode:       resd 1
        .st_uid:        resd 1
        .st_gid:        resd 1
        .st_rdev:       resq 1
        .pad1:          resq 1
        .st_size:       resq 1
        .st_blksize:    resq 1
        .pad2:          resq 1
        .st_blocks:     resq 1
        .st_atime:      resq 1
        .st_atime_nsec: resq 1
        .st_mtime:      resq 1
        .st_mtime_nsec: resd 1
        .st_ctime:      resq 1
        .st_ctime_nsec: resq 1
        .unused:        resq 3
    ENDSTRUC
    %define sizeof(x) x %+ _size

    section .data
        fileName: db "/sys/block/sda/stat",0
        ;fileName: db "/home/john/Descargas/HO.txt",0

    section .bss
        stat: resb sizeof(STAT)
        cosa1: resb 8
        cosa2: resb 16
        contenido_disp1: resb 10

    section .text
    global _start
    _start:
            ;mov rdi, fileName
            ;mov rax, sys_newstat
            ;mov rsi, stat
            ;mov rdx, 0
            ;syscall
            ;break5:
            ;mov rax, [stat + STAT.st_size]
            ;break6:
            ;mov rax, [stat + STAT.st_blocks]
            ;mov r9, rax

            mov rdi, fileName
            mov rax, sys_statfs
            mov rsi, stat
            mov rdx, 0
            syscall
            break5:
            ;mov rax, [stat + STAT.st_size]
            break6:
            mov rax, [stat + STAT.st_blocks]
            mov r9, rax



        break7:
        ;ret
        break8:
  exit
