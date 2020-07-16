.section .data
    char_nl_atoi:    .ascii "\n"

.section .text
    .global atoi_asm

    /*
    %eax: return integer
    %ebx: 10 for left shift
    %ecx: counter
    %edx: temp
    %esi: string counter
    %edi: input string
    Designed to go with a maximum number of "99\n"
    */

atoi_asm:
    xorl %ecx, %ecx

atoi_count_chars:
    movb (%edi,%ecx), %al
    cmpb char_nl_atoi, %al
    je atoi_execute
    jmp atoi_count_chars_loop

atoi_count_chars_loop:
    incl %ecx
    jmp atoi_count_chars

atoi_execute:
    xorl %eax, %eax     # Clean eax to prepare to return
    xorl %ebx, %ebx
    movl $10, %ebx      # Base 10 for arithmetic shift
    // movl $2, %ecx       # Max length of string
    # "18\n"
    // decl %ecx           # Skip "\n"
    xorl %esi, %esi

atoi_asm_loop:
    mull %ebx               # %eax *= %ebx, needed for left shift
    movb (%edi,%esi), %dl   # input string in esi position
    subl $48, %edx          # ASCII offset
    addl %edx, %eax
    inc %esi
    loopl atoi_asm_loop

atoi_asm_done: 
    ret
