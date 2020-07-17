.section .data

.section .text
    .global zero_bufferout

.type zero_bufferout, @function

zero_bufferout:
    xorl %eax, %eax
    xorl %ecx, %ecx
    movb (%edi,%ecx), %al
    testb %al, %al
    je zero_bufferout_done
    incl %ecx
    jmp zero_bufferout

zero_bufferout_done:
    ret
    