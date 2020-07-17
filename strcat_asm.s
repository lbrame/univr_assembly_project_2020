.section .data

.section .text
    .global strcat_asm

    /*
        NOTE: This is not meant to be equivalent to libc's strcat.
        This function is customized for the current project. It does
        not create a new string, it appends %edi to %esi
    */

    # %esi: main string
    # %edi: string to attach to the main string
    # %eax: temp
    # %ebx: temp 2
    # %ecx: main string counter
    # %edx: secondary string counter


strcat_asm:
    xorl %eax, %eax
    xorl %ecx, %ecx
    xorl %edx, %edx

strlen_loop:
    movb (%esi,%ecx), %al
    testb %al, %al
    jz strcat_asm_loop_pre
    incl %ecx
    jmp strlen_loop

strcat_asm_loop_pre:
    xorl %eax, %eax

strcat_asm_loop:
    movb (%edi,%edx), %al
    testb %al, %al
    jz strcat_asm_done
    movb %al, (%esi,%ecx)
    incl %ecx
    incl %edx
    jmp strcat_asm_loop
    

strcat_asm_done:
    ret
