.section .data

.section .text
    .global nltoz

nl_char:    .ascii "\n"

.type nltoz, @function

    /*
        %edi: input
        %eax: temp
        %ebx: "\n"
        %ecx: counter
    */

nltoz:
    xorl %ebx, %ebx
    movb nl_char, %bl
    xorl %ecx, %ecx

nltoz_loop:
    cmpb %bl, (%edi,%ecx)
    je nltoz_replace
    incl %ecx
    jmp nltoz_loop

nltoz_replace:
    movb $0, (%edi,%ecx)

nltoz_end:
    ret
