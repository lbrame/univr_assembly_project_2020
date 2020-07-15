.section .data

.section .text
    .global strcmp_asm

    // %eax: return value
    // %ebx: temp
    // %ecx: counter string 1
    // %esi: string 1 (null-terminated)
    // %edi: string 2
    // NOTE: At least the first string (%esi) must be
    // null-terminated.
    
strcmp_asm:
    xorl %eax, %eax
    xorl %ebx, %ebx
    xorl %ecx, %ecx

compare_loop:
    movb (%esi,%ecx), %bl
    testb %bl, %bl
    jz compare_success
    cmpb (%edi,%ecx), %bl
    je chars_equal
    jne chars_not_equal

chars_equal:
    incl %ecx
    jmp compare_loop

chars_not_equal:
    jmp compare_failure

compare_success:
    xorl %eax, %eax
    ret

compare_failure:
    movl $1, %eax
    ret
